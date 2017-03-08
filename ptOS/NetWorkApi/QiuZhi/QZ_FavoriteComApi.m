
//
//  QZ_FavoriteComApi.m
//  ptOS
//
//  Created by 周瑞 on 16/9/23.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "QZ_FavoriteComApi.h"

@implementation QZ_FavoriteComApi
{
    NSString *_companyId;
}

- (id)initWithCompanyId:(NSString *)companyId {
    if (self == [super init]) {
        _companyId = companyId;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"postFollowGS";
}

- (id)requestArgument {
    NSMutableDictionary *argument = nil;
    if(self.sessionDelegate)
    {
        argument = [self getBaseArgument];
    }
    else
    {
        argument = [self getBaseArgument];
    }
    [argument setCustomString:_companyId forKey:@"companyId"];
    return argument;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}


@end
