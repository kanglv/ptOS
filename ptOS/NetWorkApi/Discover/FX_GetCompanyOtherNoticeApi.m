//
//  FX_GetCompanyOtherNoticeApi.m
//  ptOS
//
//  Created by 吕康 on 17/3/7.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "FX_GetCompanyOtherNoticeApi.h"

@implementation FX_GetCompanyOtherNoticeApi
{
    NSString *_page;
    NSString *_sessionId;
    NSString *_type;
    
}


- (id)initWithPage:(NSString *)page withSessionId:(NSString *)sessionId withType:(NSString *)type  {
    if (self == [super init]) {
        _page = page;
        _sessionId = sessionId;
        _type = type;
}
    return self;
}

- (NSString *)requestUrl {
    return @"getCompanyOtherNotice";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGet;
}

- (id)requestArgument {
    NSMutableDictionary *argument = [self getBaseArgument];
    
    [argument setCustomString:_page forKey:@"page"];
    [argument setCustomString:_sessionId forKey:@"sessionId"];
    [argument setCustomString:_type forKey:@"type"];
    
    return argument;
}

- (NSArray *)getCompanyOtherNotice {
    NSData *data= [[self responseString] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if(dict)
    {
        NSDictionary *dataDict = [dict objectForKey:@"data"];
        NSLog(@"%@",dataDict);
        if(dataDict && [dataDict isKindOfClass:[NSDictionary class]])
        {
            NSArray *array = [dataDict objectForKey:@"dataList"];
            NSMutableArray *result = [NSMutableArray array];
            NSLog(@"%@",array);
            
            return result;
        }
    }
    return nil;
}

@end
