//
//  MY_AddExpersTableViewCell.m
//  ptOS
//
//  Created by 吕康 on 17/4/6.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "MY_AddExpersTableViewCell.h"

@implementation MY_AddExpersTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ZRViewRadius(self.backView, 10);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
