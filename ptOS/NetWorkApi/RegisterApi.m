
//
//  RegisterApi.m
//  ptOS
//
//  Created by 周瑞 on 16/9/23.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "RegisterApi.h"

@implementation RegisterApi
{
    NSString *_phone;
    NSString *_password;
}

- (instancetype)initWithPhone:(NSString *)phone withPsw:(NSString *)password {
    if (self == [super init]) {
        _phone = phone;
        _password = password;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"postRegister";
}

- (id)requestArgument {
    NSMutableDictionary *argument = [NSMutableDictionary dictionary];
    [argument setCustomString:_phone forKey:@"phone"];
    [argument setCustomString:_password forKey:@"password"];
    return argument;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}



@end
