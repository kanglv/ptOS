//
//  PT_HearthFeedBackApi.h
//  ptOS
//
//  Created by 周瑞 on 16/9/23.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseNetApi.h"

@interface PT_HearthFeedBackApi : BaseNetApi

- (id)initWithMsgId:(NSString *)msgId withImageUrls:(NSString *)urls;


@end
