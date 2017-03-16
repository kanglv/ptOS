//
//  PT_GetMessageModel.m
//  ptOS
//
//  Created by 吕康 on 17/3/14.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "PT_GetMessageModel.h"

@implementation PT_GetMessageModel

- (id)initWithDic:(NSDictionary *)dict {
    self = [super initWithDic:dict];
    if (self) {
        self.messageId          = [dict strForKey:@"id"];
        self.content              = [dict strForKey:@"content"];
        self.title       = [dict strForKey:@"title"];
        self.isRead          = [dict strForKey:@"isRead"];
        self.createTime              = [dict strForKey:@"createTime"];
        self.type      = [dict strForKey:@"type"];
        self.userId              = [dict strForKey:@"userId"];
        self.targetid     = [dict strForKey:@"targetid"];
        self.status = [dict strForKey:@"status"];

    }
    return self;
}
@end
