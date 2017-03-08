//
//  FX_GroudListApi.h
//  ptOS
//
//  Created by 周瑞 on 16/9/22.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseNetApi.h"

@interface FX_GroudListApi : BaseNetApi

- (id)initWithPage:(NSString *)page;

- (NSArray *)getGroudList;

@end
