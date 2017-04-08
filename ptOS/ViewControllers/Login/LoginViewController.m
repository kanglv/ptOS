//
//  LoginViewController.m
//  ptOS
//
//  Created by 周瑞 on 16/8/29.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "FindPSWViewController.h"
#import "FindPSW2ViewController.h"
#import "CYLTabBarController.h"
#import "LoginNetApi.h"
#import "GlobalData.h"
#import "OSSManager.h"
#import "UserInfoModel.h"
#import "ThirdBoundingViewController.h"
#import "ThirdRegisterViewController.h"
#import "UIButton+JKTouchAreaInsets.h"
#import "NSString+NTES.h"
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

#import "AFHTTPRequestOperation.h"


#import "QQLogin.h"
#import "LoginlogNetApi.h"
#import "AFNetworking.h"
#import "NewRequestMethod.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *pswTF;
@property (weak, nonatomic) IBOutlet UIButton *forgetPSWBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (nonatomic,strong)LoginNetApi *loginApi;

@property (nonatomic,strong)QQLogin *qqLoginApi;

@property (nonatomic,strong)LoginlogNetApi *loginlogApi;

@property (nonatomic, strong)NewRequestMethod *requestMethod;


@end

@implementation LoginViewController

#pragma mark - lifeCycles

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needNav = NO;
    [self initUI];
    [NotificationCenter addObserver:self selector:@selector(dismiss) name:@"dismiss" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *phone = [UserDefault stringForKey:PhoneKey];
    self.phoneNumTF.text = phone;
    if (isValidStr([UserDefault stringForKey:PswKey])) {
        self.pswTF.text = [UserDefault stringForKey:PswKey];
    }
//    [self loginNet];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    [self.loginApi stop];
    [NotificationCenter removeObserver:self];
}

#pragma mark - customFuncs
- (void)initUI {
    ZRViewRadius(self.phoneNumTF, 10);
    ZRViewRadius(self.pswTF, 10);
    ZRViewRadius(self.loginBtn, 10);
    
    self.closeBtn.jk_touchAreaInsets = UIEdgeInsetsMake(50, 50, 50, 50);
    
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
    [self.phoneNumTF setValue:WhiteColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.pswTF setValue:WhiteColor forKeyPath:@"_placeholderLabel.textColor"];
    self.pswTF.textColor = WhiteColor;
    
    self.phoneNumTF.leftViewMode = UITextFieldViewModeAlways;
    self.pswTF.leftViewMode = UITextFieldViewModeAlways;
    self.pswTF.rightViewMode = UITextFieldViewModeAlways;
    
    self.pswTF.secureTextEntry = YES;
    
}

- (void)showPSWAction:(UIButton *)btn {
    self.pswTF.secureTextEntry = !self.pswTF.secureTextEntry;
}

- (IBAction)closeBtnPress:(id)sender {
    [self cancelAction];
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
- (IBAction)registerBtnPress:(id)sender {
    RegisterViewController *ctrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    [self.navigationController pushViewController:ctrl animated:YES];
}
- (IBAction)QQBtnPress:(id)sender {
    
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             
             NSLog(@"uid=%@",user.uid);
             NSLog(@"%@",user.credential);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.nickname);
             [UserDefault setObject:user.uid forKey:UIDKey];
             [self qqLoginApiNetWithOpenId:user.uid];
             
         }
         
         else
         {
             NSLog(@"%@",error);
         }
         
     }];
    
}
- (IBAction)WXBtnPress:(id)sender {
}

- (void)cancelAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Netapi
- (void)loginNetApiNet {
    if (self.loginApi && !self.loginApi.requestOperation.isFinished) {
        [self.loginApi stop];
    }
   
    
    
    self.loginApi = [[LoginNetApi alloc]initWithUserName:self.phoneNumTF.text withUserPsw:self.pswTF.text];
    self.loginApi.netLoadingDelegate = self;
   
        [self.loginApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        LoginNetApi *result = (LoginNetApi *)request;
        if (result.isCorrectResult) {
            
            [GlobalData sharedInstance].selfInfo = [result getUserInfo];
            NSLog(@"%@",[GlobalData sharedInstance].selfInfo.userId);
            //云信的帐号密码获取？
            [[[NIMSDK sharedSDK] loginManager] login:[GlobalData sharedInstance].selfInfo.userId
                                               token:[[GlobalData sharedInstance].selfInfo.userId tokenByPassword] completion:^(NSError * _Nullable error) {
                 //18626051857
                                                   
                                                   
                                               }];
            
            [self loginlogApiNet];
           

            [JPUSHService setAlias:[GlobalData sharedInstance].selfInfo.userName callbackSelector:nil object:nil];
            
            [self downloadHeaderImage];
            [UserDefault setObject:self.phoneNumTF.text forKey:PhoneKey];
            [UserDefault setObject:self.pswTF.text forKey:PswKey];
            [UserDefault setObject:[GlobalData sharedInstance].selfInfo.userId forKey:UIDKey];
            [UserDefault synchronize];
            [self cancelAction];
        }else {
            
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"登陆失败");
        [JPUSHService setAlias:@"" callbackSelector:nil object:nil];
    }];
    
}

- (void)loginlogApiNet{
    NSMutableDictionary *argument = [NSMutableDictionary dictionary];;
    [argument setCustomString:[GlobalData sharedInstance].selfInfo.userId forKey:@"uid"];
    [argument setCustomString:[GlobalData sharedInstance].longtitude forKey:@"longitude"];
    [argument setCustomString:[GlobalData sharedInstance].latitude forKey:@"latitude"];
    [argument setCustomString:[GlobalData sharedInstance].indexLocation forKey:@"address"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:argument forKey:@"params"];
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    sessionManager.requestSerializer.timeoutInterval = 3;//设置登录超时为15s
    
    [sessionManager.requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    [sessionManager  POST:@"http://139.196.230.156/ptApp/loginlog" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"hhhhh");
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"fdsfsd");
    }];
    
}

- (void)qqLoginApiNetWithOpenId:(NSString *)openId {
    if (self.qqLoginApi && !self.qqLoginApi.requestOperation.isFinished) {
        [self.qqLoginApi stop];
    }
    self.qqLoginApi = [[QQLogin alloc]initWithOpenId:openId];
    self.qqLoginApi.netLoadingDelegate = self;
    
    [self.qqLoginApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        QQLogin *result = (QQLogin *)request;
        if (result.isCorrectResult) {
            UserInfoModel *model = [result getUserInfo];
            if (![model.sessionId isKindOfClass:[NSNull class]] && isValidStr(model.sessionId) && model.sessionId != nil) {
                
                [GlobalData sharedInstance].selfInfo = [result getUserInfo];
                
                [self downloadHeaderImage];
                [JPUSHService setAlias:[GlobalData sharedInstance].selfInfo.userName callbackSelector:nil object:nil];
                [UserDefault setObject:[GlobalData sharedInstance].selfInfo.phone forKey:PhoneKey];
                [UserDefault setObject:[GlobalData sharedInstance].selfInfo.psw forKey:PswKey];
                
                [UserDefault synchronize];
                [self cancelAction];
            }else {
                [JPUSHService setAlias:@"" callbackSelector:nil object:nil];
                ThirdRegisterViewController *ctrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ThirdRegisterViewController"];
                [self.navigationController pushViewController:ctrl animated:YES];
            }
        }else {
            
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"登陆失败");
    }];
}



- (void)downloadHeaderImage {
    NSString *fileName = [NSString stringWithFormat:@"%@.png",[GlobalData sharedInstance].selfInfo.userName];
    [[OSSManager sharedManager] downloadObjectAsyncWithFileName:fileName andBDName:@"bd-header" andGetImage:^(BOOL isSuccess, UIImage *image) {
        if (isSuccess) {
            if (image != nil) {
                NSData *data = UIImageJPEGRepresentation(image, 1.0);
                [[NSUserDefaults standardUserDefaults] setValue:data forKey:HeaderKey];
                [NotificationCenter postNotificationName:@"refreshFace" object:nil];
            }
        }
    }];
}


#pragma mark - delegate


#pragma mark - lazyViews

@end
