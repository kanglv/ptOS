//
//  QZ_CompanyTableViewCell.m
//  ptOS
//
//  Created by 周瑞 on 16/9/1.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "QZ_CompanyTableViewCell.h"

@implementation QZ_CompanyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ZRViewRadius(self.bottomView1, 10);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
