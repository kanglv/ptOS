//
//  PT_ClearMessageNumApi.m
//  ptOS
//
//  Created by 吕康 on 17/4/22.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "PT_ClearMessageNumApi.h"

@implementation PT_ClearMessageNumApi
{
    NSString *_type;
}

- (id)initWithType:(NSString *)type {
    if (self == [super init]) {
        _type = type;
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (NSString *)requestUrl {
    return @"postClearMessageNum";
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
    [argument setCustomString:_type forKey:@"type"];
    return argument;
}





@end
