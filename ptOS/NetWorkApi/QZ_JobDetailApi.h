//
//  QZ_JobDetailApi.h
//  ptOS
//
//  Created by 周瑞 on 16/9/21.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseNetApi.h"
#import "QZ_JobDetailModel.h"

@interface QZ_JobDetailApi : BaseNetApi

- (id)initWithZWID:(NSString *)zwid;

- (QZ_JobDetailModel *)getJobDetail;

@end
