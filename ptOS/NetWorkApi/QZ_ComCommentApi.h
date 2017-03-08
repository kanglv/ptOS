//
//  QZ_ComCommentApi.h
//  ptOS
//
//  Created by 周瑞 on 16/9/22.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseNetApi.h"
#import "QZ_ComCommentModel.h"
@interface QZ_ComCommentApi : BaseNetApi

- (id)initWithPage:(NSString *)page withCompanyId:(NSString *)companyId;

- (NSArray *)getComComment;
@end
