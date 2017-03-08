//
//  PT_QiuzhiTableViewCell.m
//  ptOS
//
//  Created by 周瑞 on 16/9/1.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "PT_JobMessageTableViewCell.h"

@implementation PT_JobMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ZRViewRadius(self.bottomView1, 10);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
