//
//  WeiXinLogin.m
//  ptOS
//
//  Created by 周瑞 on 16/9/23.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "WeiXinLogin.h"

@implementation WeiXinLogin

{
    NSString *_openId;
}

- (id)initWithOpenId:(NSString *)openId {
    if (self == [super init]) {
        _openId = openId;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"getWXLogin";
}

- (id)requestArgument {
    NSMutableDictionary *argument = [NSMutableDictionary dictionary];
    [argument setCustomString:_openId forKey:@"openId"];
    return argument;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGet;
}

- (UserInfoModel *)getUserInfo {
    NSData *data= [[self responseString] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if(dict)
    {
        NSDictionary *dataDict = [dict objectForKey:@"data"];
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        [userdefault setValue:dataDict[@"phone"] forKey:PhoneKey];
        if(dataDict && [dataDict isKindOfClass:[NSDictionary class]])
        {
            return [[UserInfoModel alloc] initWithDic:dataDict];
        }
    }
    
    return nil;
}

@end
