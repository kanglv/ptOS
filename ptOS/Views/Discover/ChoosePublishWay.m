//
//  ChoosePublishWay.m
//  ptOS
//
//  Created by 吕康 on 17/2/19.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "ChoosePublishWay.h"

@implementation ChoosePublishWay

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (instancetype)initWithFrame:(CGRect)frame withString:(NSString *)string
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"choosePublishWay" owner:nil options:nil] lastObject];
    if (self) {
        [self setFrame:frame];
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3];
        
        
    }
    return self;
}


@end
