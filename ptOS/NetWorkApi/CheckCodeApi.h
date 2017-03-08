//
//  CheckCodeApi.h
//  ptOS
//
//  Created by 周瑞 on 16/9/26.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseNetApi.h"

@interface CheckCodeApi : BaseNetApi

- (id)initWithPhone:(NSString *)phone withSessionId:(NSString *)sessionId withCode:(NSString *)code;


@end
