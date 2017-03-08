//
//  H5ViewController.m
//  ptOS
//
//  Created by 周瑞 on 16/9/10.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "H5ViewController.h"

@interface H5ViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *m_webView;
@end

@implementation H5ViewController

#pragma mark - lifeCycles

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
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
- (void)initWithURL:(NSString *)url andTitle:(NSString *)title {
    [self.navigationItem setTitle:title];
    [self.m_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

#pragma mark - delegate


#pragma mark - lazyViews

@end
