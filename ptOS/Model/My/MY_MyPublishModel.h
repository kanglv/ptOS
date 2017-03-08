//
//  MY_MyPublishModel.h
//  ptOS
//
//  Created by 周瑞 on 16/9/23.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseModel.h"

@interface MY_MyPublishModel : BaseModel

@property (nonatomic, copy)NSString *tzId;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *imageUrl;
@property (nonatomic, copy)NSString *address;
@property (nonatomic, copy)NSString *time;
@end
