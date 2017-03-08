//
//  FindPSWViewController.m
//  ptOS
//
//  Created by 周瑞 on 16/9/1.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "FindPSWViewController.h"
#import "FindPSW2ViewController.h"
#import "GetCodeApi.h"
#import "AFHTTPRequestOperation.h"
#import "CheckCodeApi.h"

#import "UIButton+JKCountDown.h"

#import "UIButton+JKTouchAreaInsets.h"

@interface FindPSWViewController ()
{
    NSString *_key;
}
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

@property (nonatomic,strong)GetCodeApi *getCodeApi;
@property (nonatomic,strong)CheckCodeApi *checkCodeApi;

@end

@implementation FindPSWViewController

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
    ZRViewRadius(self.nextBtn, 10);
    [self setCornerOnLetf:self.codeTF];
    [self setCornerOnRight:self.getCodeBtn];
    
    self.closeBtn.jk_touchAreaInsets = UIEdgeInsetsMake(50, 50, 50, 50);
    
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

- (IBAction)closeBtnPress:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)getCodeBtnPress:(id)sender {
    if (![ControlUtil validatePhone:self.phoneNumTF.text]) {
        [XHToast showCenterWithText:@"请输入正确的手机号"];
        return;
    }
    [_getCodeBtn jk_startTime:60 title:@"获取验证码" waitTittle:@""];
    [self getGetCodeApiNet];
}
- (IBAction)nextStepBtnPress:(id)sender {
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
            FindPSW2ViewController *ctrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FindPSW2ViewController"];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
    } failure:^(YTKBaseRequest *request) {
        
    }];
}


#pragma mark - delegate


#pragma mark - lazyViews

@end
