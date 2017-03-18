//
//  PT_NoticeTableViewCell.m
//  ptOS
//
//  Created by 吕康 on 17/3/18.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "PT_NoticeTableViewCell.h"

@implementation PT_NoticeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    ZRViewRadius(self.backView, 10);
    self.backgroundColor = BackgroundColor;
    self.backView.backgroundColor = WhiteColor;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
