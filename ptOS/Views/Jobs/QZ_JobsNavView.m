//
//  QZ_JobsNavView.m
//  ptOS
//
//  Created by 周瑞 on 16/9/6.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "QZ_JobsNavView.h"

@implementation QZ_JobsNavView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.jobsBtn setTitleColor:WhiteColor forState:UIControlStateSelected];
    [self.jobsBtn setTitleColor:RGB(193, 211, 249) forState:UIControlStateNormal];
    
    [self.companyBtn setTitleColor:WhiteColor forState:UIControlStateSelected];
    [self.companyBtn setTitleColor:RGB(193, 211, 249) forState:UIControlStateNormal];
}

@end
