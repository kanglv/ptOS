//
//  QZ_JobsTableViewCell.m
//  ptOS
//
//  Created by 周瑞 on 16/9/2.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "QZ_JobsTableViewCell.h"

@implementation QZ_JobsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ZRViewRadius(self.bottomView1, 10);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
