//
//  PublishSpeechViewController.h
//  ptOS
//
//  Created by 吕康 on 17/2/20.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "BaseViewController.h"

@interface PublishSpeechViewController : BaseViewController

//录音按钮
@property (strong, nonatomic) IBOutlet UIButton *record;

//顶部背景view
@property (strong, nonatomic) IBOutlet UIView *topView;

//地址按钮
@property (strong, nonatomic) IBOutlet UIButton *locationBtn;

//选择发布企业圈开关
@property (strong, nonatomic) IBOutlet UISwitch *switchBtn;

//显示当前位置的label
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;




@end
