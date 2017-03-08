//
//  MY_MyPublishModel.m
//  ptOS
//
//  Created by 周瑞 on 16/9/23.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "MY_MyPublishModel.h"

@implementation MY_MyPublishModel

- (instancetype)initWithDic:(NSDictionary *)dict {
    if (self == [super init]) {
        self.tzId = [dict strForKey:@"tzId"];
        self.content = [dict strForKey:@"content"];
        self.imageUrl = [dict strForKey:@"imgUrl"];
        self.address = [dict strForKey:@"address"];
        self.time = [dict strForKey:@"time"];
    }
    return self;
}


@end
