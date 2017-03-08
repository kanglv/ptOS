//
//  QZ_SortView.m
//  ptOS
//
//  Created by 周瑞 on 16/9/6.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "QZ_SortView.h"

@implementation QZ_SortView

- (void)awakeFromNib {
    [self.allBtn setTitleColor:MainColor forState:UIControlStateSelected];
    [self.allBtn setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
    [self.allBtn setTitleColor:MainColor forState:UIControlStateHighlighted];
    
    [self.moneyBtn setTitleColor:MainColor forState:UIControlStateSelected];
    [self.moneyBtn setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
    [self.moneyBtn setTitleColor:MainColor forState:UIControlStateHighlighted];
    
    [self.timeBtn setTitleColor:MainColor forState:UIControlStateSelected];
    [self.timeBtn setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
    [self.timeBtn setTitleColor:MainColor forState:UIControlStateHighlighted];
    
    [self.distanceBtn setTitleColor:MainColor forState:UIControlStateSelected];
    [self.distanceBtn setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
    [self.distanceBtn setTitleColor:MainColor forState:UIControlStateHighlighted];
}

@end
