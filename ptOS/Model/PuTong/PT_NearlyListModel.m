//
//  PT_NearlyListModel.m
//  ptOS
//
//  Created by 吕康 on 17/3/6.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "PT_NearlyListModel.h"

@implementation PT_NearlyListModel



- (id)initWithDic:(NSDictionary *)dict {
    self = [super initWithDic:dict];
    if (self) {
        self.companyName = [dict strForKey:@"companyName"];
        self.imId        = [dict strForKey:@"imId"];
        self.objId       = [dict strForKey:@"objId"];
        self.type        = [dict strForKey:@"isAttention"];
        self.isAttention = [dict strForKey:@"isAttention"];
        self.distance    = [dict strForKey:@"distance"];
        self.latitude    = [dict strForKey:@"latitude"];
        self.longitude   = [dict strForKey:@"longitude"];
        self.name        = [dict strForKey:@"name"];
        self.icon        = [dict strForKey:@"icon"];
    }
    return self;
}

@end
