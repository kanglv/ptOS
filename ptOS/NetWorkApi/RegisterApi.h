//
//  RegisterApi.h
//  ptOS
//
//  Created by 周瑞 on 16/9/23.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseNetApi.h"

@interface RegisterApi : BaseNetApi

- (id)initWithPhone:(NSString *)phone withPsw:(NSString *)password;

@end
