//
//  LaunchView.m
//  ptOS
//
//  Created by 周瑞 on 16/9/18.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "LaunchView.h"

@implementation LaunchView



- (instancetype)init {
    if (self == [super init]) {
        [self initUI];
        [self addview];
    }
    return self;
}

- (void)initUI {
    
    self.imgView = [[UIImageView alloc]init];
    NSArray *gifArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"dengluye2"],
                         [UIImage imageNamed:@"dengluye3"],
                         [UIImage imageNamed:@"dengluye4"],
                         [UIImage imageNamed:@"dengluye5"],nil];
    self.imgView.animationImages = gifArray;
    self.imgView.animationDuration = 1;
    self.imgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.imgView.animationRepeatCount = 0;
    [self addSubview:self.imgView];
}

- (void)addview {
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        //等DidFinished方法结束后,将其添加至window上(不然会检测是否有rootViewController)
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[UIApplication sharedApplication].delegate window] addSubview:self];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self removeFromSuperview];
            });
        });
    }];
}

@end
