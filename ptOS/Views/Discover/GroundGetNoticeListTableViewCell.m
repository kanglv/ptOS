//
//  GroundGetNoticeListTableViewCell.m
//  ptOS
//
//  Created by 吕康 on 17/3/12.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "GroundGetNoticeListTableViewCell.h"

@implementation GroundGetNoticeListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = BackgroundColor;
    self.backView.backgroundColor = WhiteColor;
    ZRViewRadius(_timeLabel, 5);
    ZRViewRadius(self.backView, 5);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
