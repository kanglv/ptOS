//
//  QZ_ComGiveJobsApi.h
//  ptOS
//
//  Created by 周瑞 on 16/9/22.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseNetApi.h"
#import "QZ_ComGiveJobsModel.h"
@interface QZ_ComGiveJobsApi : BaseNetApi

- (id)initWithCompanyId:(NSString *)companyId withPage:(NSString *)page;

- (QZ_ComGiveJobsModel *)getComGiveJobs;

@end
