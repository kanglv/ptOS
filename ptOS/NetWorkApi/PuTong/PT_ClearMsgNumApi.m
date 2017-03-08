//
//  PT_ClearMsgNumApi.m
//  ptOS
//
//  Created by 周瑞 on 16/9/23.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "PT_ClearMsgNumApi.h"

@implementation PT_ClearMsgNumApi

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
    return argument;
}

- (NSString *)requestUrl {
    return @"postClearPTNum";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}



@end
