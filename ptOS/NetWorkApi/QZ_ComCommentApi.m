//
//  QZ_ComCommentApi.m
//  ptOS
//
//  Created by 周瑞 on 16/9/22.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "QZ_ComCommentApi.h"

@implementation QZ_ComCommentApi
{
    NSString *_page;
    NSString *_companyId;
}
- (id)initWithPage:(NSString *)page withCompanyId:(NSString *)companyId{
    self = [super init];
    if (self) {
        _page = page;
        _companyId = companyId;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"getQYPJList";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGet;
}

- (id)requestArgument {
    NSMutableDictionary *argument = [NSMutableDictionary new];
    [argument setCustomString:_companyId forKey:@"company"];
    return argument;
}

- (NSArray *)getComComment {
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
                QZ_ComCommentModel *model = [[QZ_ComCommentModel alloc]initWithDic:dic];
                [result addObject:model];
            }
            return result;
        }
    }
    return nil;
}

@end
