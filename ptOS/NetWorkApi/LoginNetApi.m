//
//  LoginNetApi.m
//  ptOS
//
//  Created by 周瑞 on 16/9/19.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "LoginNetApi.h"
#import "UserInfoModel.h"

@implementation LoginNetApi
{
    NSString *_userName;
    NSString *_userPsw;
}

- (id)initWithUserName:(NSString *)name withUserPsw:(NSString *)psw {
    self = [super init];
    if (self) {
        _userName = name;
        _userPsw = psw;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"postUserLogin";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    NSMutableDictionary *argument = [NSMutableDictionary dictionary];
    
    [argument setCustomString:_userName forKey:@"phone"];
    [argument setCustomString:_userPsw forKey:@"password"];
    
    return argument;
}

- (UserInfoModel *)getUserInfo {
    NSData *data= [[self responseString] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if(dict)
    {
        NSDictionary *dataDict = [dict objectForKey:@"data"];
        NSLog(@"%@",dataDict);
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
