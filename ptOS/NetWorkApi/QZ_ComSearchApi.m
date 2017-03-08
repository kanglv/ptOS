//
//  QZ_ComSearchApi.m
//  ptOS
//
//  Created by 周瑞 on 16/9/22.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "QZ_ComSearchApi.h"
#import "QZ_CompanyModel.h"
@implementation QZ_ComSearchApi
{
    NSString *_page;
    NSString *_coordinate;
    NSString *_keyword;
    NSString *_city;
}
- (id) initWithPage:(NSString *)page withCoordinate:(NSString *)coordinate withKeyword:(NSString *)keyword withCity:(NSString *)city{
    self = [super init];
    if (self) {
        _page = page;
        _coordinate = coordinate;
        _keyword = keyword;
        _city = city;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"getQZGSSearchList";
}


- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGet;
}

- (id)requestArgument {
    NSMutableDictionary *argument = [NSMutableDictionary new];
    [argument setCustomString:_page forKey:@"page"];
    [argument setCustomString:_coordinate forKey:@"coordinate"];
    [argument setCustomString:_keyword forKey:@"keyword"];
    return argument;
}

- (NSArray *)getCompanySearchList {
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
                QZ_CompanyModel *model = [[QZ_CompanyModel alloc]initWithDic:dic];
                [result addObject:model];
            }
            return result;
        }
    }
    return nil;
}


@end
