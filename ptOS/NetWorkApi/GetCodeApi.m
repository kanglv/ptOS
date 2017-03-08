

//
//  GetCodeApi.m
//  ptOS
//
//  Created by 周瑞 on 16/9/23.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "GetCodeApi.h"

@implementation GetCodeApi
{
    NSString *_phone;
}

- (id)initWithPhone:(NSString *)phone {
    if (self == [super init]) {
        _phone = phone;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"getYZM";
}

- (id)requestArgument {
    NSMutableDictionary *argument = [NSMutableDictionary dictionary];
    [argument setCustomString:_phone forKey:@"phone"];
    return argument;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGet;
}

- (NSString *)getSessionId {
    NSData *data= [[self responseString] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if(dict)
    {
        NSDictionary *dataDict = [dict objectForKey:@"data"];
        if(dataDict && [dataDict isKindOfClass:[NSDictionary class]])
        {
            NSString *sessionId = dataDict[@"sessionId"];
            return sessionId;
        }
    }
    return nil;
}

@end
