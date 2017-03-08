//
//  UIViewController+Additional.m
//  lxt
//
//  Created by xhw on 15/12/31.
//  Copyright © 2015年 SM. All rights reserved.
//

#import "UIViewController+Additional.h"

@implementation UIViewController (Additional)

- (void)removeFromNavigationController
{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    id controller = nil;
    for(id ctrl in arr)
    {
        if(ctrl == self)
        {
            controller = ctrl;
            break;
        }
    }
    
    if (controller) {
        [arr removeObject:controller];
    }
    
    self.navigationController.viewControllers = arr;
}

@end
