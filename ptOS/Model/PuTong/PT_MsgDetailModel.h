//
//  PT_MsgDetailModel.h
//  ptOS
//
//  Created by 周瑞 on 16/9/22.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseModel.h"

@interface PT_MsgDetailModel : BaseModel

@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *postTime;
@property (nonatomic, copy)NSString *time;
@property (nonatomic, copy)NSString *address;
@property (nonatomic, copy)NSString *material;
@property (nonatomic, copy)NSString *coordinate;

@end
