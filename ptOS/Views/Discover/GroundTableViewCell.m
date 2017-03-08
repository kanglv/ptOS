//
//  GroundTableViewCell.m
//  ptOS
//
//  Created by 周瑞 on 16/8/31.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "GroundTableViewCell.h"

@implementation GroundTableViewCell

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
