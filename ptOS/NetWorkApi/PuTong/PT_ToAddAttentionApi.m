//
//  PT_ToAddAttentionApi.m
//  ptOS
//
//  Created by 吕康 on 17/3/18.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "PT_ToAddAttentionApi.h"

@implementation PT_ToAddAttentionApi
{
    NSString *_uid;
    NSString *_targetUid;
}

- (id)initWithUid:(NSString *)uid withTargetUid:(NSString *)targetUid {
    if (self == [super init]) {
        _uid = uid;
        _targetUid = targetUid;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"toAddAttention";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
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
    
    [argument setCustomString:_uid forKey:@"uid"];
    [argument setCustomString:_targetUid forKey:@"targetUid"];
   
    return argument;
}

@end
