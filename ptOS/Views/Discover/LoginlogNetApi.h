//
//  LoginlogNetApi.h
//  ptOS
//
//  Created by 吕康 on 17/4/5.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "BaseNetApi.h"

@interface LoginlogNetApi : BaseNetApi

- (id)initWithUid:(NSString *)uid withLongtitude:(NSString *)longtitude withLatitude:(NSString *)latitude withAddress:(NSString *)address;

@end
