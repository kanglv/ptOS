//
//  FX_ComListModel.h
//  ptOS
//
//  Created by 周瑞 on 16/9/22.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseModel.h"

@interface FX_ComListModel : BaseModel

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

@end
