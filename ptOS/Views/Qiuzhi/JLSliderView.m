//
//  JLSliderView.m
//  WQHCarJob
//
//  Created by job on 16/12/5.
//  Copyright © 2016年 job. All rights reserved.
//

#import "JLSliderView.h"
#import "UIView+Frame.h"
#import "JLSliderMoveView.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#define iconwidth   30
#define iconheight  15
@interface JLSliderView()<SlidMoveDelegate>

@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) JLSliderMoveView *moveView;
@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UILabel *leftTopLabel;
@property (strong, nonatomic) UILabel *rightTopLabel;


@property (assign, nonatomic) CGFloat moveVHeight;

@property (assign, nonatomic) CGFloat lineVHeight;

@property (assign, nonatomic, readwrite) NSUInteger currentMinValue;

@property (assign, nonatomic, readwrite) NSUInteger currentMaxValue;
@end

@implementation JLSliderView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initView];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame sliderType:(JLSliderType )type {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initView];
        self.sliderType = type;
    }
    return self;
}



-(void)initView {
    self.moveVHeight = 20; //圆形label大小
    self.lineVHeight = 5;
    self.userInteractionEnabled = YES;
    self.minValue = 1;
    self.maxValue = 10;
    self.currentMinValue = 1;
    self.currentMaxValue = 10;
    [self initMoveView];
    //顶部左边脚标
    self.leftTopLabel = [self  creatLabelWithFrame:CGRectMake(self.lineView.left - iconwidth/2 , 0, iconwidth, iconheight)];
    self.leftTopLabel.text = [NSString stringWithFormat:@"%luk", (unsigned long)self.minValue];
    [self addSubview:self.leftTopLabel];
    //顶部右边脚标
    self.rightTopLabel = [self  creatLabelWithFrame:CGRectMake(self.lineView.right - iconwidth/2 , 0, iconwidth, iconheight)];
    self.rightTopLabel.text = [NSString stringWithFormat:@"%luk", (unsigned long)self.maxValue];
    [self addSubview:self.rightTopLabel];
    
   
}

-(UILabel *)creatLabelWithFrame:(CGRect )frame {
    UILabel *label =  [[UILabel alloc]initWithFrame:frame];
    label.textColor = [UIColor blueColor];
    label.font      = [UIFont systemFontOfSize:15];
    label.layer.cornerRadius = 5;
    label.layer.masksToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    return  label;
}





-(void)initMoveView {
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(30, iconheight +self.moveVHeight/2 + 5, self.frame.size.width - 60, self.lineVHeight)];
    self.bgView.backgroundColor = [UIColor lightGrayColor];
    self.bgView.layer.cornerRadius = self.bgView.height/2                                                            ;
    self.bgView.layer.masksToBounds = YES;
    self.bgView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.bgView];
    //改变颜色的线
   
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(30, iconheight +self.moveVHeight/2 + 5, self.frame.size.width - 60, self.lineVHeight)];
    self.lineView.backgroundColor = [UIColor blueColor];
    self.lineView.layer.cornerRadius = self.lineView.height/2                                                            ;
    self.lineView.layer.masksToBounds = YES;
    [self addSubview:self.lineView];
    
    //手指移动的视图
    self.moveView = [[JLSliderMoveView alloc]initWithFrame:CGRectMake(self.lineView.left-self.moveVHeight/2 , self.lineView.bottom, self.lineView.width+self.moveVHeight, self.moveVHeight)];
    self.moveView.delegate = self;
    [self addSubview:self.moveView];
}

-(void)setSliderType:(JLSliderType)sliderType {
    if (sliderType == JLSliderTypeCenter) {
        self.moveView.centerY = self.lineView.centerY;
        self.moveView.isRound = YES;
    }else if (sliderType == JLSliderTypeBottom){
        self.moveView.top = self.lineView.bottom+10;
        self.moveView.isRound = NO;
        self.moveView.thumbColor = [UIColor blueColor];
    }
}

-(void)setThumbColor:(UIColor *)thumbColor {
    _thumbColor = thumbColor;
    self.lineView.backgroundColor = thumbColor;
}

-(void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    self.bgView.backgroundColor = bgColor;
}


#pragma mark --- 代理方法
-(void)slidMovedLeft:(CGFloat)leftPosition andRightPosition:(CGFloat)rightPosition {
    self.lineView.x = 30+leftPosition-10;
    self.lineView.width = rightPosition - leftPosition;
    
    self.leftTopLabel.centerX  = leftPosition + 30 -10;
    self.rightTopLabel.centerX = rightPosition + 30 - 10;
    
    NSUInteger width = self.maxValue - self.minValue;
    NSUInteger left  = self.minValue +(int) (self.lineView.x - self.bgView.x)/self.bgView.width * width;
    NSUInteger right  = self.minValue +(int) (self.lineView.right - self.bgView.x)/self.bgView.width * width;
    self.currentMinValue = left;
    self.currentMaxValue = right;
    
    long max = right * 1000;
    long min = left * 1000;
   
    
    self.rightTopLabel.text = [NSString stringWithFormat:@"%luk", (unsigned long)right];
    self.leftTopLabel.text  = [NSString stringWithFormat:@"%luk", (unsigned long)left];
    
    NSString *leftStr ;
    NSString *rightStr;
    NSString *string; //月薪范围label
    if([self.rightTopLabel.text isEqualToString:@"10k"] ){
        rightStr = @"不限";
        [GlobalData sharedInstance].maxSalary = @"10000";
    } else {
        rightStr = self.rightTopLabel.text;
        [GlobalData sharedInstance].maxSalary = [NSString stringWithFormat:@"%ld",max];
    }
    if([self.leftTopLabel.text isEqualToString:@"1k"]){
        leftStr = @"不限";
        [GlobalData sharedInstance].minSalary = @"1000";
    } else {
        leftStr = self.leftTopLabel.text;
        [GlobalData sharedInstance].minSalary = [NSString stringWithFormat:@"%ld",min];
    }
    if([leftStr isEqualToString:@"不限"]&[rightStr isEqualToString:@"不限"]){
        string = @"(不限)";
    } else {
        string = [NSString stringWithFormat:@"(%@-%@)",leftStr,rightStr];
    }
    NSLog(@"%@",string);
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:string,@"0", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"salary" object:self userInfo:dic];
    
    if (self.lineView.width == 0) {
        self.lineView.width = 1;
    }
}

-(void)slidDidEndMovedLeft:(CGFloat)leftPosition andRightPosition:(CGFloat)rightPosition {
    
    if ([self.delegate respondsToSelector:@selector(sliderViewDidSliderLeft:right:)]) {
        [self.delegate sliderViewDidSliderLeft:[self.leftTopLabel.text integerValue] right:[self.rightTopLabel.text integerValue]];
    }
}



@end
