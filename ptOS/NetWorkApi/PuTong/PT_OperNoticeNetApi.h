//
//  PT_OperNoticeNetApi.h
//  ptOS
//
//  Created by 吕康 on 17/4/5.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "BaseNetApi.h"

@interface PT_OperNoticeNetApi : BaseNetApi

- (id)initWithJobresumeId:(NSString *)jobresumeId withJobresumeStatus:(NSString *)jobresumeStatus withOper:(NSString *)oper;
@end
