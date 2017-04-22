//
//  NewsViewController.m
//  ptOS
//
//  Created by 吕康 on 17/3/7.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "NewsViewController.h"
#import "UIImageView+WebCache.h"
#import "DisCover_SearchNavView.h"
#import "DisCoverNavView.h"
#import "MJRefresh.h"
#import "AFHTTPRequestOperation.h"
#import "FX_GetNoticeListApi.h"
#import "FX_NoticeListModel.h"
#import "GroundGetNoticeListTableViewCell.h"

#import "NewsDetailViewController.h"

@interface NewsViewController ()<UITableViewDelegate, UITableViewDataSource>{
    
        NSInteger _leftPage;
//        NSInteger _rightPage;
//        NSInteger _searchPage;
//        NSString *m_content;
//        BOOL _hasPress;
}

//@property (nonatomic,strong)DiscoverNavView *navView;
@property (nonatomic,strong)UITableView *tbView;

//@property (nonatomic,strong)DisCover_SearchNavView *searchNavView;
//
//@property (nonatomic,strong)UIView *searchView1;
//@property (nonatomic,strong)UIView *searchView2;

@property (nonatomic,strong)FX_GetNoticeListApi *getNoticeListNet;

@property (nonatomic, strong)NSMutableArray * leftDataArray;


//@property (nonatomic, strong)NSMutableArray *searchDataArray;


//@property (nonatomic,assign)BOOL isSearch;

@property (nonatomic,assign)BOOL isGround;

@property (nonatomic ,strong)UIImageView *placeholderImageView;


@property (nonatomic, strong)UIImageView *nodataImgView;
@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.needNav = YES;
    self.title = @"新闻资讯";
    self.automaticallyAdjustsScrollViewInsets = NO;
    _leftPage = 1;
    [self getDataApiNet];
    [self initUI];
}

#pragma mark - customFuncs
- (void)initUI {
        self.tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height-64) ];
        self.tbView.backgroundColor = BackgroundColor;
        self.tbView.showsHorizontalScrollIndicator= NO;
        self.tbView.delegate = self;
        self.tbView.dataSource =self;
        self.tbView.separatorStyle = NO;
        [self.view addSubview:self.tbView];
}


- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.leftDataArray.count;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 360;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     NSDictionary *dic = self.leftDataArray[indexPath.row ];
    FX_NoticeListModel *model = [[FX_NoticeListModel alloc]initWithDic:dic];
    static NSString *left_Identifier = @"GroundGetNoticeListTableViewCell";
    GroundGetNoticeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:left_Identifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"GroundGetNoticeListTableViewCell" owner:nil options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.creatTimeLabel.text = model.createTime;
    cell.timeLabel.text = model.createTime;
    cell.titleLabel.text = model.title;
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
    cell.contentLabel.text = model.content;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.leftDataArray[indexPath.row ];
    FX_NoticeListModel *model = [[FX_NoticeListModel alloc]initWithDic:dic];
    
    NewsDetailViewController *newsDetailViewController = [[NewsDetailViewController alloc]init];
    newsDetailViewController.model = model;
    [self.navigationController pushViewController:newsDetailViewController animated:YES];
    
}

- (void)getDataApiNet {
    if (self.getNoticeListNet && !self.getNoticeListNet.requestOperation.isFinished) {
        [self.getNoticeListNet stop];
    }
    self.getNoticeListNet = [[FX_GetNoticeListApi alloc]initWithPage:[NSString stringWithFormat:@"%ld",(long)_leftPage] withSessionId:[GlobalData sharedInstance].selfInfo.sessionId withType:@"1" withSearchKey:@""];

    self.getNoticeListNet .netLoadingDelegate = self;
    self.getNoticeListNet .noNetWorkingDelegate = self;
    [self.getNoticeListNet  startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        FX_GetNoticeListApi *result = (FX_GetNoticeListApi *)request;
        if (result.isCorrectResult) {
            [self removePlaceholder];
            
            if (_leftPage == 1) {
                self.leftDataArray = [NSMutableArray arrayWithArray:[result getNoticeList]];
            }else {
                [self.leftDataArray addObjectsFromArray:[result getNoticeList]];
            }
            NSLog(@"%@",self.leftDataArray);
            [self.tbView reloadData];
            NSInteger count = [result getNoticeList].count;

            if (count == 0) {
                [self addPlaceholder];
                [(MJRefreshAutoFooter *)self.tbView.mj_footer setHidden:YES];
            }else {
                [(MJRefreshAutoFooter *)self.tbView.mj_footer setHidden:NO];
            }
        
        }else {
            [self addPlaceholder];
            if (_leftPage > 1) {
                _leftPage --;
            }else {
                self.leftDataArray = [NSMutableArray array];
            }
        }
        [self.tbView.mj_header endRefreshing];
        [self.tbView.mj_footer endRefreshing];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self addPlaceholder];
        [self.tbView reloadData];
        if (_leftPage > 1) {
            _leftPage --;
        }else {
            [self.tbView.mj_header endRefreshing];
            [self.tbView.mj_footer endRefreshing];
        }
    }];
}


//添加一个占位图
- (void)addPlaceholder {
    _placeholderImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"kongbai"]];
    _placeholderImageView.frame = CGRectMake(0, 186, self.view.frame.size.width, FITWIDTH(200));//待调整
    [self.view addSubview:_placeholderImageView];
    
}

//移除占位图
- (void)removePlaceholder {
    
    [_placeholderImageView removeFromSuperview];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
