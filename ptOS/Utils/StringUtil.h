//
//  StringUtil.h
//  lxt
//
//  Created by xhw on 15/12/23.
//  Copyright © 2015年 SM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringUtil : NSObject

+ (NSString *)libCachePath;

+(NSString*) createMd5Sign:(NSMutableDictionary*)dict;

+(NSString *)ret32bitString;

// 计算字符串的 MD5 值，
+(NSString*)getmd5WithString:(NSString*)string;

//获取appversion
+ (NSString *)getAppVersion;

//unicode解码
+(NSString*)convertUnicodeToString:(NSString*)unicode;

+ (NSString *)formatPhone:(NSString *)phone;

//字符串乘除 不损失精度
+ (NSString *)stringMutiplyWithString:(NSString *)string1 withString:(NSString *)string2;
+ (NSString *)stringDividWithString:(NSString *)string1 withString:(NSString *)string2;

+ (NSInteger)decimalfloatV:(float)floatV;
+ (NSString *)formatSize:(NSInteger)size;

@end
