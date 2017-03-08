//
//  BaseViewController.m
//  ptOS
//
//  Created by 周瑞 on 16/8/29.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "AFNetworkReachabilityManager.h"
#import "GlobalData.h"


@interface BaseViewController ()

@end

@implementation BaseViewController
{
    UIImageView *noNetWorkingImage;
    UIImageView *noDataImage;
    UIView *loadingView;
    
    NSTimer *timer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.needNav = YES;
    self.view.backgroundColor = BackgroundColor;
    //设置导航栏标题的颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     
  @{NSFontAttributeName:[UIFont systemFontOfSize:16],
    
    
    NSForegroundColorAttributeName:WhiteColor}];
    
    //导航栏颜色不透明，如果不设置，导航栏的颜色会有差别
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = MainColor;
    self.navigationController.navigationBar.tintColor = WhiteColor;
    self.view.backgroundColor = BackgroundColor;
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] init];
    returnButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = returnButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if(self.needNav)
    {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    else
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//联网正常返回后，需要显示无数据的界面调用一下，并实现hasData函数
- (void)showNoDataView
{
    [self removeAllWarning];
    
    if(![self hasData])
    {
        CGFloat width = FITWIDTH(150);
        noDataImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 250, width * 2.2, width)];
        noDataImage.centerX = self.view.centerX;
        noDataImage.y = noDataImage.y - FITWIDTH(100);
        noDataImage.image = [UIImage imageNamed:@"kongbai"];
        [self.view addSubview:noDataImage];
        
        [self.view bringSubviewToFront:noDataImage];
    }
}

- (void)showNoDataViewOnView:(UIView *)view
{
    [self removeAllWarning];
        CGFloat width = FITWIDTH(200);
        noDataImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 200, width, width)];
        noDataImage.center  = self.view.center;
        noDataImage.image = [UIImage imageNamed:@"kongbai"];
        [view addSubview:noDataImage];
        
        [view bringSubviewToFront:noDataImage];
}

- (void)removeNoData {
    if(noDataImage)
    {
        [noDataImage removeFromSuperview];
        noDataImage = nil;
    }
}

- (void)removeAllWarning
{
    if(noNetWorkingImage)
    {
        [noNetWorkingImage removeFromSuperview];
        noNetWorkingImage = nil;
    }
    
    if(noDataImage)
    {
        [noDataImage removeFromSuperview];
        noDataImage = nil;
    }
    
    if(loadingView)
    {
        [loadingView removeFromSuperview];
        loadingView = nil;
    }
}


#pragma mark --SessionExpireDelegate
//session过期
- (void)sessionIsExpire:(BaseNetApi *)object
{
    [GlobalData sharedInstance].selfInfo = nil;
    //    [UMessage setAlias:UN_VALID_ALIAS type:ALIAS_TYPE response:^(id responseObject, NSError *error) {
    
    //    }];
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *_tmpArray = [NSArray arrayWithArray:[cookieJar cookies]];
    for (NSHTTPCookie *obj in _tmpArray) {
        if([obj.name isEqualToString:@"sessionID"] || [obj.name isEqualToString:@"sessionId"])
        {
            [cookieJar deleteCookie:obj];
        }
    }
    [self presentLoginCtrl];
}

- (void)presentLoginCtrl
{
    LoginViewController *ctrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
    [self.navigationController presentViewController:nav animated:YES completion:^{
        
    }];
}

#pragma mark --NoNetWorkingDelegate
//网络接口出错后判断是否有数据，然后判断是否有网络，网络正常显示无数据，网络异常显示无网络
- (void)noNetWorking
{
    [self removeAllWarning];
    
    if(![self hasData])
    {
        if(![AFNetworkReachabilityManager sharedManager].isReachable)
        {
            CGFloat width = FITWIDTH(150);
            noNetWorkingImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 250, width * 2.2, width)];
            noNetWorkingImage.image = [UIImage imageNamed:@"chucuo"];
            noNetWorkingImage.centerX = self.view.centerX;
            [self.view addSubview:noNetWorkingImage];
            
            [self.view bringSubviewToFront:noNetWorkingImage];
        }
        else
        {
            [self showNoDataView];
        }
    }
}

- (BOOL)hasData
{
    return YES;
}

#pragma mark --NetLoadingDelegate
- (void)startLoading
{
    [self removeAllWarning];
    
    CGFloat width = 100;
    CGFloat imageWidth = 80;
    
    loadingView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - width)/2, (self.view.frame.size.height - width)/2, width, width)];
    [self.view addSubview:loadingView];
    
    UIImageView *gifImageView = [[UIImageView alloc] initWithFrame:CGRectMake((width -imageWidth)/2, 0, imageWidth, imageWidth)];
    NSArray *gifArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"jiazaizhong01"],
                         [UIImage imageNamed:@"jiazaizhong02"],
                         [UIImage imageNamed:@"jiazaizhong03"],
                         [UIImage imageNamed:@"jiazaizhong04"],
                         [UIImage imageNamed:@"jiazaizhong05"],
                         [UIImage imageNamed:@"jiazaizhong06"],
                         [UIImage imageNamed:@"jiazaizhong02"],nil];
    gifImageView.animationImages = gifArray; //动画图片数组
    gifImageView.animationDuration = 1; //执行一次完整动画所需的时长
    gifImageView.animationRepeatCount = 0;  //动画重复次数
    [loadingView addSubview:gifImageView];
    
    
    UILabel *lable = [ControlUtil lableView:@"努力加载中…"
                                  backColor:[UIColor clearColor]
                                  textColor:MainColor
                                   textFont:[UIFont systemFontOfSize:12.0]
                                  WithFrame:CGRectMake(0, imageWidth, width, width - imageWidth) textAlignment:NSTextAlignmentCenter];
    [loadingView addSubview:lable];
    
    [gifImageView startAnimating];
    
}

- (void)stopLoading
{
    if(loadingView)
    {
        [loadingView removeFromSuperview];
        loadingView = nil;
    }
}

@end
