//
//  WorkExperienceViewController.m
//  ptOS
//
//  Created by 周瑞 on 16/8/31.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "WorkExperienceViewController.h"
#import "UITextView+JKSelect.h"
#import "UITextView+JKPlaceHolder.h"

#import "MY_ExpersTableViewCell.h"
#import "MY_AddExpersTableViewCell.h"
#import "AddWorkExpersViewController.h"

@interface WorkExperienceViewController ()<UITextViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *dataArray;


@end

@implementation WorkExperienceViewController

#pragma mark - lifeCycles

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    self.dataArray =  [NSMutableArray arrayWithArray:[GlobalData sharedInstance].jl_workExp];
    NSLog(@"%@",[self.dataArray objectAtIndex:0]);
     [self.navigationItem setTitle:@"工作经历"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake(0, 0, 60, 40)];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self.textView jk_addPlaceHolder:@"  其他补充描述"];
    
    
    
}

- (void)next {
    [GlobalData sharedInstance].jl_workExp = [NSMutableArray arrayWithArray:self.dataArray];
    
    [XHToast showCenterWithText:@"保存成功"];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == self.dataArray.count){
        static NSString *jobsIdentifier = @"MY_AddExpersTableViewCell";
        MY_AddExpersTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:jobsIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"MY_AddExpersTableViewCell" owner:nil options:nil].lastObject;
        }
        [cell.AddBtn addTarget:self action:@selector(writeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    } else {
        static NSString *jobsIdentifier = @"MY_ExpersTableViewCell";
        MY_ExpersTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:jobsIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"MY_ExpersTableViewCell" owner:nil options:nil].lastObject;
        }
        
        NSMutableDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
        cell.contentLabel.text = [dic objectForKey:@"companyName"];
        NSString *time = [NSString stringWithFormat:@"%@-%@",[dic objectForKey:@"inTime"],[dic objectForKey:@"outTime"]];
        cell.timeLabel.text = time;
        cell.writeBtn.tag = [[dic objectForKey:@"resumeId"] integerValue];
        [cell.writeBtn addTarget:self action:@selector(writeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        return cell;

    }
    return nil;
}


- (void)writeBtnClicked:(UIButton *)sender{
    
     AddWorkExpersViewController *ctr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddWorkExpersViewController"];
    [self.navigationController pushViewController:ctr animated:YES];
    
}

@end
