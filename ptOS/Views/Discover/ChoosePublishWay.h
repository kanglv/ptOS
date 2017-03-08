//
//  ChoosePublishWay.h
//  ptOS
//
//  Created by 吕康 on 17/2/19.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

@interface ChoosePublishWay : BaseView 

- (instancetype)initWithFrame:(CGRect)frame withString:(NSString *)string;

@property (strong, nonatomic) IBOutlet UIButton *normalBtn;

@property (strong, nonatomic) IBOutlet UIButton *speechBtn;

@end
