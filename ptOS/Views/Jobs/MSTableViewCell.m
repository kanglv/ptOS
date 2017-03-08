//
//  MSTableViewCell.m
//  ptOS
//
//  Created by 周瑞 on 16/10/17.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "MSTableViewCell.h"

@implementation MSTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    ZRViewRadius(self.bottomView, 10);
    ZRViewBorderRadius(self.seeAllBtn, 1, [UIColor redColor]);
    ZRViewRadius(self.seeAllBtn, 5);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
@end
