//
//  FX_PublishTZApi.h
//  ptOS
//
//  Created by 周瑞 on 16/9/22.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseNetApi.h"

@interface FX_PublishTZApi : BaseNetApi

- (id)initWithContent:(NSString *)content withImgUrl:(NSString *)imgUrl withAddress:(NSString *)address withIsQYQ:(NSString *)isQYQ;

@end
