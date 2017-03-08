//
//  AddressTableViewCell.m
//  ptOS
//
//  Created by 周瑞 on 16/10/17.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "AddressTableViewCell.h"

@implementation AddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ZRViewRadius(self.bottomView, 10);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
