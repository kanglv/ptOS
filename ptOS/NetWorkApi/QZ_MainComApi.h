//
//  QZ_MainComApi.h
//  ptOS
//
//  Created by 周瑞 on 16/9/22.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseNetApi.h"
#import "QZ_MainComModel.h"
@interface QZ_MainComApi : BaseNetApi

- (id)initWithCompanyId:(NSString *)companyId;

- (QZ_MainComModel *)getMainCom;
@end
