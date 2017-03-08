//
//  PT_MsgDetailApi.m
//  ptOS
//
//  Created by 周瑞 on 16/9/23.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "PT_MsgDetailApi.h"

@implementation PT_MsgDetailApi
{
    NSString *_msgId;
}

- (id)initWithMsgId:(NSString *)messageId {
    if (self == [super init]) {
        _msgId = messageId;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"getQZTZXQ";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGet;
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
    [argument setCustomString:_msgId forKey:@"messageId"];
    return argument;
}

- (PT_MsgDetailModel *)getMsgDetail {
    NSData *data= [[self responseString] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if(dict)
    {
        NSDictionary *dataDict = [dict objectForKey:@"data"];
        if(dataDict && [dataDict isKindOfClass:[NSDictionary class]])
        {
            PT_MsgDetailModel *result = [[PT_MsgDetailModel alloc] initWithDic:dataDict];
            return result;
        }
    }
    return nil;
}

@end
