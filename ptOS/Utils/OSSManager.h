//
//  OSSManager.h
//  lxt
//
//  Created by 周瑞 on 16/7/16.
//  Copyright © 2016年 SM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AliyunOSSiOS/OSSService.h>
#import <AliyunOSSiOS/OSSCompat.h>


typedef void(^OSSBlock)(BOOL isSuccess,UIImage *image);

typedef void(^ProgressBlock)(int64_t has,int64_t total,int64_t will);


@interface OSSManager : NSObject

@property (nonatomic,copy)OSSBlock block;
@property (nonatomic,copy)ProgressBlock progressBlock;

+ (OSSManager *)sharedManager;

//异步上传
- (void)uploadObjectAsyncWithData:(NSData *)data andFileName:(NSString *)name andBDName:(NSString *)bdName andIsSuccess:(OSSBlock)block andProgressBlock:(ProgressBlock)progressBlock;

//异步下载
- (void)downloadObjectAsyncWithFileName:(NSString *)fileName andBDName:(NSString *)bdName andGetImage:(OSSBlock)block;



@end
