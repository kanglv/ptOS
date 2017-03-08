//
//  ReadApi.m
//  ptOS
//
//  Created by 周瑞 on 16/10/21.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "ReadApi.h"

@implementation ReadApi

{
    NSString *_zwId;
}

- (id)initWithZwId:(NSString *)zwId {
    if (self == [super init]) {
        _zwId = zwId;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"postRead";
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
    [argument setCustomString:_zwId forKey:@"zwId"];
    return argument;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}


@end
