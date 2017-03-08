//
//  QZ_JobDetailCollectJobApi.m
//  ptOS
//
//  Created by 周瑞 on 16/9/22.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "QZ_JobDetailCollectJobApi.h"

@implementation QZ_JobDetailCollectJobApi
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
    return @"postFollowZW";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    NSMutableDictionary *argument = [self getBaseArgument];
    [argument setCustomString:_zwId forKey:@"zwId"];
    return argument;
}

@end
