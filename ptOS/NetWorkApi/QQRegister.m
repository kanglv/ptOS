//
//  QQRegister.m
//  ptOS
//
//  Created by 周瑞 on 16/9/23.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "QQRegister.h"

@implementation QQRegister
{
    NSString *_phone;
    NSString *_password;
    NSString *_openId;
}

- (id)initWithPhone:(NSString *)phone withPassword:(NSString *)psw withOpenId:(NSString *)openId {
    if (self == [super init]) {
        _phone = phone;
        _password = psw;
        _openId = openId;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"postQQRegister";
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
    [argument setCustomString:_openId forKey:@"openId"];
    [argument setCustomString:_password forKey:@"password"];
    [argument setCustomString:_phone forKey:@"phone"];
    return argument;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

@end
