//
//  QZ_ComSearchApi.h
//  ptOS
//
//  Created by 周瑞 on 16/9/22.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseNetApi.h"

@interface QZ_ComSearchApi : BaseNetApi

- (id) initWithPage:(NSString *)page withCoordinate:(NSString *)coordinate withKeyword:(NSString *)keyword withCity:(NSString *)city;

- (NSArray *)getCompanySearchList;

@end
