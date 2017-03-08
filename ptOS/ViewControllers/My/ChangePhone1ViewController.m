//
//  ChangePhone1ViewController.m
//  ptOS
//
//  Created by 周瑞 on 16/10/8.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "ChangePhone1ViewController.h"
#import "ChangePhone2ViewController.h"

@interface ChangePhone1ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UIButton *yanzhengBtn;


@end

@implementation ChangePhone1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"修改手机号"];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 45)];
    self.phoneTF.leftView = view;
    self.phoneTF.leftViewMode = UITextFieldViewModeAlways;
    
    self.yanzhengBtn.layer.cornerRadius = 20;
    
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
    self.phoneLabel.text = [NSString stringWithFormat:@"    %@",result];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)yanzhengBtnPress:(id)sender {
    NSString *mobile = [NSString stringWithString:[GlobalData sharedInstance].selfInfo.phone];
    if ([self.phoneTF.text isEqualToString:mobile]) {
        ChangePhone2ViewController *ctrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChangePhone2ViewController"];
        [self.navigationController pushViewController:ctrl animated:YES];
    }else {
        [XHToast showCenterWithText:@"手机号码不正确"];
    }
}



@end
