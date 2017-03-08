//
//  ConcernCompanyViewController.m
//  ptOS
//
//  Created by 吕康 on 17/3/4.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "ConcernCompanyViewController.h"

#import "ConcernCompanyTableViewCell.h"

#import "GetConcernCompany.h"

#import "MJRefresh.h"

#import "UIImageView+WebCache.h"

#import "ConcernCompanyModel.h"

#import "CompanyDetailViewController.h"

@interface ConcernCompanyViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _page;
}

@property (strong , nonatomic)GetConcernCompany *getConcernCompanyApi;

@property (strong ,nonatomic)UITableView *tableView;

@property (strong, nonatomic)NSMutableArray *dataArr;

@property (strong , nonatomic)UIImageView *noDataImageView;

@end

@implementation ConcernCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    self.title = @"关注的公司";
    _page = 1;
    [self getConpanyApiNet];
    [self initTableView];
   
}

- (void)initTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height) ];
    self.tableView.backgroundColor = BackgroundColor;
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
    
    static NSString *jobsIdentifier = @"ConcernCompanyTableViewCell";
    ConcernCompanyTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:jobsIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ConcernCompanyTableViewCell" owner:nil options:nil].lastObject;
    }
    
    ConcernCompanyModel *model = [[ConcernCompanyModel alloc]initWithDic:dic];
    [cell.headerImage sd_setImageWithURL:[NSURL URLWithString:model.companyImage] placeholderImage:[UIImage imageNamed:@"moren_pt"]];
    cell.companyLabel.text = model.company;
    if([model.isZp isEqualToString:@"1"]){
        cell.stateLabel.text = @"招聘中";
    }
    cell.numberLabel.text = model.zzrsNum;
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [self.dataArr objectAtIndex:indexPath.row];
    ConcernCompanyModel *model = [[ConcernCompanyModel alloc]initWithDic:dic];
    CompanyDetailViewController *detailViewController = [[CompanyDetailViewController alloc]init];
    detailViewController.companyId = model.companyId;
    [self.navigationController pushViewController:detailViewController animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (void)getConpanyApiNet {
    if (self.getConcernCompanyApi && !self.getConcernCompanyApi.requestOperation) {
        [self.getConcernCompanyApi stop];
    }
    self.getConcernCompanyApi = [[GetConcernCompany alloc]initWithSessionId:[GlobalData sharedInstance].selfInfo.sessionId andWithPage:[NSString stringWithFormat:@"%ld",(long)_page]];
    self.getConcernCompanyApi.noNetWorkingDelegate = self;
    [self.getConcernCompanyApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        GetConcernCompany *result = (GetConcernCompany *)request;
        if (result.isCorrectResult) {
            if (_page == 1) {
                self.dataArr = [NSMutableArray arrayWithArray:[result getCompanyList]];
            }else {
                [self.dataArr addObjectsFromArray:[result getCompanyList]];
            }
            [self.tableView reloadData];
            NSInteger count = [result getCompanyList].count;
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
