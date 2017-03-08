//
//  ConcernJobModel.m
//  ptOS
//
//  Created by 吕康 on 17/3/4.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "ConcernJobModel.h"

@implementation ConcernJobModel

- (instancetype)initWithDic:(NSDictionary *)dict {
    if (self == [super init]) {
        
        self.companyId = [dict objectForKey:@"companyId"];
        self.zwName    = [dict objectForKey:@"zwName"];
        self.companyName      = [dict objectForKey:@"companyName"];
        
        self.jobId   = [dict objectForKey:@"jobId"];
        self.companyImage = [dict objectForKey:@"companyImage"];
        self.isZP      = [dict objectForKey:@"isZp"];
        self.isZZ      = [dict objectForKey:@"isZZ"];

    }
    return self;
}



@end
