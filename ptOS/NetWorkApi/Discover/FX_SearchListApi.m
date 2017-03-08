//
//  FX_SearchListApi.m
//  ptOS
//
//  Created by 周瑞 on 16/9/22.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "FX_SearchListApi.h"
#import "FX_ComListModel.h"
@implementation FX_SearchListApi

{
    NSString *_page;
    NSString *_keyword;
}

- (id)initWithPage:(NSString *)page withKeyword:(NSString *)keyword {
    if (self == [super init]) {
        _page = page;
        _keyword = keyword;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"getSearchGround";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGet;
}

- (id)requestArgument {
    NSMutableDictionary *argument = [self getBaseArgument];
    [argument setCustomString:_page forKey:@"page"];
    [argument setCustomString:_keyword forKey:@"keyword"];
    
    return argument;
}

- (NSArray *)getSearchList {
    NSData *data= [[self responseString] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if(dict)
    {
        NSDictionary *dataDict = [dict objectForKey:@"data"];
        NSLog(@"%@",dataDict);
        if(dataDict && [dataDict isKindOfClass:[NSDictionary class]])
        {
            NSArray *array = [dataDict objectForKey:@"dataList"];
            NSMutableArray *result = [NSMutableArray array];
            for(NSDictionary *dic in array)
            {
                FX_ComListModel *model = [[FX_ComListModel alloc]initWithDic:dic];
                [result addObject:model];
            }
            return result;
        }
    }
    return nil;
}

@end
