//
//  GroupSpeechTableViewCell.m
//  ptOS
//
//  Created by 吕康 on 17/2/21.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "GroupSpeechTableViewCell.h"

@implementation GroupSpeechTableViewCell

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
