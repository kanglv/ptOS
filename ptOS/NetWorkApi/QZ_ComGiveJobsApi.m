//
//  QZ_ComGiveJobsApi.m
//  ptOS
//
//  Created by 周瑞 on 16/9/22.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "QZ_ComGiveJobsApi.h"

@implementation QZ_ComGiveJobsApi
{
    NSString *_companyId;
    NSString *_page;
}
- (id)initWithCompanyId:(NSString *)companyId withPage:(NSString *)page {
    if (self == [super init]) {
        _companyId = companyId;
        _page = page;
    }
    return self;
}


- (NSString *)requestUrl {
    return @"getGSZPZWList";
}


- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGet;
}

- (id)requestArgument {
    NSMutableDictionary *argument = [NSMutableDictionary dictionary];
    [argument setCustomString:_page forKey:@"page"];
    [argument setCustomString:_companyId forKey:@"companyId"];
    return argument;
}

- (QZ_ComGiveJobsModel *)getComGiveJobs {
    NSData *data= [[self responseString] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if(dict)
    {
        NSDictionary *dataDict = [dict objectForKey:@"data"];
        if(dataDict && [dataDict isKindOfClass:[NSDictionary class]])
        {
//            NSArray *array = [dataDict objectForKey:@"dataList"];
//            NSMutableArray *result = [NSMutableArray array];
//            for(NSDictionary *dic in array)
//            {
//                QZ_ComGiveJobsModel *model = [[QZ_ComGiveJobsModel alloc]initWithDic:dic];
//                model.xysj = [dataDict strForKey:@"xysj"];
//                model.dzrs = [dataDict strForKey:@"dzrs"];
//                [result addObject:model];
//            }
//            return result;
            QZ_ComGiveJobsModel *result = [[QZ_ComGiveJobsModel alloc]initWithDic:dataDict];
            return result;
        }
    }
    return nil;
}
@end
