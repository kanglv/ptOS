//
//  PT_MsgDetailApi.h
//  ptOS
//
//  Created by 周瑞 on 16/9/23.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseNetApi.h"
#import "PT_MsgDetailModel.h"

@interface PT_MsgDetailApi : BaseNetApi

- (id)initWithMsgId:(NSString *)messageId;

- (PT_MsgDetailModel *)getMsgDetail;

@end
