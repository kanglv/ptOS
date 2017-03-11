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

#define SessionListTitle @"云信 Demo"

@interface NTESSessionListViewController ()<NIMLoginManagerDelegate,NTESListHeaderDelegate,UIViewControllerPreviewingDelegate,SessionExpireDelegate,NetLoadingDelegate,NoNetWorkingDelegate>

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) NTESListHeader *header;

@property (nonatomic,assign) BOOL supportsForceTouch;

@property (nonatomic,strong) NSMutableDictionary *previews;

@property (nonatomic,strong) NSMutableArray *pt_listArr;

@property (nonatomic,strong)PT_MsgNumApi *msgNumApi;
@property (nonatomic,strong)PT_ClearMsgNumApi *clearMsgNumApi;

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
    [self.pt_listArr addObject:@{@"title":@"陌生人",@"icon":@"icon_moshengren",@"viewController":@""}];
    [self.pt_listArr addObject:@{@"title":@"通知消息",@"icon":@"icon_tongzhi",@"viewController":@""}];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (isValidStr([GlobalData sharedInstance].selfInfo.sessionId))
    {
        [self msgNumApiNet];
    }
}

#pragma mark - NetworkApis
- (void)msgNumApiNet {
    if(self.msgNumApi && !self.msgNumApi.requestOperation.isFinished)
    {
        [self.msgNumApi stop];
    }
    
    self.msgNumApi.sessionDelegate = self;
    self.msgNumApi = [[PT_MsgNumApi alloc]init];
//    self.msgNumApi.netLoadingDelegate = self;
//    [self.msgNumApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
//        
//        PT_MsgNumApi *result = (PT_MsgNumApi *)request;
//        if(result.isCorrectResult)
//        {
////            self.timeLabel.hidden = NO;
////            self.detailLabel.hidden = NO;
////            self.msgNumLabel.hidden = NO;
//            PT_MsgNumModel *model = [result getMsgNumModel];
////            self.detailLabel.text = model.content;
//            if ([model.content isEqualToString:@""]) {
////                self.detailLabel.text = @"暂无新的消息";
//            }
////            self.timeLabel.text = model.time;
//            
////            self.msgNumLabel.text = model.number;
//            if ([model.number isEqualToString:@"0"]) {
////                self.msgNumLabel.hidden = YES;
//            }
//        }
//        
//    } failure:^(YTKBaseRequest *request) {
//        
//    }];
}

- (void)refresh:(BOOL)reload{
    [super refresh:reload];
    self.emptyTipLabel.hidden = self.recentSessions.count;
}

- (void)onSelectedRecent:(NIMRecentSession *)recent atIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {//附近的
            PT_NearlyListViewController *nearlyListViewController = [[PT_NearlyListViewController alloc]init];
            [self.navigationController pushViewController:nearlyListViewController animated:YES];
            
        }else if (indexPath.row == 1){//求职
            if (!isValidStr([GlobalData sharedInstance].selfInfo.sessionId))
            {
                [self presentLoginCtrl];
                return;
            }
//            [self clearMsgNumApiNet];
            PT_QiuzhiViewController *ctrl = [[PT_QiuzhiViewController alloc]init];
            [self.navigationController pushViewController:ctrl animated:YES];

            
        }else if (indexPath.row == 2){//活动
            
        }else if (indexPath.row == 3){//陌生人
            
        }else if (indexPath.row == 4){//通知消息
            
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
            //        cell.messageLabel.text = @"面试通知";
            //        cell.timeLabel.text = @"15分钟前";
            //        cell.timeLabel.hidden = NO;
            //        cell.tag_numLabel.text = @"12";
            //        cell.tag_numLabel.hidden = NO;
            
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
