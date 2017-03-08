//
//  UserInfoModel.h
//  ptOS
//
//  Created by 周瑞 on 16/8/30.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseModel.h"

@interface UserInfoModel : BaseModel

@property (nonatomic,copy)NSString *sessionId;
@property (nonatomic,copy)NSString *phone;
@property (nonatomic,copy)NSString *psw;
@property (nonatomic, copy) NSString *headerImgUrl;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *companyImg;
@property (nonatomic, copy) NSString *isBindQQ;
@property (nonatomic, copy) NSString *isBindWeiXin;

@end
