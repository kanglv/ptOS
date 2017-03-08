//
//  QZ_JobDetailModel.m
//  ptOS
//
//  Created by 周瑞 on 16/9/21.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "QZ_JobDetailModel.h"

@implementation QZ_JobDetailModel

- (id)initWithDic:(NSDictionary *)dict {
    self = [super initWithDic:dict];
    if (self) {
        self.isYBM           = [dict strForKey:@"isYBM"];
        self.isCollect         = [dict strForKey:@"isCollect"];
        self.zwName           = [dict strForKey:@"zwName"];
        self.collectNum         = [dict strForKey:@"collectNum"];
        self.salary         = [dict strForKey:@"salary"];
        self.isXZRZ           = [dict strForKey:@"isXZRZ"];
        self.fuli      = [dict strForKey:@"fuli"];
        self.education            = [dict strForKey:@"education"];
        self.gzxz            = [dict strForKey:@"gzxz"];
        self.sex           = [dict strForKey:@"sex"];
        self.gzjy         = [dict strForKey:@"gzjy"];
        self.age           = [dict strForKey:@"age"];
        self.qtyq         = [dict strForKey:@"qtyq"];
        self.zxsj         = [dict strForKey:@"zxsj"];
        self.companyName           = [dict strForKey:@"companyName"];
        self.companyId      = [dict strForKey:@"companyId"];
        self.city            = [dict strForKey:@"city"];
        self.zprs            = [dict strForKey:@"zprs"];
        self.ybm           = [dict strForKey:@"ybm"];
        self.zwms         = [dict strForKey:@"zwms"];
        self.gsxz           = [dict strForKey:@"gsxz"];
        self.companyImage         = [dict strForKey:@"companyImage"];
        self.isZZ         = [dict strForKey:@"isZZ"];
        self.address           = [dict strForKey:@"address"];
        self.coordinate      = [dict strForKey:@"coordinate"];
        self.isZP = [dict strForKey:@"isZP"];
    }
    return self;
}

@end
