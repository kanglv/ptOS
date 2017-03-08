//
//  FX_PublishTZApi.m
//  ptOS
//
//  Created by 周瑞 on 16/9/22.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "FX_PublishTZApi.h"

@implementation FX_PublishTZApi
{
    NSString *_content;
    NSString *_imgUrl;
    NSString *_address;
    NSString *_isQYQ;
}

- (id)initWithContent:(NSString *)content withImgUrl:(NSString *)imgUrl withAddress:(NSString *)address withIsQYQ:(NSString *)isQYQ {
    if (self == [super init]) {
        _content = content;
        _imgUrl = imgUrl;
        if (!_imgUrl || [_imgUrl isEqualToString:@""]) {
            _imgUrl = @"";
        }
        _address = address;
        if (!isValidStr(address)) {
            _address = @"未知位置";
        }
        _isQYQ = isQYQ;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"postFB";
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
    
    [argument setCustomString:_content forKey:@"content"];
    [argument setCustomString:_imgUrl forKey:@"imgUrl"];
    [argument setCustomString:_address forKey:@"address"];
    [argument setCustomString:_isQYQ forKey:@"isQYQ"];
    return argument;
}

@end
