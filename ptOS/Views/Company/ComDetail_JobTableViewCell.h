//
//  ComDetail_JobTableViewCell.h
//  ptOS
//
//  Created by 周瑞 on 16/9/8.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComDetail_JobTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIView *bottomView1;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthCons1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthCons2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthCons3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthCons4;



@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UIImageView *xzrzView;

@property (weak, nonatomic) IBOutlet UILabel *jobNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *educationLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;


@end
