//
//  GroundTableViewCell.h
//  ptOS
//
//  Created by 周瑞 on 16/8/31.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHLUILabel.h"
@interface GroundTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bottomView1;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelHeightCons;


@property (weak, nonatomic) IBOutlet UIView *shuView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nickNameWidthCons;

@property (weak, nonatomic) IBOutlet UIButton *zanBtn;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *smallImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;


@property (weak, nonatomic) IBOutlet UILabel *comNameLbel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *zanNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *addressLabel;


@end
