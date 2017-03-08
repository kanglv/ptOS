//
//  MY_MyCommentModel.m
//  ptOS
//
//  Created by 周瑞 on 16/9/23.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "MY_MyCommentModel.h"

@implementation MY_MyCommentModel

- (instancetype)initWithDic:(NSDictionary *)dict {
    if (self == [super init]) {
        self.tzId = [dict strForKey:@"tzId"];
        self.content = [dict strForKey:@"content"];
        self.imageUrl = [dict strForKey:@"imgUrl"];
        self.companyName = [dict strForKey:@"companyName"];
        self.headerImageUrl = [dict strForKey:@"headerImageUrl"];
        self.time = [dict strForKey:@"time"];
        self.nickName = [dict strForKey:@"nickName"];
        self.replyList = [dict objectForKey:@"replyList"];
    }
    return self;
}

@end
