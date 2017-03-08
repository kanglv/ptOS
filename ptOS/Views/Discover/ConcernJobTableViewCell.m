//
//  ConcernJobTableViewCell.m
//  ptOS
//
//  Created by 吕康 on 17/3/4.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "ConcernJobTableViewCell.h"

@implementation ConcernJobTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = BackgroundColor;
    
    ZRViewRadius(self.backView, 10);
    self.backView.backgroundColor = WhiteColor;
    
    self.stateLabel.layer.borderWidth = 1;
    self.stateLabel.layer.borderColor = [UIColor redColor].CGColor;
    self.stateLabel.layer.cornerRadius = 7;
    
    
    self.headerImageView.layer.cornerRadius = 19;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
