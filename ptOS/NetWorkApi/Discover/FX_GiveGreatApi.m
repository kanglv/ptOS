//
//  FX_GiveGreatApi.m
//  ptOS
//
//  Created by 周瑞 on 16/9/22.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "FX_GiveGreatApi.h"

@implementation FX_GiveGreatApi

{
    NSString *_tzId;
}
- (id)initWithtzId:(NSString *)tzId{
    self = [super init];
    if (self) {
        _tzId = tzId;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"postLike";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
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
    [argument setCustomString:_tzId forKey:@"tzId"];
    return argument;
}


@end
