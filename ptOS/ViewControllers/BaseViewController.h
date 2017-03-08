//
//  BaseViewController.h
//  ptOS
//
//  Created by 周瑞 on 16/8/29.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"
#import "BaseNetApi.h"
@interface BaseViewController : UIViewController</*SVProgressTouched,*/SessionExpireDelegate,NetLoadingDelegate,NoNetWorkingDelegate>

@property (nonatomic, assign)BOOL needNav;


//所有controller中，只要有菊花转的联网，必须重写该方法，取消所有联网，并返回上层页面
//- (void)cancelAllNetAndPopViewController;

- (void)presentLoginCtrl;

- (void)showNoDataView;
- (void)removeNoData;
- (void)showNoDataViewOnView:(UIView *)view;

- (BOOL)hasData;

- (void)removeAllWarning;

- (void)noNetWorking;

@end
