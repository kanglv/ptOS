//
//  GetcodeAfterApi.m
//  ptOS
//
//  Created by 周瑞 on 16/9/26.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "GetcodeAfterApi.h"

@implementation GetcodeAfterApi

{
    NSString *_phone;
    NSString *_sessionId;
}

- (id)initWithPhone:(NSString *)phone withSessionId:(NSString *)sessionId {
    if (self == [super init]) {
        _phone = phone;
        _sessionId = sessionId;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"getYZM";
}

- (id)requestArgument {
    NSMutableDictionary *argument = [NSMutableDictionary dictionary];
    [argument setCustomString:_phone forKey:@"phone"];
    [argument setCustomString:_sessionId forKey:@"sessionId"];
    return argument;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGet;
}


@end
