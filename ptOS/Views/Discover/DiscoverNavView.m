//
//  DiscoverNavView.m
//  ptOS
//
//  Created by 周瑞 on 16/9/9.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "DiscoverNavView.h"

@implementation DiscoverNavView

- (void)awakeFromNib {
    [self.groundBtn setTitleColor:WhiteColor forState:UIControlStateSelected];
    [self.groundBtn setTitleColor:RGB(193, 211, 249) forState:UIControlStateNormal];
    
    [self.companyBtn setTitleColor:WhiteColor forState:UIControlStateSelected];
    [self.companyBtn setTitleColor:RGB(193, 211, 249) forState:UIControlStateNormal];
}

@end
