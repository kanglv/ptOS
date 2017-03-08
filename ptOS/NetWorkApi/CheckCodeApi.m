//
//  CheckCodeApi.m
//  ptOS
//
//  Created by 周瑞 on 16/9/26.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "CheckCodeApi.h"

@implementation CheckCodeApi
{
    NSString *_phone;
    NSString *_sessionId;
    NSString *_code;
}

- (id)initWithPhone:(NSString *)phone withSessionId:(NSString *)sessionId withCode:(NSString *)code{
    if (self == [super init]) {
        _phone = phone;
        _sessionId = sessionId;
        _code = code;
    }
    return self;
}


- (NSString *)requestUrl {
    return @"checkYZM";
}

- (id)requestArgument {
    NSMutableDictionary *argument = nil;
    if(self.sessionDelegate)
    {
        argument = [self getBaseArgument];
    }
    else
    {
        argument = [NSMutableDictionary dictionary];
    }
    [argument setCustomString:_sessionId forKey:@"sessionId"];
    [argument setCustomString:_code forKey:@"code"];
    [argument setCustomString:_phone forKey:@"phone"];
    return argument;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

@end
