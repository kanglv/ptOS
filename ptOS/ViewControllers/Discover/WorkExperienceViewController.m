//
//  WorkExperienceViewController.m
//  ptOS
//
//  Created by 周瑞 on 16/8/31.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "WorkExperienceViewController.h"

@interface WorkExperienceViewController ()
@property (strong, nonatomic) IBOutlet UITextView *textView;


@end

@implementation WorkExperienceViewController

#pragma mark - lifeCycles

- (void)viewDidLoad {
    [super viewDidLoad];
     [self.navigationItem setTitle:@"工作经历"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake(0, 0, 60, 40)];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;

}

- (void)next {
    [GlobalData sharedInstance].jl_workExp = self.textView.text;
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


#pragma mark - delegate


#pragma mark - lazyViews

@end
