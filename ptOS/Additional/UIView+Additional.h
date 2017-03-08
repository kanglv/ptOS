//
//  UIView+Additional.h
//  lxt
//
//  Created by xhw on 15/12/17.
//  Copyright © 2015年 SM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Additional)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

- (UIViewController *)viewController;

@end
