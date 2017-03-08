//
//  QZ_JobListApi.h
//  ptOS
//
//  Created by 周瑞 on 16/9/20.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseNetApi.h"

@interface QZ_JobListApi : BaseNetApi

- (id)initWithPage:(NSString *)page withSort:(NSString *)sort withCoordinate:(NSString *)coordinate widthCity:(NSString *)city withMinSalary:(NSString *)minSalary withMaxSalary:(NSString *)maxSalary withExperience:(NSString *)experience withEducations:(NSString *)education withJobNatures:(NSString *)jobNatures;

//- (id) initWithPage:(NSString *)page withSort:(NSString *)sort withCoordinate:(NSString *)coordinate widthCity:(NSString *)city;

- (NSArray *)getJobsList;


@end
