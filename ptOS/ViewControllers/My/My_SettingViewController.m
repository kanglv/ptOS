
//
//  My_SettingViewController.m
//  ptOS
//
//  Created by 周瑞 on 16/9/4.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "My_SettingViewController.h"
#import "My_MyAccountViewController.h"
#import "H5ViewController.h"
#import "My_PushSettingViewController.h"
#import "LoginViewController.h"
#import "AFHTTPRequestOperation.h"
#import "MY_LogoutApi.h"
#import "AboutMeViewController.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
@interface My_SettingViewController ()

@property (nonatomic, strong)MY_LogoutApi *logoutApi;
@property (weak, nonatomic) IBOutlet UILabel *pushLabel;
@property (weak, nonatomic) IBOutlet UILabel *memeryLabel;

@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
@end

@implementation My_SettingViewController

#pragma mark - lifeCycles

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"设置"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (isValidStr([GlobalData sharedInstance].selfInfo.sessionId)) {
        self.logoutBtn.hidden = NO;
    }else {
        self.logoutBtn.hidden = YES;
    }
    
    NSInteger size = [[SDWebImageManager sharedManager].imageCache getSize];
    self.memeryLabel.text = [StringUtil formatSize:size];
    
    
    if([[UIApplication sharedApplication] currentUserNotificationSettings].types == UIUserNotificationTypeNone)
    {
        self.pushLabel.text = @"请前往设置开启推送";
    }
    else
    {
        self.pushLabel.text = @"已开启";
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - customFuncs
- (IBAction)myAccountPress:(id)sender {
    if (!isValidStr([GlobalData sharedInstance].selfInfo.sessionId))
    {
        [self presentLoginCtrl];
        return;
    }
    My_MyAccountViewController *ctrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"My_MyAccountViewController"];
    [self.navigationController pushViewController:ctrl animated:YES];
}
- (IBAction)pushSettingPress:(id)sender {
    if([[UIApplication sharedApplication] currentUserNotificationSettings].types == UIUserNotificationTypeNone)
    {
        //开启推送
        [[UIApplication sharedApplication] registerForRemoteNotifications];
         self.pushLabel.text = @"已开启";
    }
    else
    {
        //关闭推送
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        self.pushLabel.text = @"请前往设置开启推送";
    }
    
}
- (IBAction)clearMemeryPress:(id)sender {
    
    [SVProgressHUD showWithStatus:@"正在清理"];
    [[SDWebImageManager sharedManager].imageCache clearMemory];
    [[SDWebImageManager sharedManager].imageCache clearDiskOnCompletion:^{
        self.memeryLabel.text = @"0k";
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD showSuccessWithStatus:@"清除成功"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    });
}
- (IBAction)aboutUsPress:(id)sender {
    AboutMeViewController *ctrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AboutMeViewController"];
    [self.navigationController pushViewController:ctrl animated:YES];
}
- (IBAction)userAgressmentPress:(id)sender {
    H5ViewController *ctrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"H5ViewController"];
    [self.navigationController pushViewController:ctrl animated:YES];
}
- (IBAction)quitPress:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确定退出？" preferredStyle:UIAlertControllerStyleAlert];
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    WeakSelf;
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alertController.textFields.firstObject resignFirstResponder];
        
        NSString *sessionId = [GlobalData sharedInstance].selfInfo.sessionId;
        [self logoutApiNet];
        [UserDefault removeObjectForKey:PswKey];
        [UserDefault removeObjectForKey:HeaderKey];
        [UserDefault removeObjectForKey:JLKey];
        [UserDefault removeObjectForKey:UIDKey];
        
        [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error){}];
        
        /*
         @property (nonatomic,copy)NSString *jl_name;
         @property (nonatomic,copy)NSString *jl_sex;
         @property (nonatomic,copy)NSString *jl_birth;
         @property (nonatomic,copy)NSString *jl_education;
         @property (nonatomic,copy)NSString *jl_phone;
         @property (nonatomic,copy)NSString *jl_cardPicFont;
         @property (nonatomic,copy)NSString *jl_cardPicBack;
         @property (nonatomic,copy)NSString *jl_educationPiC;
         @property (nonatomic,copy)NSString *jl_zs1;
         @property (nonatomic,copy)NSString *jl_zs2;
         @property (nonatomic,copy)NSString *jl_zs3;
         @property (nonatomic,copy)NSString *jl_workExp;
         @property (nonatomic,copy)NSString *jl_skills;
         */
        [GlobalData sharedInstance].jl_name = nil;
        [GlobalData sharedInstance].jl_sex = nil;
        [GlobalData sharedInstance].jl_birth = nil;
        [GlobalData sharedInstance].jl_education = nil;
        [GlobalData sharedInstance].jl_phone = nil;
        [GlobalData sharedInstance].jl_cardPicFont = nil;
        [GlobalData sharedInstance].jl_cardPicBack = nil;
        [GlobalData sharedInstance].jl_educationPiC = nil;
//        [GlobalData sharedInstance].jl_zs1 = nil;
//        [GlobalData sharedInstance].jl_zs2 = nil;
//        [GlobalData sharedInstance].jl_zs3 = nil;
        [GlobalData sharedInstance].jl_workExp = nil;
        [GlobalData sharedInstance].jl_skills = nil;
        
        [GlobalData sharedInstance].health1 = nil;
        [GlobalData sharedInstance].health1Url = nil;
        [GlobalData sharedInstance].health2 = nil;
        [GlobalData sharedInstance].health1Ur2 = nil;
        [GlobalData sharedInstance].health3 = nil;
        [GlobalData sharedInstance].health1Ur3 = nil;
        [GlobalData sharedInstance].health4 = nil;
        [GlobalData sharedInstance].health1Ur4 = nil;
        [GlobalData sharedInstance].health5 = nil;
        [GlobalData sharedInstance].health1Ur5 = nil;
        [GlobalData sharedInstance].health6 = nil;
        [GlobalData sharedInstance].health1Ur6 = nil;
        [GlobalData sharedInstance].health7 = nil;
        [GlobalData sharedInstance].health1Ur7 = nil;
        [GlobalData sharedInstance].health8 = nil;
        [GlobalData sharedInstance].health1Ur8 = nil;
        
        [GlobalData sharedInstance].cardPicFontName = nil;
         [GlobalData sharedInstance].cardPicBackName = nil;
         [GlobalData sharedInstance].educationPiCName = nil;
        [JPUSHService setAlias:@"" callbackSelector:nil object:nil];
        
        [GlobalData sharedInstance].selfInfo = nil;
        [self.navigationController popViewControllerAnimated:YES];

    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];

    
}

#pragma mark - Networkapis
- (void)logoutApiNet {
    if(self.logoutApi&& !self.logoutApi.requestOperation.isFinished)
    {
        [self.logoutApi stop];
    }
    
    self.logoutApi = [[MY_LogoutApi alloc] init];
    self.logoutApi.sessionDelegate = self;
    [self.logoutApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        MY_LogoutApi *result = (MY_LogoutApi *)request;
        if(result.isCorrectResult)
        {
            
        }
    } failure:^(YTKBaseRequest *request) {
        
    }];
}

#pragma mark - delegate


#pragma mark - lazyViews

@end
