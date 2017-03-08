//
//  screenView.m
//  ptOS
//
//  Created by 吕康 on 17/2/13.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "screenView.h"
#import "JLSliderView.h"

@implementation screenView



- (void)awakeFromNib {
    [super awakeFromNib];
}


- (instancetype)initWithFrame:(CGRect)frame withString:(NSString *)string
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"ScreenView" owner:nil options:nil] lastObject];
    if (self) {
        [self setFrame:frame];
        self.conditionArr = [NSMutableArray arrayWithObjects:@"15", nil];
        
        self.experience = [NSMutableArray arrayWithObjects:@"0",@"0",@"0", nil];
        
        self.educations = [NSMutableArray arrayWithObjects:@"0",@"0",@"0", @"0",@"0",@"0",@"0",nil];
        
        self.jobNatures = [NSMutableArray arrayWithObjects:@"0",@"0",@"0", nil];
        
        self.salary.text = @"(不限)";
        self.sliderView = [[JLSliderView alloc]initWithFrame:CGRectMake(0, 40, self.frame.size.width, 40) sliderType:JLSliderTypeCenter];
        
        [self addSubview:self.sliderView];
        
        
    }
    return self;
}



//选择条件
- (IBAction)btnClicked:(UIButton *)sender {
    
    //点击后背景色改变
    if(sender.selected ){
        //将条件加入数组
        
//        [self.conditionArr removeObject:[NSString stringWithFormat:@"%ld",sender.tag]];
        if(sender.tag <3) {
            [self.experience setObject:@"0" atIndexedSubscript:sender.tag];
        } else if (sender.tag>=3&&sender.tag<10){
            [self.educations setObject:@"0" atIndexedSubscript:sender.tag-3];
        } else {
            [self.jobNatures setObject:@"0" atIndexedSubscript:sender.tag-10];
        }
        
         sender.backgroundColor = [UIColor whiteColor];
        sender.selected = NO;
    } else {
        //将筛选条件移出
//         [self.conditionArr addObject:[NSString stringWithFormat:@"%ld",sender.tag]];
        if(sender.tag <3) {
            [self.experience setObject:@"1" atIndexedSubscript:sender.tag];
        } else if (sender.tag>=3&&sender.tag<10){
            [self.educations setObject:@"1" atIndexedSubscript:sender.tag-3];
        } else {
            [self.jobNatures setObject:@"1" atIndexedSubscript:sender.tag-10];
        }
         sender.backgroundColor = [UIColor colorWithRed:112/255.0 green:124/255.0 blue:248/255.0 alpha:1];
       
        sender.selected = YES;
    }
}

//确定按钮呗点击
- (IBAction)sureBtnClicked:(id)sender {
    
    NSLog(@"1111hhhhhhh");
    NSLog(@"%@",self.conditionArr);
    //需要将所选条件拼接完整，具体看服务端借口规则
    [GlobalData sharedInstance].experience = [self.experience componentsJoinedByString:@","];

    [GlobalData sharedInstance].educations = [self.educations componentsJoinedByString:@","];
    
    [GlobalData sharedInstance].jobNatures = [self.jobNatures componentsJoinedByString:@","];
    
 
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.conditionArr,@"0", nil];
    //发一个通知，提示
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sure" object:self userInfo:conditionDic];
    
    
}


@end
