//
//  JuBaoViewController.m
//  ptOS
//
//  Created by 周瑞 on 16/9/29.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "JuBaoViewController.h"
#import "UITextView+JKPlaceHolder.h"

@interface JuBaoViewController ()
@property (weak, nonatomic) IBOutlet UIView *upBottomView;
@property (weak, nonatomic) IBOutlet UITextView *textTV;

@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeBtn;
@property (weak, nonatomic) IBOutlet UIButton *fourBtn;
@property (weak, nonatomic) IBOutlet UIButton *otherBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeHeightCons;
@end

@implementation JuBaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.textTV jk_addPlaceHolder:@"说说您想举报什么..."];
    self.widthCons.constant = FITWIDTH(375);
    self.heightCons.constant = 563;
}

- (void)viewWillAppear:(BOOL)animated {
    ZRViewRadius(self.upBottomView, 10);
    ZRViewRadius(self.textTV, 10);
    [super viewWillAppear:animated];
    self.typeHeightCons.constant = 40;
    self.oneBtn.hidden = YES;
    self.twoBtn.hidden = YES;
    self.threeBtn.hidden = YES;
    self.fourBtn.hidden = YES;
    self.otherBtn.hidden = YES;
    
    self.textTV.y = self.upBottomView.y + 40 + 20;
}
- (IBAction)typeAction:(id)sender {
    self.typeHeightCons.constant = 223;
    self.oneBtn.hidden = NO;
    self.twoBtn.hidden = NO;
    self.threeBtn.hidden = NO;
    self.fourBtn.hidden = NO;
    self.otherBtn.hidden = NO;
    self.textTV.y = self.upBottomView.y + 223 + 20;
}
- (IBAction)oneAction:(id)sender {
    self.typeHeightCons.constant = 40;
    self.oneBtn.hidden = YES;
    self.twoBtn.hidden = YES;
    self.threeBtn.hidden = YES;
    self.fourBtn.hidden = YES;
    self.otherBtn.hidden = YES;
    
    self.textTV.y = self.upBottomView.y + 40 + 20;
    [self.typeBtn setTitle:self.oneBtn.titleLabel.text forState:UIControlStateNormal];
}
- (IBAction)twoAction:(id)sender {
    self.typeHeightCons.constant = 40;
    self.oneBtn.hidden = YES;
    self.twoBtn.hidden = YES;
    self.threeBtn.hidden = YES;
    self.fourBtn.hidden = YES;
    self.otherBtn.hidden = YES;
    
    self.textTV.y = self.upBottomView.y + 40 + 20;
    [self.typeBtn setTitle:self.twoBtn.titleLabel.text forState:UIControlStateNormal];
}
- (IBAction)threeAction:(id)sender {
    self.typeHeightCons.constant = 40;
    self.oneBtn.hidden = YES;
    self.twoBtn.hidden = YES;
    self.threeBtn.hidden = YES;
    self.fourBtn.hidden = YES;
    self.otherBtn.hidden = YES;
    
    self.textTV.y = self.upBottomView.y + 40 + 20;
    [self.typeBtn setTitle:self.threeBtn.titleLabel.text forState:UIControlStateNormal];
}
- (IBAction)fourAction:(id)sender {
    self.typeHeightCons.constant = 40;
    self.oneBtn.hidden = YES;
    self.twoBtn.hidden = YES;
    self.threeBtn.hidden = YES;
    self.fourBtn.hidden = YES;
    self.otherBtn.hidden = YES;
    
    self.textTV.y = self.upBottomView.y + 40 + 20;
    [self.typeBtn setTitle:self.fourBtn.titleLabel.text forState:UIControlStateNormal];
}
- (IBAction)fiveAction:(id)sender {
    self.typeHeightCons.constant = 40;
    self.oneBtn.hidden = YES;
    self.twoBtn.hidden = YES;
    self.threeBtn.hidden = YES;
    self.fourBtn.hidden = YES;
    self.otherBtn.hidden = YES;
    
    self.textTV.y = self.upBottomView.y + 40 + 20;
    [self.typeBtn setTitle:self.otherBtn.titleLabel.text forState:UIControlStateNormal];
}
- (IBAction)sureAction:(id)sender {
    if ([self.typeBtn.titleLabel.text isEqualToString:@"请选择举报类型"]) {
        [XHToast showCenterWithText:@"请选择举报类型"];
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"举报成功" message:@"您的举报信息已提交成功，我们会尽快核实！感谢您对平台的支持!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
