//
//  PT_MsgListApi.h
//  ptOS
//
//  Created by 周瑞 on 16/9/23.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseNetApi.h"
#import "PT_MsgListModel.h"
@interface PT_MsgListApi : BaseNetApi

- (id) initWithPage:(NSString *)page;

- (NSArray *)getMsgList;

@end
