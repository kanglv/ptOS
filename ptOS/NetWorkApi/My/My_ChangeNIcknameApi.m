//
//  My_ChangeNIcknameApi.m
//  ptOS
//
//  Created by 周瑞 on 16/9/23.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "My_ChangeNIcknameApi.h"

@implementation My_ChangeNIcknameApi
{
    NSString *_nickName;
}

- (id)initWithNickname:(NSString *)nickname {
    if (self == [super init]) {
        _nickName = nickname;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"postChangeUserName";
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
    [argument setCustomString:_nickName forKey:@"nickName"];
    return argument;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}


@end
