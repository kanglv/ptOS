//
//  NewRequestMethod.m
//  ptOS
//
//  Created by 吕康 on 17/4/8.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "NewRequestMethod.h"
#import "AFNetworking.h"
@implementation NewRequestMethod

-(void)requestMethod:(NSString *)string withParm:(NSMutableDictionary *)dic{
    NSMutableDictionary *argument = [NSMutableDictionary dictionary];;
    [argument setCustomString:[GlobalData sharedInstance].selfInfo.userId forKey:@"uid"];
    [argument setCustomString:[GlobalData sharedInstance].longtitude forKey:@"longitude"];
    [argument setCustomString:[GlobalData sharedInstance].latitude forKey:@"latitude"];
    [argument setCustomString:[GlobalData sharedInstance].indexLocation forKey:@"address"];
    
    [dic setValue:argument forKey:@"params"];
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    sessionManager.requestSerializer.timeoutInterval = 3;//设置登录超时为15s
    
    [sessionManager.requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    [sessionManager  POST:@"http://139.196.230.156/ptApp/loginlog" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"hhhhh");
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"fdsfsd");
    }];
    
}
@end
