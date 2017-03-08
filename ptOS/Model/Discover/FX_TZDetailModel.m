//
//  FX_TZDetailModel.m
//  ptOS
//
//  Created by 周瑞 on 16/9/22.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "FX_TZDetailModel.h"

@implementation FX_TZDetailModel

- (instancetype)initWithDic:(NSDictionary *)dict {
    if (self == [super init]) {
//        self.replyName = [dict strForKey:@"replyName"];
//        self.repliedName = [dict strForKey:@"repliedName"];
//        self.replyContent = [dict strForKey:@"replyContent"];
//        self.relplyTime = [dict strForKey:@"time"];
//        self.replyId = [dict strForKey:@"replyId"];
        self.isLike = [dict objectForKey:@"isLike"];
        self.content = [dict objectForKey:@"content"];
        self.imgUrl = [dict objectForKey:@"imgUrl"];
        self.headerUrl = [dict objectForKey:@"headerUrl"];
        self.nickName = [dict objectForKey:@"nickName"];
        self.companyName = [dict objectForKey:@"companyName"];
        self.time = [dict objectForKey:@"time"];
        self.greatPeople = [dict objectForKey:@"greatPeople"];
        self.address = [dict objectForKey:@"address"];
        self.replyList = [dict objectForKey:@"commentList"];
    }
    return self;
}

@end
