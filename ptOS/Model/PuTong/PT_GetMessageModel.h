//
//  PT_GetMessageModel.h
//  ptOS
//
//  Created by 吕康 on 17/3/14.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "BaseModel.h"

@interface PT_GetMessageModel : BaseModel
@property (nonatomic, copy)NSString *messageId;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *isRead;
@property (nonatomic, copy)NSString *createTime;
@property (nonatomic, copy)NSString *type;
@property (nonatomic, copy)NSString *useriId;
@property (nonatomic, copy)NSString *targetid;
@property (nonatomic, copy)NSString *status;
@end
