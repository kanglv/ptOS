//
//  PT_NearlyListApi.m
//  ptOS
//
//  Created by 吕康 on 17/3/6.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "PT_NearlyListApi.h"


@implementation PT_NearlyListApi{
    NSString *_sessionId;
    NSString *_page;
}

- (id)initWithSessionId:(NSString *)sessionId andWithPage:(NSString *)page {
    if (self == [super init]) {
        _sessionId = sessionId;
        _page      = page;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"nearlylist";
}

- (id)requestArgument {
    NSMutableDictionary *argument = [NSMutableDictionary dictionary];
    [argument setCustomString:_sessionId forKey:@"sessionId"];
    [argument setCustomString:_page forKey:@"page"];
    return argument;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGet;
}

- (NSArray*)getNearlyList {
    NSData *data= [[self responseString] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if(dict)
    {
        NSDictionary *dataDict = [dict objectForKey:@"data"];
        NSLog(@"%@",dataDict);
        if(dataDict && [dataDict isKindOfClass:[NSDictionary class]])
        {
            NSArray *array = [dataDict objectForKey:@"datalist"];
//            NSMutableArray *result = [NSMutableArray array];
//            for(NSDictionary *dic in array)
//            {
//                PT_NearlyListModel *model = [[PT_NearlyListModel alloc]initWithDic:dic];
//                [result addObject:model];
//            }
            return array;
        }
    }
    return nil;
}


@end
