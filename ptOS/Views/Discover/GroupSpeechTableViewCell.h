//
//  GroupSpeechTableViewCell.h
//  ptOS
//
//  Created by 吕康 on 17/2/21.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHLUILabel.h"
@interface GroupSpeechTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bottomView1;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelHeightCons;

@property (strong, nonatomic) IBOutlet UIButton *playBtn;


@property (weak, nonatomic) IBOutlet UIButton *zanBtn;

@property (weak, nonatomic) IBOutlet UIView *shuView;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nickNameWidthLabel;


@property (weak, nonatomic) IBOutlet UIImageView *smallImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (strong, nonatomic) IBOutlet UILabel *comNameLabel;


@property (strong, nonatomic) IBOutlet UIButton *conNumBtn;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *zanNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *time;

@end
