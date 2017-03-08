//
//  MY_FeedbackModel.m
//  ptOS
//
//  Created by 周瑞 on 16/9/23.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "MY_FeedbackModel.h"

@implementation MY_FeedbackModel

- (instancetype)initWithDic:(NSDictionary *)dict {
    if (self == [super init]) {
        self.zwId = [dict strForKey:@"zwId"];
        self.jobName = [dict strForKey:@"jobName"];
        self.state = [dict strForKey:@"state"];
        self.conpanyName = [dict strForKey:@"conpanyName"];
        self.companyImage = [dict strForKey:@"companyImage"];
        self.isZhiZhao = [dict strForKey:@"isZhiZhao"];
        self.time = [dict strForKey:@"time"];
    }
    return self;
}

@end
