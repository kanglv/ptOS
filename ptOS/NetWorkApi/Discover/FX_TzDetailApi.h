//
//  FX_TzDetailApi.h
//  ptOS
//
//  Created by 周瑞 on 16/9/22.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseNetApi.h"
#import "FX_TZDetailModel.h"
@interface FX_TzDetailApi : BaseNetApi
- (id)initWithtzId:(NSString *)tzId;

- (FX_TZDetailModel *)getTzDetail;
@end
