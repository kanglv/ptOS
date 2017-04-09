//
//  PT_MsgNumModel.m
//  ptOS
//
//  Created by 周瑞 on 16/9/22.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "PT_MsgNumModel.h"

@implementation PT_MsgNumModel

- (id)initWithDic:(NSDictionary *)dict {
    self = [super initWithDic:dict];
    if (self) {
        self.qiuzhiDic          = [dict objectForKey:@"qiuzhi"];
        self.guanzhuDic              = [dict objectForKey:@"guanzhu"];
        self.tongzhiDic       = [dict objectForKey:@"tongzhi"];
    }
    return self;
}

@end
