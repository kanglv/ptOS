//
//  FX_GetNoticeListApi.m
//  ptOS
//
//  Created by 吕康 on 17/3/7.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "FX_GetNoticeListApi.h"

@implementation FX_GetNoticeListApi
{
    NSString *_page;
    NSString *_sessionId;
    NSString *_type;
    NSString *_searchKey;
}

- (id)initWithPage:(NSString *)page withSessionId:(NSString *)sessionId withType:(NSString *)type withSearchKey:(NSString *)searchKey {
    if (self == [super init]) {
        _page = page;
        _sessionId = sessionId;
        _type = type;
        _searchKey = searchKey;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"getNoticeList";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGet;
}

- (id)requestArgument {
    NSMutableDictionary *argument = [self getBaseArgument];
    
    [argument setCustomString:_page forKey:@"page"];
    [argument setCustomString:_sessionId forKey:@"sessionId"];
    [argument setCustomString:_type forKey:@"type"];
    [argument setCustomString:_searchKey forKey:@"searchKey"];
    return argument;
}

- (NSArray *)getNoticeList {
    NSData *data= [[self responseString] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if(dict)
    {
        NSDictionary *dataDict = [dict objectForKey:@"data"];
        if(dataDict && [dataDict isKindOfClass:[NSDictionary class]])
        {
            NSArray *array = [dataDict objectForKey:@"dataList"];
            NSMutableArray *result = [NSMutableArray array];
            NSLog(@"%@",array);
           
            return result;
        }
    }
    return nil;
}

@end
