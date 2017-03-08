//
//  MY_FeedbackApi.h
//  ptOS
//
//  Created by 周瑞 on 16/9/23.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseNetApi.h"
#import "MY_FeedbackModel.h"
@interface MY_FeedbackApi : BaseNetApi

- (id)initWithPage:(NSString *)page;

- (NSArray *)getFeedBackList;

@end
