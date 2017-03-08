//
//  FindPswApi.h
//  ptOS
//
//  Created by 周瑞 on 16/9/28.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseNetApi.h"

@interface FindPswApi : BaseNetApi

- (id)initWithPsw:(NSString *)newPsw withPhone:(NSString *)phone;

@end
