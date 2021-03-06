//
//  PT_ConcernViewController.m
//  ptOS
//
//  Created by 吕康 on 17/3/14.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "PT_ConcernViewController.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"

#import "PT_GetMessageModel.h"
#import "PT_GetMessageNetApi.h"
#import "PT_ConcernTableViewCell.h"

#import "Discover_DetailViewController.h"

@interface PT_ConcernViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger _page;
}

@property (strong , nonatomic)PT_GetMessageNetApi *getMessageApi;



@property (strong ,nonatomic)UITableView *tableView;

@property (strong, nonatomic)NSMutableArray *dataArr;

@property (strong , nonatomic)UIImageView *noDataImageView;
@end

@implementation PT_ConcernViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    self.title = @"我关注的";
    _page = 1 ;
    
    
    [self getMessageApiNet];
    
    [self initTableView];
    
}


- (void)initTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height-84) ];
    self.tableView.backgroundColor = BackgroundColor ;
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    self.tableView.separatorStyle = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [self.dataArr objectAtIndex:indexPath.row];
    static NSString *concernIdentifier = @"PT_ConcernTableViewCell";
    PT_ConcernTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:concernIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"PT_ConcernTableViewCell" owner:nil options:nil].lastObject;
    }
    
    PT_GetMessageModel *model = [[ PT_GetMessageModel alloc]initWithDic:dic];
    cell.nickNameLabel.text = model.title;
    cell.contentLabel.text  = model.content;
    cell.timeLabel.text     = model.createTime;
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Discover_DetailViewController *ctrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Discover_DetailViewController"];
     NSDictionary *dic = [self.dataArr objectAtIndex:indexPath.row];
    PT_GetMessageModel *model = [[ PT_GetMessageModel alloc]initWithDic:dic];
    ctrl.tzId = model.messageId;
    [self.navigationController pushViewController:ctrl animated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (void)getMessageApiNet {
    if (self.getMessageApi && !self.getMessageApi.requestOperation) {
        [self.getMessageApi stop];
    }
    
    NSLog(@"%@",[GlobalData sharedInstance].selfInfo.sessionId);
    self.getMessageApi = [[PT_GetMessageNetApi alloc]initWithPage:[NSString stringWithFormat:@"%ld",(long)_page] withSessionId:[GlobalData sharedInstance].selfInfo.sessionId withType:@"2"];
    
    self.getMessageApi.noNetWorkingDelegate = self;
    [self.getMessageApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        PT_GetMessageNetApi *result = (PT_GetMessageNetApi *)request;
        if (result.isCorrectResult) {
            [self removePlaceHolderView];
            if (_page == 1) {
                self.dataArr = [NSMutableArray arrayWithArray:[result getMessageList]];
            }else {
                [self.dataArr addObjectsFromArray:[result getMessageList]];
            }
            [self.tableView reloadData];
            NSInteger count = self.dataArr.count;
            if (count == 0) {
                 [self addPlaceHolderView];
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
        [self addPlaceHolderView];
        [self.tableView reloadData];
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
    _noDataImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 186, FITWIDTH(200) * 2.2, FITWIDTH(200))];  //需要调整
    _noDataImageView.centerX = self.view.centerX;
    _noDataImageView.image = [UIImage imageNamed:@"kongbai"];
    [self.view addSubview: _noDataImageView];
}

//有数据时清除占位图

- (void)removePlaceHolderView {
    
    [_noDataImageView removeFromSuperview];
}

@end
