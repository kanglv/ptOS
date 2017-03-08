//
//  KeyChainStore.h
//  lxt
//
//  Created by xhw on 16/5/10.
//  Copyright © 2016年 SM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainStore : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)deleteKeyData:(NSString *)service;

@end
