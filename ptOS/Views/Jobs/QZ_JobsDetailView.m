//
//  QZ_JobsDetailView.m
//  ptOS
//
//  Created by 周瑞 on 16/9/4.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "QZ_JobsDetailView.h"

@implementation QZ_JobsDetailView

- (void)awakeFromNib {
    [super awakeFromNib];
    ZRViewRadius(self.bottomView1, 10);
    ZRViewRadius(self.bottomView2, 10);
    ZRViewRadius(self.bottomView3, 10);
    ZRViewRadius(self.bottomView4, 10);
    ZRViewRadius(self.bottomView5, 10);
}

@end
