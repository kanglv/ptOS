//
//  QZ_ComGiveJobsModel.m
//  ptOS
//
//  Created by 周瑞 on 16/9/22.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "QZ_ComGiveJobsModel.h"

@implementation QZ_ComGiveJobsModel
- (id)initWithDic:(NSDictionary *)dict {
    self = [super initWithDic:dict];
    if (self) {
//        self.zwId = [dict strForKey:@"zwId"];
//        self.zwName= [dict strForKey:@"zwName"];
//        self.time = [dict strForKey:@"time"];
//        self.salary = [dict strForKey:@"salary"];
//        self.isXZRZ = [dict strForKey:@"isXZRZ"];
//        self.city = [dict strForKey:@"city"];
//        self.education = [dict strForKey:@"education"];
//        self.sex = [dict strForKey:@"sex"];
//        self.age = [dict strForKey:@"age"];
        self.xysj = [dict strForKey:@"xysj"];
        self.dzrs = [dict strForKey:@"dzrs"];
        self.jobList = [dict objectForKey:@"dataList"];
    }
    return self;
}
@end
