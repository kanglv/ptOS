//
//  ConcernCompanyTableViewCell.m
//  ptOS
//
//  Created by 吕康 on 17/3/4.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "ConcernCompanyTableViewCell.h"

@implementation ConcernCompanyTableViewCell

- (void)awakeFromNib {
  
    [super awakeFromNib];
    self.backgroundColor = BackgroundColor;
    ZRViewRadius(self.backView, 10);
    self.backView.backgroundColor = WhiteColor;
    
    self.headerImage.layer.cornerRadius = 19;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
