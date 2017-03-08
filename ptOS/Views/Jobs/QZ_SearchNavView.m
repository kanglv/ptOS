//
//  QZ_SearchNavView.m
//  ptOS
//
//  Created by 周瑞 on 16/9/6.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "QZ_SearchNavView.h"

@implementation QZ_SearchNavView

- (void)awakeFromNib {
    [super awakeFromNib];
    ZRViewRadius(self.searchField, 5);
    self.searchField.tintColor = WhiteColor;
    
    [self.jobsBtn setTitleColor:WhiteColor forState:UIControlStateSelected];
    [self.jobsBtn setTitleColor:RGB(193, 211, 249) forState:UIControlStateNormal];
    
    [self.companyBtn setTitleColor:WhiteColor forState:UIControlStateSelected];
    [self.companyBtn setTitleColor:RGB(193, 211, 249) forState:UIControlStateNormal];
    

}

@end
