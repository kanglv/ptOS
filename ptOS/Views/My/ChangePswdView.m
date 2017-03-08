//
//  ChangePswdView.m
//  lxt
//
//  Created by lyyLeo on 15/12/28.
//  Copyright © 2015年 SM. All rights reserved.
//

#import "ChangePswdView.h"
#import "SVProgressHUD.h"
#import "ChangePSWViewController.h"

@interface ChangePswdView()
{
    
    CGFloat _lineHeight;
    CGFloat titleWidth;
    CGFloat cellHeight;
}
@property (nonatomic,strong) UITextField *oriTF;
@property (nonatomic,strong) UITextField *nTF;
@property (nonatomic,strong) UITextField *confirmTF;

@end

@implementation ChangePswdView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    _lineHeight = 6.0;
    titleWidth = 100.0;
    cellHeight = 42.0;
    if (self) {
        CGFloat yOffset = 0.0;
        NSArray *titleArr = @[@"原密码",@"新密码",@"确认新密码"];
        for (int i = 0; i < titleArr.count; i++) {
            if (i == 0) {
                UIView *line1 = [ControlUtil lineWithFrame:CGRectMake(0,
                                                                      yOffset,
                                                                      SCREEN_WIDTH,
                                                                      _lineHeight)];
                [self addSubview:line1];
                yOffset += _lineHeight;
            }
            UIView *cell = [self cellWithTitle:[titleArr objectAtIndex:i]
                                      andFrame:CGRectMake(0,
                                                          yOffset,
                                                          SCREEN_WIDTH,
                                                          cellHeight)
                                        andTag:i];
            [self addSubview:cell];
            yOffset += cellHeight;
            
            UIView *line2 = [ControlUtil lineView1pxWithFrame:CGRectMake(0, yOffset, SCREEN_WIDTH, 1)];
            [self addSubview:line2];
            yOffset += 1.0;
        }
        
        [self.oriTF becomeFirstResponder];
        
        UIButton * saveBtn =[[UIButton alloc] initWithFrame:CGRectMake(cellHeight,
                                                                       yOffset + cellHeight,
                                                                       SCREEN_WIDTH - 2*cellHeight,
                                                                       cellHeight)];
        saveBtn.backgroundColor = MainColor;
        saveBtn.layer.cornerRadius = cellHeight/2.0;
        saveBtn.layer.masksToBounds = YES;
        
        [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [saveBtn addTarget:self action:@selector(savePswd) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:saveBtn];
    }
    return self;
}

-(UIView *) cellWithTitle:(NSString *) _title andFrame:(CGRect) _frame andTag:(int) _tag
{
    UIView * _cell = [[UIView alloc] initWithFrame:_frame];
    _cell.backgroundColor = [UIColor whiteColor];
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
//                                                                    0,
//                                                                    titleWidth,
//                                                                    cellHeight)];
//    titleLabel.text = _title;
//    titleLabel.textColor = [UIColor blackColor];
//    titleLabel.textAlignment = NSTextAlignmentRight;
//    [_cell addSubview:titleLabel];

    
    UITextField * tf = [[UITextField alloc] initWithFrame:CGRectMake(20,
                                                                     (cellHeight - 20.0)/2,
                                                                     SCREEN_WIDTH - 20 - 20,
                                                                     20.0)];
    
    tf.delegate = self;
    tf.textAlignment = NSTextAlignmentLeft;
    tf.secureTextEntry = YES;
    tf.placeholder = _title;
    if (_tag == 0) {
        self.oriTF = tf;
    }
    if (_tag == 1) {
        self.nTF = tf;
    }
    if (_tag == 2) {
        self.confirmTF = tf;
    }
    [_cell addSubview:tf];
    
    return _cell;
}


-(void) savePswd
{
    
    NSString *psw = [UserDefault objectForKey:PswKey];
    if(!isValidStr(self.oriTF.text))
    {
        [SVProgressHUD showImage:nil status:@"请输入原密码"];
        return;
    }
    
    if(!isValidStr(self.nTF.text))
    {
        [SVProgressHUD showImage:nil status:@"请输入新密码"];
        return;
    }
    
    if(![ControlUtil validatePWD:self.nTF.text])
    {
        [SVProgressHUD showImage:nil status:@"密码须为6-16位字母或数字的组合"];
        return;
    }
    
    if(![self.nTF.text isEqualToString:self.confirmTF.text])
    {
        [SVProgressHUD showImage:nil status:@"两次输入的密码不一致"];
        return;
    }
    
    if (![self.oriTF.text isEqualToString:psw]) {
        [SVProgressHUD showImage:nil status:@"原密码不正确"];
        return;
    }
    
    [(ChangePSWViewController *)self.viewController changePwdNet:self.oriTF.text withNPWD:self.nTF.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.oriTF resignFirstResponder];
    [self.nTF resignFirstResponder];
    [self.confirmTF resignFirstResponder];
}
@end
