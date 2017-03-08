//
//  MY_MyCommentModel.h
//  ptOS
//
//  Created by 周瑞 on 16/9/23.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseModel.h"

@interface MY_MyCommentModel : BaseModel

@property (nonatomic, copy)NSString *tzId;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *imageUrl;
@property (nonatomic, copy)NSString *nickName;
@property (nonatomic, copy)NSString *companyName;
@property (nonatomic, copy)NSString *headerImageUrl;
@property (nonatomic, copy)NSString *time;
@property (nonatomic, strong)NSArray *replyList;

@end
