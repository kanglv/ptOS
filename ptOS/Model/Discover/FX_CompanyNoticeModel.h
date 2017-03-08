//
//  FX_CompanyNoticeModel.h
//  ptOS
//
//  Created by 吕康 on 17/3/7.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "BaseModel.h"

@interface FX_CompanyNoticeModel : BaseModel
@property (nonatomic, copy)NSString *tzId;
@property (nonatomic, copy)NSString *isLike;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *imgUrl;
@property (nonatomic, copy)NSString *headerUrl;
@property (nonatomic, copy)NSString *nickName;
@property (nonatomic, copy)NSString *companyName;
@property (nonatomic, copy)NSString *time;
@property (nonatomic, copy)NSString *greatNum;
@property (nonatomic, copy)NSString *commentNum;
@property (nonatomic, copy)NSString *address;
@property (nonatomic, copy)NSString *fileType;
@property (nonatomic, copy)NSString *creatorid;
@property (nonatomic, copy)NSString *userName;
@end
