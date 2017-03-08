
//
//  MY_MyPublishApi.m
//  ptOS
//
//  Created by 周瑞 on 16/9/23.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "MY_MyPublishApi.h"
#import "MY_MyPublishModel.h"

@implementation MY_MyPublishApi
{
    NSString *_page;
}

- (id)initWithPage:(NSString *)page {
    if (self == [super init]) {
        _page = page;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"getMyPublish";
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

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGet;
}

- (NSArray *)getMyPublishList {
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
                MY_MyPublishModel *model = [[MY_MyPublishModel alloc]initWithDic:dic];
                [result addObject:model];
            }
            return result;
        }
    }
    return nil;
}

@end
