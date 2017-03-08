//
//  QZ_JobDetail_ApplyJobApi.m
//  ptOS
//
//  Created by 周瑞 on 16/9/22.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "QZ_JobDetail_ApplyJobApi.h"

@implementation QZ_JobDetail_ApplyJobApi
{
    NSString *_zwId;
}
- (instancetype)initWithZWID:(NSString *)zwId {
    self = [super init];
    if (self) {
        _zwId = zwId;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"postApply";
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
    [argument setCustomString:_zwId forKey:@"zwId"];
    return argument;
}



@end
