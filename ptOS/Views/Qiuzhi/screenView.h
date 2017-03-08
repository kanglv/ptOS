//
//  screenView.h
//  ptOS
//
//  Created by 吕康 on 17/2/13.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

#import "JLSliderView.h"


@interface screenView : BaseView
- (instancetype)initWithFrame:(CGRect)frame withString:(NSString *)string;

//筛选条件数组
@property (strong , nonatomic)NSMutableArray *conditionArr;

@property (strong , nonatomic)NSMutableArray *experience;

@property (strong , nonatomic)NSMutableArray *educations;

@property (strong , nonatomic)NSMutableArray *jobNatures;

@property (weak, nonatomic) IBOutlet UIButton *sureButton;


@property (strong, nonatomic) IBOutlet JLSliderView *sliderView;


@property (weak, nonatomic) IBOutlet UILabel *salary;

@end
