//
//  QZ_CompanyDetailView1.m
//  ptOS
//
//  Created by 周瑞 on 16/9/8.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "QZ_CompanyDetailView1.h"

@implementation QZ_CompanyDetailView1

- (void)awakeFromNib {
    [super awakeFromNib];
    ZRViewRadius(self.bottomView1, 10);
    ZRViewRadius(self.bottomView2, 10);
    ZRViewRadius(self.bottomView3, 10);
    ZRViewRadius(self.bottomView4, 10);
    

    ZRViewRadius(self.headerImageView, 15);
    
    ZRViewBorderRadius(self.seeAllBtn,  1, [UIColor redColor]);
    ZRViewRadius(self.seeAllBtn, 5);
    
    [self.attentionBtn setImage:[UIImage imageNamed:@"icon_guanzhu_press"] forState:UIControlStateSelected];
    [self.attentionBtn setImage:[UIImage imageNamed:@"icon_guanzhu"] forState:UIControlStateNormal];
    //            self.detailView1.attentionBtn.userInteractionEnabled = NO;
//    [self.attentionBtn setImage:[UIImage imageNamed:@"icon_guanzhu_press"] forState:UIControlStateSelected];
    //            self.detailView2.attentionBtn.userInteractionEnabled = NO;

}

- (void)setCornerOnLetf:(UIView *)view
{
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                     byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerTopLeft)
                                           cornerRadii:CGSizeMake(15.0f, 15.0f)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

- (void)setCornerOnRight:(UIView *)view
{
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                     byRoundingCorners:(UIRectCornerBottomRight | UIRectCornerTopRight)
                                           cornerRadii:CGSizeMake(15.0f, 15.0f)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}


@end
