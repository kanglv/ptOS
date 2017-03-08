//
//  PutongViewController.m
//  ptOS
//
//  Created by 周瑞 on 16/8/30.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "PutongViewController.h"
#import "PT_QiuzhiViewController.h"
#import "AFHTTPRequestOperation.h"
#import "PT_MsgNumApi.h"
#import "PT_ClearMsgNumApi.h"
#import "PT_MsgNumModel.h"
#import "PT_NearlyListViewController.h"
#import "NTESContactViewController.h"
#import "NTESSearchTeamViewController.h"
#import "UIAlertView+NTESBlock.h"
#import "UIActionSheet+NTESBlock.h"
#import "NTESContactAddFriendViewController.h"
#import "UIView+Toast.h"
#import "NIMContactSelectViewController.h"
#import "NTESSessionViewController.h"

@interface PutongViewController ()
@property (nonatomic,strong)PT_MsgNumApi *msgNumApi;
@property (nonatomic,strong)PT_ClearMsgNumApi *clearMsgNumApi;


@end

@implementation PutongViewController



#pragma mark - lifeCycles

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"扑通"];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(23, 23, 20, 20);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"icon_tongxunlu.png"] forState:UIControlStateNormal];
    //    backBtn.centerY = doneButton.centerY;
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
    [backBtn addTarget:self action:@selector(backToFirst) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(23, 23, 20, 20);
    [addBtn setBackgroundImage:[UIImage imageNamed:@"icon_tianjia.png"] forState:UIControlStateNormal];
    //    backBtn.centerY = doneButton.centerY;
    [addBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
    [addBtn addTarget:self action:@selector(rightToFirst) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (isValidStr([GlobalData sharedInstance].selfInfo.sessionId))
    {
        [self msgNumApiNet];
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
    ZRViewRadius(self.msgNumLabel, 11);
    ZRViewRadius(self.bottomView1, 10);
    self.timeLabel.hidden = YES;
    self.detailLabel.hidden = YES;
    self.msgNumLabel.hidden = YES;
}
//活动按钮事件
- (IBAction)activityAction:(id)sender {
}
//附近的人点击事件
- (IBAction)nearbyAction:(id)sender {
    PT_NearlyListViewController *nearlyListViewController = [[PT_NearlyListViewController alloc]init];
    [self.navigationController pushViewController:nearlyListViewController animated:YES];
    
}
//通知消息点击事件
- (IBAction)messageAction:(id)sender {
}
//我关注的人点击事件
- (IBAction)concernAction:(id)sender {
}

- (IBAction)QZBtnPress:(id)sender {
    if (!isValidStr([GlobalData sharedInstance].selfInfo.sessionId))
    {
        [self presentLoginCtrl];
        return;
    }
    [self clearMsgNumApiNet];
    PT_QiuzhiViewController *ctrl = [[PT_QiuzhiViewController alloc]init];
    [self.navigationController pushViewController:ctrl animated:YES];
}


#pragma mark - NetworkApis 
- (void)msgNumApiNet {
    if(self.msgNumApi && !self.msgNumApi.requestOperation.isFinished)
    {
        [self.msgNumApi stop];
    }
    
    self.msgNumApi.sessionDelegate = self;
    self.msgNumApi = [[PT_MsgNumApi alloc]init];
    self.msgNumApi.netLoadingDelegate = self;
    [self.msgNumApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        PT_MsgNumApi *result = (PT_MsgNumApi *)request;
        if(result.isCorrectResult)
        {
            self.timeLabel.hidden = NO;
            self.detailLabel.hidden = NO;
            self.msgNumLabel.hidden = NO;
            PT_MsgNumModel *model = [result getMsgNumModel];
            self.detailLabel.text = model.content;
            if ([model.content isEqualToString:@""]) {
                self.detailLabel.text = @"暂无新的消息";
            }
            self.timeLabel.text = model.time;
            
            self.msgNumLabel.text = model.number;
            if ([model.number isEqualToString:@"0"]) {
                self.msgNumLabel.hidden = YES;
            }
        }
        
    } failure:^(YTKBaseRequest *request) {
        
    }];
}

- (void)clearMsgNumApiNet {
    if(self.clearMsgNumApi && !self.clearMsgNumApi.requestOperation.isFinished)
    {
        [self.clearMsgNumApi stop];
    }
    
    self.clearMsgNumApi.sessionDelegate = self;
    self.clearMsgNumApi = [[PT_ClearMsgNumApi alloc]init];
    self.clearMsgNumApi.netLoadingDelegate = self;
    [self.clearMsgNumApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        PT_ClearMsgNumApi *result = (PT_ClearMsgNumApi *)request;
        if(result.isCorrectResult)
        {
            
        }
        
    } failure:^(YTKBaseRequest *request) {
        
    }];
}

- (void)rightToFirst{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"添加好友",@"创建高级群",@"创建讨论组",@"搜索高级群", nil];
    __weak typeof(self) wself = self;
    NSString *currentUserId = [[NIMSDK sharedSDK].loginManager currentAccount];
    [sheet showInView:self.view completionHandler:^(NSInteger index) {
        UIViewController *vc;
        switch (index) {
            case 0:
                vc = [[NTESContactAddFriendViewController alloc] initWithNibName:nil bundle:nil];
                break;
            case 1:{  //创建高级群
                [wself presentMemberSelector:^(NSArray *uids) {
                    NSArray *members = [@[currentUserId] arrayByAddingObjectsFromArray:uids];
                    NIMCreateTeamOption *option = [[NIMCreateTeamOption alloc] init];
                    option.name       = @"高级群";
                    option.type       = NIMTeamTypeAdvanced;
                    option.joinMode   = NIMTeamJoinModeNoAuth;
                    option.postscript = @"邀请你加入群组";
                    [SVProgressHUD show];
                    [[NIMSDK sharedSDK].teamManager createTeam:option users:members completion:^(NSError *error, NSString *teamId) {
                        [SVProgressHUD dismiss];
                        if (!error) {
                            NIMSession *session = [NIMSession session:teamId type:NIMSessionTypeTeam];
                            NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
                            [wself.navigationController pushViewController:vc animated:YES];
                        }else{
                            [wself.view makeToast:@"创建失败" duration:2.0 position:CSToastPositionCenter];
                        }
                    }];
                }];
                break;
            }
            case 2:{ //创建讨论组
                [wself presentMemberSelector:^(NSArray *uids) {
                    if (!uids.count) {
                        return; //讨论组必须除自己外必须要有一个群成员
                    }
                    NSArray *members = [@[currentUserId] arrayByAddingObjectsFromArray:uids];
                    NIMCreateTeamOption *option = [[NIMCreateTeamOption alloc] init];
                    option.name       = @"讨论组";
                    option.type       = NIMTeamTypeNormal;
                    [SVProgressHUD show];
                    [[NIMSDK sharedSDK].teamManager createTeam:option users:members completion:^(NSError *error, NSString *teamId) {
                        [SVProgressHUD dismiss];
                        if (!error) {
                            NIMSession *session = [NIMSession session:teamId type:NIMSessionTypeTeam];
                            NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
                            [wself.navigationController pushViewController:vc animated:YES];
                        }else{
                            [wself.view makeToast:@"创建失败" duration:2.0 position:CSToastPositionCenter];
                        }
                    }];
                }];
                break;
            }
            case 3:
                vc = [[NTESSearchTeamViewController alloc] initWithNibName:nil bundle:nil];
                break;
            default:
                break;
        }
        if (vc) {
            [wself.navigationController pushViewController:vc animated:YES];
        }
    }];
    
}

- (void)backToFirst{
    
    NTESContactViewController *vc = [[NTESContactViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)presentMemberSelector:(ContactSelectFinishBlock) block{
    NSMutableArray *users = [[NSMutableArray alloc] init];
    //使用内置的好友选择器
    NIMContactFriendSelectConfig *config = [[NIMContactFriendSelectConfig alloc] init];
    //获取自己id
    NSString *currentUserId = [[NIMSDK sharedSDK].loginManager currentAccount];
    [users addObject:currentUserId];
    //将自己的id过滤
    config.filterIds = users;
    //需要多选
    config.needMutiSelected = YES;
    //初始化联系人选择器
    NIMContactSelectViewController *vc = [[NIMContactSelectViewController alloc] initWithConfig:config];
    //回调处理
    vc.finshBlock = block;
    [vc show];
}

#pragma mark - delegate


#pragma mark - lazyViews
@end
