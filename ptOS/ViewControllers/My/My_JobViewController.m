//
//  My_JobViewController.m
//  ptOS
//
//  Created by 周瑞 on 16/9/10.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "My_JobViewController.h"
#import "FavoriteJobTableViewCell.h"
#import "AFHTTPRequestOperation.h"
#import "MJRefresh.h"
#import "MY_FeedbackApi.h"
#import "MY_FeedbackModel.h"
#import "UIImageView+WebCache.h"
#import "JobsDetailViewController.h"
#import "NSDate+JKExtension.h"

@interface My_JobViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSInteger _page;
}
@property (nonatomic, strong)UITableView *tbView;

@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, strong)MY_FeedbackApi *feedbackApi;

@end

@implementation My_JobViewController

#pragma mark - lifeCycles

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"求职"];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - customFuncs
- (void) initUI {
    
    _page = 1;
    [self.view addSubview:self.tbView];
    [self feedbacApiNet];
}

- (BOOL)hasData {
    if (self.dataArray.count > 0) {
        return YES;
    }else {
        return NO;
    }
}

#pragma mark - NetworkApi
- (void)feedbacApiNet {
    if (self.feedbackApi && !self.feedbackApi.requestOperation.isFinished) {
        [self.feedbackApi stop];
    }
    self.feedbackApi = [[MY_FeedbackApi alloc]initWithPage:[NSString stringWithFormat:@"%ld",(long)_page]];
    self.feedbackApi.netLoadingDelegate = self;
    self.feedbackApi.noNetWorkingDelegate = self;
    [self.feedbackApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        MY_FeedbackApi *result = (MY_FeedbackApi *)request;
        if (result.isCorrectResult) {
            if (_page == 1) {
                self.dataArray = [NSMutableArray arrayWithArray:[result getFeedBackList]];
            }else {
                [self.dataArray addObjectsFromArray:[result getFeedBackList]];
            }
            [self.tbView reloadData];
            NSInteger count = [result getFeedBackList].count;
            if (count == 0) {
                [(MJRefreshAutoFooter *)self.tbView.mj_footer setHidden:YES];
            }else {
                [(MJRefreshAutoFooter *)self.tbView.mj_footer setHidden:NO];
            }
        }else {
            if (_page > 1) {
                _page --;
            }else {
                self.dataArray = [NSMutableArray array];
                [self.tbView reloadData];
            }
        }
        [self showNoDataView];
        [self.tbView.mj_header endRefreshing];
        [self.tbView.mj_footer endRefreshing];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (_page > 1) {
            _page --;
        }else {
            [self.tbView.mj_header endRefreshing];
            [self.tbView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 104;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *jobsIdentifier = @"FavoriteJobTableViewCell";
    FavoriteJobTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:jobsIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"FavoriteJobTableViewCell" owner:nil options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MY_FeedbackModel *model = self.dataArray[indexPath.row];
    [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.companyImage] placeholderImage:[UIImage imageNamed:@"moren_pt"]];
    ZRViewRadius(cell.headerImageView, 25);
    cell.jobNameLabel.text = model.jobName;
    cell.companyNameLabel.text = model.conpanyName;
    NSString *timenow = [NSDate jk_timeInfoWithDateString:model.time];
    cell.timeLabel.text = timenow;
    cell.statusLabel.text = [NSString stringWithFormat:@"【%@】",model.state];
    CGFloat width = [ControlUtil widthWithContent:model.conpanyName withFont:[UIFont systemFontOfSize:13] withHeight:16];
//    cell.companyNameLabel.width = width + 20;
//    cell.zzView.x= cell.companyNameLabel.x + width + 3 ;
//    if (SCREEN_WIDTH < 321) {
//        cell.zzView.x= cell.companyNameLabel.x + width + 3 + 20;
//    }

    cell.nameWidthCons.constant = width;
    if ([model.isZhiZhao isEqualToString:@"1"]) {
        cell.zzView.image = [UIImage imageNamed:@"icon_zhizhao"];
    }else {
        cell.zzView.image = [UIImage imageNamed:@"tab_zhongjie"];
    }
//    cell.zzView.x = cell.companyNameLabel.x + width + 3;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JobsDetailViewController *ctrl = [[JobsDetailViewController alloc]init];
    MY_FeedbackModel *model = self.dataArray[indexPath.row];
    ctrl.zwId = model.zwId;
    [self.navigationController pushViewController:ctrl animated:YES];
}

#pragma mark - lazyViews
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (UITableView *)tbView {
    if (_tbView == nil) {
        _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        _tbView.delegate = self;
        _tbView.dataSource = self;
        _tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tbView.backgroundColor = BackgroundColor;
        
        _tbView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page = 1;
            [self feedbacApiNet];
        }];
        _tbView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            if (self.dataArray.count == 0 && _page) {
                _page = 1;
            }else {
                _page ++;
            }
            [self feedbacApiNet];
        }];
    }
    return _tbView;
}

@end
