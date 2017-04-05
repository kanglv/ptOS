//
//  MyInfo3ViewController.m
//  ptOS
//
//  Created by 周瑞 on 16/8/31.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "MyInfo3ViewController.h"
#import "MY_PostReumeApi.h"
#import "AFHTTPRequestOperation.h"
#import "AJPhotoPickerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "AJPhotoBrowserViewController.h"
#import "OSSManager.h"
#import "UIButton+WebCache.h"
#import "UITextView+JKSelect.h"
#import "UITextView+JKPlaceHolder.h"
@interface MyInfo3ViewController ()<UITextFieldDelegate,UITextViewDelegate>
{
    BOOL _is1;
    BOOL _is2;
    BOOL _is3;
    NSInteger n;
    NSInteger m;
}

@property (nonatomic,strong)MY_PostReumeApi *postResumeApi;

@property (weak, nonatomic) IBOutlet UITextView *workExpTV;



@end

@implementation MyInfo3ViewController

#pragma mark - lifeCycles

- (void)viewDidLoad {
    [super viewDidLoad];
   

    [self.navigationItem setTitle:@"技能情况"];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake(0, 0, 60, 40)];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    if([[GlobalData sharedInstance].jl_skills isEqualToString:@""] ){
        [self.workExpTV jk_addPlaceHolder:@"  记得保存哦"];
    } else{
        self.workExpTV.text = [GlobalData sharedInstance].jl_skills;
    }
  
    [NotificationCenter addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:nil];
    
}


//监听输入变化
- (void)textChange {
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    

}

- (void)dealloc {
    [NotificationCenter removeObserver:self];
}

#pragma mark - customFuncs
- (void)next {
    [GlobalData sharedInstance].jl_skills = self.workExpTV.text;
    [XHToast showCenterWithText:@"保存成功"];
}




#pragma mark - lazyViews

@end
