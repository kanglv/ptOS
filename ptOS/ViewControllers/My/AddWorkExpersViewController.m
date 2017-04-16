//
//  AddWorkExpersViewController.m
//  ptOS
//
//  Created by 吕康 on 17/4/6.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "AddWorkExpersViewController.h"
#import "UITextView+JKSelect.h"
#import "UITextView+JKPlaceHolder.h"
#import "MHDatePicker.h"

@interface AddWorkExpersViewController ()

@property (strong, nonatomic) IBOutlet UILabel *inTimeLabel;
@property (strong, nonatomic) IBOutlet UIButton *inTimeBtn;

@property (strong, nonatomic) IBOutlet UILabel *outTimeLabel;
@property (strong, nonatomic) IBOutlet UIButton *outTimeBtn;

@property (strong, nonatomic) IBOutlet UITextField *companyTextFiled;
@property (strong, nonatomic) IBOutlet UITextView *descripteTextView;

@property (strong, nonatomic) MHDatePicker *selectDatePicker;

@property (strong,nonatomic) NSString * isNew;

@end

@implementation AddWorkExpersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    [self.navigationItem setTitle:@"添加经历"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"添加" forState:UIControlStateNormal];
    [btn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake(0, 0, 60, 40)];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.inTimeBtn.tag = 1;
    [self.inTimeBtn addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventTouchUpInside];
    
    self.outTimeBtn.tag = 2;
    [self.outTimeBtn addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.descripteTextView jk_addPlaceHolder: @"   请添加描述"];
    
    //输入公司的testField设置
    self.companyTextFiled.placeholder = @"输入公司名";
    self.companyTextFiled.borderStyle =  UITextBorderStyleNone;
    
    
    

}

- (void)selectDate:(UIButton *)sender {
    
    _selectDatePicker = [[MHDatePicker alloc] init];
    _selectDatePicker.isBeforeTime = YES;
    _selectDatePicker.datePickerMode = UIDatePickerModeDate;
    
    __weak typeof(self) weakSelf = self;
    [_selectDatePicker didFinishSelectedDate:^(NSDate *selectedDate) {
        NSString *time = [weakSelf dateStringWithDate:selectedDate DateFormat:@"yyyy年MM月"];
        NSDate *now = [NSDate date];
        if([selectedDate timeIntervalSinceDate:now] > 0.0){
            [XHToast showCenterWithText:@"时间选择错误，请重试"];
        } else{
            if(sender.tag == 1){
                self.inTimeLabel.text = time;
            } else {
                self.outTimeLabel.text = time;
            }
        }
    }];
    [self.view endEditing:YES];
}

- (NSString *)dateStringWithDate:(NSDate *)date DateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSString *str = [dateFormatter stringFromDate:date];
    return str ? str : @"";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)add:(UIButton *)sender{
    //防止多次点击
    [sender setEnabled:NO];
    
    //发一个通知，跳转到前一个页面
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:self.inTimeLabel.text forKey:@"inTime"];
    [dic setValue:self.outTimeLabel.text forKey:@"outTime"];
    [dic setValue:self.companyTextFiled.text forKey:@"companyName"];
    [dic setValue:self.descripteTextView.text forKey:@"description"];
    
    NSString *string;
    if([GlobalData sharedInstance].jl_resumeId){
        //已存在的
        string = [GlobalData sharedInstance].jl_resumeId;
       
    } else {
        //新增的
        string = [GlobalData sharedInstance].selfInfo.userId;
    }

    [dic setValue:string forKey:@"resumeId"];
    if([self.indexExpersId isEqualToString:@"10000"]){
        self.isNew = @"1";
        //如何设一个ID?
         [dic setValue: [GlobalData sharedInstance].jl_expersID forKey:@"id"];
         int i = [[GlobalData sharedInstance].jl_expersID intValue] + 1;
       
        [GlobalData sharedInstance].jl_expersID = [NSString stringWithFormat:@"%d",i];
        
    }else {
        self.isNew = @"0";
        [dic setValue:self.indexExpersId forKey:@"id"];
    }

    
    [dic setValue:@"" forKey:@"voice"];
    
    NSMutableDictionary *addDic =[[NSMutableDictionary alloc]init];
    
    [addDic setValue:self.isNew forKey:@"isNew"];
    [addDic setValue:dic forKey:@"dataDic"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"workExp" object:self userInfo:addDic];
    
    //跳回上一页
    [self.navigationController popViewControllerAnimated:YES];

    
    
    
}
@end
