//
//  PT_GetMessageNetApi.h
//  ptOS
//
//  Created by 吕康 on 17/3/14.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "BaseNetApi.h"

@interface PT_GetMessageNetApi : BaseNetApi
- (id)initWithPage:(NSString *)page withSessionId:(NSString *)sessionId withType:(NSString *)type;

- (NSArray*)getMessageList;
@end
