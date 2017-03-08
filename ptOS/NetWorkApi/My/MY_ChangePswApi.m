//
//  MY_ChangePswApi.m
//  ptOS
//
//  Created by 周瑞 on 16/9/23.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "MY_ChangePswApi.h"

@implementation MY_ChangePswApi
{
    NSString *_newPsw;
}

- (id)initWithPsw:(NSString *)newPsw {
    if (self == [super init]) {
        _newPsw = newPsw;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"postChangePSW";
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
    [argument setCustomString:_newPsw forKey:@"newPsw"];
    return argument;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}



@end
