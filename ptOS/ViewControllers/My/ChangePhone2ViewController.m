//
//  ChangePhone2ViewController.m
//  ptOS
//
//  Created by 周瑞 on 16/10/8.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "ChangePhone2ViewController.h"
#import "MY_ChangePhoneApi.h"
#import "AFHTTPRequestOperation.h"

#import "UIButton+JKCountDown.h"

#import "GetCodeApi.h"
#import "CheckCodeApi.h"
@interface ChangePhone2ViewController ()
{
    NSString *_key;
}
@property (weak, nonatomic) IBOutlet UIButton *getcodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *neweTF;

@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property (nonatomic,strong)MY_ChangePhoneApi *changePhoneApi;
@property (nonatomic,strong)CheckCodeApi *checkCodeApi;
@property (nonatomic,strong)GetCodeApi *getCodeApi;

@end

@implementation ChangePhone2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 40)];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 40)];
    self.neweTF.leftView = view1;
    self.neweTF.leftViewMode = UITextFieldViewModeAlways;
    self.codeTF.leftView = view2;
    self.codeTF.leftViewMode = UITextFieldViewModeAlways;
    ZRViewRadius(self.getcodeBtn, 5);
    ZRViewRadius(self.saveBtn, 20);

}

- (void)changePhoneApiNet {
    if(self.changePhoneApi&& !self.changePhoneApi.requestOperation.isFinished)
    {
        [self.changePhoneApi stop];
    }
    
    self.changePhoneApi = [[MY_ChangePhoneApi alloc] initWithPhone:self.neweTF.text];
    self.changePhoneApi.sessionDelegate = self;
    [self.changePhoneApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        MY_ChangePhoneApi *result = (MY_ChangePhoneApi *)request;
        if(result.isCorrectResult)
        {
            [XHToast showCenterWithText:@"修改成功"];
            [GlobalData sharedInstance].selfInfo.phone = self.neweTF.text;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } failure:^(YTKBaseRequest *request) {
        
    }];
}

#pragma mark - NetworkApis
- (void)getGetCodeApiNet {
    if(self.getCodeApi&& !self.getCodeApi.requestOperation.isFinished)
    {
        [self.getCodeApi stop];
    }
    
    self.getCodeApi = [[GetCodeApi alloc] initWithPhone:self.neweTF.text];
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
    
    self.checkCodeApi = [[CheckCodeApi alloc] initWithPhone:self.neweTF.text withSessionId:_key withCode:self.codeTF.text];
    [self.checkCodeApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        CheckCodeApi *result = (CheckCodeApi *)request;
        if(result.isCorrectResult)
        {
            [self changePhoneApiNet];
        }
    } failure:^(YTKBaseRequest *request) {
        
    }];
}


- (IBAction)getCodeAction:(id)sender {
    if (![ControlUtil validatePhone:self.neweTF.text]) {
        [XHToast showCenterWithText:@"请输入正确的手机号"];
        return;
    }
    [_getcodeBtn jk_startTime:60 title:@"获取验证码" waitTittle:@""];
    [self getGetCodeApiNet];
}
- (IBAction)saveAction:(id)sender {
    if (![ControlUtil validatePhone:self.neweTF.text]) {
        [XHToast showCenterWithText:@"请输入正确的手机号"];
        return;
    }
    if (!isValidStr(self.codeTF.text)) {
        [XHToast showCenterWithText:@"请输入验证码"];
        return;
    }
    
    [self checkCodeApiNet];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
