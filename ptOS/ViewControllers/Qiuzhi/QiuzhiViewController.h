//
//  QiuzhiViewController.h
//  ptOS
//
//  Created by 周瑞 on 16/8/30.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseViewController.h"

@interface QiuzhiViewController : BaseViewController

- (void)autiLoginNet;

//选择的当前城市，默认为定位的当前城市
@property (assign,nonatomic) NSString *selectedCity;


//@property (assign ,nonatomic) UIView *chooseView;

@end
