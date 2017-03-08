//
//  PT_MsgNumModel.h
//  ptOS
//
//  Created by 周瑞 on 16/9/22.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseModel.h"

@interface PT_MsgNumModel : BaseModel

@property (nonatomic, copy)NSString *time;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *number;

@end
