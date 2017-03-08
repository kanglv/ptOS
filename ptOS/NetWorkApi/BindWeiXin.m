//
//  BindWeiXin.m
//  ptOS
//
//  Created by 周瑞 on 16/9/23.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BindWeiXin.h"

@implementation BindWeiXin
{
    NSString *_openId;
}

- (id)initWithOpenId:(NSString *)openId {
    if (self == [super init]) {
        _openId = openId;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"postBindWX";
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
    [argument setCustomString:_openId forKey:@"openId"];
    return argument;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}



@end
