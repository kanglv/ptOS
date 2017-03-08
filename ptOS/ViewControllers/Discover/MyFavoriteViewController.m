//
//  MyFavoriteViewController.m
//  ptOS
//
//  Created by 周瑞 on 16/8/31.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "MyFavoriteViewController.h"

#import "ConcernJobViewController.h"

#import "ConcernCompanyViewController.h"

@interface MyFavoriteViewController ()

@end

@implementation MyFavoriteViewController

#pragma mark - lifeCycles

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关注";
    
}

- (IBAction)companyBtnClick:(id)sender {
    //关注的企业
    ConcernCompanyViewController *companyViewController = [[ConcernCompanyViewController alloc]init];
    [self.navigationController pushViewController:companyViewController animated:YES];
}
- (IBAction)peopleBtnClick:(id)sender {
    //关注的人
}

- (IBAction)jobBtnClick:(id)sender {
    //关注的职位
    
    ConcernJobViewController *jobViewController = [[ConcernJobViewController alloc]init];
    [self.navigationController pushViewController:jobViewController animated:YES];

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



@end
