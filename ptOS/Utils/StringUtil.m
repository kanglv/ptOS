//
//  StringUtil.m
//  lxt
//
//  Created by xhw on 15/12/23.
//  Copyright © 2015年 SM. All rights reserved.
//

#import "StringUtil.h"
#import <CommonCrypto/CommonDigest.h>

@implementation StringUtil

+ (NSString *)libCachePath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"];
}

+ (NSString*)getmd5WithString:(NSString *)string {
    const char* original_str=[string UTF8String];
    unsigned char digist[CC_MD5_DIGEST_LENGTH]; //CC_MD5_DIGEST_LENGTH = 16
    CC_MD5(original_str, (CC_LONG)strlen(original_str), digist);
    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    for(int  i =0; i<CC_MD5_DIGEST_LENGTH;i++){
        [outPutStr appendFormat:@"%02x", digist[i]];// 小写 x 表示输出的是小写 MD5 ，大写 X 表示输出的是大写 MD5
    }
    
    return [outPutStr lowercaseString];
}

+(NSString *)ret32bitString
{
    
    char data[32];
    
    for (int x=0;x<32;data[x++] = (char)('A' + (arc4random_uniform(26))));
    
    return [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
    
}

+(NSString*) createMd5Sign:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
        
    }
    //添加key字段
    [contentString appendFormat:@"key=%@", @"qwertasdfgzxcvbqwertasdfgzxcv881"];
    //得到MD5 sign签名
    NSString *md5Sign =[StringUtil getmd5WithString:contentString];
    
    return md5Sign;
}


#pragma mark 获取appversion
+ (NSString *)getAppVersion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return appVersion;
}


#pragma mark - unicode解码
+(NSString*)convertUnicodeToString:(NSString*)unicode
{
    if(unicode == nil)
        return nil;
    NSString *tempStr1 = [unicode stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListWithData:tempData
                                                                    options:NSPropertyListMutableContainers
                                                                     format:nil
                                                                      error:nil];
    return [returnStr stringByReplacingOccurrencesOfString:@"\r\n" withString:@"n"];
}

+ (NSString *)formatPhone:(NSString *)phone
{
    if (phone.length < 7) {
        return phone;
    }
    else
    {
        NSString *result = @"";
        for(int i = 0 ; i < phone.length ; i++)
        {
            NSString *subStr = [phone substringWithRange:NSMakeRange(i, 1)];
            if(i <= 3 || i >= phone.length -4)
            {
                result = [result stringByAppendingString:subStr];
            }
            else
            {
                result = [result stringByAppendingString:@"*"];
            }
        }
        return result;
    }
}

+ (NSString *)stringMutiplyWithString:(NSString *)string1 withString:(NSString *)string2
{
    NSDecimalNumber *multiplierNumber = [NSDecimalNumber decimalNumberWithString:string1];
    NSDecimalNumber *multiplicandNumber = [NSDecimalNumber decimalNumberWithString:string2];
    NSDecimalNumber *product = [multiplicandNumber decimalNumberByMultiplyingBy:multiplierNumber];
    return [product stringValue];
}

+ (NSString *)stringDividWithString:(NSString *)string1 withString:(NSString *)string2
{
    NSDecimalNumber *multiplierNumber = [NSDecimalNumber decimalNumberWithString:string1];
    NSDecimalNumber *multiplicandNumber = [NSDecimalNumber decimalNumberWithString:string2];
    NSDecimalNumber *product = [multiplierNumber decimalNumberByDividingBy:multiplicandNumber];
    return [product stringValue];
}

//格式话小数 四舍五入类型
+ (NSInteger)decimalfloatV:(float)floatV
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setPositiveFormat:@"0"];
    
    NSString *string = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
    
    return [string integerValue];
}

+ (NSString *)formatSize:(NSInteger)size
{
    if(size == 0)
    {
        return @"0K";
    }
    else if(size < 1000)
    {
        return [NSString stringWithFormat:@"%ldB",size];
    }
    else if(size < 1000000)
    {
        return [NSString stringWithFormat:@"%ldK",size/1000];
    }
    else
    {
        return [NSString stringWithFormat:@"%ldM",size/1000000];
    }
}
@end
