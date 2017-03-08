//
//  QZ_JobDetailApi.m
//  ptOS
//
//  Created by 周瑞 on 16/9/21.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "QZ_JobDetailApi.h"

@implementation QZ_JobDetailApi
{
    NSString *_zwId;
}

- (id)initWithZWID:(NSString *)zwid {
    self = [super init];
    if (self) {
        _zwId = zwid;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"getZWXQ";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGet;
}

- (id)requestArgument {
    NSMutableDictionary *argument = [NSMutableDictionary new];
    [argument setCustomString:_zwId forKey:@"zwId"];
    return argument;
}

- (QZ_JobDetailModel *)getJobDetail {
    NSData *data= [[self responseString] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if(dict)
    {
        NSDictionary *dataDict = [dict objectForKey:@"data"];
        if(dataDict && [dataDict isKindOfClass:[NSDictionary class]])
        {
            QZ_JobDetailModel *result = [[QZ_JobDetailModel alloc] initWithDic:dataDict];
            
            return result;
        }
    }
    return nil;
}

@end
