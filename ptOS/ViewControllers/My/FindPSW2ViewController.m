//
//  FindPSW2ViewController.m
//  ptOS
//
//  Created by 周瑞 on 16/9/1.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "FindPSW2ViewController.h"
#import "MY_ChangePswApi.h"
#import "FindPswApi.h"
#import "UIButton+JKTouchAreaInsets.h"
#import "AFHTTPRequestOperation.h"
@interface FindPSW2ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *closeBgn;
@property (nonatomic, strong)MY_ChangePswApi *changePswApi;
@property (nonatomic, strong)FindPswApi *findPswApi;
@property (weak, nonatomic) IBOutlet UITextField *pswTF;

@end

@implementation FindPSW2ViewController

#pragma mark - lifeCycles

- (void)viewDidLoad {
    [super viewDidLoad];
    self.closeBgn.jk_touchAreaInsets = UIEdgeInsetsMake(50, 50, 50, 50);
    self.needNav = NO;
    self.pswTF.secureTextEntry = YES;

    self.pswTF.textColor = WhiteColor;
    [self.pswTF setValue:WhiteColor forKeyPath:@"_placeholderLabel.textColor"];
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

#pragma mark - NetworkApis
- (void)changPswApiNet {
    if(self.findPswApi&& !self.findPswApi.requestOperation.isFinished)
    {
        [self.findPswApi stop];
    }
    
    self.findPswApi = [[FindPswApi alloc] initWithPsw:self.pswTF.text withPhone:self.phone];
    [self.findPswApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        FindPswApi *result = (FindPswApi *)request;
        if(result.isCorrectResult)
        {
            [XHToast showCenterWithText:@"设置成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } failure:^(YTKBaseRequest *request) {
        
    }];
}


#pragma mark - customFuncs
- (IBAction)sureBtnPress:(id)sender {
    if (![ControlUtil validatePWD:self.pswTF.text]) {
        [XHToast showCenterWithText:@"密码必须由6-16位的字母或数字组成"];
        return;
    }
    [self changPswApiNet];
}
- (IBAction)closeAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - delegate


#pragma mark - lazyViews

@end
