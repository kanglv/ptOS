//
//  PT_MsgDetailModel.m
//  ptOS
//
//  Created by 周瑞 on 16/9/22.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "PT_MsgDetailModel.h"

@implementation PT_MsgDetailModel

- (id)initWithDic:(NSDictionary *)dict {
    self = [super initWithDic:dict];
    if (self) {
        self.title          = [dict strForKey:@"title"];
        self.content              = [dict strForKey:@"content"];
        self.postTime       = [dict strForKey:@"postTime"];
        self.time           = [dict strForKey:@"time"];
        self.address        = [dict strForKey:@"address"];
        self.material         = [dict strForKey:@"material"];
        self.coordinate           = [dict strForKey:@"coordinate"];
    }
    return self;
}

@end
