//
//  WeiXinRegister.h
//  ptOS
//
//  Created by 周瑞 on 16/9/23.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseNetApi.h"

@interface WeiXinRegister : BaseNetApi

- (id)initWithPhone:(NSString *)phone withPassword:(NSString *)psw withOpenId:(NSString *)openId withYzm:(NSString *)yzm;

@end
