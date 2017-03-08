//
//  QZ_JobsTableViewCell.h
//  ptOS
//
//  Created by 周瑞 on 16/9/2.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QZ_JobsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bottomView1;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthCons1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthCons2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthCons3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthCons4;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameWidthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceWidthCons;


@property (weak, nonatomic) IBOutlet UILabel *jobNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UIImageView *xzrzLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *educationLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *zhizhaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;


@end
