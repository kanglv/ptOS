//
//  FX_CompanyNoticeModel.m
//  ptOS
//
//  Created by 吕康 on 17/3/7.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "FX_CompanyNoticeModel.h"

@implementation FX_CompanyNoticeModel
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
        self.creatorid = [dict strForKey:@"creatorid"];
        self.userName = [dict strForKey:@"userName"];
    }
    return self;
}

@end
