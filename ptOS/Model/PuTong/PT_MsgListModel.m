
//
//  PT_MsgListModel.m
//  ptOS
//
//  Created by 周瑞 on 16/9/22.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "PT_MsgListModel.h"

@implementation PT_MsgListModel

- (id)initWithDic:(NSDictionary *)dict {
    self = [super initWithDic:dict];
    if (self) {
        self.messageId          = [dict strForKey:@"messageId"];
        self.title              = [dict strForKey:@"title"];
        self.type       = [dict strForKey:@"type"];
        self.content           = [dict strForKey:@"content"];
        self.companyName        = [dict strForKey:@"companyName"];
        self.time         = [dict strForKey:@"time"];
        self.hint           = [dict strForKey:@"hint"];
        self.zwName       = [dict strForKey:@"zwName"];
    }
    return self;
}

@end
