//
//  MyCommentViewController.m
//  ptOS
//
//  Created by 周瑞 on 16/9/24.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "MyCommentViewController.h"
#import "MY_MyCommentApi.h"
#import "MJRefresh.h"
#import "AFHTTPRequestOperation.h"
#import "MyCommentTableViewCell.h"
#import "CommentLabel.h"
#import "MY_MyCommentModel.h"
#import "Discover_DetailViewController.h"

@interface MyCommentViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSInteger _page;
}
@property (nonatomic, strong)UITableView *tbView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)MY_MyCommentApi *myCommentApi;

@end

@implementation MyCommentViewController

#pragma mark - lifeCycles

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我的评论"];
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
    [self mycommentApiNet];
}


-(BOOL)hasData {
    if (self.dataArray.count > 0) {
        return YES;
    }else {
        return NO;
    }
}
#pragma mark - NetworkApi
- (void)mycommentApiNet {
    if (self.myCommentApi && !self.myCommentApi.requestOperation.isFinished) {
        [self.myCommentApi stop];
    }
    self.myCommentApi.sessionDelegate = self;
    self.myCommentApi = [[MY_MyCommentApi alloc]initWithPage:[NSString stringWithFormat:@"%ld",(long)_page]];
    self.myCommentApi.netLoadingDelegate = self;
    self.myCommentApi.noNetWorkingDelegate = self;
    [self.myCommentApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        MY_MyCommentApi *result = (MY_MyCommentApi *)request;
        if (result.isCorrectResult) {
            if (_page == 1) {
                self.dataArray = [NSMutableArray arrayWithArray:[result getMyCommentList]];
            }else {
                [self.dataArray addObjectsFromArray:[result getMyCommentList]];
            }
            NSLog(@"%@",self.dataArray);
            [self.tbView reloadData];
            NSInteger count = [result getMyCommentList].count;
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
    MY_MyCommentModel *model = self.dataArray[indexPath.row];
    CommentLabel *view = [[CommentLabel alloc]init];
    CGFloat h = [view getHeightWithArray:model.replyList];
    return h + 170 + 10 + 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *jobsIdentifier = @"MyCommentTableViewCell2";
    MyCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:jobsIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MyCommentTableViewCell" owner:nil options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MY_MyCommentModel *model = self.dataArray[indexPath.row];
    [cell setModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MY_MyCommentModel *model = self.dataArray[indexPath.row];
    Discover_DetailViewController *ctrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Discover_DetailViewController"];
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
            [self mycommentApiNet];
        }];
        _tbView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            if (self.dataArray.count == 0 && _page) {
                _page = 1;
            }else {
                _page ++;
            }
            [self mycommentApiNet];
        }];
    }
    return _tbView;
}

@end
