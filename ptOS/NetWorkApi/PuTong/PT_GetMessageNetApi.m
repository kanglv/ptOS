//
//  PT_GetMessageNetApi.m
//  ptOS
//
//  Created by 吕康 on 17/3/14.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "PT_GetMessageNetApi.h"

@implementation PT_GetMessageNetApi
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
    return @"getMessage";
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

- (NSArray *)getMessageList {
    NSData *data= [[self responseString] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if(dict)
    {
        NSDictionary *dataDict = [dict objectForKey:@"data"];
        NSLog(@"%@",dataDict);
        if(dataDict && [dataDict isKindOfClass:[NSDictionary class]])
        {
            NSArray *array = [dataDict objectForKey:@"datalist"];
            
            return array;
        }
    }
    return nil;
}

@end
