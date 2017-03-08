//
//  SetPSWViewController.m
//  ptOS
//
//  Created by 周瑞 on 16/9/1.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "SetPSWViewController.h"
#import "RegisterApi.h"
#import "AFHTTPRequestOperation.h"
#import "StringUtil.h"
#import "QQRegister.h"
#import "UIButton+JKTouchAreaInsets.h"

@interface SetPSWViewController ()
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UITextField *pswTF;
@property (weak, nonatomic) IBOutlet UIButton *doneRegisterBtn;

@property (nonatomic, strong)RegisterApi *registerApi;
@property (nonatomic,strong)QQRegister *qqRegisterApi;

@end

@implementation SetPSWViewController

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
-(void)initUI {

    ZRViewRadius(self.pswTF, 10);
    ZRViewRadius(self.doneRegisterBtn, 10);
    
    self.closeBtn.jk_touchAreaInsets = UIEdgeInsetsMake(50, 50, 50, 50);
    
    UIButton *rightView = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightView setBackgroundImage:[UIImage imageNamed:@"icon_xianshimima"] forState:UIControlStateNormal];
    [rightView setBackgroundImage:[UIImage imageNamed:@"icon_xianshimima_press"] forState:UIControlStateSelected];
    [rightView addTarget:self action:@selector(showPSWAction:) forControlEvents:UIControlEventTouchUpInside];
    rightView.frame = CGRectMake(0, 0, 18, 18);
    UIView *bgView3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 45)];
    [bgView3 addSubview:rightView];
    rightView.center = bgView3.center;
    self.pswTF.rightView = bgView3;
    self.pswTF.rightViewMode = UITextFieldViewModeAlways;
    self.pswTF.secureTextEntry = YES;
    
    self.pswTF.textColor = WhiteColor;
    [self.pswTF setValue:WhiteColor forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)showPSWAction:(UIButton *)btn {
    self.pswTF.secureTextEntry = !self.pswTF.secureTextEntry;
}


- (IBAction)closeBtnPress:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneRegisterBtnPress:(id)sender {
    if (!isValidStr(self.pswTF.text)) {
        [XHToast showCenterWithText:@"请输入密码"];
        return;
    }
    if (![ControlUtil validatePWD:self.pswTF.text]) {
        [XHToast showCenterWithText:@"密码必须由6-16位的字母或数字组合"];
        return;
    }
    [self registerApiNet];
}

#pragma mark - NetworkApis

- (void)registerApiNet {
    
    if(self.registerApi&& !self.registerApi.requestOperation.isFinished)
    {
        [self.registerApi stop];
    }
    
    self.registerApi = [[RegisterApi alloc] initWithPhone:self.phone withPsw:self.pswTF.text];
    NSLog(@"%@",self.phone);
    NSLog(@"%@",self.pswTF.text);
    [self.registerApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        RegisterApi *result = (RegisterApi *)request;
        if(result.isCorrectResult)
        {
            if (isValidStr(self.uid)) {
                [self qqRegisterApiNet];
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } failure:^(YTKBaseRequest *request) {
        
    }];
}

- (void)qqRegisterApiNet {
    if(self.qqRegisterApi&& !self.qqRegisterApi.requestOperation.isFinished)
    {
        [self.qqRegisterApi stop];
    }
    
    self.qqRegisterApi = [[QQRegister alloc] initWithPhone:self.phone withPassword:self.pswTF.text withOpenId:self.uid];
    NSLog(@"%@",self.phone);
    NSLog(@"%@",self.pswTF.text);
    [self.qqRegisterApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        QQRegister *result = (QQRegister *)request;
        if(result.isCorrectResult)
        {
            [XHToast showCenterWithText:@"注册成功"];
        }
    } failure:^(YTKBaseRequest *request) {
        
    }];
}

#pragma mark - delegate


#pragma mark - lazyViews

@end
