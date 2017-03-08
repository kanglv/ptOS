//
//  ControlUtil.m
//  lxt
//
//  Created by xhw on 15/12/15.
//  Copyright © 2015年 SM. All rights reserved.
//

#import "ControlUtil.h"
#import "UIImage+UIImageScale.h"

@implementation ControlUtil

+(UILabel *)lableView:(NSString *)text backColor:(UIColor*)back textColor:(UIColor*)front textFont:(UIFont *)font WithFrame:(CGRect)frame textAlignment:(NSTextAlignment)alignment
{
    UILabel *lable = [[UILabel alloc] initWithFrame:frame];
    lable.text = text;
    lable.backgroundColor = back;
    lable.textColor = front;
    lable.font = font;
    lable.textAlignment = alignment;
    return lable;
}

+(UIImageView *)imageView:(NSString *)backImageName WithFrame:(CGRect)frame
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:backImageName];
    return imageView;
}



+ (void)resetLineView:(UIView *)lineView WithFrame:(CGRect)rect
{
    lineView.frame = rect;
    NSArray *array = [lineView subviews];
    if(array.count == 2)
    {
        UIView *topLine = array.firstObject;
        topLine.frame = CGRectMake(0, 0, rect.size.width, 1.0);
        
        UIView *bottomLine = array.lastObject;
        bottomLine.frame = CGRectMake(0, rect.size.height - 1.0, rect.size.width, 1.0);
    }
 }

+ (UIImage *)getZhanweiImageWithSize:(CGSize)size
{
    UIImage *image = [UIImage imageNamed:@"zhanwei"];
    CGSize initSize = CGSizeMake(180.0, 165.0);
    
    CGFloat x = 0.0;
    CGFloat y = 0.0;
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    CGFloat scale = 0.0;
    
    if(size.width/size.height > initSize.width/initSize.height)
    {
        scale = width/initSize.width;
        y = (initSize.height *scale - height)/2.0;
    }
    else
    {
        scale = height/initSize.height;
        x = (initSize.width *scale - width)/2.0;
    }
    
    image = [image scaleToSize:CGSizeMake(initSize.width * scale, initSize.height * scale)];

    image = [image getSubImage:CGRectMake(x, y, width, height)];
    
    return image;
}
//单像素画线
+ (UIView *)lineView1pxWithFrame:(CGRect)rect
{
    UIView *line = [[UIView alloc]initWithFrame:rect];
    [line setBackgroundColor:RGB(0xe7, 0xe7, 0xe7)];
    return line;
}

//电子邮件
+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


//手机号码
+ (BOOL)validatePhone:(NSString *)phone
{
//    /**
//     * 手机号码
//     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     * 联通：130,131,132,152,155,156,185,186
//     * 电信：133,1349,153,180,189
//     */
//    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
//    /**
//     10         * 中国移动：China Mobile
//     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     12         */
//    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
//    /**
//     15         * 中国联通：China Unicom
//     16         * 130,131,132,152,155,156,185,186
//     17         */
//    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
//    /**
//     20         * 中国电信：China Telecom
//     21         * 133,1349,153,180,189
//     22         */
//    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
//    /**
//     25         * 大陆地区固话及小灵通
//     26         * 区号：010,020,021,022,023,024,025,027,028,029
//     27         * 号码：七位或八位
//     28         */
//    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
//    
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//    
//    if (([regextestmobile evaluateWithObject:phone] == YES)
//        || ([regextestcm evaluateWithObject:phone] == YES)
//        || ([regextestct evaluateWithObject:phone] == YES)
//        || ([regextestcu evaluateWithObject:phone] == YES))
//    {
//        if([regextestcm evaluateWithObject:phone] == YES) {
//            
//        } else if([regextestct evaluateWithObject:phone] == YES) {
//            
//        } else if ([regextestcu evaluateWithObject:phone] == YES) {
//            
//        } else {
//            
//        }
//        
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
    
    NSString *phoneNumber = @"^1[3-9]\\d{9}$";
    NSPredicate *regexMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneNumber];
    return [regexMobile evaluateWithObject:phone];
}

//密码
+ (BOOL)validatePWD:(NSString *)pwd
{
    NSString *pwdRegex = @"^[A-Z0-9a-z]{6,16}$";
    NSPredicate *pwdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pwdRegex];
    return [pwdTest evaluateWithObject:pwd];
}


//多像素画线
+ (UIView *)lineWithFrame:(CGRect)rect
{
    CGFloat height = rect.size.height;
    
    UIView *line = [[UIView alloc]initWithFrame:rect];
    [line setBackgroundColor:COLOR_VIEW_BACK];
    
    if(height > 2.01)
    {
        UIColor *tmpColor = RGB(231, 231, 231);
        UIView *top = [[UIView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, 1.0)];
        [top setBackgroundColor:tmpColor];
        [line addSubview:top];
        
        UIView *bottom = [[UIView alloc]initWithFrame:CGRectMake(0, rect.size.height - 1.0, rect.size.width, 1.0)];
        [bottom setBackgroundColor:tmpColor];
        [line addSubview:bottom];
    }
    return line;
}



//
+ (BOOL)validateBankMaster:(NSString *)rname
{
    if(!isValidStr(rname) || rname.length < 2)
    {
        return NO;
    }
    
    NSString *pwdRegex = @"^[\u4e00-\u9fa5\\·]+$";
    NSPredicate *pwdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pwdRegex];
    return [pwdTest evaluateWithObject:rname];
}


//身份证号
+ (BOOL) validateIdNum: (NSString *)idNum
{
    BOOL flag;
    if (idNum.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:idNum];
}

//银行卡号 0正确，1位数不对 2奇偶求和不对
+ (NSInteger)validateBankNum:(NSString*) cardNo
{
    
    NSString *regex2 = @"^(\\d{16}|\\d{19})$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    if(![identityCardPredicate evaluateWithObject:cardNo])
    {
        return 1;
    }
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[cardNo length];
    int lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];
    
    cardNo = [cardNo substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)
        return 0;
    else
        return 2;
}

//用户名
+ (BOOL)validateUserName:(NSString *)userName
{
    NSString *pwdRegex = @"^[A-Z0-9a-z]{5,15}$";
    NSPredicate *pwdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pwdRegex];
    return [pwdTest evaluateWithObject:userName];
}

//是否是金额
+ (BOOL)validateMoney:(NSString *)money
{
    NSString *pwdRegex = @"^[0-9]+(.[0-9]{0,2})?$";
    NSPredicate *pwdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pwdRegex];
    return [pwdTest evaluateWithObject:money];
}

//是否是昵称
+ (BOOL)validateNickName:(NSString *)name
{
    if(!isValidStr(name))
    {
        return NO;
    }
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* data = [name dataUsingEncoding:enc];
    NSInteger length =  [data length];
    if(length >= 4 && length <= 16)
    {
        return YES;
    }
    return NO;
}

//取得内容的高度
+(CGFloat)heightWithContent:(NSString *)content
                   withFont:(UIFont *)font
                  withWidth:(CGFloat)width
{
    // content
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0,width, 0.0)];
    textLabel.numberOfLines = 0;
    textLabel.font = font;
    textLabel.text = content;
    [textLabel sizeToFit];
    
    return textLabel.bounds.size.height + 1.0;
}

//获取内容的宽度
+(CGFloat)widthWithContent:(NSString *)content
                  withFont:(UIFont *)font
                 withHeight:(CGFloat)height
{
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0,0.0, height)];
    textLabel.numberOfLines = 0;
    textLabel.font = font;
    textLabel.text = content;
    [textLabel sizeToFit];
    
    return textLabel.bounds.size.width + 1.0;
}
@end
