//
//  FX_ReplyApi.m
//  ptOS
//
//  Created by 周瑞 on 16/9/22.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "FX_ReplyApi.h"

@implementation FX_ReplyApi
{
    NSString *_tzId;
    NSString *_repliedName;
    NSString *_content;
    NSString *_replyId;
}

- (id)initWithTzId:(NSString *)tzId withRepliedName:(NSString *)repliedName withContent:(NSString *)content withReplyId:(NSString *)replyId{
    if (self == [super init]) {
        _tzId = tzId;
        _repliedName = repliedName;
        _content = content;
        _replyId = replyId;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"postReply";
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
    [argument setCustomString:_tzId forKey:@"tzId"];
    [argument setCustomString:_repliedName forKey:@"repliedName"];
    [argument setCustomString:_content forKey:@"content"];
    [argument setCustomString:_replyId forKey:@"replyId"];
    return argument;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (NSArray *)getReplyList{
    NSData *data= [[self responseString] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if(dict)
    {
        NSDictionary *dataDict = [dict objectForKey:@"data"];
        if(dataDict && [dataDict isKindOfClass:[NSDictionary class]])
        {
            NSArray *array = [dataDict objectForKey:@"dataList"];
            NSMutableArray *result = [NSMutableArray array];
            for(NSDictionary *dic in array)
            {
                ReplyModel *model = [[ReplyModel alloc]initWithDic:dic];
                [result addObject:model];
            }
            return result;
        }
    }
    return nil;
}

@end
