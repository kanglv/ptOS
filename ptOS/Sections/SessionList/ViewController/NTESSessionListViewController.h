//
//  NTESSessionListViewController.h
//  NIMDemo
//
//  Created by chris on 15/2/2.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PT_MsgNumModel.h"

@interface NTESSessionListViewController : NIMSessionListViewController

@property (nonatomic,strong) UILabel *emptyTipLabel;
@property (nonatomic, strong)PT_MsgNumModel *model;


@end
