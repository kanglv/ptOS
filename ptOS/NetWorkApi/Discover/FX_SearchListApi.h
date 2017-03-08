//
//  FX_SearchListApi.h
//  ptOS
//
//  Created by 周瑞 on 16/9/22.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseNetApi.h"

@interface FX_SearchListApi : BaseNetApi

- (id)initWithPage:(NSString *)page withKeyword:(NSString *)keyword;

- (NSArray *)getSearchList;
@end
