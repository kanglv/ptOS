//
//  CommentLabel.h
//  ptOS
//
//  Created by 周瑞 on 16/10/8.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseView.h"

#import <Foundation/Foundation.h>

@interface CommentLabel : BaseView

- (id)initWithArray:(NSArray *)array;

- (CGFloat) getHeightWithArray:(NSArray *)array;

@end
