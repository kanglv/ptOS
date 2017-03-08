//
//  QZ_ComCommentModel.m
//  ptOS
//
//  Created by 周瑞 on 16/9/22.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "QZ_ComCommentModel.h"

@implementation QZ_ComCommentModel
- (id)initWithDic:(NSDictionary *)dict {
    self = [super initWithDic:dict];
    if (self) {
        self.Id = [dict strForKey:@"Id"];
        self.content = [dict strForKey:@"content"];
        self.time = [dict strForKey:@"time"];
        self.userImage = [dict strForKey:@"userImage"];
        self.nickName = [dict strForKey:@"nickName"];
        self.company = [dict strForKey:@"company"];
    }
    return self;
}
@end
