//
//  PT_ConcernTableViewCell.h
//  ptOS
//
//  Created by 吕康 on 17/3/16.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PT_ConcernTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UILabel *publishLabel;

@end
