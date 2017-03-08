//
//  QZ_CompanyDetailView2.m
//  ptOS
//
//  Created by 周瑞 on 16/9/8.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "QZ_CompanyDetailView2.h"

@implementation QZ_CompanyDetailView2

- (void)awakeFromNib {
    [super awakeFromNib];
    ZRViewRadius(self.bottomView, 10);
    
    ZRViewRadius(self.headerImageView, 15);
    [self.attentionBtn setImage:[UIImage imageNamed:@"icon_guanzhu_press"] forState:UIControlStateSelected];
    [self.attentionBtn setImage:[UIImage imageNamed:@"icon_guanzhu"] forState:UIControlStateNormal];
}



@end
