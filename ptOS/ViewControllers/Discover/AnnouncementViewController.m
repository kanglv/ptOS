//
//  AnnouncementViewController.m
//  ptOS
//
//  Created by 吕康 on 17/3/14.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "AnnouncementViewController.h"
#import "UIImageView+WebCache.h"
#import "DisCover_SearchNavView.h"
#import "DisCoverNavView.h"
#import "MJRefresh.h"
#import "AFHTTPRequestOperation.h"
#import "FX_GetNoticeListApi.h"
#import "FX_NoticeListModel.h"
#import "GroundGetNoticeListTableViewCell.h"

@interface AnnouncementViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UITextFieldDelegate>{
    
    NSInteger _leftPage;
    NSInteger _rightPage;
    NSInteger _searchPage;
    NSString *m_content;
    BOOL _hasPress;
}

@property (nonatomic,strong)DiscoverNavView *navView;
@property (nonatomic,strong)UITableView *tbView;

@property (nonatomic,strong)DisCover_SearchNavView *searchNavView;

@property (nonatomic,strong)UIView *searchView1;
@property (nonatomic,strong)UIView *searchView2;

@property (nonatomic,strong)FX_GetNoticeListApi *getNoticeListNet;

@property (nonatomic, strong)NSMutableArray * leftDataArray;


@property (nonatomic, strong)NSMutableArray *searchDataArray;


@property (nonatomic,assign)BOOL isSearch;

@property (nonatomic,assign)BOOL isGround;

@property (nonatomic ,strong)UIImageView *placeholderImageView;


@property (nonatomic, strong)UIImageView *nodataImgView;
@end

@implementation AnnouncementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needNav = YES;
    self.title = @"通知公告";
    _hasPress = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _leftPage = 1;
    _searchPage = 1;
    self.isSearch = NO;
    self.isGround = YES;
    
    [self getDataApiNet];
    [self initUI];
}


- (void)getDataApiNet {
    if (self.getNoticeListNet && !self.getNoticeListNet.requestOperation.isFinished) {
        [self.getNoticeListNet stop];
    }
    self.getNoticeListNet = [[FX_GetNoticeListApi alloc]initWithPage:[NSString stringWithFormat:@"%ld",(long)_leftPage] withSessionId:[GlobalData sharedInstance].selfInfo.sessionId withType:@"3" withSearchKey:self.searchNavView.searchTF.text];
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
                [self.tbView reloadData];
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
#pragma mark - customFuncs
- (void)initUI {
    
    [self.view addSubview:self.tbView];
    
//    [self.view addSubview:self.searchNavView];
//    
//    [self.view addSubview:self.navView];
//    
//    
//    
//    
//    [self setFrame];
//    
    
}


- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tbView) {
        if (self.isSearch) {
            return self.searchDataArray.count;
        }else {
            return self.leftDataArray.count;
        }
        return 10;
    }else {
        return 0;
    }
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
    
    cell.timeLabel.text = model.createTime;
    cell.titleLabel.text = model.title;
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
    cell.contentLabel.text = model.content;
    return cell;
}

//- (void)searchBtnPress {
//    
//    self.navView.hidden = YES;
//    self.searchNavView.hidden = NO;
//    self.searchView1.hidden = YES;
//    self.searchView2.hidden = YES;
//    
//    
//    self.isSearch = YES;
//    [self.searchDataArray removeAllObjects];
//    
//    [self getDataApiNet];
//    [self.tbView reloadData];
//    [self.searchNavView.searchTF becomeFirstResponder];
//}
//
//- (void)cancelSearch {
//    [self.view endEditing:YES];
//    self.searchNavView.hidden = YES;
//    self.navView.hidden = NO;
//    self.searchView1.hidden = NO;
//    self.searchView2.hidden = NO;
//    
//    [self.searchDataArray removeAllObjects];
//    
//    self.isSearch = NO;
//    
//    [self.tbView reloadData];
//}
//
//
//
//- (void)back{
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (UITableView *)tbView {
    if (_tbView == nil) {
        _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 ) style:UITableViewStylePlain];
        _tbView.delegate = self;
        _tbView.dataSource = self;
        _tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tbView.backgroundColor = BackgroundColor;
        _tbView.tableHeaderView = self.searchView1;
        
        
        _tbView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _leftPage = 1;
            
        }];
        _tbView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            if (_leftDataArray.count == 0 && _leftPage) {
                _leftPage = 1;
            }else {
                _leftPage ++;
            }
            
        }];
    }
    return _tbView;
}

//
//- (DiscoverNavView *)navView {
//    if (_navView == nil) {
//        _navView = [[NSBundle mainBundle] loadNibNamed:@"DiscoverNavView" owner:nil options:nil].lastObject;
//        
//        [_navView.publishBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//        [_navView.publishBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//        [_navView.groundBtn2 setTitle:@"通知公告" forState:UIControlStateNormal];
//        _navView.groundBtn.hidden = YES;
//        _navView.companyBtn.hidden = YES;
//        _navView.searchBtn.hidden = YES;
//    }
//    return _navView;
//}
//
//
//- (DisCover_SearchNavView *)searchNavView {
//    if (_searchNavView == nil) {
//        _searchNavView = [[NSBundle mainBundle] loadNibNamed:@"DisCover_SearchNavView" owner:nil options:nil].lastObject;
//        UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 0, 15, 15)];
//        leftView.image = [UIImage imageNamed:@"icon_shousuo"];
//        UIView *reaLeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 45, 15)];
//        [reaLeftView addSubview:leftView];
//        _searchNavView.searchTF.leftView = reaLeftView;
//        _searchNavView.searchTF.leftViewMode = UITextFieldViewModeAlways;
//        UIImageView *rightView = [[UIImageView alloc]initWithFrame:CGRectMake(21, 1.5, 12, 12)];
//        UIView *reaRightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 45, 15)];
//        [reaRightView addSubview:rightView];
//        rightView.image = [UIImage imageNamed:@"icon_guanbi"];
//        _searchNavView.searchTF.rightView = reaRightView;
//        _searchNavView.searchTF.rightViewMode = UITextFieldViewModeWhileEditing;
//        _searchNavView.searchTF.delegate = self;
//        _searchNavView.searchTF.textColor = WhiteColor;
//        [_searchNavView.searchTF setValue:WhiteColor forKeyPath:@"_placeholderLabel.textColor"];
//        [_searchNavView.cancelBtn addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
//        _searchNavView.hidden = YES;
//    }
//    return _searchNavView;
//}
//
//- (UIView *)searchView1 {
//    if (_searchView1 == nil) {
//        _searchView1 = [[UIView alloc]init];
//        _searchView1.backgroundColor = MainColor;
//        _searchView1.frame = CGRectMake(0, 64, SCREEN_WIDTH, 40);
//        
//        UIView *whiteBgView = [[UIView alloc]initWithFrame:CGRectMake(12, 5, FITWIDTH(351), 30)];
//        whiteBgView.backgroundColor = RGB(162, 192, 249);
//        [_searchView1 addSubview:whiteBgView];
//        
//        UIImageView *searchImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2.0 - 33, 7, 15, 16)];
//        searchImageView.image = [UIImage imageNamed:@"icon_shousuo.png"];
//        [whiteBgView addSubview:searchImageView];
//        ZRViewRadius(whiteBgView, 5);
//        
//        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(searchImageView.x + 20, searchImageView.y, 25, 16)];
//        label.font = [UIFont systemFontOfSize:12];
//        label.text = @"搜索";
//        label.textColor = [UIColor whiteColor];
//        [whiteBgView addSubview:label];
//        
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
//        btn.frame = whiteBgView.frame;
//        [btn addTarget:self action:@selector(searchBtnPress) forControlEvents:UIControlEventTouchUpInside];
//        [whiteBgView addSubview:btn];
//    }
//    return _searchView1;
//}
//
//- (UIView *)searchView2 {
//    if (_searchView2 == nil) {
//        _searchView2 = [[UIView alloc]init];
//        _searchView2.backgroundColor = MainColor;
//        _searchView2.frame = CGRectMake(0, 64, SCREEN_WIDTH, 40);
//        
//        UIView *whiteBgView = [[UIView alloc]initWithFrame:CGRectMake(12, 5, FITWIDTH(351), 30)];
//        whiteBgView.backgroundColor = RGB(162, 192, 249);
//        [_searchView2 addSubview:whiteBgView];
//        
//        UIImageView *searchImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2.0 - 33, 7, 15, 16)];
//        searchImageView.image = [UIImage imageNamed:@"icon_shousuo.png"];
//        [whiteBgView addSubview:searchImageView];
//        ZRViewRadius(whiteBgView, 5);
//        
//        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(searchImageView.x + 20, searchImageView.y, 25, 16)];
//        label.font = [UIFont systemFontOfSize:12];
//        label.text = @"搜索";
//        label.textColor = [UIColor whiteColor];
//        [whiteBgView addSubview:label];
//        
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
//        btn.frame = whiteBgView.frame;
//        [btn addTarget:self action:@selector(searchBtnPress) forControlEvents:UIControlEventTouchUpInside];
//        [whiteBgView addSubview:btn];
//    }
//    return _searchView2;
//}
//
//- (void)setFrame {
//    self.navView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
//    self.searchNavView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
//    self.searchView1.frame = CGRectMake(0, 64, SCREEN_WIDTH, 40);
//}

@end
