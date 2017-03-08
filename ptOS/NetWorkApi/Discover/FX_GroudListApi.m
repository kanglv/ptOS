//
//  FX_GroudListApi.m
//  ptOS
//
//  Created by 周瑞 on 16/9/22.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "FX_GroudListApi.h"
#import "FX_ComListModel.h"
@implementation FX_GroudListApi
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
    return @"getGround";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGet;
}

- (id)requestArgument {
    NSMutableDictionary *argument = [self getBaseArgument];
    
    [argument setCustomString:_page forKey:@"page"];
    return argument;
}

- (NSArray *)getGroudList {
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
