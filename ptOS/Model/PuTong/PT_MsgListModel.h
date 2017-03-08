//
//  PT_MsgListModel.h
//  ptOS
//
//  Created by 周瑞 on 16/9/22.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseModel.h"

@interface PT_MsgListModel : BaseModel

@property (nonatomic, copy)NSString *messageId;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *type;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *companyName;
@property (nonatomic, copy)NSString *time;
@property (nonatomic, copy)NSString *hint;
@property (nonatomic, copy)NSString *zwName;

@end
