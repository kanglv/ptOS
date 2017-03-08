//
//  QZ_seachNumModel.m
//  ptOS
//
//  Created by 周瑞 on 16/9/22.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "QZ_seachNumModel.h"

@implementation QZ_seachNumModel

- (id)initWithDic:(NSDictionary *)dict {
    self = [super initWithDic:dict];
    if (self) {
        self.zwNum = [dict strForKey:@"zwNum"];
        self.gsNum = [dict strForKey:@"gsNum"];
    }
    return self;
}


@end
