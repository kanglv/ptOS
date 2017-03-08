//
//  MY_LogoutApi.m
//  ptOS
//
//  Created by 周瑞 on 16/9/23.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "MY_LogoutApi.h"

@implementation MY_LogoutApi


- (id)requestArgument {
    NSMutableDictionary *argument = [NSMutableDictionary dictionary];
    if(self.sessionDelegate)
    {
        argument = [self getBaseArgument];
    }
    else
    {
        argument = [self getBaseArgument];
    }
    return argument;
}

- (NSString *)requestUrl {
    return @"getLogOut";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGet;
}


@end
