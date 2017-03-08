//
//  QZ_MainComModel.m
//  ptOS
//
//  Created by 周瑞 on 16/9/22.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "QZ_MainComModel.h"

@implementation QZ_MainComModel

- (id)initWithDic:(NSDictionary *)dict {
    self = [super initWithDic:dict];
    if (self) {
        self.isCollect = [dict strForKey:@"isCollect"];
        self.collectNum = [dict strForKey:@"collectNum"];
        self.company = [dict strForKey:@"company"];
        self.gsjs = [dict strForKey:@"gsjs"];
        self.gshj = [dict strForKey:@"gshj"];
        self.gsxz = [dict strForKey:@"gsxz"];
        self.companyImage = [dict strForKey:@"companyImage"];
        self.isZZ = [dict strForKey:@"isZZ"];
        self.address = [dict strForKey:@"address"];
        self.gspj = [dict strForKey:@"gspj"];
        self.coordinate = [dict strForKey:@"coordinate"];
    }
    return self;
}
@end
