//
//  FX_GetCompanyOtherNoticeApi.h
//  ptOS
//
//  Created by 吕康 on 17/3/7.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "BaseNetApi.h"

@interface FX_GetCompanyOtherNoticeApi : BaseNetApi
- (id)initWithPage:(NSString *)page withSessionId:(NSString *)sessionId withType:(NSString *)type;

- (NSArray *)getCompanyOtherNotice;
@end
