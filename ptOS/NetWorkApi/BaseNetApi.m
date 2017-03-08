//
//  BaseNetApi.m
//  lxt
//
//  Created by xhw on 15/12/12.
//  Copyright © 2015年 SM. All rights reserved.
//

#import "BaseNetApi.h"
#import "GlobalData.h"

@interface BaseNetApi ()

@end

@implementation BaseNetApi

- (id)init
{
    self = [super init];
    if(self)
    {
        self.isCorrectResult = NO;
        self.needShowError = YES;
    }
    return self;
}

//统一请求参数，比如tokon等
- (NSMutableDictionary *)getBaseArgument
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    if(isValidStr([GlobalData sharedInstance].selfInfo.sessionId))
    {
        [result setObject:[GlobalData sharedInstance].selfInfo.sessionId forKey:@"sessionId"];
    }
    return result;
}

//统一处理返回结果中的错误类型
- (void)requestCompleteFilter {
    
    //af的json解析有点问题
    NSData *data= [[self responseString] dataUsingEncoding:NSUTF8StringEncoding];
    if(!data)
    {
        return;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSString *result = [dic strForKey:@"success"];
    NSLog(@"%@",result);
    
    if([result isEqualToString:@"2"])
    {
        //sessionId过期,在需要验证session的界面中，实现该代理
       
            [self.sessionDelegate sessionIsExpire:self];
        
    }else if ([result isEqualToString:@"3"]) {
        [UserDefault setObject:@"0" forKey:JLKey];
    }
    else if(![result isEqualToString:@"0"])
    {
        //参数获取失败
        NSString *errInfo = [dic objectForKey:@"message"];
        if(self.needShowError)
        {
            if(isValidStr([StringUtil convertUnicodeToString:errInfo]))
            {
                [SVProgressHUD showImage:nil status:[StringUtil convertUnicodeToString:errInfo]];
            }
        }
    }
    else
    {
        self.isCorrectResult = YES;
    }
}

//统一处理联网错误
- (void)requestFailedFilter {
//    NSError *error  = self.requestOperation.error;
    NSLog(@"请求地址\n%@",[self requestUrl]);
    NSLog(@"请求参数\n%@",[self requestArgument]);
//    NSLog(@"错误结果\n%@",error);
    if(self.needShowError)
    {
        [SVProgressHUD showImage:nil status:@"连接服务器失败,请稍后再试"];
    }
    
    if(self.noNetWorkingDelegate)
    {
        [self.noNetWorkingDelegate noNetWorking];
    }
}

//网络请求开始，转圈
- (void)toggleAccessoriesWillStartCallBack
{
    //    if(self.progressTouchedDelegate)
    //    {
    //        [SVProgressHUD setTouchedDelegate:self.progressTouchedDelegate];
    //        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    //        [SVProgressHUD show];
    //    }
    
    if(self.netLoadingDelegate)
    {
        [self.netLoadingDelegate startLoading];
    }
}

//网络请求结束，停止转圈
- (void)toggleAccessoriesWillStopCallBack
{
    //    if(self.progressTouchedDelegate)
    //    {
    //        [SVProgressHUD setTouchedDelegate:nil];
    //        [SVProgressHUD dismiss];
    //    }
    if(self.netLoadingDelegate)
    {
        [self.netLoadingDelegate stopLoading];
    }
}

@end
