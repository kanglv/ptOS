//
//  AppDelegate.m
//  ptOS
//
//  Created by 周瑞 on 16/8/26.
//  Copyright © 2016年 商盟. All rights reserved.
//

#import "AppDelegate.h"
#import "TabbarController.h"
#import "IQKeyboardManager.h"
#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>
#import <UserNotifications/UserNotifications.h>
#import "YTKNetworkConfig.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

#import <AMapFoundationKit/AMapFoundationKit.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

#define UM_APPKEY @"57d5609b67e58ecf2a001f3c"
#define GMap_APPKEY @"04c0b7d2c1edacac03e5527fd3cb4b86"
#define JPush_APPKEY @"df0db706713b07e6aaff7800"
#define Share_APPKEY @"1772c42427f4c"

//网易云信相关设置
#import "NTESLoginViewController.h"
#import "NIMSDK.h"
#import "UIView+Toast.h"
#import "NTESService.h"
#import "NTESNotificationCenter.h"
#import "NTESLogManager.h"
#import "NTESDemoConfig.h"
#import "NTESSessionUtil.h"
#import "NTESMainTabController.h"
#import "NTESLoginManager.h"
#import "NTESCustomAttachmentDecoder.h"
#import "NTESClientUtil.h"
#import "NTESNotificationCenter.h"
#import "NIMKit.h"
#import "NTESSDKConfigDelegate.h"
#import "NTESCellLayoutConfig.h"
#import "CocoaLumberjack.h"
#import "NSString+NTES.h"

#ifdef DEBUG
static DDLogLevel ddLogLevel = DDLogLevelVerbose;
#else
static DDLogLevel ddLogLevel = DDLogLevelInfo;
#endif
NSString *NTESNotificationLogout = @"NTESNotificationLogout";


@interface AppDelegate ()<JPUSHRegisterDelegate,NIMLoginManagerDelegate>
@property (nonatomic,strong) NTESSDKConfigDelegate *sdkConfigDelegate;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //    网易云设置
    
    //在注册 NIMSDK appKey 之前先进行配置信息的注册，如是否使用新路径,是否要忽略某些通知，是否需要多端同步未读数
    self.sdkConfigDelegate = [[NTESSDKConfigDelegate alloc] init];
    [[NIMSDKConfig sharedConfig] setDelegate:self.sdkConfigDelegate];
    [[NIMSDKConfig sharedConfig] setShouldSyncUnreadCount:YES];
    
    
    //appkey 是应用的标识，不同应用之间的数据（用户、消息、群组等）是完全隔离的。
    //如需打网易云信 Demo 包，请勿修改 appkey ，开发自己的应用时，请替换为自己的 appkey 。
    //并请对应更换 Demo 代码中的获取好友列表、个人信息等网易云信 SDK 未提供的接口。
    NSString *appKey = [[NTESDemoConfig sharedConfig] appKey];
    NSString *cerName= [[NTESDemoConfig sharedConfig] cerName];
    [[NIMSDK sharedSDK] registerWithAppID:appKey
                                  cerName:cerName];
    
    
    //注册自定义消息的解析器
    [NIMCustomObject registerCustomDecoder:[NTESCustomAttachmentDecoder new]];
    
    //注册 NIMKit 自定义排版配置
    [[NIMKit sharedKit] registerLayoutConfig:[NTESCellLayoutConfig class]];
    
    
    
    [self setupServices];
    [self registerAPNs];
    [self commonInitListenEvents];
//    //网易云信设置
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window.backgroundColor = [UIColor grayColor];
//    [self.window makeKeyAndVisible];
//    [application setStatusBarStyle:UIStatusBarStyleLightContent];
//    
//    [self setupMainViewController];
    
    //
    
    //        、、
    //        、、
    // 设置主窗口,并设置根控制器
            self.window = [[UIWindow alloc]init];
            self.window.backgroundColor = [UIColor whiteColor];
            self.window.frame = [UIScreen mainScreen].bounds;
            TabbarController *tabBarControllerConfig = [[TabbarController alloc] init];
            [self.window setRootViewController:tabBarControllerConfig.tabBarController];
            [self.window makeKeyAndVisible];
    [self customizeInterface];
    
    YTKNetworkConfig *config = [YTKNetworkConfig sharedInstance];
    config.baseUrl = BASE_URL;
    
    //IQKeyboardManager
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    //JPush
    [self setJPushWithOptions:launchOptions];
    
    //ShareSDK
    [self setShareWithOptions:launchOptions];
    
    NSString *uid = [UserDefault objectForKey:UIDKey];
    NSLog(@"%@",uid);
    if (isValidStr(uid)) {
        if(![[[NIMSDK sharedSDK] loginManager]isLogined]){
             [[[NIMSDK sharedSDK] loginManager] autoLogin:uid token:[uid tokenByPassword]];
        }
    }
    
    
    return YES;
}


- (void)setJPushWithOptions:(NSDictionary *)options {
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:options appKey:JPush_APPKEY
                          channel:@"Publish channel"
                 apsForProduction:false
            advertisingIdentifier:advertisingId];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
}

//配置share
- (void)setShareWithOptions:(NSDictionary *)options {
    [ShareSDK registerApp:@"扑通工作"
     
          activePlatforms:@[
                            
                            
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                            ]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
                 
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxfa5999355450c125"
                                       appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1105686442"
                                      appKey:@"0bjQaThf9HuRVAF9"
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
}

//配置高德
- (void)setGMap {
    [AMapServices sharedServices].apiKey = GMap_APPKEY;
}


- (void)customizeInterface {
    [self setUpNavigationBarAppearance];
}

/**
 *  设置navigationBar样式
 */
- (void)setUpNavigationBarAppearance {
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    
    UIImage *backgroundImage = nil;
    NSDictionary *textAttributes = nil;
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        backgroundImage = [UIImage imageNamed:@"navigationbar_background_tall"];
        
        textAttributes = @{
                           NSFontAttributeName : [UIFont boldSystemFontOfSize:18],
                           NSForegroundColorAttributeName : [UIColor blackColor],
                           };
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        backgroundImage = [UIImage imageNamed:@"navigationbar_background"];
        textAttributes = @{
                           UITextAttributeFont : [UIFont boldSystemFontOfSize:18],
                           UITextAttributeTextColor : [UIColor blackColor],
                           UITextAttributeTextShadowColor : [UIColor clearColor],
                           UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetZero],
                           };
#endif
    }
    
    [navigationBarAppearance setBackgroundImage:backgroundImage
                                  forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
    //设置状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[ UIApplication sharedApplication ] setStatusBarStyle : UIStatusBarStyleLightContent ];
    
    //去掉返回按钮上的文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
}




- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    NSLog(@"哈哈");
    [JPUSHService registerDeviceToken:deviceToken];
    //    、、网易云
    [[NIMSDK sharedSDK] updateApnsToken:deviceToken];
    DDLogInfo(@"didRegisterForRemoteNotificationsWithDeviceToken:  %@", deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
}

//- (void)applicationDidEnterBackground:(UIApplication *)application {
//
//}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    NSLog(@"%@",userInfo);
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[[NIMSDK sharedSDK] loginManager] removeDelegate:self];
}


#pragma mark - ApplicationDelegate
//- (void)applicationWillResignActive:(UIApplication *)application {
//}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSInteger count = [[[NIMSDK sharedSDK] conversationManager] allUnreadCount];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:count];
}

//- (void)applicationWillEnterForeground:(UIApplication *)application {
//}
//
//- (void)applicationDidBecomeActive:(UIApplication *)application {
//}
//
//- (void)applicationWillTerminate:(UIApplication *)application {
//}

//- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
//{
//    [[NIMSDK sharedSDK] updateApnsToken:deviceToken];
//    DDLogInfo(@"didRegisterForRemoteNotificationsWithDeviceToken:  %@", deviceToken);
//}

//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
//    DDLogInfo(@"receive remote notification:  %@", userInfo);
//}
//
//- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
//{
//    DDLogError(@"fail to get apns token :%@",error);
//}


#pragma mark - misc
- (void)registerAPNs
{
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types
                                                                             categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}

- (void)setupMainViewController
{
    LoginData *data = [[NTESLoginManager sharedManager] currentLoginData];
    NSString *account = [data account];
    NSString *token = [data token];
    
    //如果有缓存用户名密码推荐使用自动登录
    if ([account length] && [token length])
    {
        [[[NIMSDK sharedSDK] loginManager] autoLogin:account
                                               token:token];
        [[NTESServiceManager sharedManager] start];
//        NTESMainTabController *mainTab = [[NTESMainTabController alloc] initWithNibName:nil bundle:nil];
//        self.window.rootViewController = mainTab;
    }
    else
    {
//        [self setupLoginViewController];
    }
}

- (void)commonInitListenEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logout:)
                                                 name:NTESNotificationLogout
                                               object:nil];
    
    [[[NIMSDK sharedSDK] loginManager] addDelegate:self];
}

- (void)setupLoginViewController
{
    NTESLoginViewController *loginController = [[NTESLoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginController];
//    self.window.rootViewController = nav;
}

#pragma mark - 注销
-(void)logout:(NSNotification*)note
{
    [self doLogout];
}

- (void)doLogout
{
    [[NTESLoginManager sharedManager] setCurrentLoginData:nil];
    [[NTESServiceManager sharedManager] destory];
    [self setupLoginViewController];
}


#pragma NIMLoginManagerDelegate
-(void)onKick:(NIMKickReason)code clientType:(NIMLoginClientType)clientType
{
    NSString *reason = @"你被踢下线";
    switch (code) {
        case NIMKickReasonByClient:
        case NIMKickReasonByClientManually:{
            NSString *clientName = [NTESClientUtil clientName:clientType];
            reason = clientName.length ? [NSString stringWithFormat:@"你的帐号被%@端踢出下线，请注意帐号信息安全",clientName] : @"你的帐号被踢出下线，请注意帐号信息安全";
            break;
        }
        case NIMKickReasonByServer:
            reason = @"你被服务器踢下线";
            break;
        default:
            break;
    }
    [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NTESNotificationLogout object:nil];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"下线通知" message:reason delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
}

- (void)onAutoLoginFailed:(NSError *)error
{
    //只有连接发生严重错误才会走这个回调，在这个回调里应该登出，返回界面等待用户手动重新登录。
    DDLogInfo(@"onAutoLoginFailed %zd",error.code);
    NSString *toast = [NSString stringWithFormat:@"登录失败: %zd",error.code];
    [self.window makeToast:toast duration:2.0 position:CSToastPositionCenter];
    [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NTESNotificationLogout object:nil];
    }];
}


#pragma mark - logic impl
- (void)setupServices
{
    [[NTESLogManager sharedManager] start];
    [[NTESNotificationCenter sharedCenter] start];
}


@end
