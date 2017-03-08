//
//  QZ_SearchNumApi.h
//  ptOS
//
//  Created by 周瑞 on 16/9/22.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseNetApi.h"
#import "QZ_seachNumModel.h"
@interface QZ_SearchNumApi : BaseNetApi

- (id)initWithKeyword:(NSString *)keyword withCity:(NSString *)city;

- (QZ_seachNumModel *)getSearchNum;

@end
