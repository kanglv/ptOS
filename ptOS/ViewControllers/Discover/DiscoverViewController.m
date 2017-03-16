//
//  DiscoverViewController.m
//  ptOS
//
//  Created by 周瑞 on 16/8/30.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "DiscoverViewController.h"
#import "GroundTableViewCell.h"
#import "GroundNoImageTableViewCell.h"
#import "GroupSpeechTableViewCell.h"
#import "DiscoverNavView.h"
#import "PubLishQunaziViewController.h"
#import "Discover_companyTableViewCell.h"
#import "DisCover_SearchNavView.h"
#import "Discover_DetailViewController.h"
#import "MJRefresh.h"
#import "AFHTTPRequestOperation.h"
#import "FX_GroudListApi.h"
#import "FX_ComListApi.h"
#import "FX_SearchListApi.h"
#import "FX_GiveGreatApi.h"
#import "FX_ComListModel.h"
#import "UIImageView+WebCache.h"

#import "ChoosePublishWay.h"

#import "PublishSpeechViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <AVFoundation/AVFoundation.h>

#import "NewsViewController.h"
#import "WorkerViewController.h"
#import "SuggestionViewController.h"
#import "PolicyViewController.h"
#import "AnnouncementViewController.h"

@interface DiscoverViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UITextFieldDelegate>
{
    NSInteger _leftPage;
    NSInteger _rightPage;
    NSInteger _searchPage;
    NSString *m_content;
    
    BOOL _hasPress;
}
@property (nonatomic,strong)DiscoverNavView *navView;
@property (nonatomic,strong)UITableView *left_tbView;
@property (nonatomic,strong)UITableView *right_tbView;
@property (nonatomic,strong)DisCover_SearchNavView *searchNavView;

@property (nonatomic,strong)UIView *searchView1;
@property (nonatomic,strong)UIView *searchView2;

@property (nonatomic, strong)FX_GroudListApi *groundListApi;
@property (nonatomic, strong)FX_ComListApi *comListApi;

@property (nonatomic, strong)FX_SearchListApi *searchApi;

@property (nonatomic, strong)FX_GiveGreatApi *giveGreatApi;

@property (nonatomic, strong)NSMutableArray * leftDataArray;
@property (nonatomic, strong)NSMutableArray *rightDataArray;

@property (nonatomic, strong)NSMutableArray *searchDataArray;


@property (nonatomic,assign)BOOL isSearch;

@property (nonatomic,assign)BOOL isGround;

@property (nonatomic ,strong)UIImageView *placeholderImageView;


@property (nonatomic, strong)UIImageView *nodataImgView;

@property (nonatomic ,strong)ChoosePublishWay *choosePublishWayView;

@property (nonatomic, strong)UITapGestureRecognizer *tapGestureReconizer;

@property (nonatomic, strong)AVAudioPlayer *player;

@end

@implementation DiscoverViewController

#pragma mark - lifeCycles

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needNav = NO;
    _hasPress = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _leftPage = 1;
    _rightPage = 1;
    _searchPage = 1;
    self.isSearch = NO;
    self.isGround = YES;
    [self initUI];
    
    [NotificationCenter addObserver:self selector:@selector(refresh) name:@"publish_refresh" object:nil];
    [NotificationCenter addObserver:self selector:@selector(pushToSubViewController:) name:@"indexItem" object:nil];
}

- (void)dealloc {
    [NotificationCenter removeObserver:self];
}

//点击广场上的cell
- (void)pushToSubViewController:(NSNotification *)notification {
    NSString *indexItem = [notification.userInfo objectForKey:@"0"];
    if([indexItem isEqualToString:@"0"]){
        //跳转新闻资讯
        NewsViewController *newsVc = [[NewsViewController alloc]init];
        [self.navigationController pushViewController:newsVc animated:YES];
    }  else if ([indexItem isEqualToString:@"1"]){
        PolicyViewController *policyVc = [[PolicyViewController alloc]init];
        [self.navigationController pushViewController:policyVc animated:YES];
    } else if([indexItem isEqualToString:@"2"]){
        AnnouncementViewController *announcementVc = [[AnnouncementViewController alloc]init];
        [self.navigationController pushViewController:announcementVc animated:YES];
    } else if([indexItem isEqualToString:@"3"]){
        //工资政策
    } else if([indexItem isEqualToString:@"4"]){
        WorkerViewController *workerVc = [[WorkerViewController alloc]init];
        [self.navigationController pushViewController:workerVc animated:YES];
    }  else if ([indexItem isEqualToString:@"5"]){
        SuggestionViewController *suggestionVc = [[SuggestionViewController alloc]init];
        [self.navigationController pushViewController:suggestionVc animated:YES];
    }
}

//添加一个占位图
- (void)addPlaceholder {
    _placeholderImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"kongbai"]];
    _placeholderImageView.frame = CGRectMake(100, 250, 200, 200);//待调整
    [self.view addSubview:_placeholderImageView];
    
}

//移除占位图
- (void)removePlaceholder {
    
    [_placeholderImageView removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[GlobalData sharedInstance].selfInfo.companyName isEqualToString:@""] || [GlobalData sharedInstance].selfInfo.companyName == nil || [[GlobalData sharedInstance].selfInfo.companyName isKindOfClass:[NSNull class]] ) {
        //        没有企业
        self.navView.companyBtn.hidden = YES;
        self.navView.groundBtn.hidden = YES;
        self.navView.groundBtn2.hidden = NO;
        self.right_tbView.hidden = YES;
        
//        [self addPlaceholder];
    }else {
        self.navView.companyBtn.hidden = NO;
        self.navView.groundBtn2.hidden = YES;
        self.navView.groundBtn.hidden = NO;
        [self comListApiNet];
        
//        [self removePlaceholder];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - customFuncs
- (void)initUI {
    [self.view addSubview:self.right_tbView];
    [self.view addSubview:self.left_tbView];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.searchNavView];
    
    
    if ([[GlobalData sharedInstance].selfInfo.companyName isEqualToString:@""] || [GlobalData sharedInstance].selfInfo.companyName == nil || [[GlobalData sharedInstance].selfInfo.companyName isKindOfClass:[NSNull class]] ) {
        //        没有企业
        self.navView.companyBtn.hidden = YES;
        self.navView.groundBtn.hidden = YES;
        self.navView.groundBtn2.hidden = NO;
        self.right_tbView.hidden = YES;
        
//        [self addPlaceholder];
    }else {
        self.navView.companyBtn.hidden = NO;
        self.navView.groundBtn2.hidden = YES;
        self.navView.groundBtn.hidden = NO;
        [self comListApiNet];
        
//        [self removePlaceholder];
    }
    
    [self setFrame];
    [self groundListApiNet];
    
}
- (void)publishBtnPress {
    //弹出一个页面
    if(self.choosePublishWayView){
        
        [self.view bringSubviewToFront:self.choosePublishWayView];
        
    } else {
        self.choosePublishWayView = [[ChoosePublishWay alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) withString:@"publish"];
        [self.choosePublishWayView.normalBtn addTarget:self action:@selector(publishNormalMessage) forControlEvents:UIControlEventTouchUpInside];
        [self.choosePublishWayView.speechBtn addTarget:self action:@selector(publishSpeechMessage) forControlEvents:UIControlEventTouchUpInside];
        
        //添加单击手势
        self.tapGestureReconizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
        [self.choosePublishWayView addGestureRecognizer:self.tapGestureReconizer];
        
        
        [self.view addSubview:self.choosePublishWayView];
    }
    
}

//选择发布页的点击手势
- (void)singleTap {
    
    [self.view sendSubviewToBack:self.choosePublishWayView];
    
}

//发布普通消息
- (void)publishNormalMessage {
    PubLishQunaziViewController *ctrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PubLishQunaziViewController"];
    [self.navigationController pushViewController:ctrl animated:YES];

}
//发布语音消息
- (void)publishSpeechMessage {

    PublishSpeechViewController *publishSpeechViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PublishSpeechViewController"];
        [self.navigationController pushViewController:publishSpeechViewController animated:YES];
}

- (void)shareActionWithContent:(UIButton *)sender {
    GroundNoImageTableViewCell *cell = (GroundNoImageTableViewCell *)sender.superview.superview.superview;
    NSIndexPath *indexpath = [self.left_tbView indexPathForCell:cell];
    FX_ComListModel *model = [[FX_ComListModel alloc]init];
    if (_isSearch) {
        model = self.searchDataArray[indexpath.row];
    }else {
        model = self.leftDataArray[indexpath.row];
    }
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"shareImg.png"]];
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:model.content
                                         images:imageArray
                                            url:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/pu-tong-gong-zuo/id1167899764"]
                                          title:@"扑通工作"
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}

}

- (void)groundBtnPress {
    self.left_tbView.hidden = NO;
    self.right_tbView.hidden = YES;
    self.navView.groundBtn.selected = YES;
    self.navView.companyBtn.selected = NO;
    
    CGFloat y = self.left_tbView.contentOffset.y;
    if (y >= 40) {
        self.navView.searchBtn.hidden = YES;
    }else {
        self.navView.searchBtn.hidden = YES;
    }
}

- (void)companyBtnPress {
    
    self.left_tbView.hidden = YES;
    self.right_tbView.hidden = NO;
    self.navView.groundBtn.selected = NO;
    self.navView.companyBtn.selected = YES;
    
    CGFloat y = self.right_tbView.contentOffset.y;
    if (y >= 40) {
        self.navView.searchBtn.hidden = YES;
    }else {
        self.navView.searchBtn.hidden = YES;
    }
    if (_hasPress == NO) {
        [self comListApiNet];
        _hasPress = YES;
    }
    
}

- (void)searchBtnPress {
//    if (!isValidStr([GlobalData sharedInstance].selfInfo.sessionId)) {
//        [self presentLoginCtrl];
//        return;
//    }
    self.navView.hidden = YES;
    self.searchNavView.hidden = NO;
    self.searchView1.hidden = YES;
    self.searchView2.hidden = YES;
    
    
    self.isSearch = YES;
    [self.searchDataArray removeAllObjects];
    if (self.left_tbView.hidden == YES) {
        //搜索前是企业状态
        self.isGround = NO;
    }else {
        //搜索前是广场状态
        self.isGround = YES;
    }
    [self.left_tbView reloadData];
    [self.searchNavView.searchTF becomeFirstResponder];
}

- (void)cancelSearch {
    [self.view endEditing:YES];
    self.searchNavView.hidden = YES;
    self.navView.hidden = NO;
    self.searchView1.hidden = NO;
    self.searchView2.hidden = NO;
    
    [self.searchDataArray removeAllObjects];
    
    self.isSearch = NO;
    if (self.isGround == YES) {
        self.left_tbView.hidden = NO;
        self.right_tbView.hidden= YES;
    }else{
        self.left_tbView.hidden = YES;
        self.right_tbView.hidden= NO;
    }
    [self.left_tbView reloadData];
}

- (void)refresh {
    [self groundListApiNet];
    [self comListApiNet];
}

#pragma mark - NetworkApis
- (void)groundListApiNet {
    if (self.groundListApi && !self.groundListApi.requestOperation.isFinished) {
        [self.groundListApi stop];
    }
    self.groundListApi = [[FX_GroudListApi alloc]initWithPage:[NSString stringWithFormat:@"%ld",(long)_leftPage]];
    self.groundListApi.netLoadingDelegate = self;
    self.groundListApi.noNetWorkingDelegate = self;
    [self.groundListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        FX_GroudListApi *result = (FX_GroudListApi *)request;
        if (result.isCorrectResult) {
            if (_leftPage == 1) {
                self.leftDataArray = [NSMutableArray arrayWithArray:[result getGroudList]];
            }else {
                [self.leftDataArray addObjectsFromArray:[result getGroudList]];
            }
            [self.left_tbView reloadData];
            NSInteger count = [result getGroudList].count;
            if (count == 0) {
                [(MJRefreshAutoFooter *)self.left_tbView.mj_footer setHidden:YES];
            }else {
                [(MJRefreshAutoFooter *)self.left_tbView.mj_footer setHidden:NO];
            }
        }else {
            if (_leftPage > 1) {
                _leftPage --;
            }else {
                self.leftDataArray = [NSMutableArray array];
                [self.left_tbView reloadData];
            }
        }
        [self.left_tbView.mj_header endRefreshing];
        [self.left_tbView.mj_footer endRefreshing];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (_leftPage > 1) {
            _leftPage --;
        }else {
            [self.left_tbView.mj_header endRefreshing];
            [self.left_tbView.mj_footer endRefreshing];
        }
    }];
}

- (void)comListApiNet {
    if (isValidStr([GlobalData sharedInstance].selfInfo.companyName)) {
        
    
    if (self.comListApi && !self.comListApi.requestOperation.isFinished) {
        [self.comListApi stop];
    }
    self.comListApi = [[FX_ComListApi alloc]initWithPage:[NSString stringWithFormat:@"%ld",(long)_rightPage]];
    self.comListApi.netLoadingDelegate = self;
    self.comListApi.noNetWorkingDelegate = self;
    [self.comListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        FX_ComListApi *result = (FX_ComListApi *)request;
        if (result.isCorrectResult) {
            if (_rightPage == 1) {
                self.rightDataArray = [NSMutableArray arrayWithArray:[result getComList]];
            }else {
                [self.rightDataArray addObjectsFromArray:[result getComList]];
            }
            [self.right_tbView reloadData];
            NSInteger count = [result getComList].count;
            if (count == 0) {
                [(MJRefreshAutoFooter *)self.right_tbView.mj_footer setHidden:YES];
            }else {
                [(MJRefreshAutoFooter *)self.right_tbView.mj_footer setHidden:NO];
            }
        }else {
            if (_rightPage > 1) {
                _rightPage --;
            }else {
                self.rightDataArray = [NSMutableArray array];
                [self.right_tbView reloadData];
            }
        }
        [self.right_tbView.mj_header endRefreshing];
        [self.right_tbView.mj_footer endRefreshing];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (_rightPage > 1) {
            _rightPage --;
        }else {
            [self.right_tbView.mj_header endRefreshing];
            [self.right_tbView.mj_footer endRefreshing];
        }
    }];
        
    }
}

- (void)searchApiNet {
    if (self.searchApi && !self.searchApi.requestOperation.isFinished) {
        [self.searchApi stop];
    }
    self.searchApi = [[FX_SearchListApi alloc]initWithPage:[NSString stringWithFormat:@"%ld",(long)_searchPage] withKeyword:self.searchNavView.searchTF.text];
    self.searchApi.netLoadingDelegate = self;
    self.searchApi.noNetWorkingDelegate = self;
    [self.searchApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        FX_SearchListApi *result = (FX_SearchListApi *)request;
        if (result.isCorrectResult) {
            if (_searchPage == 1) {
                self.searchDataArray = [NSMutableArray arrayWithArray:[result getSearchList]];
            }else {
                [self.searchDataArray addObjectsFromArray:[result getSearchList]];
            }
            [self.left_tbView reloadData];
            NSInteger count = [result getSearchList].count;
            if (count == 0) {
                [(MJRefreshAutoFooter *)self.left_tbView.mj_footer setHidden:YES];
            }else {
                [(MJRefreshAutoFooter *)self.left_tbView.mj_footer setHidden:NO];
            }
        }else {
            if (_searchPage > 1) {
                _searchPage --;
            }else {
                self.searchDataArray = [NSMutableArray array];
                [self.left_tbView reloadData];
            }
        }
        [self.left_tbView.mj_header endRefreshing];
        [self.left_tbView.mj_footer endRefreshing];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (_searchPage > 1) {
            _searchPage --;
        }else {
            [self.left_tbView.mj_header endRefreshing];
            [self.left_tbView.mj_footer endRefreshing];
        }
    }];
}

- (void)giveGreatApiNetWithTzId:(NSString *)tzId {
    if (!isValidStr([GlobalData sharedInstance].selfInfo.sessionId))
    {
        [self presentLoginCtrl];
        return;
    }
    
    if(self.giveGreatApi&& !self.giveGreatApi.requestOperation.isFinished)
    {
        [self.giveGreatApi stop];
    }
    
    self.giveGreatApi = [[FX_GiveGreatApi alloc]initWithtzId:tzId];
    self.giveGreatApi.sessionDelegate = self;
    [self.giveGreatApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        FX_GiveGreatApi *result = (FX_GiveGreatApi *)request;
        if(result.isCorrectResult)
        {
            
        }
    } failure:^(YTKBaseRequest *request) {
        
    }];
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.left_tbView) {
        if (self.isSearch) {
            return self.searchDataArray.count;
        }else {
            return self.leftDataArray.count;
        }
        return 10;
    }else if (tableView == self.right_tbView) {
        return self.rightDataArray.count;
    }else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.left_tbView) {
        FX_ComListModel *model = [[FX_ComListModel alloc]init];
        if (self.isSearch) {
            if (self.searchDataArray.count > 0 ) {
                model = self.searchDataArray[indexPath.row];
            }
        }else {
            if (self.leftDataArray.count > 0) {
                model = self.leftDataArray[indexPath.row];
            }
            
        }
        CGFloat height = [ControlUtil heightWithContent:model.content withFont:[UIFont systemFontOfSize:15] withWidth:FITWIDTH(326)];
        if (model.imgUrl.length < 6) {
            
          
            if (height > 60) {
                return 181;
            }else {
                return 181 - 60 + height;
            }
        }else if([model.fileType isEqualToString:@"2"]){
           
             return 154 ;
        } else {
            return 181;
        }
        
    }else if (tableView == self.right_tbView) {
        if (indexPath.row == 0) {
            return 200;
        }else {
            FX_ComListModel *model = [[FX_ComListModel alloc]init];
            model = self.rightDataArray[indexPath.row];
            
            if (model.imgUrl.length < 6) {
                //无图
                CGFloat height = [ControlUtil heightWithContent:model.content withFont:[UIFont systemFontOfSize:15] withWidth:FITWIDTH(326)];
                if (height > 60) {
                    return 181;
                }else {
                    return 181 - 60 + height;
                }
            }else {
                //有图
                return 181;
            }
        }
    }else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.left_tbView) {
        FX_ComListModel *model = [[FX_ComListModel alloc]init];
        if (self.isSearch) {
            if (self.searchDataArray.count > 0 ) {
                model = self.searchDataArray[indexPath.row];
            }
        }else {
            if (self.leftDataArray.count > 0) {
                model = self.leftDataArray[indexPath.row];
            }
            
        }
        
        if([model.fileType isEqualToString:@"1"]) {
            //图片或者文字
            if (model.imgUrl.length < 6) {
                //纯文本
                static NSString *left_Identifier = @"GroundNoImageTableViewCell";
                GroundNoImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:left_Identifier];
                if (cell == nil) {
                    cell = [[NSBundle mainBundle] loadNibNamed:@"GroundNoImageTableViewCell" owner:nil options:nil].lastObject;
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentLabel.text = model.content;
                
                [cell.smallImageView sd_setImageWithURL:[NSURL URLWithString:model.headerUrl] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
                ZRViewRadius(cell.smallImageView, 12);
                cell.nickNameLabel.text = model.nickName;
                cell.comNameLbel.text = model.companyName;
                cell.timeLabel.text = model.time;
                [cell.zanNumLabel setTitle:model.greatNum forState:UIControlStateNormal];
                [cell.commentNumLabel setTitle:model.commentNum forState:UIControlStateNormal];
                [cell.addressLabel setTitle:model.address forState:UIControlStateNormal];
                
                
                [cell.shareBtn addTarget:self action:@selector(shareActionWithContent:) forControlEvents:UIControlEventTouchUpInside];
                
                if ([model.companyName isEqualToString:@""] || model.companyName == nil || [model.companyName isKindOfClass:[NSNull class]]) {
                    cell.shuView.hidden = YES;
                }else {
                    cell.shuView.hidden = NO;
                }
                
                CGFloat width1 = [ControlUtil widthWithContent:model.nickName withFont:[UIFont systemFontOfSize:14] withHeight:21];
                cell.nickNameWidthLabel.constant = width1;
                
                CGFloat height = [ControlUtil heightWithContent:model.content withFont:[UIFont systemFontOfSize:15] withWidth:FITWIDTH(326)];
                if (height >= 60) {
                    height = 60;
                }
                cell.labelHeightCons.constant = height;
                
                if ([model.isLike isEqualToString:@"1"]) {
                    cell.zanBtn.selected = YES;
                }else {
                    cell.zanBtn.selected = NO;
                }
                [cell.zanBtn addTarget:self action:@selector(dianzanActionNO:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            } else {
                //带图的
                static NSString *left_Identifier = @"GroundTableViewCell";
                GroundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:left_Identifier];
                if (cell == nil) {
                    cell = [[NSBundle mainBundle] loadNibNamed:@"GroundTableViewCell" owner:nil options:nil].lastObject;
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentLabel.text = model.content;
                [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"moren_pt"]];
                [cell.smallImageView sd_setImageWithURL:[NSURL URLWithString:model.headerUrl] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
                ZRViewRadius(cell.smallImageView, 12);
                cell.nickNameLabel.text = model.nickName;
                cell.comNameLbel.text = model.companyName;
                cell.timeLabel.text = model.time;
                [cell.zanNumLabel setTitle:model.greatNum forState:UIControlStateNormal];
                [cell.commentNumLabel setTitle:model.commentNum forState:UIControlStateNormal];
                [cell.addressLabel setTitle:model.address forState:UIControlStateNormal];
                
                
                [cell.shareBtn addTarget:self action:@selector(shareActionWithContent:) forControlEvents:UIControlEventTouchUpInside];
                
                if ([model.companyName isEqualToString:@""] || model.companyName == nil || [model.companyName isKindOfClass:[NSNull class]]) {
                    cell.shuView.hidden = YES;
                }else {
                    cell.shuView.hidden = NO;
                }
                
                
                
                CGFloat height = [ControlUtil heightWithContent:model.content withFont:[UIFont systemFontOfSize:15] withWidth:FITWIDTH(326)];
                if (height >= 60) {
                    height = 60;
                }
                cell.labelHeightCons.constant = height;
                
                if ([model.isLike isEqualToString:@"1"]) {
                    cell.zanBtn.selected = YES;
                }else {
                    cell.zanBtn.selected = NO;
                }
                [cell.zanBtn addTarget:self action:@selector(dianzanActionNO:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }
            
            

        } else if ([model.fileType isEqualToString:@"2"]){
            //语音
          
            static NSString *left_Identifier = @"GroupSpeechTableViewCell";
            GroupSpeechTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:left_Identifier];
            
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"GroupSpeechTableViewCell" owner:nil options:nil].lastObject;
            }
            
            [cell.smallImageView sd_setImageWithURL:[NSURL URLWithString:model.headerUrl] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
            ZRViewRadius(cell.smallImageView, 12);
            cell.nickNameLabel.text = model.nickName;
            cell.comNameLabel.text = model.companyName;
            cell.timeLabel.text = model.time;
            [cell.zanNumLabel setTitle:model.greatNum forState:UIControlStateNormal];
            [cell.commentNumLabel setTitle:model.commentNum forState:UIControlStateNormal];
            [cell.addressLabel setTitle:model.address forState:UIControlStateNormal];
            cell.time.text = @"";
            [cell.playBtn setImage:[UIImage imageNamed:@"icon_yuying"] forState:UIControlStateNormal];
            cell.playBtn.tag = indexPath.row;
            [cell.playBtn addTarget:self action:@selector(playGroundSpeech:) forControlEvents:UIControlEventTouchUpInside];
            
            
            cell.time.text = [self caculateSpeechTime:model.imgUrl withMessageId:model.tzId];
            
            [cell.shareBtn addTarget:self action:@selector(shareActionWithContent:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([model.companyName isEqualToString:@""] || model.companyName == nil || [model.companyName isKindOfClass:[NSNull class]]) {
                cell.shuView.hidden = YES;
            }else {
                cell.shuView.hidden = NO;
            }

            
            CGFloat height = [ControlUtil heightWithContent:model.content withFont:[UIFont systemFontOfSize:15] withWidth:FITWIDTH(326)];
            if (height >= 60) {
                height = 60;
            }

            
            if ([model.isLike isEqualToString:@"1"]) {
                cell.zanBtn.selected = YES;
            }else {
                cell.zanBtn.selected = NO;
            }
            [cell.zanBtn addTarget:self action:@selector(dianzanActionNO:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
            
            
        } else {
            //视频，先用image的cell
            
            static NSString *left_Identifier = @"GroundTableViewCell";
            GroundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:left_Identifier];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"GroundTableViewCell" owner:nil options:nil].lastObject;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentLabel.text = model.content;
            [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"moren_pt"]];
            [cell.smallImageView sd_setImageWithURL:[NSURL URLWithString:model.headerUrl] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
            ZRViewRadius(cell.smallImageView, 12);
            cell.nickNameLabel.text = model.nickName;
            cell.comNameLbel.text = model.companyName;
            cell.timeLabel.text = model.time;
            [cell.zanNumLabel setTitle:model.greatNum forState:UIControlStateNormal];
            [cell.commentNumLabel setTitle:model.commentNum forState:UIControlStateNormal];
            [cell.addressLabel setTitle:model.address forState:UIControlStateNormal];
            
            
            [cell.shareBtn addTarget:self action:@selector(shareActionWithContent:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([model.companyName isEqualToString:@""] || model.companyName == nil || [model.companyName isKindOfClass:[NSNull class]]) {
                cell.shuView.hidden = YES;
            }else {
                cell.shuView.hidden = NO;
            }
            

            
            CGFloat height = [ControlUtil heightWithContent:model.content withFont:[UIFont systemFontOfSize:15] withWidth:FITWIDTH(326)];
            if (height >= 60) {
                height = 60;
            }
            cell.labelHeightCons.constant = height;
            
            if ([model.isLike isEqualToString:@"1"]) {
                cell.zanBtn.selected = YES;
            }else {
                cell.zanBtn.selected = NO;
            }
            [cell.zanBtn addTarget:self action:@selector(dianzanActionNO:) forControlEvents:UIControlEventTouchUpInside];
            return cell;

        }
        
        
    }else if (tableView == self.right_tbView) {
        //显示公司页数据
        if (indexPath.row == 0) {
            static NSString *left_Identifier = @"Discover_companyTableViewCell";
            Discover_companyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:left_Identifier];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"Discover_companyTableViewCell" owner:nil options:nil].lastObject;
            }
            cell.companyName.text = [GlobalData sharedInstance].selfInfo.companyName;
            [cell.m_ImageView sd_setImageWithURL:[NSURL URLWithString:[GlobalData sharedInstance].selfInfo.companyImg] placeholderImage:[UIImage imageNamed:@"moren_pt"]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else {
            FX_ComListModel *model = [[FX_ComListModel alloc]init];
            model = self.rightDataArray[indexPath.row - 1];
            if([model.fileType isEqualToString:@"1"]) {
                //图片或者文字
                if (model.imgUrl.length < 6) {
                    //纯文本
                    static NSString *left_Identifier = @"GroundNoImageTableViewCell";
                    GroundNoImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:left_Identifier];
                    if (cell == nil) {
                        cell = [[NSBundle mainBundle] loadNibNamed:@"GroundNoImageTableViewCell" owner:nil options:nil].lastObject;
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.contentLabel.text = model.content;
                    
                    [cell.smallImageView sd_setImageWithURL:[NSURL URLWithString:model.headerUrl] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
                    ZRViewRadius(cell.smallImageView, 12);
                    cell.nickNameLabel.text = model.nickName;
                    cell.comNameLbel.text = model.companyName;
                    cell.timeLabel.text = model.time;
                    [cell.zanNumLabel setTitle:model.greatNum forState:UIControlStateNormal];
                    [cell.commentNumLabel setTitle:model.commentNum forState:UIControlStateNormal];
                    [cell.addressLabel setTitle:model.address forState:UIControlStateNormal];
                    
                    
                    [cell.shareBtn addTarget:self action:@selector(shareActionWithContent:) forControlEvents:UIControlEventTouchUpInside];
                    
                    if ([model.companyName isEqualToString:@""] || model.companyName == nil || [model.companyName isKindOfClass:[NSNull class]]) {
                        cell.shuView.hidden = YES;
                    }else {
                        cell.shuView.hidden = NO;
                    }
                    
                    CGFloat width1 = [ControlUtil widthWithContent:model.nickName withFont:[UIFont systemFontOfSize:14] withHeight:21];
                    cell.nickNameWidthLabel.constant = width1;
                    
                    CGFloat height = [ControlUtil heightWithContent:model.content withFont:[UIFont systemFontOfSize:15] withWidth:FITWIDTH(326)];
                    if (height >= 60) {
                        height = 60;
                    }
                    cell.labelHeightCons.constant = height;
                    
                    if ([model.isLike isEqualToString:@"1"]) {
                        cell.zanBtn.selected = YES;
                    }else {
                        cell.zanBtn.selected = NO;
                    }
                    [cell.zanBtn addTarget:self action:@selector(dianzanActionNO:) forControlEvents:UIControlEventTouchUpInside];
                    return cell;
                } else {
                    //带图的
                    static NSString *left_Identifier = @"GroundTableViewCell";
                    GroundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:left_Identifier];
                    if (cell == nil) {
                        cell = [[NSBundle mainBundle] loadNibNamed:@"GroundTableViewCell" owner:nil options:nil].lastObject;
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.contentLabel.text = model.content;
                    [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"moren_pt"]];
                    [cell.smallImageView sd_setImageWithURL:[NSURL URLWithString:model.headerUrl] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
                    ZRViewRadius(cell.smallImageView, 12);
                    cell.nickNameLabel.text = model.nickName;
                    cell.comNameLbel.text = model.companyName;
                    cell.timeLabel.text = model.time;
                    [cell.zanNumLabel setTitle:model.greatNum forState:UIControlStateNormal];
                    [cell.commentNumLabel setTitle:model.commentNum forState:UIControlStateNormal];
                    [cell.addressLabel setTitle:model.address forState:UIControlStateNormal];
                    
                    
                    [cell.shareBtn addTarget:self action:@selector(shareActionWithContent:) forControlEvents:UIControlEventTouchUpInside];
                    
                    if ([model.companyName isEqualToString:@""] || model.companyName == nil || [model.companyName isKindOfClass:[NSNull class]]) {
                        cell.shuView.hidden = YES;
                    }else {
                        cell.shuView.hidden = NO;
                    }
                    
                    
                    
                    CGFloat height = [ControlUtil heightWithContent:model.content withFont:[UIFont systemFontOfSize:15] withWidth:FITWIDTH(326)];
                    if (height >= 60) {
                        height = 60;
                    }
                    cell.labelHeightCons.constant = height;
                    
                    if ([model.isLike isEqualToString:@"1"]) {
                        cell.zanBtn.selected = YES;
                    }else {
                        cell.zanBtn.selected = NO;
                    }
                    [cell.zanBtn addTarget:self action:@selector(dianzanActionNO:) forControlEvents:UIControlEventTouchUpInside];
                    return cell;
                }
                
                
                
            } else if ([model.fileType isEqualToString:@"2"]){
                //语音
                
                static NSString *left_Identifier = @"GroupSpeechTableViewCell";
                GroupSpeechTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:left_Identifier];
                if (cell == nil) {
                    cell = [[NSBundle mainBundle] loadNibNamed:@"GroupSpeechTableViewCell" owner:nil options:nil].lastObject;
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

                [cell.smallImageView sd_setImageWithURL:[NSURL URLWithString:model.headerUrl] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
                ZRViewRadius(cell.smallImageView, 12);
                cell.nickNameLabel.text = model.nickName;
                cell.comNameLabel.text = model.companyName;
                cell.timeLabel.text = model.time;
                [cell.zanNumLabel setTitle:model.greatNum forState:UIControlStateNormal];
                [cell.commentNumLabel setTitle:model.commentNum forState:UIControlStateNormal];
                [cell.addressLabel setTitle:model.address forState:UIControlStateNormal];
                
                [cell.playBtn setImage:[UIImage imageNamed:@"icon_yuying"] forState:UIControlStateNormal];
                cell.playBtn.tag = indexPath.row;
                [cell.playBtn addTarget:self action:@selector(playSpeech:) forControlEvents:UIControlEventTouchUpInside];
                [cell.shareBtn addTarget:self action:@selector(shareActionWithContent:) forControlEvents:UIControlEventTouchUpInside];
                
                if ([model.companyName isEqualToString:@""] || model.companyName == nil || [model.companyName isKindOfClass:[NSNull class]]) {
                    cell.shuView.hidden = YES;
                }else {
                    cell.shuView.hidden = NO;
                }
                
                
                CGFloat height = [ControlUtil heightWithContent:model.content withFont:[UIFont systemFontOfSize:15] withWidth:FITWIDTH(326)];
                if (height >= 60) {
                    height = 60;
                }
                
                
                if ([model.isLike isEqualToString:@"1"]) {
                    cell.zanBtn.selected = YES;
                }else {
                    cell.zanBtn.selected = NO;
                }
                [cell.zanBtn addTarget:self action:@selector(dianzanActionNO:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
                
                
            } else {
                //视频，先用image的cell
                
                static NSString *left_Identifier = @"GroundTableViewCell";
                GroundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:left_Identifier];
                if (cell == nil) {
                    cell = [[NSBundle mainBundle] loadNibNamed:@"GroundTableViewCell" owner:nil options:nil].lastObject;
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentLabel.text = model.content;
                [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"moren_pt"]];
                [cell.smallImageView sd_setImageWithURL:[NSURL URLWithString:model.headerUrl] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
                ZRViewRadius(cell.smallImageView, 12);
                cell.nickNameLabel.text = model.nickName;
                cell.comNameLbel.text = model.companyName;
                cell.timeLabel.text = model.time;
                [cell.zanNumLabel setTitle:model.greatNum forState:UIControlStateNormal];
                [cell.commentNumLabel setTitle:model.commentNum forState:UIControlStateNormal];
                [cell.addressLabel setTitle:model.address forState:UIControlStateNormal];
                
                
                [cell.shareBtn addTarget:self action:@selector(shareActionWithContent:) forControlEvents:UIControlEventTouchUpInside];
                
                if ([model.companyName isEqualToString:@""] || model.companyName == nil || [model.companyName isKindOfClass:[NSNull class]]) {
                    cell.shuView.hidden = YES;
                }else {
                    cell.shuView.hidden = NO;
                }
                
                CGFloat height = [ControlUtil heightWithContent:model.content withFont:[UIFont systemFontOfSize:15] withWidth:FITWIDTH(326)];
                if (height >= 60) {
                    height = 60;
                }
                cell.labelHeightCons.constant = height;
                
                if ([model.isLike isEqualToString:@"1"]) {
                    cell.zanBtn.selected = YES;
                }else {
                    cell.zanBtn.selected = NO;
                }
                [cell.zanBtn addTarget:self action:@selector(dianzanActionNO:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
                
            }
        }
    }else {
        return nil;
    }
}

//计算语音时长
- (NSString *)caculateSpeechTime:(NSString *)url withMessageId:(NSString *)messageId{
    
    //将语音写入缓存,获取录音时长
    NSString * string;
    
    NSError *error;
    NSLog(@"%@",url);
    NSData *audioData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *amrfilePath = [NSString stringWithFormat:@"%@/%@.aac", docDirPath , messageId];
    [audioData writeToFile:amrfilePath atomically:YES];
    NSLog(@"%@",amrfilePath);
    
     AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:amrfilePath] error:&error];
    float seconds =  (float)player.duration;
    
    int disSecond = ceilf(seconds);
    string = [NSString stringWithFormat:@"%d秒",disSecond];
    NSLog(@"%@",string);
    return string;
}

- (void)playGroundSpeech:(UIButton *)sender{
    //广场列表的播放录音
    FX_ComListModel *model = [[FX_ComListModel alloc]init];
    if (self.isSearch) {
        if (self.searchDataArray.count > 0 ) {
            model = self.searchDataArray[sender.tag];
        }
    }else {
        if (self.leftDataArray.count > 0) {
            model = self.leftDataArray[sender.tag];
        }
    }
    if([model.fileType isEqualToString:@"2"]){
                NSError *error;
        NSLog(@"当前文件地址%@",model.imgUrl);
        NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//        NSData *audioData = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.imgUrl]];
     
        
        NSString *amrfilePath = [NSString stringWithFormat:@"%@/%@.aac", docDirPath , model.tzId];
//        [audioData writeToFile:amrfilePath atomically:YES];
        NSLog(@"%@",amrfilePath);
        self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:amrfilePath] error:&error];
        
        if (self.player == nil){
            NSLog(@"AudioPlayer did not load properly: %@", [error description]);
        }else{
            [self.player play];
        }
        
        if (error) {
            NSLog(@"error:%@",[error description]);
            return;
        }
    }
}

- (void)playSpeech:(UIButton *)sender{
    //公司列表播放录音
    FX_ComListModel *model = [[FX_ComListModel alloc]init];
    model = self.rightDataArray[sender.tag - 1];
    if([model.fileType isEqualToString:@"2"]){
        self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:model.imgUrl] error:nil];
        NSError *error;
        
        self.player.volume=1;
        if (error) {
            NSLog(@"error:%@",[error description]);
            return;
        }
        //准备播放
        [self.player prepareToPlay];
        //播放
        [self.player play];
    }
}

- (void)dianzanActionNO:(UIButton *)sender {
    if (!isValidStr([GlobalData sharedInstance].selfInfo.sessionId))
    {
        [self presentLoginCtrl];
        return;
    }
    
    GroundNoImageTableViewCell *cell = (GroundNoImageTableViewCell *)sender.superview.superview.superview;
    NSIndexPath *indexpath = [self.left_tbView indexPathForCell:cell];
    FX_ComListModel *model = [[FX_ComListModel alloc]init];
    if (_isSearch) {
        model = self.searchDataArray[indexpath.row];
    }else {
        model = self.leftDataArray[indexpath.row];
    }
    if (cell.zanBtn.selected == YES) {
        NSInteger n = cell.zanNumLabel.titleLabel.text.integerValue;
        NSString *nowNum = [NSString stringWithFormat:@"%ld",(long)n - 1];
        [cell.zanNumLabel setTitle:nowNum forState:UIControlStateNormal];
    }else {
        NSInteger n = cell.zanNumLabel.titleLabel.text.integerValue;
        NSString *nowNum = [NSString stringWithFormat:@"%ld",(long)n + 1];
        [cell.zanNumLabel setTitle:nowNum forState:UIControlStateNormal];
    }
    [self giveGreatApiNetWithTzId:model.tzId];
    cell.zanBtn.selected = !cell.zanBtn.selected;
    
    
}

- (void)dianzanActionHas:(UIButton *)sender {
    if (!isValidStr([GlobalData sharedInstance].selfInfo.sessionId))
    {
        [self presentLoginCtrl];
        return;
    }
    GroundTableViewCell *cell = (GroundTableViewCell *)sender.superview.superview.superview;
    NSIndexPath *indexpath = [self.left_tbView indexPathForCell:cell];
    FX_ComListModel *model = [[FX_ComListModel alloc]init];
    if (_isSearch) {
        model = self.searchDataArray[indexpath.row];
    }else {
        model = self.leftDataArray[indexpath.row];
    }
    if (cell.zanBtn.selected == YES) {
        NSInteger n = cell.zanNumLabel.titleLabel.text.integerValue;
        NSString *nowNum = [NSString stringWithFormat:@"%ld",(long)n - 1];
        [cell.zanNumLabel setTitle:nowNum forState:UIControlStateNormal];
    }else {
        NSInteger n = cell.zanNumLabel.titleLabel.text.integerValue;
        NSString *nowNum = [NSString stringWithFormat:@"%ld",(long)n + 1];
        [cell.zanNumLabel setTitle:nowNum forState:UIControlStateNormal];
    }
    [self giveGreatApiNetWithTzId:model.tzId];
    cell.zanBtn.selected = !cell.zanBtn.selected;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Discover_DetailViewController *ctrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Discover_DetailViewController"];
    FX_ComListModel *model;
    if (tableView == self.left_tbView) {
        if (_isSearch) {
            model = self.searchDataArray[indexPath.row];
        }else {
            model = self.leftDataArray[indexPath.row];
        }
        
    }else {
        if (indexPath.row == 0) {
            return;
        }
        model = self.rightDataArray[indexPath.row - 1];
    }
    
    ctrl.tzId = model.tzId;
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.left_tbView) {
        if (scrollView.contentOffset.y >= 40) {
            self.navView.searchBtn.hidden = NO;
        }else {
            self.navView.searchBtn.hidden = YES;
        }
    }else {
        if (scrollView.contentOffset.y >= 40) {
            self.navView.searchBtn.hidden = NO;
        }else {
            self.navView.searchBtn.hidden = YES;
        }
    }
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (!isValidStr(textField.text)) {
        [XHToast showCenterWithText:@"请输入关键词"];
        return NO;
    }
    self.left_tbView.hidden = NO;
    self.right_tbView.hidden = YES;
    [self searchApiNet];
    return YES;
}


#pragma mark - lazyViews
- (UIImageView *)nodataImgView {
    if (_nodataImgView == nil) {
        _nodataImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 250, FITWIDTH(200) * 2.2, FITWIDTH(200))];
        _nodataImgView.centerX = self.view.centerX;
        _nodataImgView.image = [UIImage imageNamed:@"kongbai"];
    }
    return _nodataImgView;
}

- (NSMutableArray *)leftDataArray {
    if (_leftDataArray == nil) {
        _leftDataArray = [[NSMutableArray alloc]init];
    }
    return _leftDataArray;
}

- (NSMutableArray *)rightDataArray {
    if (_rightDataArray == nil) {
        _rightDataArray = [[NSMutableArray alloc]init];
    }
    return _rightDataArray;
}

- (NSMutableArray *)searchDataArray {
    if (_searchDataArray == nil) {
        _searchDataArray = [NSMutableArray array];
    }
    return _searchDataArray;
}

- (UITableView *)left_tbView {
    if (_left_tbView == nil) {
        _left_tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) style:UITableViewStylePlain];
        _left_tbView.delegate = self;
        _left_tbView.dataSource = self;
        _left_tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _left_tbView.backgroundColor = BackgroundColor;
        _left_tbView.tableHeaderView = self.searchView1;

        
        _left_tbView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _leftPage = 1;
            [self groundListApiNet];
        }];
        _left_tbView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            if (_leftDataArray.count == 0 && _leftPage) {
                _leftPage = 1;
            }else {
                _leftPage ++;
            }
            [self groundListApiNet];
        }];
    }
    return _left_tbView;
}

- (UITableView *)right_tbView {
    if (_right_tbView == nil) {
        _right_tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) style:UITableViewStylePlain];
        _right_tbView.delegate = self;
        _right_tbView.dataSource = self;
        _right_tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _right_tbView.backgroundColor = BackgroundColor;
        _right_tbView.tableHeaderView = self.searchView2;
        _right_tbView.hidden = YES;

        
        _right_tbView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _rightPage = 1;
            [self comListApiNet];
        }];
        _right_tbView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            if (_rightDataArray.count == 0 && _rightPage) {
                _rightPage = 1;
            }else {
                _rightPage ++;
            }
            [self comListApiNet];
        }];
    }
    return _right_tbView;
}

- (DiscoverNavView *)navView {
    if (_navView == nil) {
        _navView = [[NSBundle mainBundle] loadNibNamed:@"DiscoverNavView" owner:nil options:nil].lastObject;
        [_navView.publishBtn addTarget:self action:@selector(publishBtnPress) forControlEvents:UIControlEventTouchUpInside];
        [_navView.groundBtn addTarget:self action:@selector(groundBtnPress) forControlEvents:UIControlEventTouchUpInside];
        [_navView.companyBtn addTarget:self action:@selector(companyBtnPress) forControlEvents:UIControlEventTouchUpInside];
        [_navView.searchBtn addTarget:self action:@selector(searchBtnPress) forControlEvents:UIControlEventTouchUpInside];
        _navView.groundBtn.selected = YES;
        _navView.companyBtn.selected = NO;
        _navView.searchBtn.hidden = YES;
    }
    return _navView;
}

- (DisCover_SearchNavView *)searchNavView {
    if (_searchNavView == nil) {
        _searchNavView = [[NSBundle mainBundle] loadNibNamed:@"DisCover_SearchNavView" owner:nil options:nil].lastObject;
        UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 0, 15, 15)];
        leftView.image = [UIImage imageNamed:@"icon_shousuo"];
        UIView *reaLeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 45, 15)];
        [reaLeftView addSubview:leftView];
        _searchNavView.searchTF.leftView = reaLeftView;
        _searchNavView.searchTF.leftViewMode = UITextFieldViewModeAlways;
        UIImageView *rightView = [[UIImageView alloc]initWithFrame:CGRectMake(21, 1.5, 12, 12)];
        UIView *reaRightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 45, 15)];
        [reaRightView addSubview:rightView];
        rightView.image = [UIImage imageNamed:@"icon_guanbi"];
        _searchNavView.searchTF.rightView = reaRightView;
        _searchNavView.searchTF.rightViewMode = UITextFieldViewModeWhileEditing;
        _searchNavView.searchTF.delegate = self;
        _searchNavView.searchTF.textColor = WhiteColor;
        [_searchNavView.searchTF setValue:WhiteColor forKeyPath:@"_placeholderLabel.textColor"];
        [_searchNavView.cancelBtn addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
        _searchNavView.hidden = YES;
    }
    return _searchNavView;
}

- (UIView *)searchView1 {
    if (_searchView1 == nil) {
        _searchView1 = [[UIView alloc]init];
        _searchView1.backgroundColor = MainColor;
        _searchView1.frame = CGRectMake(0, 64, SCREEN_WIDTH, 40);
        
        UIView *whiteBgView = [[UIView alloc]initWithFrame:CGRectMake(12, 5, FITWIDTH(351), 30)];
        whiteBgView.backgroundColor = RGB(162, 192, 249);
        [_searchView1 addSubview:whiteBgView];
        
        UIImageView *searchImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2.0 - 33, 7, 15, 16)];
        searchImageView.image = [UIImage imageNamed:@"icon_shousuo.png"];
        [whiteBgView addSubview:searchImageView];
        ZRViewRadius(whiteBgView, 5);
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(searchImageView.x + 20, searchImageView.y, 25, 16)];
        label.font = [UIFont systemFontOfSize:12];
        label.text = @"搜索";
        label.textColor = [UIColor whiteColor];
        [whiteBgView addSubview:label];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = whiteBgView.frame;
        [btn addTarget:self action:@selector(searchBtnPress) forControlEvents:UIControlEventTouchUpInside];
        [whiteBgView addSubview:btn];
    }
    return _searchView1;
}

- (UIView *)searchView2 {
    if (_searchView2 == nil) {
        _searchView2 = [[UIView alloc]init];
        _searchView2.backgroundColor = MainColor;
        _searchView2.frame = CGRectMake(0, 64, SCREEN_WIDTH, 40);
        
        UIView *whiteBgView = [[UIView alloc]initWithFrame:CGRectMake(12, 5, FITWIDTH(351), 30)];
        whiteBgView.backgroundColor = RGB(162, 192, 249);
        [_searchView2 addSubview:whiteBgView];
        
        UIImageView *searchImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2.0 - 33, 7, 15, 16)];
        searchImageView.image = [UIImage imageNamed:@"icon_shousuo.png"];
        [whiteBgView addSubview:searchImageView];
        ZRViewRadius(whiteBgView, 5);
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(searchImageView.x + 20, searchImageView.y, 25, 16)];
        label.font = [UIFont systemFontOfSize:12];
        label.text = @"搜索";
        label.textColor = [UIColor whiteColor];
        [whiteBgView addSubview:label];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = whiteBgView.frame;
        [btn addTarget:self action:@selector(searchBtnPress) forControlEvents:UIControlEventTouchUpInside];
        [whiteBgView addSubview:btn];
    }
    return _searchView2;
}

- (void)setFrame {
    self.navView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    self.searchNavView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    self.searchView1.frame = CGRectMake(0, 64, SCREEN_WIDTH, 40);
}

@end
