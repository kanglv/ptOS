//
//  My_MyAccountViewController.m
//  ptOS
//
//  Created by 周瑞 on 16/9/4.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "My_MyAccountViewController.h"
#import "My_ChangeNIcknameApi.h"
#import "AFHTTPRequestOperation.h"
#import "ChangePhone1ViewController.h"
#import "ChangePSWViewController.h"
@interface My_MyAccountViewController ()

@property (nonatomic, strong)My_ChangeNIcknameApi *changeNameApi;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *wxBtn;
@property (weak, nonatomic) IBOutlet UIButton *QQBtn;

@property (nonatomic,strong)NSString *name;

@end

@implementation My_MyAccountViewController

#pragma mark - lifeCycles

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"我的账号"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.wxBtn.userInteractionEnabled = NO;
    if ([[GlobalData sharedInstance].selfInfo.isBindWeiXin isEqualToString:@"1"]) {
        [self.wxBtn setBackgroundImage:[UIImage imageNamed:@"icon_weixing_press"] forState:UIControlStateNormal];
    }
    if ([[GlobalData sharedInstance].selfInfo.isBindQQ isEqualToString:@"1"]) {
        [self.QQBtn setImage:[UIImage imageNamed:@"icon_qq_press"] forState:UIControlStateNormal];
    }
    
    self.nickNameLabel.text = [GlobalData sharedInstance].selfInfo.nickName;
    NSString *mobile = [NSString stringWithString:[GlobalData sharedInstance].selfInfo.phone];
    NSMutableString *result = [NSMutableString string];
    if(mobile.length >= 7)
    {
        [result appendString:[mobile substringToIndex:3]];
        for(int i = 0 ; i < mobile.length - 7;i ++)
        {
            [result appendString:@"*"];
        }
        [result appendString:[mobile substringFromIndex:mobile.length - 4]];
    }
    else
    {
        [result appendString:mobile];
    }
    self.phoneNumLabel.text = [NSString stringWithFormat:@"    %@",result];
    self.QQBtn.userInteractionEnabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - NetworkApis
- (void)changNameApiNetWithName:(NSString *)name {
    if(self.changeNameApi&& !self.changeNameApi.requestOperation.isFinished)
    {
        [self.changeNameApi stop];
    }
    
    self.changeNameApi = [[My_ChangeNIcknameApi alloc] initWithNickname:name];
    self.changeNameApi.sessionDelegate = self;
    [self.changeNameApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        My_ChangeNIcknameApi *result = (My_ChangeNIcknameApi *)request;
        if(result.isCorrectResult)
        {
            [XHToast showCenterWithText:@"修改成功"];
            self.nickNameLabel.text = self.name;
            [GlobalData sharedInstance].selfInfo.nickName = self.name;
        }
    } failure:^(YTKBaseRequest *request) {
        
    }];
}

#pragma mark - customFuncs
- (IBAction)nickNameBtnPress:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"输入用户名" preferredStyle:UIAlertControllerStyleAlert];
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alertController.textFields.firstObject resignFirstResponder];
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alertController.textFields.firstObject resignFirstResponder];
        if (!isValidStr(alertController.textFields.firstObject.text)) {
            [SVProgressHUD showImage:nil status:@"请输入昵称"];
        }else if (![ControlUtil validateNickName:alertController.textFields.firstObject.text]) {
            [SVProgressHUD showImage:nil status:@"4-16个字符，汉字为2个字符"];
       }else {
           [self changNameApiNetWithName:alertController.textFields.firstObject.text];
           self.name = alertController.textFields.firstObject.text;
       }
        
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"4-16个字符，汉字为2个字符";
    }];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)phoneNumBtnPress:(id)sender {
    ChangePhone1ViewController *ctrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChangePhone1ViewController"];
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (IBAction)pswBtnPress:(id)sender {
    ChangePSWViewController *ctrl = [[ChangePSWViewController alloc]init];
    [self.navigationController pushViewController:ctrl animated:YES];
}
#pragma mark - delegate


#pragma mark - lazyViews

@end
