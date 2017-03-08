//
//  QZ_CompanyModel.m
//  ptOS
//
//  Created by 周瑞 on 16/9/21.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "QZ_CompanyModel.h"

@implementation QZ_CompanyModel

- (id)initWithDic:(NSDictionary *)dict {
    self = [super initWithDic:dict];
    if (self) {
        self.companyId           = [dict strForKey:@"companyId"];
        self.zzzwNum         = [dict strForKey:@"zzzwNum"];
        self.zzrsNum           = [dict strForKey:@"zzrsNum"];
        self.zprsMonthNum         = [dict strForKey:@"zprsMonthNum"];
        self.time         = [dict strForKey:@"time"];
        self.company           = [dict strForKey:@"company"];
        self.companyImage      = [dict strForKey:@"companyImage"];
        self.isZZ            = [dict strForKey:@"isZZ"];
        self.distance            = [dict strForKey:@"distance"];
    }
    return self;
}

@end
