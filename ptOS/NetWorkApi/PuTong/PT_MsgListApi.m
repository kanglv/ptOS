//
//  PT_MsgListApi.m
//  ptOS
//
//  Created by 周瑞 on 16/9/23.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "PT_MsgListApi.h"

@implementation PT_MsgListApi

{
    NSString *_page;
}

- (id)initWithPage:(NSString *)page {
    if (self == [super init]) {
        _page = page;
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGet;
}

- (NSString *)requestUrl {
    return @"getQZTZ";
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
    [argument setCustomString:_page forKey:@"page"];
    return argument;
}

- (NSArray *)getMsgList {
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
                PT_MsgListModel *model = [[PT_MsgListModel alloc]initWithDic:dic];
                [result addObject:model];
            }
            return result;
        }
    }
    return nil;
}

@end
