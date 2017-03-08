//
//  PT_HearthFeedBackApi.m
//  ptOS
//
//  Created by 周瑞 on 16/9/23.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "PT_HearthFeedBackApi.h"

@implementation PT_HearthFeedBackApi
{
    NSString *_msgId;
    NSString *_imgUrls;
}

- (id)initWithMsgId:(NSString *)msgId withImageUrls:(NSString *)urls {
    if (self == [super init]) {
        _msgId = msgId;
        _imgUrls = urls;
    }
    return self;
}

- (id)requestArgument {
    NSMutableDictionary *argument = [self getBaseArgument];

    [argument setCustomString:_msgId forKey:@"messageId"];
    [argument setCustomString:_imgUrls forKey:@"imgUrls"];
    return argument;
}



- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (NSString *)requestUrl {
    return @"postTJFK";
}

@end
