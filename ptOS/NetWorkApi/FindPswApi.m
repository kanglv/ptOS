//
//  FindPswApi.m
//  ptOS
//
//  Created by 周瑞 on 16/9/28.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "FindPswApi.h"

@implementation FindPswApi

{
    NSString *_newPsw;
    NSString *_phone;
}

- (id)initWithPsw:(NSString *)newPsw withPhone:(NSString *)phone{
    if (self == [super init]) {
        _newPsw = newPsw;
        _phone = phone;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"postForgetPSW";
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
    [argument setCustomString:_newPsw forKey:@"newPsw"];
    [argument setCustomString:_phone forKey:@"phone"];
    return argument;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

@end
