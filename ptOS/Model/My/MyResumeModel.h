//
//  MyResumeModel.h
//  ptOS
//
//  Created by 周瑞 on 16/9/23.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseModel.h"

@interface MyResumeModel : BaseModel


@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *sex;
@property (nonatomic, copy)NSString *birth;
@property (nonatomic, copy)NSString *education;
@property (nonatomic, copy)NSString *phone;
@property (nonatomic, copy)NSString *cardPicFront;
@property (nonatomic, copy)NSString *cardPicBack;
@property (nonatomic, copy)NSString *educationPic;
@property (nonatomic, copy)NSString *zs1;
@property (nonatomic, copy)NSString *zs2;
@property (nonatomic, copy)NSString *zs3;
@property (nonatomic, copy)NSString *workExp;
@property (nonatomic, copy)NSString *skills;

@end
