//
//  MY_ResumeDetailApi.h
//  ptOS
//
//  Created by 周瑞 on 16/9/23.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseNetApi.h"
#import "MY_ResumeDetailModel.h"
@interface MY_ResumeDetailApi : BaseNetApi

- (MY_ResumeDetailModel *)getResumeDetail;

@end
