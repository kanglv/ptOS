//
//  CommonService.m
//  MobileAssistant
//
//  Created by 房 国生 on 14-9-17.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import "CommonService.h"
#import "AFNetworking.h"

@implementation CommonService

- (void)getNetWorkData:(NSDictionary *)param Successed:(void(^)(id entity)) successed Failed:(void(^)(int errorCode ,NSString *message))failed
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",server,ports] parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSLog(@"%@", responseObject);
        
//        NSError *e;
//        NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&e];
//        
        successed(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSInteger errorCode = error.code;
        NSString *errorMessage = [error localizedDescription];
        
        failed(errorCode,errorMessage);
    }];

}


@end
