//
//  PT_NearlyListApi.m
//  ptOS
//
//  Created by 吕康 on 17/3/6.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "PT_NearlyListApi.h"


@implementation PT_NearlyListApi{
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
    return @"nearlylist";
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

- (NSArray*)getNearlyList {
    NSData *data= [[self responseString] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if(dict)
    {
        NSDictionary *dataDict = [dict objectForKey:@"data"];
        NSLog(@"%@",dataDict);
        if([[dataDict objectForKey:@"datalist"] isKindOfClass:[NSNull class]]){
            
        }
        
        if(dataDict && [dataDict isKindOfClass:[NSDictionary class]])
        {
            if([[dataDict objectForKey:@"datalist"] isKindOfClass:[NSArray class]]){
                 return [dataDict objectForKey:@"datalist"];
            } else{
                NSArray *array = [[NSArray alloc]init];
                return array;
            }
        }
    }
    return nil;
}


@end
