//
//  PT_MsgNumApi.h
//  ptOS
//
//  Created by 周瑞 on 16/9/23.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseNetApi.h"
#import "PT_MsgNumModel.h"
@interface PT_MsgNumApi : BaseNetApi

- (instancetype)init;

- (PT_MsgNumModel *)getMsgNumModel;

@end
