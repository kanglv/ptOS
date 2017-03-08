//
//  PT_NearlyListApi.h
//  ptOS
//
//  Created by 吕康 on 17/3/6.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "BaseNetApi.h"
#import "PT_NearlyListModel.h"
@interface PT_NearlyListApi : BaseNetApi

- (id)initWithSessionId:(NSString *)sessionId andWithPage:(NSString *)page;

- (NSArray *)getNearlyList;

@end
