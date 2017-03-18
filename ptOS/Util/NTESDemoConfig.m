//
//  NTESDemoConfig.m
//  NIM
//
//  Created by amao on 4/21/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "NTESDemoConfig.h"

@interface NTESDemoConfig ()

@end

@implementation NTESDemoConfig
+ (instancetype)sharedConfig
{
    static NTESDemoConfig *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NTESDemoConfig alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
//        _appKey = @"f627f3c01e1304793b7dd6972ae4a92e";
        _apiURL = @"https://app.netease.im/api";
        _cerName= @"zhengshu";
        _appKey = @"d4cb991c5d421c11da3019feda601b64";
    }
    return self;
}

- (NSString *)appKey
{
    return _appKey;
}

- (NSString *)apiURL
{
    NSAssert([[NIMSDK sharedSDK] isUsingDemoAppKey], @"只有 demo appKey 才能够使用这个API接口");
    return _apiURL;
}

- (NSString *)cerName
{
    return _cerName;
}


@end
