//
//  ThirdBoundingViewController.m
//  ptOS
//
//  Created by 周瑞 on 16/9/4.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "ThirdBoundingViewController.h"
#import "AFHTTPRequestOperation.h"
#import "BindQQ.h"
#import "FindPSWViewController.h"
#import "LoginNetApi.h"
#import "ThirdRegisterViewController.h"


@interface ThirdBoundingViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *pswTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIImageView *forgetPSWBtn;

@property (nonatomic,strong)BindQQ *bindQQApi;
@property (nonatomic,strong)LoginNetApi *loginApi;

@end

@implementation ThirdBoundingViewController

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
    ZRViewRadius(self.pswTF, 10);
    ZRViewRadius(self.loginBtn, 10);
    
    UIImageView *phoneLeftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_shoujihao"]];
    UIImageView *pswLeftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_mima"]];
    UIButton *rightView = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightView setBackgroundImage:[UIImage imageNamed:@"icon_xianshimima"] forState:UIControlStateNormal];
    [rightView setBackgroundImage:[UIImage imageNamed:@"icon_xianshimima_press"] forState:UIControlStateSelected];
    [rightView addTarget:self action:@selector(showPSWAction:) forControlEvents:UIControlEventTouchUpInside];
    rightView.frame = CGRectMake(0, 0, 18, 18);
    phoneLeftView.frame = CGRectMake(0, 0, 18, 18);
    pswLeftView.frame = CGRectMake(0, 0, 18, 18);
    
    UIView *bgView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 45)];
    UIView *bgView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 45)];
    UIView *bgView3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 45)];
    
    [bgView1 addSubview:phoneLeftView];
    [bgView2 addSubview:pswLeftView];
    [bgView3 addSubview:rightView];
    
    
    phoneLeftView.center = bgView1.center;
    pswLeftView.center = bgView2.center;
    rightView.center = bgView3.center;
    
    self.phoneNumTF.leftView = bgView1;
    self.pswTF.leftView = bgView2;
    self.pswTF.rightView = bgView3;
    
    self.phoneNumTF.textColor = WhiteColor;
    self.pswTF.textColor = WhiteColor;
    
    [self.phoneNumTF setValue:WhiteColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.pswTF setValue:WhiteColor forKeyPath:@"_placeholderLabel.textColor"];
    
    self.phoneNumTF.leftViewMode = UITextFieldViewModeAlways;
    self.pswTF.leftViewMode = UITextFieldViewModeAlways;
    self.pswTF.rightViewMode = UITextFieldViewModeAlways;
    
    self.pswTF.secureTextEntry = YES;
}

-(void)showPSWAction:(UIButton *)btn {
    self.pswTF.secureTextEntry = !self.pswTF.secureTextEntry;
}

- (IBAction)forgetPSWBtnPress:(id)sender {
    FindPSWViewController *ctrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"FindPSWViewController"];
    [self.navigationController pushViewController:ctrl animated:YES];
}
- (IBAction)loginBtnPress:(id)sender {
    if (![ControlUtil validatePhone:self.phoneNumTF.text]) {
        [XHToast showCenterWithText:@"请输入正确的手机号"];
        return;
    }
    if (!isValidStr(self.pswTF.text)) {
        [XHToast showCenterWithText:@"请输入密码"];
        return;
    }
    if (![ControlUtil validatePWD:self.pswTF.text]) {
        [XHToast showCenterWithText:@"密码不正确"];
        return;
    }
    [self loginNetApiNet];
    
}
- (IBAction)backBtnPress:(id)sender {
    ThirdRegisterViewController *ctrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ThirdRegisterViewController"];
    ctrl.uid = [UserDefault objectForKey:UIDKey];
    [self.navigationController pushViewController:ctrl animated:YES];
}

#pragma mark - networkApi
- (void)bindQQApiNet {
    NSString *uid = [UserDefault objectForKey:UIDKey];
    if (self.bindQQApi && !self.bindQQApi.requestOperation.isFinished) {
        [self.bindQQApi stop];
    }
    self.bindQQApi = [[BindQQ alloc]initWithOpenId:uid];
    self.bindQQApi.netLoadingDelegate = self;
    
    [self.bindQQApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        LoginNetApi *result = (LoginNetApi *)request;
        if (result.isCorrectResult) {
            NSLog(@"绑定成功");
            [XHToast showCenterWithText:@"绑定成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [NotificationCenter postNotificationName:@"dismiss" object:nil];
        }else {
            
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"登陆失败");
    }];
}


- (void)loginNetApiNet {
    if (self.loginApi && !self.loginApi.requestOperation.isFinished) {
        [self.loginApi stop];
    }
    self.loginApi = [[LoginNetApi alloc]initWithUserName:self.phoneNumTF.text withUserPsw:self.pswTF.text];
    self.loginApi.netLoadingDelegate = self;
    
    [self.loginApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        LoginNetApi *result = (LoginNetApi *)request;
        if (result.isCorrectResult) {
            
            
            
            [self bindQQApiNet];
            
            
            [GlobalData sharedInstance].selfInfo = [result getUserInfo];
            [JPUSHService setAlias:[GlobalData sharedInstance].selfInfo.userName callbackSelector:nil object:nil];
            [UserDefault setObject:self.phoneNumTF.text forKey:PhoneKey];
            [UserDefault setObject:self.pswTF.text forKey:PswKey];
            
            [UserDefault synchronize];
        }else {
            
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"登陆失败");
    }];
    
}

#pragma mark - delegate


#pragma mark - lazyViews

@end
