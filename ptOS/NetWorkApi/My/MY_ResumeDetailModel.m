//
//  MY_ResumeDetailModel.m
//  ptOS
//
//  Created by 周瑞 on 16/9/23.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "MY_ResumeDetailModel.h"

@implementation MY_ResumeDetailModel

- (instancetype)initWithDic:(NSDictionary *)dict {
    if (self == [super init]) {
        self.basicInfo = [dict strForKey:@"basicInfo"];
        self.certificate = [dict strForKey:@"certificate"];
        self.workExp = [dict strForKey:@"workExp"];
        self.skills = [dict strForKey:@"skills"];
    }
    return self;
}


@end
