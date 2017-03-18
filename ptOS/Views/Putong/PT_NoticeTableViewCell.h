//
//  PT_NoticeTableViewCell.h
//  ptOS
//
//  Created by 吕康 on 17/3/18.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PT_NoticeTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;

@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
@end
