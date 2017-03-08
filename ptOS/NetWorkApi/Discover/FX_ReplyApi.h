//
//  FX_ReplyApi.h
//  ptOS
//
//  Created by 周瑞 on 16/9/22.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseNetApi.h"
#import "ReplyModel.h"
@interface FX_ReplyApi : BaseNetApi

- (id)initWithTzId:(NSString *)tzId withRepliedName:(NSString *)repliedName withContent:(NSString *)content withReplyId:(NSString *)replyId;



@end
