//
//  LoginlogNetApi.m
//  ptOS
//
//  Created by 吕康 on 17/4/5.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "LoginlogNetApi.h"

@implementation LoginlogNetApi
{
    NSString *_uid;
    NSString *_longtitude;
    NSString *_latitude;
    NSString *_address;
   
}

- (id)initWithUid:(NSString *)uid withLongtitude:(NSString *)longtitude withLatitude:(NSString *)latitude withAddress:(NSString *)address{
    if (self == [super init]) {
        _uid = uid;
        _longtitude = longtitude;
        _latitude = latitude;
        _address = address;
    }
    return  self;
}


- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument{
    NSMutableDictionary *argument = nil;
    if(self.sessionDelegate)
    {
        argument = [self getBaseArgument];
    }
    else
    {
        argument = [self getBaseArgument];
    }
    [argument setCustomString:_uid forKey:@"uid"];
    [argument setCustomString:_longtitude forKey:@"longitude"];
    [argument setCustomString:_latitude forKey:@"latitude"];
    [argument setCustomString:_address forKey:@"address"];
    
    return argument;
}


- (NSString *)requestUrl {
    return @"Loginlog";
}

@end
