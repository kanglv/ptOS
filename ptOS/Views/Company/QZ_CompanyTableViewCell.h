//
//  QZ_CompanyTableViewCell.h
//  ptOS
//
//  Created by 周瑞 on 16/9/1.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QZ_CompanyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bottomView1;

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *jobNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *zhizhaoView;
@property (weak, nonatomic) IBOutlet UILabel *jobsNum;
@property (weak, nonatomic) IBOutlet UILabel *personNum;
@property (weak, nonatomic) IBOutlet UILabel *nearlyNum;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameWidthCons;


@end
