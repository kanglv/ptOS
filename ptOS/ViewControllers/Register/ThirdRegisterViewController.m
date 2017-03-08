//
//  ThirdRegisterViewController.m
//  ptOS
//
//  Created by 周瑞 on 16/9/4.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "ThirdRegisterViewController.h"
#import "H5ViewController.h"
#import "AFHTTPRequestOperation.h"
#import "QQRegister.h"
#import "RegisterApi.h"
#import "CheckCodeApi.h"
#import "GetCodeApi.h"
#import "SetPSWViewController.h"
#import "UIButton+JKCountDown.h"
#import "ThirdBoundingViewController.h"
@interface ThirdRegisterViewController ()
{
    NSString *_key;
}
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreementBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (nonatomic,strong)QQRegister *QQRigisterApi;
@property (nonatomic,strong)GetCodeApi *getCodeApi;
@property (nonatomic,strong)RegisterApi *registerApi;
@property (nonatomic,strong)CheckCodeApi *checkCodeApi;

@end

@implementation ThirdRegisterViewController

#pragma mark - lifeCycles

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needNav = NO;
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - customFuncs
- (void)initUI {
    ZRViewRadius(self.phoneNumTF, 10);
    ZRViewRadius(self.registerBtn, 10);
    [self setCornerOnLetf:self.codeTF];
    [self setCornerOnRight:self.getCodeBtn];
    
    
    
    UIImageView *phoneLeftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_shoujihao"]];
    UIImageView *pswLeftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_mima"]];
    
    phoneLeftView.frame = CGRectMake(0, 0, 18, 18);
    pswLeftView.frame = CGRectMake(0, 0, 18, 18);
    
    UIView *bgView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 45)];
    UIView *bgView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 45)];
    
    [bgView1 addSubview:phoneLeftView];
    [bgView2 addSubview:pswLeftView];
    
    
    phoneLeftView.center = bgView1.center;
    pswLeftView.center = bgView2.center;
    
    self.phoneNumTF.leftView = bgView1;
    self.codeTF.leftView = bgView2;
    
    self.phoneNumTF.textColor = WhiteColor;
    self.codeTF.textColor = WhiteColor;
    
    [self.phoneNumTF setValue:WhiteColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.codeTF setValue:WhiteColor forKeyPath:@"_placeholderLabel.textColor"];
    
    self.phoneNumTF.leftViewMode = UITextFieldViewModeAlways;
    self.codeTF.leftViewMode = UITextFieldViewModeAlways;
}

- (IBAction)closeBtnPres:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)getCodeBtnPress:(id)sender {
    if (![ControlUtil validatePhone:self.phoneNumTF.text]) {
        [XHToast showCenterWithText:@"请输入正确的手机号"];
        return;
    }
    [_getCodeBtn jk_startTime:60 title:@"获取验证码" waitTittle:@""];
    [self getGetCodeApiNet];
}
- (IBAction)agreementBtnPress:(id)sender {
    H5ViewController *ctrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"H5ViewController"];
    [self.navigationController pushViewController:ctrl animated:YES];
}
- (IBAction)registerBtnPress:(id)sender {
    if (![ControlUtil validatePhone:self.phoneNumTF.text]) {
        [XHToast showCenterWithText:@"请输入正确的手机号"];
        return;
    }
    if (!isValidStr(self.codeTF.text)) {
        [XHToast showCenterWithText:@"请输入验证码"];
        return;
    }
    [self checkCodeApiNet];
}
- (IBAction)backBtnPress:(id)sender {
    ThirdBoundingViewController *ctrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ThirdBoundingViewController"];
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void)setCornerOnLetf:(UIView *)view
{
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                     byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerTopLeft)
                                           cornerRadii:CGSizeMake(10.0f, 10.0f)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

- (void)setCornerOnRight:(UIView *)view
{
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                     byRoundingCorners:(UIRectCornerBottomRight | UIRectCornerTopRight)
                                           cornerRadii:CGSizeMake(10.0f, 10.0f)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}
#pragma mark - NetworkApis
- (void)getGetCodeApiNet {
    if(self.getCodeApi&& !self.getCodeApi.requestOperation.isFinished)
    {
        [self.getCodeApi stop];
    }
    
    self.getCodeApi = [[GetCodeApi alloc] initWithPhone:self.phoneNumTF.text];
    [self.getCodeApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        GetCodeApi *result = (GetCodeApi *)request;
        if(result.isCorrectResult)
        {
            _key = [result getSessionId];
        }
    } failure:^(YTKBaseRequest *request) {
        
    }];
}

- (void)checkCodeApiNet {
    if(self.checkCodeApi&& !self.checkCodeApi.requestOperation.isFinished)
    {
        [self.checkCodeApi stop];
    }
    
    self.checkCodeApi = [[CheckCodeApi alloc] initWithPhone:self.phoneNumTF.text withSessionId:_key withCode:self.codeTF.text];
    [self.checkCodeApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        CheckCodeApi *result = (CheckCodeApi *)request;
        if(result.isCorrectResult)
        {
            SetPSWViewController *ctrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SetPSWViewController"];
            ctrl.code = _key;
            ctrl.phone = self.phoneNumTF.text;
            ctrl.uid = self.uid;
            [self.navigationController pushViewController:ctrl animated:YES];
        }
    } failure:^(YTKBaseRequest *request) {
        
    }];
}



#pragma mark - delegate


#pragma mark - lazyViews

@end
