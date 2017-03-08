

//
//  GetCodeApi.m
//  ptOS
//
//  Created by 周瑞 on 16/9/23.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "GetConcernCompany.h"

@implementation GetConcernCompany
{
    NSString *_sessionId;
    NSString *_page;
}

- (id)initWithSessionId:(NSString *)sessionId andWithPage:(NSString *)page {
    if (self == [super init]) {
        _sessionId = sessionId;
        _page      = page;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"getGzgs";
}

- (id)requestArgument {
    NSMutableDictionary *argument = [NSMutableDictionary dictionary];
    [argument setCustomString:_sessionId forKey:@"sessionId"];
    [argument setCustomString:_page forKey:@"page"];
    return argument;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGet;
}

- (NSArray*)getCompanyList {
    NSData *data= [[self responseString] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if(dict)
    {
        NSArray *array = [dict objectForKey:@"data"];
        NSLog(@"%@",[[array objectAtIndex:0] objectForKey:@"company"]);
        return array;
    }
    return nil;
}

@end
