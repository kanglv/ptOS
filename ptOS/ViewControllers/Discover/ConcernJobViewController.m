//
//  ConcernJobViewController.m
//  ptOS
//
//  Created by 吕康 on 17/3/4.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "ConcernJobViewController.h"

#import "ConcernJobTableViewCell.h"

#import "GetConcernJob.h"

#import "MJRefresh.h"

#import "UIImageView+WebCache.h"

#import "ConcernJobModel.h"

#import "JobsDetailViewController.h"

@interface ConcernJobViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _page;
}

@property (strong , nonatomic)GetConcernJob *getConcernJobApi;

@property (strong ,nonatomic)UITableView *tableView;

@property (strong, nonatomic)NSMutableArray *dataArr;

@property (strong , nonatomic)UIImageView *noDataImageView;

@end

@implementation ConcernJobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    self.title = @"关注的职位";
    _page = 1 ;
    [self getJobApiNet];
    
    [self initTableView];
    
}


- (void)initTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height) ];
    self.tableView.backgroundColor = BackgroundColor ;
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    self.tableView.separatorStyle = NO;
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [self.dataArr objectAtIndex:indexPath.row];
    
    static NSString *jobsIdentifier = @"ConcernJobTableViewCell";
    ConcernJobTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:jobsIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ConcernJobTableViewCell" owner:nil options:nil].lastObject;
    }
    
    ConcernJobModel *model = [[ConcernJobModel alloc]initWithDic:dic];
    [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.companyImage] placeholderImage:[UIImage imageNamed:@"moren_pt"]];
    cell.company.text = model.companyName;
    cell.job.text     = model.zwName;
    cell.timelabel.text = @"2小时前";
    if([model.isZZ isEqualToString:@"1"]){
        cell.stateLabel.text = @"直招";
    } else{
        cell.stateLabel.text = @"中介";
    }
    if([model.isZP isEqualToString:@"1"]){
        cell.recruitState.text = @"招工中";
    } else {
        cell.recruitState.text = @"未招聘";
    }
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [self.dataArr objectAtIndex:indexPath.row];
    ConcernJobModel *model = [[ConcernJobModel alloc]initWithDic:dic];
    JobsDetailViewController *detailViewController = [[JobsDetailViewController alloc]init];
    detailViewController.zwId = model.jobId;
    [self.navigationController pushViewController:detailViewController animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (void)getJobApiNet {
    if (self.getConcernJobApi && !self.getConcernJobApi.requestOperation) {
        [self.getConcernJobApi stop];
    }
    
    NSLog(@"%@",[GlobalData sharedInstance].selfInfo.sessionId);
    self.getConcernJobApi = [[GetConcernJob alloc]initWithSessionId:[GlobalData sharedInstance].selfInfo.sessionId andWithPage:[NSString stringWithFormat:@"%ld",(long)_page]];
    self.getConcernJobApi.noNetWorkingDelegate = self;
    [self.getConcernJobApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
      GetConcernJob *result = (GetConcernJob *)request;
        if (result.isCorrectResult) {
            if (_page == 1) {
                self.dataArr = [NSMutableArray arrayWithArray:[result getJobList]];
            }else {
                [self.dataArr addObjectsFromArray:[result getJobList]];
            }
            [self.tableView reloadData];
            NSInteger count = [result getJobList].count;
            if (count == 0) {
                [(MJRefreshAutoFooter *)self.tableView.mj_footer setHidden:YES];
            }else {
                [(MJRefreshAutoFooter *)self.tableView.mj_footer setHidden:NO];
            }
        }else {
            if (_page > 1) {
                _page --;
            }else {
                self.dataArr = [NSMutableArray array];
                [self.tableView reloadData];
            }
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (_page > 1) {
            _page --;
        }else {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}
//没有数据时添加占位的view

- (void)addPlaceHolderView {
    _noDataImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 250, FITWIDTH(200) * 2.2, FITWIDTH(200))];  //需要调整
    _noDataImageView.centerX = self.view.centerX;
    _noDataImageView.image = [UIImage imageNamed:@"kongbai"];
    [self.view addSubview: _noDataImageView];
}

//有数据时清除占位图

- (void)removePlaceHolderView {
    
    [_noDataImageView removeFromSuperview];
}



@end
