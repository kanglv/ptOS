//
//  ChangePSWViewController.m
//  ptOS
//
//  Created by 周瑞 on 16/10/8.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "ChangePSWViewController.h"
#import "ChangePswdView.h"
#import "MY_ChangePswApi.h"
@interface ChangePSWViewController ()
@property(nonatomic,strong) ChangePswdView *changePswdView;
@property(nonatomic,strong) MY_ChangePswApi *changePasswordNetApi;
@end

@implementation ChangePSWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"修改密码"];
    self.changePswdView = [[ChangePswdView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT - 64)];
    [self.view addSubview:self.changePswdView];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)changePwdNet:(NSString *)oldPwd withNPWD:(NSString *)newPwd
{
    
    self.changePasswordNetApi = [[MY_ChangePswApi alloc] initWithPsw:newPwd];
    self.changePasswordNetApi.netLoadingDelegate = self;
    
    WeakSelf;
    [self.changePasswordNetApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        MY_ChangePswApi *result = (MY_ChangePswApi *)request;
        if(result.isCorrectResult)
        {
            //保存密码
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:newPwd forKey:PswKey];
            [userDefault synchronize];
            
            [SVProgressHUD showImage:nil status:@"修改成功，请牢记新密码"];
            
            //界面跳转
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(YTKBaseRequest *request) {
        
    }];
}

@end
