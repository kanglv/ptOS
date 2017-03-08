//
//  PT_QiuzhiTableViewCell.h
//  ptOS
//
//  Created by 周瑞 on 16/9/1.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PT_JobMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bottomView1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeightCons;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *seeLabel;
@end
