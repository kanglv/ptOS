//
//  QQLogin.h
//  ptOS
//
//  Created by 周瑞 on 16/9/23.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseNetApi.h"

@interface QQLogin : BaseNetApi

- (id)initWithOpenId:(NSString *)openId;

- (UserInfoModel *)getUserInfo;

@end
