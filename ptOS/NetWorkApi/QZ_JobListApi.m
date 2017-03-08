//
//  QZ_JobListApi.m
//  ptOS
//
//  Created by 周瑞 on 16/9/20.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "QZ_JobListApi.h"
#import "QZ_JobModel.h"
@implementation QZ_JobListApi
{
    NSString *_page;
    NSString *_sort;
    NSString *_coordinate;
    NSString *_city;
    NSString *_minSalary;
    NSString *_maxSalary;
    NSString *_experiences;
    NSString *_educations;
    NSString *_jobNatures;
}
- (id)initWithPage:(NSString *)page withSort:(NSString *)sort withCoordinate:(NSString *)coordinate widthCity:(NSString *)city withMinSalary:(NSString *)minSalary withMaxSalary:(NSString *)maxSalary withExperience:(NSString *)experience withEducations:(NSString *)education withJobNatures:(NSString *)jobNatures{
    self = [super init];
    if (self) {
        _page = page;
        _sort = sort;
        _coordinate = coordinate;
        _city = city;
        _maxSalary =maxSalary;
        _minSalary = minSalary;
        _experiences = experience;
        _educations = education;
        _jobNatures = jobNatures;
    }
    return self;
}



- (NSString *)requestUrl {
    return @"getQZZWList";
}


- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGet;
}

- (id)requestArgument {
    NSMutableDictionary *argument = [NSMutableDictionary dictionary];
    [argument setCustomString:_page forKey:@"page"];
    [argument setCustomString:_sort forKey:@"sort"];
    [argument setCustomString:_coordinate forKey:@"coordinate"];
    [argument setCustomString:_city forKey:@"city"];
    [argument setCustomString:_maxSalary forKey:@"maxSalary"];
    [argument setCustomString:_minSalary forKey:@"minSalary"];
    [argument setCustomString:_experiences forKey:@"experiences"];
    [argument setCustomString:_educations forKey:@"educations"];
    [argument setCustomString:_jobNatures forKey:@"jobNatures"];
    return argument;
}

- (NSArray *)getJobsList {
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
                QZ_JobModel *model = [[QZ_JobModel alloc]initWithDic:dic];
                [result addObject:model];
            }
            return result;
        }
    }
    return nil;
}



@end
