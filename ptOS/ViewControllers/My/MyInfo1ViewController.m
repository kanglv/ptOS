//
//  MyInfo1ViewController.m
//  ptOS
//
//  Created by 周瑞 on 16/8/31.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "MyInfo1ViewController.h"
#import "MyInfo2ViewController.h"
#import "MHDatePicker.h"
#import "UIButton+JKTouchAreaInsets.h"
#import "LTPickerView.h"

@interface MyInfo1ViewController ()
{
    BOOL _isBirth;
    BOOL _isEdu;
}
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UIView *manLeftBtn;
@property (weak, nonatomic) IBOutlet UIButton *manBtn;
@property (weak, nonatomic) IBOutlet UIView *womenLetfBtn;
@property (weak, nonatomic) IBOutlet UIButton *womenBtn;
@property (weak, nonatomic) IBOutlet UIButton *riliBtn;
@property (weak, nonatomic) IBOutlet UIButton *xueliBtn;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;

@property (strong, nonatomic) MHDatePicker *selectDatePicker;

@end

@implementation MyInfo1ViewController

#pragma mark - lifeCycles

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manBtn.jk_touchAreaInsets = UIEdgeInsetsMake(10, 20, 10, 1);
    self.womenBtn.jk_touchAreaInsets = UIEdgeInsetsMake(10, 20, 10, 1);
    [self.navigationItem setTitle:@"基本信息"];
    _isBirth = NO;
    _isEdu = NO;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"下一步" forState:UIControlStateNormal];
    [btn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake(0, 0, 60, 40)];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self initUI];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (isValidStr([GlobalData sharedInstance].jl_name)) {
        self.nameTF.text = [GlobalData sharedInstance].jl_name;
    }
    if (isValidStr([GlobalData sharedInstance].jl_birth)) {
        [self.riliBtn setTitle:[GlobalData sharedInstance].jl_birth forState:UIControlStateNormal];
        _isBirth = YES;
    }
    if (isValidStr([GlobalData sharedInstance].jl_education)) {
        NSString *edu;
        if ([[GlobalData sharedInstance].jl_education isEqualToString:@"5"]) {
            edu = @"本科及以上";
        }else if ([[GlobalData sharedInstance].jl_education isEqualToString:@"4"]) {
            edu = @"大专";
        }else if ([[GlobalData sharedInstance].jl_education isEqualToString:@"3"]) {
            edu = @"高中";
        }else if ([[GlobalData sharedInstance].jl_education isEqualToString:@"2"]) {
            edu = @"中专";
        }else if ([[GlobalData sharedInstance].jl_education isEqualToString:@"1"]) {
            edu = @"初中";
        }else if ([[GlobalData sharedInstance].jl_education isEqualToString:@"0"]) {
            edu = @"小学";
        }
        [self.xueliBtn setTitle:edu forState:UIControlStateNormal];
        _isEdu = YES;
    }
    if (isValidStr([GlobalData sharedInstance].jl_phone)) {
        self.phoneNumLabel.text = [GlobalData sharedInstance].jl_phone;
    }
    NSString *sex = [GlobalData sharedInstance].jl_sex;
    if ([sex isEqualToString:@"0"]) {
        self.manLeftBtn.hidden = NO;
        self.womenLetfBtn.hidden = YES;
    }else {
        self.manLeftBtn.hidden = YES;
        self.womenLetfBtn.hidden = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - customFuncs
- (void)initUI {
    ZRViewRadius(self.manLeftBtn, 8);
    ZRViewRadius(self.womenLetfBtn, 8);
    ZRViewRadius(self.oneLabel, 12.5);
    
    [self.riliBtn addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventTouchUpInside];
    [self.xueliBtn addTarget:self action:@selector(setEdu) forControlEvents:UIControlEventTouchUpInside];
    

    [self.manBtn addTarget:self action:@selector(manBtnPress) forControlEvents:UIControlEventTouchUpInside];
    [self.womenBtn addTarget:self action:@selector(womenBtnPress) forControlEvents:UIControlEventTouchUpInside];
}

- (void)next {
    if (!isValidStr(self.nameTF.text)) {
        [XHToast showCenterWithText:@"请输入姓名"];
        return;
    }
    if (!_isBirth || !_isEdu) {
        [XHToast showCenterWithText:@"请填写完整"];
        return;
    }
    if (self.manLeftBtn.hidden == YES) {
        //女
        [GlobalData sharedInstance].jl_sex = @"1";
    }else {
        //男
        [GlobalData sharedInstance].jl_sex = @"0";
    }
    [GlobalData sharedInstance].jl_name = self.nameTF.text;
    [GlobalData sharedInstance].jl_phone = [GlobalData sharedInstance].selfInfo.phone;
    MyInfo2ViewController *ctrl =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyInfo2ViewController"];
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void)setEdu {
    LTPickerView* pickerView = [LTPickerView new];
    pickerView.dataSource = @[@"小学", @"初中",@"中专",@"高中",@"大专",@"本科及以上"];//设置要显示的数据
    pickerView.defaultStr = @"本科及以上";//默认选择的数据
    [pickerView show];//显示
    //回调block
    pickerView.block = ^(LTPickerView* obj,NSString* str,int num){
        //obj:LTPickerView对象
        //str:选中的字符串
        //num:选中了第几行
        NSString *str1 = [NSString stringWithFormat:@"%d",num];
        [self.xueliBtn setTitle:str forState:UIControlStateNormal];
        [GlobalData sharedInstance].jl_education = str1;
        _isEdu = YES;
    };
    [self.view endEditing:YES];
}

- (void)selectDate:(id)sender {
    
    _selectDatePicker = [[MHDatePicker alloc] init];
    _selectDatePicker.isBeforeTime = YES;
    _selectDatePicker.datePickerMode = UIDatePickerModeDate;
    
    __weak typeof(self) weakSelf = self;
    [_selectDatePicker didFinishSelectedDate:^(NSDate *selectedDate) {
        NSString *time = [weakSelf dateStringWithDate:selectedDate DateFormat:@"yyyy年MM月dd日"];
        [weakSelf.riliBtn setTitle:time forState:UIControlStateNormal];
        [GlobalData sharedInstance].jl_birth = time;
        _isBirth = YES;
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

- (void)manBtnPress {
    self.manLeftBtn.hidden = NO;
    self.womenLetfBtn.hidden = YES;
    [self.view endEditing:YES];
}

- (void)womenBtnPress {
    self.manLeftBtn.hidden = YES;
    self.womenLetfBtn.hidden = NO;
    [self.view endEditing:YES];
}

#pragma mark - delegate


#pragma mark - lazyViews

@end
