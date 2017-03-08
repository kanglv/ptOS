//
//  MY_ChangePhoneApi.m
//  ptOS
//
//  Created by 周瑞 on 16/9/23.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "MY_ChangePhoneApi.h"

@implementation MY_ChangePhoneApi
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
    return @"postChangePhone";
}

- (id)requestArgument {
    NSMutableDictionary *argument = nil;
    if(self.sessionDelegate)
    {
        argument = [self getBaseArgument];
    }
    else
    {
        argument = [self getBaseArgument];
    }
    [argument setCustomString:_phone forKey:@"phone"];
    return argument;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}



@end
