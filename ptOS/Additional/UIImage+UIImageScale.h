//
//  UIImage+UIImageScale.h
//  lxt
//
//  Created by xhw on 15/12/23.
//  Copyright © 2015年 SM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImageScale)

-(UIImage*)getSubImage:(CGRect)rect;
-(UIImage*)scaleToSize:(CGSize)size;

@end
