//
//  FX_TzDetailApi.m
//  ptOS
//
//  Created by 周瑞 on 16/9/22.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "FX_TzDetailApi.h"
@implementation FX_TzDetailApi
{
    NSString *_tzId;
}

- (id)initWithtzId:(NSString *)tzId {
    if (self == [super init]) {
        _tzId = tzId;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"getTZXQ";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGet;
}

- (id)requestArgument {
    NSMutableDictionary *argument = [NSMutableDictionary dictionary];
    [argument setCustomString:_tzId forKey:@"tzId"];
    return argument;
}

- (FX_TZDetailModel *)getTzDetail {
    NSData *data= [[self responseString] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if(dict)
    {
        NSDictionary *dataDict = [dict objectForKey:@"data"];
        if(dataDict && [dataDict isKindOfClass:[NSDictionary class]])
        {
            FX_TZDetailModel *result = [[FX_TZDetailModel alloc] initWithDic:dataDict];
            
            return result;
        }
    }
    return nil;
}
@end
