//
//  GlobalData.m
//  ptOS
//
//  Created by 周瑞 on 16/8/30.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "GlobalData.h"

@implementation GlobalData

static GlobalData *shareObj = nil;

+ (GlobalData *)sharedInstance {
    if (shareObj == nil) {
        shareObj = [[self alloc]init];
    }
    return shareObj;
}

@end
