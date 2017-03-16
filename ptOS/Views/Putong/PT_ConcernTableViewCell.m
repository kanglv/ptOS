//
//  PT_ConcernTableViewCell.m
//  ptOS
//
//  Created by 吕康 on 17/3/16.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "PT_ConcernTableViewCell.h"

@implementation PT_ConcernTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ZRViewRadius(self.backView, 10);
    self.backgroundColor = BackgroundColor;
    self.backView.backgroundColor = WhiteColor;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
