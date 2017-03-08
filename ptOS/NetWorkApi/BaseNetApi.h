//
//  BaseNetApi.h
//  lxt
//
//  Created by xhw on 15/12/12.
//  Copyright © 2015年 SM. All rights reserved.
//

#import "YTKRequest.h"
#import "SVProgressHUD.h"

@class BaseNetApi;
//跳转delegate
@protocol JLDelegate <NSObject>

- (void)jumpToJL;

@end

//session过期，重新登录的界面需要实现
@protocol SessionExpireDelegate <NSObject>

- (void)sessionIsExpire:(BaseNetApi *)object;

@end

//需要显示联网加载中的界面需要实现
@protocol NetLoadingDelegate <NSObject>

- (void)startLoading;

- (void)stopLoading;

@end

//联网后，需要显示无网络的界面需要实现
@protocol NoNetWorkingDelegate <NSObject>

- (void)noNetWorking;

@end

@interface BaseNetApi : YTKRequest

//判断联网成功,但是返回结果是否正确
@property (nonatomic,assign)BOOL isCorrectResult;

@property (nonatomic,assign)BOOL needShowError;

//以下delegate统一在BaseViewController中实现，需要的界面，在联网时设置api的delegate就行
@property (nonatomic,assign)id<SessionExpireDelegate>sessionDelegate;
@property (nonatomic,assign)id<NetLoadingDelegate>netLoadingDelegate;
@property (nonatomic,assign)id<NoNetWorkingDelegate>noNetWorkingDelegate;

@property (nonatomic,weak)id<JLDelegate> jlDelegate;

//如果联网需要菊花转，则设置此参数，同时这个delegate会在baseViewController中统一处理
//@property (nonatomic,assign)id<SVProgressTouched>progressTouchedDelegate;

//统一请求参数，比如tokon等
- (NSMutableDictionary *)getBaseArgument;


@end
