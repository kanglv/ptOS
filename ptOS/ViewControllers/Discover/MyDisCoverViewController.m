//
//  MyDisCoverViewController.m
//  ptOS
//
//  Created by 周瑞 on 16/8/31.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "MyDisCoverViewController.h"
#import "MyPublishViewController.h"
#import "MyCommentViewController.h"

@interface MyDisCoverViewController ()

@end

@implementation MyDisCoverViewController

#pragma mark - lifeCycles

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"发现"];
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
- (IBAction)myCommentPress:(id)sender {
    MyCommentViewController *ctrl = [[MyCommentViewController alloc]init];
    [self.navigationController pushViewController:ctrl animated:YES];
}
- (IBAction)myPublishPress:(id)sender {
    MyPublishViewController *ctrl = [[MyPublishViewController alloc]init];
    [self.navigationController pushViewController:ctrl animated:YES];
}


#pragma mark - delegate


#pragma mark - lazyViews

@end
