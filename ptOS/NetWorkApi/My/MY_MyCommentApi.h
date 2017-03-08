//
//  MY_MyCommentApi.h
//  ptOS
//
//  Created by 周瑞 on 16/9/23.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseNetApi.h"

@interface MY_MyCommentApi : BaseNetApi

- (id)initWithPage:(NSString *)page;

- (NSArray *)getMyCommentList;

@end
