//
//  QZ_MainComApi.m
//  ptOS
//
//  Created by 周瑞 on 16/9/22.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "QZ_MainComApi.h"

@implementation QZ_MainComApi
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
    return @"getQYJS";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGet;
}

- (id)requestArgument {
    NSMutableDictionary *argument = [self getBaseArgument];
    
    [argument setCustomString:_companyId forKey:@"companyId"];
    return argument;
}

- (QZ_MainComModel *)getMainCom {
    NSData *data= [[self responseString] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if(dict)
    {
        NSDictionary *dataDict = [dict objectForKey:@"data"];
        if(dataDict && [dataDict isKindOfClass:[NSDictionary class]])
        {
            QZ_MainComModel *result = [[QZ_MainComModel alloc] initWithDic:dataDict];
            
            return result;
        }
    }
    return nil;
}


@end
