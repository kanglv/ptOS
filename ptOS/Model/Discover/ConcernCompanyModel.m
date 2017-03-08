//
//  ConcernCompanyModel.m
//  ptOS
//
//  Created by 吕康 on 17/3/4.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "ConcernCompanyModel.h"

@implementation ConcernCompanyModel

- (instancetype)initWithDic:(NSDictionary *)dict {
    if (self == [super init]) {
        
        self.companyId = [dict objectForKey:@"companyId"];
        self.zzzwNum   = [dict objectForKey:@"zzzwNum"];
        self.Time      = [dict objectForKey:@"Time"];
        self.zzrsNum   = [dict objectForKey:@"zzrsNum"];
        self.company   = [dict objectForKey:@"company"];
        self.companyImage = [dict objectForKey:@"companyImage"];
        self.isZp      = [dict objectForKey:@"isZp"];
    }
    return self;
}



@end
