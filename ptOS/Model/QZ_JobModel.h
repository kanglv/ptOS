//
//  QZ_JobModel.h
//  ptOS
//
//  Created by 周瑞 on 16/9/20.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseModel.h"

@interface QZ_JobModel : BaseModel

@property (nonatomic,copy)NSString *zwId;
@property (nonatomic,copy)NSString *zwName;
@property (nonatomic,copy)NSString *time;
@property (nonatomic,copy)NSString *salary;
@property (nonatomic,copy)NSString *isXZRZ;
@property (nonatomic,copy)NSString *city;
@property (nonatomic,copy)NSString *education;
@property (nonatomic,copy)NSString *sex;
@property (nonatomic,copy)NSString *age;
@property (nonatomic,copy)NSString *company;
@property (nonatomic,copy)NSString *companyImage;
@property (nonatomic,copy)NSString *isZZ;
@property (nonatomic,copy)NSString *distance;

@end
