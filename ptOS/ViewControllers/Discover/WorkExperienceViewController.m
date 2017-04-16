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
    
//    [self.tableView setFrame:CGRectMake(0, 10, self.view.frame.size.width, 50*(self.dataArray.count+1))];
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
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addWorkExp:) name:@"workExp" object:nil];
    

}

- (void)next {
    [GlobalData sharedInstance].jl_workExp = [NSMutableArray arrayWithArray:self.dataArray];
    
    [XHToast showCenterWithText:@"保存成功"];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addWorkExp:) name:@"workExp" object:nil];
//  

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"workExp" object:nil];
}



- (void)addWorkExp:(NSNotification *)notification {
    
    
    if([[notification.userInfo objectForKey:@"isNew"]isEqualToString:@"1"]){
        //若为新增简历
         [self.dataArray addObject:[notification.userInfo objectForKey:@"dataDic"]];
        
        //去重策略
        for(int i=0;i<self.dataArray.count;i++){
            NSMutableDictionary *dic = [self.dataArray objectAtIndex:i];
            NSString *str  = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
            NSMutableDictionary *newDataDic =[notification.userInfo objectForKey:@"dataDic"];
            //找到对应的简历，更新
            if([str isEqualToString:[newDataDic objectForKey:@"id"]]){
                [self.dataArray replaceObjectAtIndex:i withObject:newDataDic];
            }
        }

        
    } else {
        for(int i=0;i<self.dataArray.count;i++){
            NSMutableDictionary *dic = [self.dataArray objectAtIndex:i];
            NSString *str  = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
            NSMutableDictionary *newDataDic =[notification.userInfo objectForKey:@"dataDic"];
            //找到对应的简历，更新
            if([str isEqualToString:[newDataDic objectForKey:@"id"]]){
                [self.dataArray replaceObjectAtIndex:i withObject:newDataDic];
            }
        }
    }
    
    
    
    
    [self.tableView reloadData];
    
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
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        [cell.AddBtn addTarget:self action:@selector(writeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.AddBtn.tag = 10000;
        return cell;
        
    } else {
        static NSString *jobsIdentifier = @"MY_ExpersTableViewCell";
        MY_ExpersTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:jobsIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"MY_ExpersTableViewCell" owner:nil options:nil].lastObject;
        }
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        NSMutableDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
        cell.contentLabel.text = [dic objectForKey:@"companyName"];
        NSString *time = [NSString stringWithFormat:@"%@-%@",[dic objectForKey:@"inTime"],[dic objectForKey:@"outTime"]];
        cell.timeLabel.text = time;
        cell.writeBtn.tag = [[dic objectForKey:@"id"] integerValue];
        [cell.writeBtn addTarget:self action:@selector(writeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
       
        return cell;

    }
    return nil;
}


- (void)writeBtnClicked:(UIButton *)sender{
    
     AddWorkExpersViewController *ctr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddWorkExpersViewController"];
    ctr.indexExpersId = [NSString stringWithFormat:@"%ld",sender.tag];
    [self.navigationController pushViewController:ctr animated:YES];
    
}

@end
