//
//  FX_TZDetailModel.h
//  ptOS
//
//  Created by 周瑞 on 16/9/22.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseModel.h"

@interface FX_TZDetailModel : BaseModel

@property (nonatomic, copy)NSString *isLike;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *imgUrl;
@property (nonatomic, copy)NSString *headerUrl;
@property (nonatomic, copy)NSString *nickName;
@property (nonatomic, copy)NSString *companyName;
@property (nonatomic, copy)NSString *time;
@property (nonatomic, copy)NSString *greatPeople;
@property (nonatomic, copy)NSString *address;

@property (nonatomic, strong)NSArray *replyList;

//@property (nonatomic, copy)NSString *replyName;
//@property (nonatomic, copy)NSString *repliedName;
//@property (nonatomic, copy)NSString *replyContent;
//@property (nonatomic, copy)NSString *relplyTime;
//@property (nonatomic, copy)NSString *replyId;

@end
