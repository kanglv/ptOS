//
//  ConcernJobModel.h
//  ptOS
//
//  Created by 吕康 on 17/3/4.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "BaseModel.h"

@interface ConcernJobModel : BaseModel

@property (nonatomic, copy)NSString *jobId;
@property (nonatomic, copy)NSString *zwName;
@property (nonatomic, copy)NSString *companyName;
@property (nonatomic, copy)NSString *companyId;
@property (nonatomic, copy)NSString *companyImage;
@property (nonatomic, copy)NSString *isZP;
@property (nonatomic ,copy)NSString *isZZ;

@end
