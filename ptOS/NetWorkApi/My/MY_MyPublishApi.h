//
//  MY_MyPublishApi.h
//  ptOS
//
//  Created by 周瑞 on 16/9/23.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseNetApi.h"

@interface MY_MyPublishApi : BaseNetApi

- (id)initWithPage:(NSString *)page;

- (NSArray *)getMyPublishList;


@end
