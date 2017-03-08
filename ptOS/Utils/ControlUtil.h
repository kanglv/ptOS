//
//  ControlUtil.h
//  lxt
//
//  Created by xhw on 15/12/15.
//  Copyright © 2015年 SM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ControlUtil : NSObject

+(UILabel *)lableView:(NSString *)text backColor:(UIColor*)back textColor:(UIColor*)front textFont:(UIFont *)font WithFrame:(CGRect)frame textAlignment:(NSTextAlignment)alignment;

+(UIImageView *)imageView:(NSString *)backImageName WithFrame:(CGRect)frame;


+ (void)resetLineView:(UIView *)lineView WithFrame:(CGRect)rect;

+ (UIImage *)getZhanweiImageWithSize:(CGSize)size;

+ (UIView *)lineWithFrame:(CGRect)rect;
+ (UIView *)lineView1pxWithFrame:(CGRect)rect;
+ (BOOL)validatePhone:(NSString *)phone;
+ (BOOL)validateEmail:(NSString *)email;
+ (BOOL)validatePWD:(NSString *)pwd;
+ (BOOL)validateNickName:(NSString *)name;
+ (BOOL)validateBankMaster:(NSString *)rname;
+ (NSInteger)validateBankNum:(NSString*) cardNo;
+ (BOOL) validateIdNum: (NSString *)idNum;
+ (BOOL)validateUserName:(NSString *)userName;
+ (BOOL)validateMoney:(NSString *)money;

+(CGFloat)heightWithContent:(NSString *)content
                   withFont:(UIFont *)font
                  withWidth:(CGFloat)width;

+(CGFloat)widthWithContent:(NSString *)content
                   withFont:(UIFont *)font
                  withHeight:(CGFloat)height;



@end
