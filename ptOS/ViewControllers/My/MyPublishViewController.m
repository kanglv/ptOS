//
//  MyPublishViewController.m
//  ptOS
//
//  Created by 周瑞 on 16/9/10.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "MyPublishViewController.h"
#import "MyPublishTableViewCell.h"
#import "MJRefresh.h"
#import "AFHTTPRequestOperation.h"
#import "MY_MyPublishApi.h"
#import "MY_MyPublishModel.h"
#import "UIImageView+WebCache.h"
#import "Discover_DetailViewController.h"

@interface MyPublishViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSInteger _page;
}
@property (nonatomic, strong)UITableView *tbView;
@property (nonatomic, strong)MY_MyPublishApi *myPublishApi;
@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation MyPublishViewController

#pragma mark - lifeCycles

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我发布的"];
    _page = 1;
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
    [self.view addSubview:self.tbView];
    [self myPublishApiNet];
}

- (BOOL)hasData {
    if (self.dataArray.count > 0) {
        return YES;
    }else {
        return NO;
    }
}

#pragma mark - NetworkApi 
- (void)myPublishApiNet {
    if (self.myPublishApi && !self.myPublishApi.requestOperation.isFinished) {
        [self.myPublishApi stop];
    }
    self.myPublishApi.sessionDelegate = self;
    self.myPublishApi = [[MY_MyPublishApi alloc]initWithPage:[NSString stringWithFormat:@"%ld",(long)_page]];
    self.myPublishApi.netLoadingDelegate = self;
    self.myPublishApi.noNetWorkingDelegate = self;
    [self.myPublishApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        MY_MyPublishApi *result = (MY_MyPublishApi *)request;
        if (result.isCorrectResult) {
            if (_page == 1) {
                self.dataArray = [NSMutableArray arrayWithArray:[result getMyPublishList]];
            }else {
                [self.dataArray addObjectsFromArray:[result getMyPublishList]];
            }
            [self.tbView reloadData];
            NSInteger count = [result getMyPublishList].count;
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
    
    return 163;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *jobsIdentifier = @"MyPublishTableViewCell";
    MyPublishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:jobsIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MyPublishTableViewCell" owner:nil options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MY_MyPublishModel *model = self.dataArray[indexPath.row];
    if (model.imageUrl == nil || model.imageUrl.length < 6) {
        cell.headerImageView.hidden = YES;
        cell.conetentLabel.width = FITWIDTH(337);
    }else {
        cell.headerImageView.hidden = NO;
        cell.conetentLabel.width = FITWIDTH(268);
    }
    cell.conetentLabel.text = model.content;
    [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@"moren_pt"]];
    [cell.adressLabel setTitle:model.address forState:UIControlStateNormal];
    cell.timeLabel.text = model.time;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Discover_DetailViewController *ctrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Discover_DetailViewController"];
    MY_MyPublishModel *model = self.dataArray[indexPath.row];
    ctrl.tzId = model.tzId;
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
            [self myPublishApiNet];
        }];
        _tbView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            if (self.dataArray.count == 0 && _page) {
                _page = 1;
            }else {
                _page ++;
            }
            [self myPublishApiNet];
        }];
    }
    return _tbView;
}

@end
