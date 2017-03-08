//
//  QZ_JobModel.m
//  ptOS
//
//  Created by 周瑞 on 16/9/20.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "QZ_JobModel.h"

@implementation QZ_JobModel

- (id)initWithDic:(NSDictionary *)dict {
    self = [super initWithDic:dict];
    if (self) {
        self.zwId           = [dict strForKey:@"zwId"];
        self.zwName         = [dict strForKey:@"zwName"];
        self.time           = [dict strForKey:@"time"];
        self.salary         = [dict strForKey:@"salary"];
        self.isXZRZ         = [dict strForKey:@"isXZRZ"];
        self.city           = [dict strForKey:@"city"];
        self.education      = [dict strForKey:@"education"];
        self.sex            = [dict strForKey:@"sex"];
        self.age            = [dict strForKey:@"age"];
        self.company        = [dict strForKey:@"company"];
        self.companyImage   = [dict strForKey:@"companyImage"];
        self.isZZ           = [dict strForKey:@"isZZ"];
        self.distance       = [dict strForKey:@"distance"];
    }
    return self;
}

@end
