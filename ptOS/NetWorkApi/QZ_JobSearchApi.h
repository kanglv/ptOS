//
//  QZ_JobSearchApi.h
//  ptOS
//
//  Created by 周瑞 on 16/9/22.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseNetApi.h"

@interface QZ_JobSearchApi : BaseNetApi

- (id) initWithPage:(NSString *)page withSort:(NSString *)sort withKeyword:(NSString *)keyword withCoordinate:(NSString *)coordinate withCity:(NSString *)city withMinSalary:(NSString *)minSalary withMaxSalary:(NSString *)maxSalary withExperience:(NSString *)experience withEducations:(NSString *)education withJobNatures:(NSString *)jobNatures;

- (NSArray *)getJobSearchList;

@end
