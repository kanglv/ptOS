//
//  FX_NoticeListModel.m
//  ptOS
//
//  Created by 吕康 on 17/3/12.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "FX_NoticeListModel.h"

@implementation FX_NoticeListModel

- (instancetype)initWithDic:(NSDictionary *)dict {
    if (self == [super init]) {
        
        self.content = [dict objectForKey:@"content"];
        self.type    = [dict objectForKey:@"type"];
        self.noticeId     = [dict objectForKey:@"id"];
        self.imageUrl   = [dict objectForKey:@"imgUrl"];
        self.createTime = [dict objectForKey:@"createTime"];
        self.title     = [dict objectForKey:@"title"];
    }
    return self;
}

@end
