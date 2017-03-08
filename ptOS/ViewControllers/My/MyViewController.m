//
//  MyViewController.m
//  ptOS
//
//  Created by 周瑞 on 16/8/30.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "MyViewController.h"
#import "MyDisCoverViewController.h"
#import "MyResumeViewController.h"
#import "My_SettingViewController.h"
#import "My_JobViewController.h"
#import "GetUserInfoApi.h"
#import "UserInfoModel.h"
#import "AFHTTPRequestOperation.h"
#import "MyChangeHeaderViewController.h"
#import "MyFavoriteViewController.h"


@interface MyViewController ()

@property (weak, nonatomic) IBOutlet UIView *bottomView1;

@property (weak, nonatomic) IBOutlet UIView *bottomView3;

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@property (nonatomic,strong)GetUserInfoApi *getUserInfoApi;

@end

@implementation MyViewController

#pragma mark - lifeCycles

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人中心";
    [NotificationCenter addObserver:self selector:@selector(refreshFace) name:@"refreshFace" object:nil];
    [self initRadios];
}

- (void)dealloc {
    [NotificationCenter removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //去掉导航栏下面的黑线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    if (isValidStr([GlobalData sharedInstance].selfInfo.sessionId)) {
//如果已经登录,如果昵称为null则显示注册帐号
        if([[GlobalData sharedInstance].selfInfo.nickName isEqualToString:@""]) {
            self.nickNameLabel.text = [GlobalData sharedInstance].selfInfo.userName;
        } else{
            self.nickNameLabel.text = [GlobalData sharedInstance].selfInfo.nickName;
        }

        NSData *data = [UserDefault objectForKey:HeaderKey];
        UIImage *image = [UIImage imageWithData:data];
        if (image) {
            self.headerImageView.image = image;
        }else {
            self.headerImageView.image = [UIImage imageNamed:@"morentouxiang"];
        }
    }else {
        self.headerImageView.image = [UIImage imageNamed:@"morentouxiang"];
        self.nickNameLabel.text = @"登录/注册";
    }
}

- (void)refreshFace {
    NSData *data = [UserDefault objectForKey:HeaderKey];
    UIImage *image = [UIImage imageWithData:data];
    if (image) {
        self.headerImageView.image = image;
    }else {
        self.headerImageView.image = [UIImage imageNamed:@"morentouxiang"];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - customFuncs
//设置圆角
- (void)initRadios {
    ZRViewRadius(self.bottomView1, 10);
   
    ZRViewRadius(self.bottomView3, 10);
    ZRViewRadius(self.headerImageView, 45);
    self.headerImageView.clipsToBounds = YES;

    self.headerImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpToChange:)];
    [self.headerImageView addGestureRecognizer:g];
}

- (void)jumpToChange:(UITapGestureRecognizer *)g {
    if (!isValidStr([GlobalData sharedInstance].selfInfo.sessionId))
    {
        [self presentLoginCtrl];
        return;
    }
    MyChangeHeaderViewController *ctrl = [[MyChangeHeaderViewController alloc]init];
    [self.navigationController pushViewController:ctrl animated:YES];
}

//点击简历
- (IBAction)resumeAction:(id)sender {
    if (!isValidStr([GlobalData sharedInstance].selfInfo.sessionId))
    {
        [self presentLoginCtrl];
        return;
    }
    MyResumeViewController *ctrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyResumeViewController"];
    [self.navigationController pushViewController:ctrl animated:YES];
}

//点击职位
- (IBAction)jobsAction:(id)sender {
    if (!isValidStr([GlobalData sharedInstance].selfInfo.sessionId))
    {
        [self presentLoginCtrl];
        return;
    }
    My_JobViewController *ctrl = [[My_JobViewController alloc]init];
    [self.navigationController pushViewController:ctrl animated:YES];
}

//点击发现
- (IBAction)discoverAction:(id)sender {
    if (!isValidStr([GlobalData sharedInstance].selfInfo.sessionId))
    {
        [self presentLoginCtrl];
        return;
    }
    MyDisCoverViewController *ctrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyDisCoverViewController"];
    [self.navigationController pushViewController:ctrl animated:YES];
}

//点击关注
- (IBAction)attention:(id)sender {
    NSLog(@"关注按钮呗点击");
    MyFavoriteViewController *favoriteViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyFavoriteViewController"];
    [self.navigationController pushViewController:favoriteViewController animated:YES];
}

//点击设置
- (IBAction)settingAction:(id)sender {
    My_SettingViewController *ctrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"My_SettingViewController"];
    [self.navigationController pushViewController:ctrl animated:YES];
}

#pragma mark - NetworkApis
- (void)getUserInfoApiNet {
    if(self.getUserInfoApi && !self.getUserInfoApi.requestOperation.isFinished)
    {
        [self.getUserInfoApi stop];
    }
    
    self.getUserInfoApi = [[GetUserInfoApi alloc] init];
    self.getUserInfoApi.netLoadingDelegate = self;
    [self.getUserInfoApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        GetUserInfoApi *result = (GetUserInfoApi *)request;
        if(result.isCorrectResult)
        {
            [GlobalData sharedInstance].selfInfo = [result getUserInfo];
        }
        
    } failure:^(YTKBaseRequest *request) {
        
    }];
}

#pragma mark - delegate


#pragma mark - lazyViews

@end
