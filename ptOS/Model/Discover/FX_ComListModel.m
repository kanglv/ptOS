//
//  FX_ComListModel.m
//  ptOS
//
//  Created by 周瑞 on 16/9/22.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "FX_ComListModel.h"

@implementation FX_ComListModel

- (id)initWithDic:(NSDictionary *)dict {
    if (self == [super initWithDic:dict]) {
        self.tzId = [dict strForKey:@"tzId"];
        self.isLike = [dict strForKey:@"isLike"];
        self.content = [dict strForKey:@"content"];
        self.imgUrl = [dict strForKey:@"imgUrl"];
        self.headerUrl = [dict strForKey:@"headerUrl"];
        self.nickName = [dict strForKey:@"nickName"];
        self.companyName = [dict strForKey:@"companyName"];
        self.time = [dict strForKey:@"time"];
        self.greatNum = [dict strForKey:@"greatNum"];
        self.commentNum = [dict strForKey:@"commentNum"];
        self.address = [dict strForKey:@"address"];
        self.fileType = [dict strForKey:@"fileType"];
    }
    return self;
}

@end
