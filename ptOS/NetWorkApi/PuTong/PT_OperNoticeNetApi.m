//
//  PT_OperNoticeNetApi.m
//  ptOS
//
//  Created by 吕康 on 17/4/5.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "PT_OperNoticeNetApi.h"

@implementation PT_OperNoticeNetApi{
    NSString * _jobresumeId;
    NSString * _jobresumeStatus;
    NSString * _oper;
}

- (id)initWithJobresumeId:(NSString *)jobresumeId withJobresumeStatus:(NSString *)jobresumeStatus withOper:(NSString *)oper{
    if (self == [super init]) {
    _jobresumeId = jobresumeId;
    _jobresumeStatus = jobresumeStatus;
    _oper = oper;
    }
    return self;
}

- (NSString *)requestUrl {
    
    return  @"operNotice";
}

- (id)requestArgument {
    NSMutableDictionary *argument = [NSMutableDictionary dictionary];;
    [argument setCustomString:_jobresumeId forKey:@"jobresumeId"];
    [argument setCustomString:_jobresumeStatus forKey:@"jobresumeStatus"];
    [argument setCustomString:_oper forKey:@"oper"];
    return argument;
}



- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}


@end
