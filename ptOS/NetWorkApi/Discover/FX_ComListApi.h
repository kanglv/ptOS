//
//  FX_ComListApi.h
//  ptOS
//
//  Created by 周瑞 on 16/9/22.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseNetApi.h"

@interface FX_ComListApi : BaseNetApi

- (id)initWithPage:(NSString *)page;

- (NSArray *)getComList;

@end
