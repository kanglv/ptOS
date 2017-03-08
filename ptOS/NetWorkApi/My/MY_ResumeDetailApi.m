

//
//  MY_ResumeDetailApi.m
//  ptOS
//
//  Created by 周瑞 on 16/9/23.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "MY_ResumeDetailApi.h"

@implementation MY_ResumeDetailApi

- (NSString *)requestUrl {
    return @"getMyResumeGK";
}

- (id)requestArgument {
    NSMutableDictionary *argument = nil;
    if(self.sessionDelegate)
    {
        argument = [self getBaseArgument];
    }
    else
    {
        argument = [self getBaseArgument];
    }
    return argument;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGet;
}

- (MY_ResumeDetailModel *)getResumeDetail {
    NSData *data= [[self responseString] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if(dict)
    {
        NSDictionary *dataDict = [dict objectForKey:@"data"];
        if(dataDict && [dataDict isKindOfClass:[NSDictionary class]])
        {
            MY_ResumeDetailModel *result = [[MY_ResumeDetailModel alloc] initWithDic:dataDict];
            
            return result;
        }
    }
    return nil;
}

@end
