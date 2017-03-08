//
//  QZTopTextView.m
//  circle_iphone
//
//  Created by MrYu on 16/8/17.
//  Copyright © 2016年 ctquan. All rights reserved.
//

#import "QZTopTextView.h"
#import "CommonDef.h"

@interface QZTopTextView()
{
    UIButton *_issueBtn;
    UIView *_bgView;
    UITapGestureRecognizer *_tap;
}
@end

@implementation QZTopTextView

+ (instancetype)topTextView
{
    return [[self alloc] init];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, ConvertTo6_H(316)*CT_SCALE_Y);
        // 切换中文九宫格所有数据都对 但是现实会有一个差不多10的间距  加大高度 补足 多的部分键盘挡住 视觉效果没有变
        self.frame = CGRectMake(0, SCREEN_HEIGHT - ConvertTo6_H(110)*CT_SCALE_Y, SCREEN_WIDTH, ConvertTo6_H(110)*CT_SCALE_Y);
        self.lpTextView.scrollsToTop = NO;
        self.backgroundColor = UIColorFromRGB(0xf8f8f8);
        [self makeSubView];
        // 添加键盘监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

#pragma mark - 监听键盘
- (void)keyboardWillAppear:(NSNotification *)notif
{
    if ([self.lpTextView isFirstResponder]) {
        NSDictionary *info = [notif userInfo];
        NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
        //        CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        CGSize keyboardSize = [value CGRectValue].size;
        NSLog(@"keyboardSize.height%f",keyboardSize.height);
        
        // 5s ios10 可能有问题  带验证
        [UIView animateWithDuration:0.25 animations:^{
            if (keyboardSize.height == 292.0 || keyboardSize.height == 282.0) {
                // 适配搜狗输入法 分别在6p  6/5s 高度
                self.y = SCREEN_HEIGHT - keyboardSize.height - ConvertTo6_H(316 - 140)*CT_SCALE_Y + 26.0;
            }else{
                self.y = SCREEN_HEIGHT - keyboardSize.height - ConvertTo6_H(316 - 140)*CT_SCALE_Y ;
            }
            
//            self.y = SCREEN_HEIGHT - keyboardSize.height - ConvertTo6_H(316)*CT_SCALE_Y ;
        }];
        [self.superview addSubview:_bgView];
        [self.superview addSubview:self];
    }
}
- (void)keyboardWillDisappear:(NSNotification *)notif
{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.y = SCREEN_HEIGHT - ConvertTo6_H(120)*CT_SCALE_Y;
    }];
    [_bgView removeFromSuperview];
}

#pragma mark - 非通知调用键盘消失方法
- (void)keyboardWillDisappear
{
    [self.lpTextView resignFirstResponder];
}


-(void)makeSubView
{
    // 输入框
    self.lpTextView.frame = CGRectMake(ConvertTo6_W(30)*CT_SCALE_X, 10, SCREEN_WIDTH - 2 * ConvertTo6_W(30)*CT_SCALE_X - FITWIDTH(40), ConvertTo6_H(70)*CT_SCALE_Y);
    self.lpTextView.placeholderText = @"我也说点什么吧！";
    self.lpTextView.font = [UIFont systemFontOfSize:15];
    self.lpTextView.textColor = UIColorFromRGB(0x333333);
    self.lpTextView.layer.borderWidth = 0.5;
    self.lpTextView.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;
    self.lpTextView.layer.cornerRadius = 2;
    self.lpTextView.clipsToBounds = YES;
    [self addSubview:self.lpTextView];
    
    // @"发布"btn
    _issueBtn = [[UIButton alloc] init];
    _issueBtn.width = ConvertTo6_W(90)*CT_SCALE_X;
    _issueBtn.height = ConvertTo6_H(70)*CT_SCALE_Y;
    _issueBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    // 右边对齐输入框
    _issueBtn.x = self.lpTextView.x + self.lpTextView.width + 3;
    _issueBtn.centerY = self.lpTextView.centerY;
    [_issueBtn setTitle:@"发送" forState:UIControlStateNormal];
    _issueBtn.backgroundColor = UIColorFromRGB(0x00a0ff);
    _issueBtn.layer.cornerRadius = 5;
    _issueBtn.clipsToBounds = YES;
    [_issueBtn addTarget:self action:@selector(issueBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_issueBtn];
    
    // 半透明灰色背景
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _bgView.backgroundColor = UIColorFromRGB(0x000000);
    _bgView.alpha = 0.5;
    
    _tap = [[UITapGestureRecognizer alloc] init];
    [_tap addTarget:self action:@selector(keyboardWillDisappear)];
    [_bgView addGestureRecognizer:_tap];
}

#pragma mark - 点击发布按钮
- (void)issueBtnClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendComment)]) {
        [self.delegate sendComment];
        _lpTextView.text = @"";
    }
}

- (LPlaceholderTextView *)lpTextView
{
    if (!_lpTextView) {
        LPlaceholderTextView *lpTextView=[[LPlaceholderTextView alloc] init];
        _lpTextView = lpTextView;
    }
    return _lpTextView;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_bgView removeGestureRecognizer:_tap];
}
@end
