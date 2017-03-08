//
//  NSDictionary+Additional.m
//  ienglish
//
//  Created by xhw on 15/12/10.
//  Copyright © 2015年 JXB. All rights reserved.
//

#import "NSDictionary+Additional.h"

@implementation NSDictionary (Additional)

- (NSString *)strForKey:(NSString *)key
{
    NSString *result = nil;
    if([[self allKeys] containsObject:key])
    {
        result = [self objectForKey:key];
    }
    
    if([result isKindOfClass:[NSString class]] && isValidStr(result))
    {
        return result;
    }
    else if([result isKindOfClass:[NSNumber class]] && !IsNilOrNull(result))
    {
        return [(NSNumber *)result stringValue];
    }
    
    return @"";
}

- (NSNumber *)numForKey:(NSString *)key
{
    NSNumber *result = nil;
    if([[self allKeys] containsObject:key])
    {
        result = [self objectForKey:key];
    }

    if([result isKindOfClass:[NSNumber class]] && !IsNilOrNull(result))
    {
        return result;
    }
    
    return nil;
}

- (NSString *)numForKeyToString:(NSString *)key
{
    NSNumber *num = [self numForKey:key];
    if(IsNilOrNull(num))
    {
        return [num stringValue];
    }
    
    return nil;
}

@end


@implementation NSMutableDictionary (Additional)

- (void)setCustomString:(NSString *)string forKey:(NSString *)aKey
{
    if(isValidStr(string))
    {
        [self setObject:string forKey:aKey];
    }
}

@end