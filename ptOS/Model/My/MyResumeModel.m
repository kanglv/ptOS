
//
//  MyResumeModel.m
//  ptOS
//
//  Created by 周瑞 on 16/9/23.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "MyResumeModel.h"

@implementation MyResumeModel

- (instancetype)initWithDic:(NSDictionary *)dict {
    if (self == [super init]) {
        self.name = [dict strForKey:@"name"];
        self.sex = [dict strForKey:@"sex"];
        self.birth = [dict strForKey:@"birth"];
        self.education = [dict strForKey:@"education"];
        self.phone = [dict strForKey:@"phone"];
        self.cardPicFront = [dict strForKey:@"cardPicFront"];
        self.cardPicBack = [dict strForKey:@"cardPicBack"];
        self.educationPic = [dict strForKey:@"educationPic"];
        self.zs1 = [dict strForKey:@"zs1"];
        self.zs2 = [dict strForKey:@"zs2"];
        self.zs3 = [dict strForKey:@"zs3"];
        self.workExp = [dict strForKey:@"workExp"];
        self.skills = [dict strForKey:@"skills"];
    }
    return self;
}

@end
