//
//  MY_ExpersTableViewCell.h
//  ptOS
//
//  Created by 吕康 on 17/4/6.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MY_ExpersTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UIButton *writeBtn;
@property (strong, nonatomic) IBOutlet UIView *backView;

@end
