//
//  PT_ToAddAttentionApi.h
//  ptOS
//
//  Created by 吕康 on 17/3/18.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "BaseNetApi.h"

@interface PT_ToAddAttentionApi : BaseNetApi

- (id)initWithUid:(NSString *)uid withTargetUid:(NSString *)targetUid;

@end
