//
//  WeiXinRegister.m
//  ptOS
//
//  Created by 周瑞 on 16/9/23.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "WeiXinRegister.h"

@implementation WeiXinRegister
{
    NSString *_phone;
    NSString *_password;
    NSString *_openId;
    NSString *_yzm;
}

- (id)initWithPhone:(NSString *)phone withPassword:(NSString *)psw withOpenId:(NSString *)openId withYzm:(NSString *)yzm {
    if (self == [super init]) {
        _phone = phone;
        _password = psw;
        _openId = openId;
        _yzm = yzm;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"postWXRegister";
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
    [argument setCustomString:_yzm forKey:@"yzm"];
    return argument;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}


@end
