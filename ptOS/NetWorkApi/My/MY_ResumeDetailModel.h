//
//  MY_ResumeDetailModel.h
//  ptOS
//
//  Created by 周瑞 on 16/9/23.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseModel.h"

@interface MY_ResumeDetailModel : BaseModel

@property (nonatomic, copy)NSString *basicInfo;
@property (nonatomic, copy)NSString *certificate;
@property (nonatomic, copy)NSString *workExp;
@property (nonatomic, copy)NSString *skills;

@end
