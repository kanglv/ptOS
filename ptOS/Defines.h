//
//  Defines.h
//  ptOS
//
//  Created by 周瑞 on 16/8/26.
//  Copyright © 2016年 商盟. All rights reserved.
//

#ifndef Defines_h
#define Defines_h

#define BASE_URL @"http://139.196.230.156/ptApp/"

//弱引用
#define WeakSelf __weak typeof(self) weakSelf = self;

//屏幕高度
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

//屏幕宽度
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width

//设置view的圆角和边框
#define ZRViewBorderRadius(View, Width, Color)\
\
[View.layer setMasksToBounds:NO];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

//只有圆角，没有边框
#define ZRViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\

//适应尺寸
#define FITWIDTH(w) (SCREEN_WIDTH / 375 * w)

//通知中心
#define NotificationCenter [NSNotificationCenter defaultCenter]

//沙盒
#define UserDefault [NSUserDefaults standardUserDefaults]

//获取temp
#define kPathTemp NSTemporaryDirectory()
//获取沙盒 Document
#define kPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
//获取沙盒 Cache
#define kPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

// 日志输出
//#ifdef DEBUG
//#   define NSLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
//#else
//#define NSLog(...)
//#endif


#ifdef DEBUG // 处于开发阶段
#define NSLog(...) NSLog(__VA_ARGS__)
#else // 处于发布阶段
#define NSLog(...)
#endif

//判断系统版本是否大于等于iOS7.0
#define IS_IOS7 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)? (YES):(NO))

/********************  有效性校验  *************************/
/********************  有效性校验  *************************/
#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) || ([(_ref) isKindOfClass:[NSNull class]]) )

#define isValidStr(_ref) ((IsNilOrNull(_ref)==NO) && ([_ref length]>0))

/********************  关于颜色  *************************/
/********************  关于颜色  *************************/
// HEX
#define UIColorWithRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 获取RGB颜色带透明度
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
//透明度为1.0
#define RGB(r,g,b) RGBA(r,g,b,1.0)

//UIColor 十六进制RGB_0x
#define UIColorFromRGB_0x(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define BackgroundColor RGB(242,242,242)
#define MainColor [UIColor colorWithRed:100/255.0f green:150/255.0f blue:245/255.0f alpha:1.0]
#define WhiteColor RGB(255,255,255)
#define COLOR_VIEW_BACK RGB(246, 246, 246)

//keys
#define PhoneKey @"phone_key"
#define PswKey   @"password_key"
#define HeaderKey @"headerImageView_now"
#define JLKey @"hasJL"
#define UIDKey @"uid"

#endif /* Defines_h */
