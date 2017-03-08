//
//  GetUserInfoApi.h
//  ptOS
//
//  Created by 周瑞 on 16/9/23.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseNetApi.h"
#import "UserInfoModel.h"
@interface GetUserInfoApi : BaseNetApi

- (UserInfoModel *)getUserInfo;

@end
