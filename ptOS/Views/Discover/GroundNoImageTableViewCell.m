//
//  GroundNoImageTableViewCell.m
//  ptOS
//
//  Created by 周瑞 on 16/9/4.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "GroundNoImageTableViewCell.h"

@implementation GroundNoImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ZRViewRadius(self.bottomView1, 10);
    [self.zanBtn setImage:[UIImage imageNamed:@"icon_dianzan"] forState:UIControlStateNormal];
    [self.zanBtn setImage:[UIImage imageNamed:@"icon_dianzhan_blue"] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
