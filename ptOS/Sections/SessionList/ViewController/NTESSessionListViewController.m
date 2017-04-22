//
//  NTESSessionListViewController.m
//  NIMDemo
//
//  Created by chris on 15/2/2.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESSessionListViewController.h"
#import "NTESSessionViewController.h"
#import "NTESSessionPeekViewController.h"
#import "UIView+NTES.h"
#import "NTESBundleSetting.h"
#import "NTESListHeader.h"
#import "NTESClientsTableViewController.h"
#import "NTESSnapchatAttachment.h"
#import "NTESJanKenPonAttachment.h"
#import "NTESChartletAttachment.h"
#import "NTESWhiteboardAttachment.h"
#import "NTESSessionUtil.h"
#import "NTESPersonalCardViewController.h"

#import "PT_ListTableViewCell.h"
#import "PT_NearlyTableViewCell.h"
#import "PT_MsgNumApi.h"
#import "PT_ClearMsgNumApi.h"
#import "AFHTTPRequestOperation.h"
#import "BaseNetApi.h"
#import "PT_QiuzhiViewController.h"
#import "LoginViewController.h"
#import "PT_NearlyListViewController.h"
#import "PT_ConcernViewController.h"
#import "PT_NoticeViewController.h"
#import "PT_ClearMessageNumApi.h"

#define SessionListTitle @"云信 Demo"

@interface NTESSessionListViewController ()<NIMLoginManagerDelegate,NTESListHeaderDelegate,UIViewControllerPreviewingDelegate,SessionExpireDelegate,NetLoadingDelegate,NoNetWorkingDelegate>
{
    UIImageView *noNetWorkingImage;
    UIImageView *noDataImage;
    UIView *loadingView;
    
    NSTimer *timer;
}

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) NTESListHeader *header;

@property (nonatomic,assign) BOOL supportsForceTouch;

@property (nonatomic,strong) NSMutableDictionary *previews;

@property (nonatomic,strong) NSMutableArray *pt_listArr;

@property (nonatomic,strong)PT_MsgNumApi *msgNumApi;
@property (nonatomic,strong)PT_ClearMsgNumApi *clearMsgNumApi;
@property (nonatomic,strong)PT_ClearMessageNumApi *clearMessageNumApi;


@end

@implementation NTESSessionListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _previews = [[NSMutableDictionary alloc] init];
        self.autoRemoveRemoteSession = [[NTESBundleSetting sharedConfig] autoRemoveRemoteSession];
    }
    return self;
}

- (void)dealloc{
    [[NIMSDK sharedSDK].loginManager removeDelegate:self];
}


- (void)viewDidLoad{
    [super viewDidLoad];
    self.supportsForceTouch = [self.traitCollection respondsToSelector:@selector(forceTouchCapability)] && self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable;
    
    [[NIMSDK sharedSDK].loginManager addDelegate:self];
    self.header = [[NTESListHeader alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    self.header.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.header.delegate = self;
    [self.view addSubview:self.header];
    
    self.emptyTipLabel = [[UILabel alloc] init];
    self.emptyTipLabel.text = @"还没有会话，在通讯录中找个人聊聊吧";
    [self.emptyTipLabel sizeToFit];
    self.emptyTipLabel.hidden = self.recentSessions.count;
    //    [self.view addSubview:self.emptyTipLabel];
    
    NSString *userID = [[[NIMSDK sharedSDK] loginManager] currentAccount];
    self.navigationItem.titleView  = [self titleView:userID];
    
    self.tableView.backgroundColor = BackgroundColor;
    self.pt_listArr = [NSMutableArray array];
    [self.pt_listArr addObject:@{@"title":@"求职",@"icon":@"icon_pt_qiuzhi",@"viewController":@""}];
    [self.pt_listArr addObject:@{@"title":@"活动",@"icon":@"icon_huodong",@"viewController":@""}];
    [self.pt_listArr addObject:@{@"title":@"我关注的",@"icon":@"icon_dguanzhu",@"viewController":@""}];
    [self.pt_listArr addObject:@{@"title":@"通知消息",@"icon":@"icon_tongzhi",@"viewController":@""}];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (isValidStr([GlobalData sharedInstance].selfInfo.sessionId))
    {
      
    }
}

#pragma mark - NetworkApis

- (void)refresh:(BOOL)reload{
    [super refresh:reload];
    self.emptyTipLabel.hidden = self.recentSessions.count;
}


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



#pragma mark --NoNetWorkingDelegate
//网络接口出错后判断是否有数据，然后判断是否有网络，网络正常显示无数据，网络异常显示无网络
- (void)noNetWorking
{
    
    if(![self hasData])
    {
       
            CGFloat width = FITWIDTH(150);
            noNetWorkingImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 250, width * 2.2, width)];
            noNetWorkingImage.image = [UIImage imageNamed:@"chucuo"];
            noNetWorkingImage.centerX = self.view.centerX;
            [self.view addSubview:noNetWorkingImage];
            
            [self.view bringSubviewToFront:noNetWorkingImage];
    }
}

- (BOOL)hasData
{
    return YES;
}

#pragma mark --NetLoadingDelegate
- (void)startLoading
{
    
    
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
//             [XHToast showCenterWithText:@"清除成功"];
        }
        
    } failure:^(YTKBaseRequest *request) {
        
    }];
}

- (void)clearMsgNumApiNetwithType:(NSString *)type {
    if(self.clearMessageNumApi && !self.clearMessageNumApi.requestOperation.isFinished)
    {
        [self.clearMessageNumApi stop];
    }
    
    self.clearMessageNumApi.sessionDelegate = self;
    self.clearMessageNumApi = [[PT_ClearMessageNumApi alloc]initWithType:type];
    self.clearMessageNumApi.netLoadingDelegate = self;
    [self.clearMessageNumApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        PT_ClearMessageNumApi *result = (PT_ClearMessageNumApi *)request;
        if(result.isCorrectResult)
        {
//            [XHToast showCenterWithText:@"清除成功"];
        }
        
    } failure:^(YTKBaseRequest *request) {
        
    }];
}


- (void)onSelectedRecent:(NIMRecentSession *)recent atIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {//附近的
            if (!isValidStr([GlobalData sharedInstance].selfInfo.sessionId))
            {
                [self presentLoginCtrl];
                return;
            }
            PT_NearlyListViewController *nearlyListViewController = [[PT_NearlyListViewController alloc]init];
            [self.navigationController pushViewController:nearlyListViewController animated:YES];
            
        }else if (indexPath.row == 1){//求职
            if (!isValidStr([GlobalData sharedInstance].selfInfo.sessionId))
            {
                [self presentLoginCtrl];
                return;
            }
            
            [self clearMsgNumApi];
            PT_QiuzhiViewController *ctrl = [[PT_QiuzhiViewController alloc]init];
            [self.navigationController pushViewController:ctrl animated:YES];

            
        }else if (indexPath.row == 2){//活动
            
        }else if (indexPath.row == 3){//我关注的
            if (!isValidStr([GlobalData sharedInstance].selfInfo.sessionId))
            {
                [self presentLoginCtrl];
                return;
            }
             [self clearMsgNumApiNetwithType:@"2"];
            PT_ConcernViewController *concernVc = [[PT_ConcernViewController alloc]init];
            [self.navigationController pushViewController:concernVc animated:YES];
        }else if (indexPath.row == 4){//通知消息
            if (!isValidStr([GlobalData sharedInstance].selfInfo.sessionId))
            {
                [self presentLoginCtrl];
                return;
            }
             [self clearMsgNumApiNetwithType:@"1"];
            PT_NoticeViewController *noticeVc = [[PT_NoticeViewController alloc]init];
            [self.navigationController pushViewController:noticeVc animated:YES];

        }else{
            
        }
        
    }else{
        
        NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:recent.session];
        [self.navigationController pushViewController:vc animated:YES];

    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            static NSString * cellId = @"PT_NearlyTableViewCell";
            PT_NearlyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            
            cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] firstObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            return cell;
        }else{
            static NSString * cellId = @"PT_ListTableViewCell";
            PT_ListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            
            cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] firstObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.icon_image.image = [UIImage imageNamed:self.pt_listArr[indexPath.row - 1][@"icon"]];
            cell.titleLabel.text = self.pt_listArr[indexPath.row - 1][@"title"];
            //如何获取求职的数据，知道有新的通知
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];

           
            if(indexPath.row ==1){
                dic = self.model.qiuzhiDic;
                
            } else if(indexPath.row == 3){
                dic = self.model.guanzhuDic;
            } else if(indexPath.row ==4){
                dic = self.model.tongzhiDic;
            }
            
            //时间
            if(indexPath.row ==2){
                cell.timeLabel.text = @"";
            } else {
                cell.timeLabel.text =[NSString stringWithFormat:@"%@",[dic objectForKey:@"time"]];
            }
            //内容
            if([[dic strForKey:@"content"] isEqualToString:@""]){
                cell.messageLabel.text =@"暂无新消息";
            } else {
                cell.messageLabel.text = [dic strForKey:@"content"];
            }
           
            //消息数目
            if([[dic strForKey:@"number"] isEqualToString:@"0"]){
                cell.tag_numLabel.text = @"";
            } else{
                NSLog(@"数目：%@",[dic strForKey:@"number"]);
                 cell.tag_numLabel.text = [dic strForKey:@"number"];
            }
           
            return cell;
        }
    }else{
        
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        
        return cell;
        
    }
    
}


- (void)onSelectedAvatar:(NIMRecentSession *)recent
             atIndexPath:(NSIndexPath *)indexPath{
    if (recent.session.sessionType == NIMSessionTypeP2P) {
        NTESPersonalCardViewController *vc = [[NTESPersonalCardViewController alloc] initWithUserId:recent.session.sessionId];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)onDeleteRecentAtIndexPath:(NIMRecentSession *)recent atIndexPath:(NSIndexPath *)indexPath{
    [super onDeleteRecentAtIndexPath:recent atIndexPath:indexPath];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self refreshSubview];
}


- (NSString *)nameForRecentSession:(NIMRecentSession *)recent{
    if ([recent.session.sessionId isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]]) {
        return @"我的电脑";
    }
    return [super nameForRecentSession:recent];
}

#pragma mark - SessionListHeaderDelegate

- (void)didSelectRowType:(NTESListHeaderType)type{
    //多人登录
    switch (type) {
        case ListHeaderTypeLoginClients:{
            NTESClientsTableViewController *vc = [[NTESClientsTableViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}


#pragma mark - NIMLoginManagerDelegate
- (void)onLogin:(NIMLoginStep)step{
    [super onLogin:step];
    switch (step) {
        case NIMLoginStepLinkFailed:
            self.titleLabel.text = [SessionListTitle stringByAppendingString:@"(未连接)"];
            break;
        case NIMLoginStepLinking:
            self.titleLabel.text = [SessionListTitle stringByAppendingString:@"(连接中)"];
            break;
        case NIMLoginStepLinkOK:
        case NIMLoginStepSyncOK:
            self.titleLabel.text = SessionListTitle;
            break;
        case NIMLoginStepSyncing:
            self.titleLabel.text = [SessionListTitle stringByAppendingString:@"(同步数据)"];
            break;
        default:
            break;
    }
    [self.titleLabel sizeToFit];
    self.titleLabel.centerX   = self.navigationItem.titleView.width * .5f;
    [self.header refreshWithType:ListHeaderTypeNetStauts value:@(step)];
    [self.view setNeedsLayout];
}

- (void)onMultiLoginClientsChanged
{
    [self.header refreshWithType:ListHeaderTypeLoginClients value:[NIMSDK sharedSDK].loginManager.currentLoginClients];
    [self.view setNeedsLayout];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.supportsForceTouch) {
        id<UIViewControllerPreviewing> preview = [self registerForPreviewingWithDelegate:self sourceView:cell];
        [self.previews setObject:preview forKey:@(indexPath.row)];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.supportsForceTouch) {
        id<UIViewControllerPreviewing> preview = [self.previews objectForKey:@(indexPath.row)];
        [self unregisterForPreviewingWithContext:preview];
        [self.previews removeObjectForKey:@(indexPath.row)];
    }
}


- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)context viewControllerForLocation:(CGPoint)point {
    UITableViewCell *touchCell = (UITableViewCell *)context.sourceView;
    if ([touchCell isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:touchCell];
        NIMRecentSession *recent = self.recentSessions[indexPath.row];
        NTESSessionPeekNavigationViewController *nav = [NTESSessionPeekNavigationViewController instance:recent.session];
        return nav;
    }
    return nil;
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    UITableViewCell *touchCell = (UITableViewCell *)previewingContext.sourceView;
    if ([touchCell isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:touchCell];
        NIMRecentSession *recent = self.recentSessions[indexPath.row];
        NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:recent.session];
        [self.navigationController showViewController:vc sender:nil];
    }
}


#pragma mark - Private
- (void)refreshSubview{
    [self.titleLabel sizeToFit];
    self.titleLabel.centerX   = self.navigationItem.titleView.width * .5f;
    self.tableView.top = self.header.height;
    self.tableView.height = self.view.height - self.tableView.top;
    self.header.bottom    = self.tableView.top + self.tableView.contentInset.top;
    self.emptyTipLabel.centerX = self.view.width * .5f;
    self.emptyTipLabel.centerY = self.tableView.height * .5f;
}

- (UIView*)titleView:(NSString*)userID{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.text =  SessionListTitle;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
    [self.titleLabel sizeToFit];
    UILabel *subLabel  = [[UILabel alloc] initWithFrame:CGRectZero];
    subLabel.textColor = [UIColor grayColor];
    subLabel.font = [UIFont systemFontOfSize:12.f];
    subLabel.text = userID;
    subLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [subLabel sizeToFit];
    
    UIView *titleView = [[UIView alloc] init];
    titleView.width  = subLabel.width;
    titleView.height = self.titleLabel.height + subLabel.height;
    
    subLabel.bottom = titleView.height;
    [titleView addSubview:self.titleLabel];
    [titleView addSubview:subLabel];
    return titleView;
}


- (NSAttributedString *)contentForRecentSession:(NIMRecentSession *)recent{
    NSAttributedString *content;
    if (recent.lastMessage.messageType == NIMMessageTypeCustom)
    {
        NIMCustomObject *object = recent.lastMessage.messageObject;
        NSString *text = @"";
        if ([object.attachment isKindOfClass:[NTESSnapchatAttachment class]]) {
            text = @"[阅后即焚]";
        }
        else if ([object.attachment isKindOfClass:[NTESJanKenPonAttachment class]]) {
            text = @"[猜拳]";
        }
        else if ([object.attachment isKindOfClass:[NTESChartletAttachment class]]) {
            text = @"[贴图]";
        }
        else if ([object.attachment isKindOfClass:[NTESWhiteboardAttachment class]]) {
            text = @"[白板]";
        }else{
            text = @"[未知消息]";
        }
        if (recent.session.sessionType != NIMSessionTypeP2P)
        {
            NSString *nickName = [NTESSessionUtil showNick:recent.lastMessage.from inSession:recent.lastMessage.session];
            text =  nickName.length ? [nickName stringByAppendingFormat:@" : %@",text] : @"";
        }
        content = [[NSAttributedString alloc] initWithString:text];
    }
    else
    {
        content = [super contentForRecentSession:recent];
    }
    NSMutableAttributedString *attContent = [[NSMutableAttributedString alloc] initWithAttributedString:content];
    [self checkNeedAtTip:recent content:attContent];
    return attContent;
}


- (void)checkNeedAtTip:(NIMRecentSession *)recent content:(NSMutableAttributedString *)content
{
    if ([NTESSessionUtil recentSessionIsAtMark:recent]) {
        NSAttributedString *atTip = [[NSAttributedString alloc] initWithString:@"[有人@你] " attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
        [content insertAttributedString:atTip atIndex:0];
    }
}

- (void)presentLoginCtrl{
    
    LoginViewController *ctrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
    [self.navigationController presentViewController:nav animated:YES completion:^{
        
    }];
}

@end
