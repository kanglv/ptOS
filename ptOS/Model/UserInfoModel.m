//
//  UserInfoModel.m
//  ptOS
//
//  Created by 周瑞 on 16/8/30.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

- (id)initWithDic:(NSDictionary *)dict {
    self = [super initWithDic:dict];
    if (self) {
        self.sessionId          = [dict strForKey:@"sessionId"];
        self.phone              = [dict strForKey:@"phone"];
        self.headerImgUrl       = [dict strForKey:@"headerImgUrl"];
        self.userName           = [dict strForKey:@"userName"];
        self.nickName           = [dict strForKey:@"nickName"];
        self.companyName        = [dict strForKey:@"companyName"];
        self.companyImg         = [dict strForKey:@"companyImg"];
        self.isBindQQ           = [dict strForKey:@"isBindQQ"];
        self.isBindWeiXin       = [dict strForKey:@"isBindWeiXin"];
    }
    return self;
}

@end
