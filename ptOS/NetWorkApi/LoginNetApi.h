//
//  LoginNetApi.h
//  ptOS
//
//  Created by 周瑞 on 16/9/19.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseNetApi.h"

@class UserInfoModel;

@interface LoginNetApi : BaseNetApi

- (id)initWithUserName:(NSString *)name withUserPsw:(NSString *)psw;

- (UserInfoModel *)getUserInfo;

@end
