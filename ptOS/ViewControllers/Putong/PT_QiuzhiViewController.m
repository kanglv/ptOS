//
//  PT_QiuzhiViewController.m
//  ptOS
//
//  Created by 周瑞 on 16/9/1.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "PT_QiuzhiViewController.h"
#import "PT_JobMessageTableViewCell.h"
#import "PT_MapViewController.h"
#import "MJRefresh.h"
#import "AFHTTPRequestOperation.h"
#import "PT_MsgListApi.h"
#import "PT_MsgDetailModel.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "PT_HealthExamFeedBackViewController.h"
@interface PT_QiuzhiViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSInteger _page;
}
@property (nonatomic, strong)UITableView *tbView;

@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, strong)PT_MsgListApi *msgListApi;

@end

@implementation PT_QiuzhiViewController

#pragma mark - lifeCycles

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"求职"];
    _page = 1;
    [self initUI];
    [NotificationCenter addObserver:self selector:@selector(refresh) name:@"refreshList" object:nil];
}

- (void)dealloc {
    [NotificationCenter removeObserver:self];
}

- (void)refresh {
    _page = 1;
    [self msgListApiNet];
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
    [self msgListApiNet];
}

- (BOOL)hasData {
    if (self.dataArray.count > 0) {
        return YES;
    }
    else {
        return NO;
    }
}

#pragma mark - NetworkApi
- (void)msgListApiNet {
    if (self.msgListApi && !self.msgListApi.requestOperation.isFinished) {
        [self.msgListApi stop];
    }
    self.msgListApi.sessionDelegate = self;
    self.msgListApi = [[PT_MsgListApi alloc]initWithPage:[NSString stringWithFormat:@"%ld",(long)_page]];
    self.msgListApi.netLoadingDelegate = self;
    self.msgListApi.noNetWorkingDelegate = self;
    [self.msgListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        PT_MsgListApi *result = (PT_MsgListApi *)request;
        if (result.isCorrectResult) {
            if (_page == 1) {
                self.dataArray = [NSMutableArray arrayWithArray:[result getMsgList]];
            }else {
                [self.dataArray addObjectsFromArray:[result getMsgList]];
            }
            [self.tbView reloadData];
            NSInteger count = [result getMsgList].count;
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
    PT_MsgListModel *model = self.dataArray[indexPath.row];
    CGFloat height = [ControlUtil heightWithContent:model.content withFont:[UIFont systemFontOfSize:16] withWidth:FITWIDTH(333)];
    if (height <= 26) {
        return 180;
    }else {
        return 180 + (height - 26);
    }
    

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *jobsIdentifier = @"PT_JobMessageTableViewCell";
    PT_JobMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:jobsIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"PT_JobMessageTableViewCell" owner:nil options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    PT_MsgListModel *model = self.dataArray[indexPath.row];
    cell.timeLabel.text = model.time;
    cell.typeLabel.text = model.title;
    cell.companyNameLabel.text = model.companyName;
    cell.seeLabel.text = model.hint;
    cell.contentLabel.text = model.content;
    
    CGFloat height = [ControlUtil heightWithContent:model.content withFont:[UIFont systemFontOfSize:16] withWidth:FITWIDTH(333)];
    cell.contentHeightCons.constant = height;
    if (height < 26) {
        height = 26;
    }
    cell.bottomHeightCons.constant = 136 + height - 26;
    [cell layoutSubviews];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PT_MsgListModel *model = self.dataArray[indexPath.row];
    if ([model.type isEqualToString:@"0"]) {
        PT_MapViewController *ctrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PT_MapViewController"];
        
        ctrl.msgId = model.messageId;
        ctrl.type = model.type;
        ctrl.title = model.title;
        [self.navigationController pushViewController:ctrl animated:YES];
    }else if ([model.type isEqualToString:@"1"]) {
        
    }else if ([model.type isEqualToString:@"2"]) {
        PT_HealthExamFeedBackViewController *ctrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PT_HealthExamFeedBackViewController"];
        ctrl.msgId = model.messageId;
        [self.navigationController pushViewController:ctrl animated:YES];
    }else if ([model.type isEqualToString:@"3"]) {
        [XHToast showCenterWithText:@"您已经提交过了"];
    }
    
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
            [self msgListApiNet];
        }];
        _tbView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            if (self.dataArray.count == 0 && _page) {
                _page = 1;
            }else {
                _page ++;
            }
            [self msgListApiNet];
        }];
    }
    return _tbView;
}

@end
