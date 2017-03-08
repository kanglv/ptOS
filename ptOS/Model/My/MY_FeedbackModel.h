//
//  MY_FeedbackModel.h
//  ptOS
//
//  Created by 周瑞 on 16/9/23.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseModel.h"

@interface MY_FeedbackModel : BaseModel

@property (nonatomic, copy)NSString *zwId;
@property (nonatomic, copy)NSString *jobName;
@property (nonatomic, copy)NSString *state;
@property (nonatomic, copy)NSString *conpanyName;
@property (nonatomic, copy)NSString *companyImage;
@property (nonatomic, copy)NSString *isZhiZhao;
@property (nonatomic, copy)NSString *time;

@end
