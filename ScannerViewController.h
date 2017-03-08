//
//  ScannerViewController.h
//  lxt
//
//  Created by xhw on 15/12/12.
//  Copyright © 2015年 SM. All rights reserved.
//

#import "BaseViewController.h"

@protocol ScannerViewControllerDelegate <NSObject>
/**
 *  扫描成功后返回扫描结果
 *
 *  @param result 扫描结果
 */
- (void)didFinshedScanning:(NSString *)result;

@end

@interface ScannerViewController : BaseViewController

- (id)initWithType:(BOOL)isRegister;

@property (nonatomic,assign) id<ScannerViewControllerDelegate> delegate;

@end
