//
//  NSDictionary+Additional.h
//  ienglish
//
//  Created by xhw on 15/12/10.
//  Copyright © 2015年 JXB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Additional)

- (NSString *)strForKey:(NSString *)key;
- (NSNumber *)numForKey:(NSString *)key;
- (NSString *)numForKeyToString:(NSString *)key;

@end

@interface NSMutableDictionary (Additional)

- (void)setCustomString:(NSString *)string forKey:(NSString *)aKey;

@end