//
//  QZ_CompanyListApi.h
//  ptOS
//
//  Created by 周瑞 on 16/9/21.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseNetApi.h"

@interface QZ_CompanyListApi : BaseNetApi

- (id) initWithPage:(NSString *)page withCoordinate:(NSString *)coordinate widtCity:(NSString *)city;

- (NSArray *)getCompanyList;


@end
