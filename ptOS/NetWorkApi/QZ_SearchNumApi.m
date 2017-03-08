//
//  QZ_SearchNumApi.m
//  ptOS
//
//  Created by 周瑞 on 16/9/22.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "QZ_SearchNumApi.h"

@implementation QZ_SearchNumApi
{
    NSString *_keyword;
    NSString *_city;
}
- (id)initWithKeyword:(NSString *)keyword withCity:(NSString *)city{
    if (self == [super init]) {
        _keyword = keyword;
        _city = city;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"getSearch";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGet;
}

- (id)requestArgument {
    NSMutableDictionary *argument = [NSMutableDictionary new];
    [argument setCustomString:_keyword forKey:@"keyword"];
    return argument;
}

- (QZ_seachNumModel *)getSearchNum {
    NSData *data= [[self responseString] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if(dict)
    {
        NSDictionary *dataDict = [dict objectForKey:@"data"];
        if(dataDict && [dataDict isKindOfClass:[NSDictionary class]])
        {
            QZ_seachNumModel *result = [[QZ_seachNumModel alloc] initWithDic:dataDict];
            
            return result;
        }
    }
    return nil;
}

@end
