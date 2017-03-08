//
//  PT_NearlyListModel.h
//  ptOS
//
//  Created by 吕康 on 17/3/6.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "BaseModel.h"

@interface PT_NearlyListModel : BaseModel

@property (nonatomic, copy)NSString *imId;
@property (nonatomic, copy)NSString *objId;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *companyName;
@property (nonatomic, copy)NSString *icon;
@property (nonatomic, copy)NSString *type;
@property (nonatomic, copy)NSString *isAttention;
@property (nonatomic, copy)NSString *distance;
@property (nonatomic, copy)NSString * longitude;
@property (nonatomic, copy)NSString *latitude;

@end
