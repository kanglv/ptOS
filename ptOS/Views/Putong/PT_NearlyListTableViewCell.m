//
//  PT_NearlyListTableViewCell.m
//  ptOS
//
//  Created by 吕康 on 17/3/6.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "PT_NearlyListTableViewCell.h"

@implementation PT_NearlyListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
     ZRViewRadius(self.backView, 10);
    self.backgroundColor = BackgroundColor;
    self.backView.backgroundColor = WhiteColor;
    self.stateBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = 25;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
