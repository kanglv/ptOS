//
//  DiscoverLabel.h
//  ptOS
//
//  Created by 周瑞 on 16/9/27.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseView.h"

#import <Foundation/Foundation.h>

@protocol ReplyDelegate <NSObject>

- (void)replyWithId:(NSString *)Id withRepliedName:(NSString *)name;

@end

@interface DiscoverLabel : BaseView



- (id)initWithArray:(NSArray *)array;

- (CGFloat) getHeightWithArray:(NSArray *)array;

@property (nonatomic,weak)id<ReplyDelegate> delegate;

@end
