//
//  NTESContactViewController.m
//  NIMDemo
//
//  Created by chris on 15/2/2.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESContactViewController.h"
#import "NTESSessionUtil.h"
#import "NTESSessionViewController.h"
#import "NTESContactUtilItem.h"
#import "NTESContactDefines.h"
#import "NTESGroupedContacts.h"
#import "UIView+Toast.h"
#import "NTESCustomNotificationDB.h"
#import "NTESNotificationCenter.h"
#import "UIActionSheet+NTESBlock.h"
#import "NTESSearchTeamViewController.h"
#import "NTESContactAddFriendViewController.h"
#import "NTESPersonalCardViewController.h"
#import "UIAlertView+NTESBlock.h"
#import "SVProgressHUD.h"
#import "NTESContactUtilCell.h"
#import "NIMContactDataCell.h"
#import "NIMContactSelectViewController.h"
#import "NTESUserUtil.h"
#import <QuartzCore/QuartzCore.h>
#import "NTESContactDataMember.h"
#import "ContactsTableView.h"
#import "AddContactsViewController.h"
#import "ContactDetailViewController.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"
#import "Contacts.h"
#import "ContactCell.h"
#import "PinYinForObjc.h"


@interface NTESContactViewController ()<NIMUserManagerDelegate,
NIMSystemNotificationManagerDelegate,
NTESContactUtilCellDelegate,
NIMContactDataCellDelegate,
NIMLoginManagerDelegate,
ContactsTableViewDelegate> {
    UIRefreshControl *_refreshControl;
    NTESGroupedContacts *_contacts;
}

@property (nonatomic, strong) ContactsTableView *contactTableView;
@property (nonatomic, strong) NSMutableArray *contactArraytemp; //从数据库读取的contacts数据
@property (nonatomic, strong) NSMutableArray *allArray;  // 包含空数据的contactsArray
@property (nonatomic, strong) NSMutableArray *dataSource;  // 核心数据
@property (nonatomic, strong) NSMutableArray *indexTitles;


@property (nonatomic,strong) NSArray * datas;

@end

@implementation NTESContactViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[[NIMSDK sharedSDK] systemNotificationManager] removeDelegate:self];
    [[[NIMSDK sharedSDK] loginManager] removeDelegate:self];
    [[[NIMSDK sharedSDK] userManager] removeDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tableView.delegate       = self;
//    self.tableView.dataSource     = self;
//    UIEdgeInsets separatorInset   = self.tableView.separatorInset;
//    separatorInset.right          = 0;
//    self.tableView.separatorInset = separatorInset;
//    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
//    self.tableView.tableFooterView = [[UIView alloc] init];
    [self prepareData];
    [[[NIMSDK sharedSDK] systemNotificationManager] addDelegate:self];
    [[[NIMSDK sharedSDK] loginManager] addDelegate:self];
    [[[NIMSDK sharedSDK] userManager] addDelegate:self];
    
    
    
    
    
    self.dataSource = [[NSMutableArray alloc] init];
    self.contactArraytemp = [[NSMutableArray alloc] init];
    self.allArray = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
    
    contactsSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 40)];
    
    //
//     contactsSearchBar.backgroundColor=[UIColor clearColor];
    //去掉搜索框背景
    //1.
//    [[contactsSearchBar.subviews objectAtIndex:0]removeFromSuperview];
//    //2.
//    for (UIView *subview in contactsSearchBar.subviews)
//    {
//        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
//        {
//            [subview removeFromSuperview];
//            break;
//        }
//    }
    //
    contactsSearchBar.delegate = self;
    [contactsSearchBar setPlaceholder:@"搜索"];
    contactsSearchBar.keyboardType = UIKeyboardTypeDefault;
    searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:contactsSearchBar contentsController:self];
   
   
    searchDisplayController.active = NO;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    
    [self performSelector:@selector(loadLocalData)];
    
    [self createTableView];
}

- (void)setUpNavItem{
    UIButton *teamBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [teamBtn addTarget:self action:@selector(onOpera:) forControlEvents:UIControlEventTouchUpInside];
    [teamBtn setImage:[UIImage imageNamed:@"icon_tinfo_normal"] forState:UIControlStateNormal];
    [teamBtn setImage:[UIImage imageNamed:@"icon_tinfo_pressed"] forState:UIControlStateHighlighted];
    [teamBtn sizeToFit];
    UIBarButtonItem *teamItem = [[UIBarButtonItem alloc] initWithCustomView:teamBtn];
//    self.navigationItem.rightBarButtonItem = teamItem;
}

- (void)prepareData{
    _contacts = [[NTESGroupedContacts alloc] init];

    NSString *contactCellUtilIcon   = @"icon";
    NSString *contactCellUtilVC     = @"vc";
    NSString *contactCellUtilBadge  = @"badge";
    NSString *contactCellUtilTitle  = @"title";
    NSString *contactCellUtilUid    = @"uid";
    NSString *contactCellUtilSelectorName = @"selName";
//原始数据
    
    NSInteger systemCount = [[[NIMSDK sharedSDK] systemNotificationManager] allUnreadCount];
    NSMutableArray *utils =
            [@[
//              @{
//                  contactCellUtilIcon:@"icon_notification_normal",
//                  contactCellUtilTitle:@"验证消息",
//                  contactCellUtilVC:@"NTESSystemNotificationViewController",
//                  contactCellUtilBadge:@(systemCount)
//               },
              @{
                  contactCellUtilIcon:@"icon_team_advance_normal",
                  contactCellUtilTitle:@"高级群",
                  contactCellUtilVC:@"NTESAdvancedTeamListViewController"
               },
//              @{
//                  contactCellUtilIcon:@"icon_team_normal_normal",
//                  contactCellUtilTitle:@"讨论组",
//                  contactCellUtilVC:@"NTESNormalTeamListViewController"
//                },
//              @{
//                  contactCellUtilIcon:@"icon_blacklist_normal",
//                  contactCellUtilTitle:@"黑名单",
//                  contactCellUtilVC:@"NTESBlackListViewController"
//                  },
//              @{
//                  contactCellUtilIcon:@"icon_computer_normal",
//                  contactCellUtilTitle:@"我的电脑",
//                  contactCellUtilSelectorName:@"onEnterMyComputer"
//                },
              ] mutableCopy];
    
    self.navigationItem.title = @"通讯录";
    [self setUpNavItem];
    
    //构造显示的数据模型
    NTESContactUtilItem *contactUtil = [[NTESContactUtilItem alloc] init];
    NSMutableArray * members = [[NSMutableArray alloc] init];
    for (NSDictionary *item in utils) {
        NTESContactUtilMember *utilItem = [[NTESContactUtilMember alloc] init];
        utilItem.nick              = item[contactCellUtilTitle];
        utilItem.icon              = [UIImage imageNamed:item[contactCellUtilIcon]];
        utilItem.vcName            = item[contactCellUtilVC];
        utilItem.badge             = [item[contactCellUtilBadge] stringValue];
        utilItem.userId            = item[contactCellUtilUid];
        utilItem.selName           = item[contactCellUtilSelectorName];
        [members addObject:utilItem];
    }
    contactUtil.members = members;
    
    [_contacts addGroupAboveWithTitle:@"" members:contactUtil.members];
}


#pragma mark - Action
- (void)onEnterMyComputer{
    NSString *uid = [[NIMSDK sharedSDK].loginManager currentAccount];
    NIMSession *session = [NIMSession session:uid type:NIMSessionTypeP2P];
    NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onOpera:(id)sender{
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


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger i = indexPath.row;
    if (indexPath.row == 0) {
        
        id<NTESContactItem> contactItem = (id<NTESContactItem>)[_contacts memberOfIndex:indexPath];
        if ([contactItem respondsToSelector:@selector(selName)] && [contactItem selName].length) {
            SEL sel = NSSelectorFromString([contactItem selName]);
            SuppressPerformSelectorLeakWarning([self performSelector:sel withObject:nil]);
        }
        else if (contactItem.vcName.length) {
            Class clazz = NSClassFromString(contactItem.vcName);
            UIViewController * vc = [[clazz alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }else if([contactItem respondsToSelector:@selector(userId)]){
            NSString * friendId   = contactItem.userId;
            [self enterPersonalCard:friendId];
        }
        return;
    }
   
    id<NTESContactItem> contactItem = (id<NTESContactItem>)[_contacts memberOfIndex:indexPath];
    if ([contactItem respondsToSelector:@selector(selName)] && [contactItem selName].length) {
        SEL sel = NSSelectorFromString([contactItem selName]);
        SuppressPerformSelectorLeakWarning([self performSelector:sel withObject:nil]);
    }
    else if (contactItem.vcName.length) {
        Class clazz = NSClassFromString(contactItem.vcName);
        UIViewController * vc = [[clazz alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }else if([contactItem respondsToSelector:@selector(userId)]){
        NSString * friendId   = contactItem.userId;
        [self enterPersonalCard:friendId];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id<NTESContactItem> contactItem = (id<NTESContactItem>)[_contacts memberOfIndex:indexPath];
    return contactItem.uiHeight;
}


#pragma mark - UITableViewDataSource
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSArray *arr = [_contacts membersOfGroup:section];
//    
//    return [_contacts memberCountOfGroup:section];
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return [_contacts groupCount];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    id contactItem = [_contacts memberOfIndex:indexPath];
//    NSString * cellId = [contactItem reuseId];
//    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//    if (!cell) {
//        Class cellClazz = NSClassFromString([contactItem cellName]);
//        cell = [[cellClazz alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
//    }
//    if ([contactItem showAccessoryView]) {
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }else{
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }
//    if ([cell isKindOfClass:[NTESContactUtilCell class]]) {
//        [(NTESContactUtilCell *)cell refreshWithContactItem:contactItem];
//        [(NTESContactUtilCell *)cell setDelegate:self];
//    }else{
//        [(NIMContactDataCell *)cell refreshUser:contactItem];
//        [(NIMContactDataCell *)cell setDelegate:self];
//    }
//    return cell;
//}
//
//- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return [_contacts titleOfGroup:section];
//}
//
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    return _contacts.sortedGroupTitles;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//    return index + 1;
//}
//
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    id<NTESContactItem> contactItem = (id<NTESContactItem>)[_contacts memberOfIndex:indexPath];
//    return [contactItem userId].length;
//}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除好友" message:@"删除好友后，将同时解除双方的好友关系" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert showAlertWithCompletionHandler:^(NSInteger index) {
            if (index == 1) {
                [SVProgressHUD show];
                id<NTESContactItem,NTESGroupMemberProtocol> contactItem = (id<NTESContactItem,NTESGroupMemberProtocol>)[_contacts memberOfIndex:indexPath];
                NSString *userId = [contactItem userId];
                __weak typeof(self) wself = self;
                [[NIMSDK sharedSDK].userManager deleteFriend:userId completion:^(NSError *error) {
                    [SVProgressHUD dismiss];
                    if (!error) {
                        [_contacts removeGroupMember:contactItem];
                    }else{
                        [wself.view makeToast:@"删除失败"duration:2.0f position:CSToastPositionCenter];
                    }
                }];
            }
        }];
    }
}

#pragma mark - NIMContactDataCellDelegate
- (void)onPressAvatar:(NSString *)memberId{
    [self enterPersonalCard:memberId];
}

#pragma mark - NTESContactUtilCellDelegate
- (void)onPressUtilImage:(NSString *)content{
    [self.view makeToast:[NSString stringWithFormat:@"点我干嘛 我是<%@>",content] duration:2.0 position:CSToastPositionCenter];
}

#pragma mark - NIMContactSelectDelegate
- (void)didFinishedSelect:(NSArray *)selectedContacts{
    
}

#pragma mark - NIMSDK Delegate
- (void)onSystemNotificationCountChanged:(NSInteger)unreadCount
{
    [self prepareData];
    [self.tableView reloadData];
}

- (void)onLogin:(NIMLoginStep)step
{
    if (step == NIMLoginStepSyncOK) {
        if (self.isViewLoaded) {//没有加载view的话viewDidLoad里会走一遍prepareData
            [self prepareData];
            [self.tableView reloadData];
        }
    }
}

- (void)onUserInfoChanged:(NIMUser *)user
{
    [self refresh];
}

- (void)onFriendChanged:(NIMUser *)user{
    [self refresh];
}

- (void)onBlackListChanged
{
    [self refresh];
}

- (void)onMuteListChanged
{
    [self refresh];
}

- (void)refresh
{
    [self prepareData];
    [self.tableView reloadData];
}

#pragma mark - Private
- (void)enterPersonalCard:(NSString *)userId{
    NTESPersonalCardViewController *vc = [[NTESPersonalCardViewController alloc] initWithUserId:userId];
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
//自定义tableview

// 创建tableView
- (void) createTableView {
    
    self.contactTableView = [[ContactsTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.bounds.size.height)];
    _contactTableView.delegate = self;
    self.contactTableView.tableView.tableHeaderView = contactsSearchBar;
    [self.view addSubview:self.contactTableView];
}

- (void) reloadTableView {
    self.contactTableView = [[ContactsTableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    self.contactTableView.delegate = self;
    self.contactTableView.tableView.tableHeaderView = contactsSearchBar;
    [self.view addSubview:self.contactTableView];
}

- (void)loadLocalData
{
    self.contactArraytemp = [[NSMutableArray alloc] init];

    NSArray *tarr1 = [_contacts membersOfGroup:1];
    NSArray *tarr0 = [_contacts membersOfGroup:0];
//    for (NTESContactUtilMember *nts in tarr0) {
//            Contacts *contact =[[Contacts alloc]init];
//        contact.name = nts.nick;
////        contact.name = @" 我的群组";
//
//    
////        contact.name = @" 我的群组";
//        contact.headimage = [UIImage imageNamed:@"touxiang2"];
//        contact.address = @"";
//        contact.detail = @"";
//        [self.contactArraytemp addObject:contact];
//        
//    }

    for (NTESContactDataMember *nts in tarr1) {
        NIMKitInfo *nimkitinfo = nts.info;
        NSString *name = nimkitinfo.showName;
        Contacts *contact =[[Contacts alloc]init];

        if (nimkitinfo.avatarUrlString) {
            
    
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:nimkitinfo.avatarUrlString]];
            
//        contact.name = @"张三";
       //        contact.headimage = [UIImage imageNamed:@"touxiang1"];
        contact.headimage = [UIImage imageWithData:data];
        }else {
            contact.headimage = nimkitinfo.avatarImage;
        }
        contact.name= name;

        contact.address = @"";
        contact.detail = name;
        [self.contactArraytemp addObject:contact];

    }
//    
//    @property (nonatomic, copy) NSString     *name;
//    @property (nonatomic, copy) UIImage    *headimage;
//    @property (nonatomic, copy) NSString     *address;
//    @property (nonatomic, copy) NSString     *detail;
    // json数据解析
    NSString *contactPath = [[NSBundle mainBundle] pathForResource:@"contacts1" ofType:@"json"];
//    NSData *data = [NSData dataWithContentsOfFile:contactPath];
//    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//    
//    self.contactArraytemp = [[NSMutableArray alloc] init];
//    for (int i = 0; i < array.count; i++) {
//        Contacts *contact = [[Contacts alloc] initWithPropertiesDictionary:array[i]];
//        [self.contactArraytemp addObject:contact];
//    }
//    
    
    // 对数据进行排序，并按首字母分类
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    for (Contacts *contact in self.contactArraytemp) {
        NSInteger sect = [theCollation sectionForObject:contact
                                collationStringSelector:@selector(name)];
        contact.sectionNumber = sect;
        
    }
//    for (int i = 0;  i<tarr0.count; i++) {
    
      
//        if (i == 1) {
    
       NTESContactUtilMember *nts  = tarr0[0];
        Contacts *contact =[[Contacts alloc]init];
//        contact.name = nts.nick;
        //        contact.name = @" 我的群组";
        
        
                contact.name = @"我的群组";
        contact.headimage = [UIImage imageNamed:@"icon_qunzhu.png"];
    
        contact.address = @"";
        contact.detail = @"";
        [self.contactArraytemp addObject:contact];
//        break;
//               }
//        
//    }
    NSInteger highSection = [[theCollation sectionTitles] count];
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for (int i=0; i<=highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    
    for (Contacts *contact in self.contactArraytemp) {
        [(NSMutableArray *)[sectionArrays objectAtIndex:contact.sectionNumber] addObject:contact];
    }
    
    self.allArray = [[NSMutableArray alloc] init];
    for (NSMutableArray *sectionArray in sectionArrays) {
        NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(name)];
        [self.allArray addObject:sortedSection];
    }
    
    // 只取有数据的Array
    for (NSMutableArray *sectionArray0 in self.allArray) {
        if (sectionArray0.count) {
            [self.dataSource addObject:sectionArray0];
        }
        
    }
    NSMutableArray *qun = [[NSMutableArray alloc ]init];
    
//    for (NTESContactUtilMember *nts in tarr0) {
//        Contacts *contact =[[Contacts alloc]init];
//        contact.name = nts.nick;
//        //        contact.name = @" 我的群组";
//        
//        
//        //        contact.name = @" 我的群组";
//        contact.headimage = [UIImage imageNamed:@"touxiang2"];
//        contact.address = @"";
//        contact.detail = @"";
//        [qun addObject:contact];
//        
//    }
//    [self.dataSource addObject:qun];
    
}


// 添加联系人
- (void)addcontactsAction
{
    AddContactsViewController* addcontact = [[AddContactsViewController alloc] initWithNibName:@"AddContactsViewController" bundle:nil];
    
    [self.navigationController pushViewController:addcontact animated:YES];
    
}


- (void)addnewcontact:(NSNotification *)notification
{
    Contacts *newcontact = notification.object;
    NSString *name = newcontact.name;
    
    NSLog(@"添加联系人%@",name);
    [self.contactArraytemp addObject:newcontact];
    
    // 数据更新
    self.dataSource = [[NSMutableArray alloc] init];
    self.allArray = [[NSMutableArray alloc] init];
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    for (Contacts *contact in self.contactArraytemp) {
        NSInteger sect = [theCollation sectionForObject:contact
                                collationStringSelector:@selector(name)];
        contact.sectionNumber = sect;
        
    }
    
    NSInteger highSection = [[theCollation sectionTitles] count];
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for (int i=0; i<=highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    
    for (Contacts *contact in self.contactArraytemp) {
        [(NSMutableArray *)[sectionArrays objectAtIndex:contact.sectionNumber] addObject:contact];
    }
    
    self.allArray = [[NSMutableArray alloc] init];
    for (NSMutableArray *sectionArray in sectionArrays) {
        NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(name)];
        [self.allArray addObject:sortedSection];
    }
    
    // 只取有数据的Array
    for (NSMutableArray *sectionArray0 in self.allArray) {
        if (sectionArray0.count) {
            [self.dataSource addObject:sectionArray0];
        }
        
    }
    [self reloadTableView];
    
}



//#pragma mark - UITableViewDataSource
// IndexTable
- (NSArray *) sectionIndexTitlesForABELTableView:(ContactsTableView *)tableView
{
    if (tableView == searchDisplayController.searchResultsTableView)
    {
        return nil;
    }
    else{
        self.indexTitles = [NSMutableArray array];
        
        for (int i = 0; i < self.allArray.count; i++) {
            if ([[self.allArray objectAtIndex:i] count]) {
                [self.indexTitles addObject:[[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:i]];
            }
        }
        
        return self.indexTitles;
        
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"";
    }
    if (tableView == searchDisplayController.searchResultsTableView)
    {
        return nil;
    }
    else{
        
        return [self.indexTitles objectAtIndex:section];
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == searchDisplayController.searchResultsTableView)
    {
        return 1;
    }
    else{
        return self.dataSource.count;
        
    }
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView)  // 有搜索
    {
        return searchResults.count;
    }
    else{
        return [[self.dataSource objectAtIndex:section] count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ContactCell";
    ContactCell *cell = (ContactCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactCell" owner:self options:nil] lastObject];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        // 搜索结果显示
        Contacts *contact = searchResults[indexPath.row];
        
        NSString *nametext = [NSString stringWithFormat:@"%@",contact.name];
        
        cell.tag = indexPath.row;
        cell.delegate = self;
         cell.headImage.image = contact.headimage;
        cell.nameLabel.text = nametext;
        
    }
    else {
        
        Contacts *contact = (Contacts *)[[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        NSString *nametext = [NSString stringWithFormat:@"%@",contact.name];
          cell.headImage.image = contact.headimage;
        cell.tag = indexPath.row;
        cell.delegate = self;
        cell.nameLabel.text = nametext;
    }
    
    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

//
//// 选中某个cell，进入 detailcontact 联系人详情页面
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    ContactDetailViewController *contactdetail = [[ContactDetailViewController alloc] init];
//    if (tableView == self.searchDisplayController.searchResultsTableView) {
//        contactdetail.contact = searchResults[indexPath.row];
//    }
//    else {
//        
//        contactdetail.contact = (Contacts *)[[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
//        
//    }
//    
//    [self.navigationController pushViewController:contactdetail animated:YES];
//}

// 联系人搜索，可实现汉字搜索，汉语拼音搜索和拼音首字母搜索，
// 输入联系人名称，进行搜索， 返回搜索结果searchResults
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    searchResults = [[NSMutableArray alloc]init];
    if (contactsSearchBar.text.length>0&&![ChineseInclude isIncludeChineseInString:contactsSearchBar.text]) {
        for (NSArray *section in self.dataSource) {
            for (Contacts *contact in section)
            {
                
                if ([ChineseInclude isIncludeChineseInString:contact.name]) {
                    NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:contact.name];
                    NSRange titleResult=[tempPinYinStr rangeOfString:contactsSearchBar.text options:NSCaseInsensitiveSearch];
                    
                    if (titleResult.length>0) {
                        [searchResults addObject:contact];
                    }
                    else {
                        NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:contact.name];
                        NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:contactsSearchBar.text options:NSCaseInsensitiveSearch];
                        if (titleHeadResult.length>0) {
                            [searchResults  addObject:contact];
                        }
                    }
                    NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:contact.name];
                    NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:contactsSearchBar.text options:NSCaseInsensitiveSearch];
                    if (titleHeadResult.length>0) {
                        [searchResults  addObject:contact];
                    }
                }
                else {
                    NSRange titleResult=[contact.name rangeOfString:contactsSearchBar.text options:NSCaseInsensitiveSearch];
                    if (titleResult.length>0) {
                        [searchResults  addObject:contact];
                    }
                }
            }
        }
    } else if (contactsSearchBar.text.length>0&&[ChineseInclude isIncludeChineseInString:contactsSearchBar.text]) {
        
        for (NSArray *section in self.dataSource) {
            for (Contacts *contact in section)
            {
                NSString *tempStr = contact.name;
                NSRange titleResult=[tempStr rangeOfString:contactsSearchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:contact];
                }
                
            }
        }
    }
    
}




// searchbar 点击上浮，完毕复原
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    //准备搜索前，把上面调整的TableView调整回全屏幕的状态
    [UIView animateWithDuration:1.0 animations:^{
        self.contactTableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        
    }];
    return YES;
}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    //搜索结束后，恢复原状
    [UIView animateWithDuration:1.0 animations:^{
        self.contactTableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    }];
    return YES;
}



@end
