//
//  CompanyDetailViewController.m
//  ptOS
//
//  Created by 周瑞 on 16/9/8.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "CompanyDetailViewController.h"
#import "QZ_CompanyDetailView1.h"
#import "QZ_CompanyDetailView2.h"
#import "CommentTableViewCell.h"
#import "ComDetail_JobTableViewCell.h"
#import "QZ_ComCommentApi.h"
#import "QZ_ComGiveJobsApi.h"
#import "MJRefresh.h"
#import "AFHTTPRequestOperation.h"
#import "QZ_MainComApi.h"
#import "QZ_FavoriteComApi.h"
#import "UIImageView+WebCache.h"
#import "QZ_ComGiveJobsModel.h"
#import "JobsDetailViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <MapKit/MapKit.h>
#import "MoviewViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "NSDate+JKExtension.h"
#import "AVPlayerController.h"

@interface CompanyDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _leftPage;
    NSInteger _rightPage;
    NSString *_coor;
    NSString *_videoUrl;
    
    UIView *_bigView;
    
    NSString *_msString;
    
    BOOL _isAll;
}
@property (nonatomic,strong)QZ_CompanyDetailView1 *detailView1;
@property (nonatomic,strong)QZ_CompanyDetailView2 *detailView2;

@property (nonatomic,strong)UITableView *left_tbView;
@property (nonatomic,strong)UITableView *right_tbView;

@property (nonatomic, strong)NSMutableArray * leftDataArray;
@property (nonatomic, strong)NSMutableArray *rightDataArray;

@property (nonatomic, strong)QZ_MainComApi *mainComApi;

@property (nonatomic, strong)QZ_ComCommentApi *commentListApi;
@property (nonatomic, strong)QZ_ComGiveJobsApi *giveJobListApi;
@property (nonatomic, strong)QZ_FavoriteComApi *favoriteApi;
@end

@implementation CompanyDetailViewController

#pragma mark - lifeCycles

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"公司详情";
    _leftPage = 1;
    _rightPage = 1;
    [self initUI];
    _isAll = NO;
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
- (void)initUI {
    self.left_tbView.tableHeaderView = self.detailView1;
    self.right_tbView.tableHeaderView = self.detailView2;
    
    [self.view addSubview:self.left_tbView];
    [self.view addSubview:self.right_tbView];
    self.right_tbView.hidden = YES;
    
    [self mainComApiNet];
    [self commentListApiNet];
    [self giveJobsListApiNet];
}


- (void)seeAllAction {
     CGFloat height1 = [ControlUtil heightWithContent:_msString withFont:[UIFont systemFontOfSize:14] withWidth:SCREEN_WIDTH - 32];
    self.detailView1.miaoshuHeightCons.constant = height1 + 70;
    self.detailView1.labelHeightCons.constant = height1 + 20;
    self.detailView1.seeAllBtn.hidden = YES;
    _isAll = YES;
    self.detailView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, 629 + height1 -70);
    self.left_tbView.tableHeaderView = self.detailView1;
}


- (void)videoAction {
    AVPlayerController *ctrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"AVPlayerController"];
    ctrl.url = _videoUrl;
    if (_videoUrl) {
        [self presentViewController:ctrl animated:YES completion:nil];
    } else {
        [XHToast showCenterWithText:@"视频加载错误"];
    }
    
}

- (void)navAction {
    
    if (isValidStr(_coor)) {
        NSArray *array = [_coor componentsSeparatedByString:@","];
        if (array.count > 1) {
            NSString *longti = array[0];
            NSString *lati = array[1];
            CLLocationCoordinate2D to = CLLocationCoordinate2DMake(lati.doubleValue, longti.doubleValue);
            
            //        to = [TQLocationConverter transformFromBaiduToGCJ:to];
            
            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:to addressDictionary:nil]];
            
            [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil] launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil] forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
        }
    }
}


- (void)attentionBtn {
    if (!isValidStr([GlobalData sharedInstance].selfInfo.sessionId))
    {
        [self presentLoginCtrl];
        return;
    }
    [self favoriteApiNet];
}

- (void)leftBtnPress {
    
    [self.right_tbView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.left_tbView setContentOffset:CGPointMake(0, 0) animated:YES];
    self.right_tbView.hidden = YES;
    self.left_tbView.hidden = NO;
    
//    self.detailView1.leftBtn.selected = YES;
//    [self.detailView1.leftBtn setBackgroundColor:MainColor];
//    self.detailView1.rightBtn.selected = NO;
//    self.detailView1.rightBtn.backgroundColor = WhiteColor;
    
//    self.detailView2.leftBtn.selected = YES;
//    [self.detailView2.leftBtn setBackgroundColor:MainColor];
//    self.detailView2.rightBtn.selected = NO;
//    self.detailView2.rightBtn.backgroundColor = WhiteColor;
    
    self.detailView1.leftBtn.userInteractionEnabled = NO;
    self.detailView2.leftBtn.userInteractionEnabled = NO;
    self.detailView1.rightBtn.userInteractionEnabled = YES;
    self.detailView2.rightBtn.userInteractionEnabled = YES;
}

- (void)rightBtnPress {
    [self.right_tbView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.left_tbView setContentOffset:CGPointMake(0, 0) animated:YES];
    self.right_tbView.hidden = NO;
    self.left_tbView.hidden = YES;
    
//    self.detailView1.leftBtn.selected = NO;
//    [self.detailView1.leftBtn setBackgroundColor:WhiteColor];
//    self.detailView1.rightBtn.selected = YES;
//    self.detailView1.rightBtn.backgroundColor = MainColor;
//    
//    self.detailView2.leftBtn.selected = NO;
//    [self.detailView2.leftBtn setBackgroundColor:WhiteColor];
//    self.detailView2.rightBtn.selected = YES;
//    self.detailView2.rightBtn.backgroundColor = MainColor;
    
    self.detailView1.leftBtn.userInteractionEnabled = YES;
    self.detailView2.leftBtn.userInteractionEnabled = YES;
    self.detailView1.rightBtn.userInteractionEnabled = NO;
    self.detailView2.rightBtn.userInteractionEnabled = NO;
}

#pragma mark - Networkapis 
- (void)commentListApiNet {
    if (self.commentListApi && !self.commentListApi.requestOperation.isFinished) {
        [self.commentListApi stop];
    }
    self.commentListApi = [[QZ_ComCommentApi alloc]initWithPage:[NSString stringWithFormat:@"%ld",(long)_leftPage] withCompanyId:self.companyId];
    self.commentListApi.netLoadingDelegate = self;
    self.commentListApi.noNetWorkingDelegate = self;
    [self.commentListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        QZ_ComCommentApi *result = (QZ_ComCommentApi *)request;
        if (result.isCorrectResult) {
            if (_leftPage == 1) {
                self.leftDataArray = [NSMutableArray arrayWithArray:[result getComComment]];
            }else {
                [self.leftDataArray addObjectsFromArray:[result getComComment]];
            }
            [self.left_tbView reloadData];
            NSInteger count = [result getComComment].count;
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

- (void)giveJobsListApiNet {
    if (self.giveJobListApi && !self.giveJobListApi.requestOperation.isFinished) {
        [self.giveJobListApi stop];
    }
    self.giveJobListApi = [[QZ_ComGiveJobsApi alloc] initWithCompanyId:self.companyId withPage:[NSString stringWithFormat:@"%ld",(long)_rightPage]];
    self.giveJobListApi.netLoadingDelegate = self;
    self.giveJobListApi.noNetWorkingDelegate = self;
    [self.giveJobListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        QZ_ComGiveJobsApi *result = (QZ_ComGiveJobsApi *)request;
        if (result.isCorrectResult) {
            if (_rightPage == 1) {
                QZ_ComGiveJobsModel *model = [result getComGiveJobs];
                self.rightDataArray = [NSMutableArray arrayWithArray:model.jobList];
            }else {
                QZ_ComGiveJobsModel *model = [result getComGiveJobs];
                [self.rightDataArray addObjectsFromArray:model.jobList];
            }
            QZ_ComGiveJobsModel *model = [result getComGiveJobs];
            NSString *time = model.xysj;
            CGFloat time1 = time.floatValue;
            NSString *time2 = [NSString stringWithFormat:@"%.0f",time1];
            self.detailView2.xiangyingTimeLabel.text = time2;
            self.detailView2.needNumLabel.text = model.dzrs;
            CGFloat width1 = [ControlUtil widthWithContent:time2 withFont:[UIFont systemFontOfSize:18] withHeight:18];
            CGFloat width2 = [ControlUtil widthWithContent:model.dzrs withFont:[UIFont systemFontOfSize:18] withHeight:18];
            
            self.detailView2.xiangyingTimeLabel.width = width1;
            self.detailView2.needNumLabel.width = width2;
            self.detailView2.tianLabel.x = self.detailView2.xiangyingTimeLabel.x + width1 + 3;
            self.detailView2.renLabel.x = self.detailView2.needNumLabel.x + width2 + 3;
            [self.right_tbView reloadData];
            NSInteger count = [result getComGiveJobs].jobList.count;
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

- (void)mainComApiNet {
    if(self.mainComApi && !self.mainComApi.requestOperation.isFinished)
    {
        [self.mainComApi stop];
    }
    
    self.mainComApi.sessionDelegate = self;
    self.mainComApi = [[QZ_MainComApi alloc]initWithCompanyId:self.companyId];
    self.mainComApi.netLoadingDelegate = self;
    [self.mainComApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        QZ_MainComApi *result = (QZ_MainComApi *)request;
        if(result.isCorrectResult)
        {
            QZ_MainComModel *model = [result getMainCom];
            self.detailView1.comNameLabel.text = model.company;
            self.detailView1.comTypeLabel.text = model.gsxz;
            if ([model.isCollect isEqualToString:@"1"]) {
                self.detailView1.attentionBtn.selected = YES;
                self.detailView2.attentionBtn.selected = YES;
                ZRViewRadius(self.detailView1.headerImageView, 12);
                ZRViewRadius(self.detailView2.headerImageView, 12);
                
            }else {
                self.detailView1.attentionBtn.selected = NO;
                self.detailView2.attentionBtn.selected = NO;
            }
            if ([model.isZZ isEqualToString:@"1"]) {
                self.detailView1.isRZImageVIew.hidden = NO;
            }else {
                self.detailView1.isRZImageVIew.hidden = YES;
            }
            
            _videoUrl = model.gshj;
//            NSLog(@"%@")
//            _videoUrl = @"http://www.jxgbwlxy.gov.cn/tm/course/041629011/sco1/1.mp4";
            
//            UIImage *image =  [self firstFrameWithVideoURL:[NSURL URLWithString:_videoUrl] size:CGSizeMake(200, 100)];
            UIImage *image = [self thumbnailImageForVideo:[NSURL URLWithString:_videoUrl] atTime:1];
            self.detailView1.videoImage.image = image;
            [self.detailView1.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.companyImage] placeholderImage:[UIImage imageNamed:@"moren_pt"]];
            [self.detailView2.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.companyImage] placeholderImage:[UIImage imageNamed:@"moren_pt"]];
            self.detailView2.attentionNumLabel.text = [NSString stringWithFormat:@"%@人已关注",model.collectNum];
            self.detailView1.attentionNumLabel.text = [NSString stringWithFormat:@"%@人已关注",model.collectNum];
            self.detailView1.comIntroduceLabel.text = model.gsjs;
            
            _coor = model.coordinate;
            _msString = model.gsjs;
            CGFloat height1 = [ControlUtil heightWithContent:model.gsjs withFont:[UIFont systemFontOfSize:14] withWidth:SCREEN_WIDTH - 40];
            if (_isAll) {
                
            }else {
            if (height1 > 101) {
                self.detailView1.miaoshuHeightCons.constant = 102 + 100;
                self.detailView1.labelHeightCons.constant = 102;
                self.detailView1.seeAllBtn.hidden = NO;
            }else {
                self.detailView1.miaoshuHeightCons.constant = height1 + 50;
                self.detailView1.labelHeightCons.constant = height1;
                self.detailView1.seeAllBtn.hidden = YES;
            }
            }
            
            self.detailView1.addressLabel.text = model.address;
            self.detailView1.commentNumLabel.text = [NSString stringWithFormat:@"公司评价(%@)",model.gspj];

            if ([model.isZZ isEqualToString:@"1"]) {
                self.detailView2.isRZImageView.hidden = NO;
            }else {
                self.detailView2.isRZImageView.hidden = YES;
            }
            [self.detailView2.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.companyImage] placeholderImage:[UIImage imageNamed:@"moren_pt"]];
            self.detailView2.comNameLabel.text = model.company;
            self.detailView2.comTypeLabel.text = model.gsxz;
            
            if ([model.isCollect isEqualToString:@"1"]) {
                self.detailView1.attentionBtn.selected = YES;
                self.detailView2.attentionBtn.selected = YES;
            }
//            [_bigView removeFromSuperview];
            self.detailView1.coverView.hidden = YES;
            [self.left_tbView.mj_header endRefreshing];
        }
        
    } failure:^(YTKBaseRequest *request) {
        
    }];
}

- (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    
    return thumbnailImage;
}

- (void)favoriteApiNet {
    if (!isValidStr([GlobalData sharedInstance].selfInfo.sessionId))
    {
        [self presentLoginCtrl];
        return;
    }
    
    if(self.favoriteApi && !self.favoriteApi.requestOperation.isFinished)
    {
        [self.favoriteApi stop];
    }
    
    self.favoriteApi.sessionDelegate = self;
    self.favoriteApi = [[QZ_FavoriteComApi alloc] initWithCompanyId:self.companyId];
    [self.favoriteApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        QZ_FavoriteComApi *result = (QZ_FavoriteComApi *)request;
        if(result.isCorrectResult)
        {
            self.detailView1.attentionBtn.selected = !self.detailView1.attentionBtn.selected;
            self.detailView2.attentionBtn.selected = !self.detailView2.attentionBtn.selected;
        }
    } failure:^(YTKBaseRequest *request) {
        
    }];
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.left_tbView) {
        return self.leftDataArray.count;
    }else if (tableView == self.right_tbView) {
        return self.rightDataArray.count;
    }else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.left_tbView) {
        return 130;
    }else if (tableView == self.right_tbView) {
        return 115;
    }else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.left_tbView) {
        static NSString *left_Identifier = @"CommentTableViewCell";
        CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:left_Identifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:nil options:nil].lastObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (tableView == self.right_tbView) {
        static NSString *left_Identifier = @"ComDetail_JobTableViewCell";
        ComDetail_JobTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:left_Identifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"ComDetail_JobTableViewCell" owner:nil options:nil].lastObject;
        }
        NSDictionary *dict = self.rightDataArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.jobNameLabel.text = dict[@"zwName"];
        cell.moneyLabel.text = dict[@"salary"];
        cell.cityLabel.text = dict[@"city"];
        cell.educationLabel.text = dict[@"education"];
        cell.sexLabel.text = dict[@"sex"];
        cell.ageLabel.text = dict[@"age"];
        NSString *timenow = [NSDate jk_timeInfoWithDateString:dict[@"time"]];
        cell.timeLabel.text = [NSString stringWithFormat:@"%@发布",timenow];
        
        CGFloat width11 = [ControlUtil widthWithContent:dict[@"city"] withFont:[UIFont systemFontOfSize:11] withHeight:11];
        CGFloat width12 = [ControlUtil widthWithContent:dict[@"education"] withFont:[UIFont systemFontOfSize:11] withHeight:11];
        CGFloat width13 = [ControlUtil widthWithContent:dict[@"sex"] withFont:[UIFont systemFontOfSize:11] withHeight:11];
        CGFloat width14 = [ControlUtil widthWithContent:dict[@"age"] withFont:[UIFont systemFontOfSize:11] withHeight:11];
        cell.widthCons1.constant = width11;
        cell.widthCons2.constant = width12;
        cell.widthCons3.constant = width13;
        cell.widthCons4.constant = width14;
        
        if ([dict[@"isXZRZ"] isEqualToString:@"1"]) {
            cell.xzrzView.hidden = NO;
        }else {
            cell.xzrzView.hidden = YES;
        }
        CGFloat width = [ControlUtil widthWithContent:dict[@"salary"] withFont:[UIFont systemFontOfSize:16] withHeight:14];
        cell.moneyLabel.width = width;
        cell.unitLabel.x = cell.moneyLabel.x + width + 5;
        cell.xzrzView.x = cell.unitLabel.width + cell.unitLabel.x + 3;
        return cell;
    }else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.rightDataArray[indexPath.row];
    NSString *zwId = dict[@"zwId"];
    JobsDetailViewController *ctrl = [[JobsDetailViewController alloc]init];
    ctrl.zwId = zwId;
    [self.navigationController pushViewController:ctrl animated:YES];
}


#pragma mark - lazyViews
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

- (QZ_CompanyDetailView1 *)detailView1 {
    if (_detailView1 == nil) {
        _detailView1 = [[NSBundle mainBundle] loadNibNamed:@"QZ_CompanyDetailView1" owner:nil options:nil].lastObject;
    }
    [_detailView1.leftBtn addTarget:self action:@selector(leftBtnPress) forControlEvents:UIControlEventTouchUpInside];
    [_detailView1.rightBtn addTarget:self action:@selector(rightBtnPress) forControlEvents:UIControlEventTouchUpInside];
    
    [_detailView1.attentionBtn addTarget:self action:@selector(attentionBtn) forControlEvents:UIControlEventTouchUpInside];
    [_detailView2.attentionBtn addTarget:self action:@selector(attentionBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [_detailView1.seeAllBtn addTarget:self action:@selector(seeAllAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_detailView1.addressBtn addTarget:self action:@selector(navAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_detailView1.playBtn addTarget:self action:@selector(videoAction) forControlEvents:UIControlEventTouchUpInside];
    
    return _detailView1;
}

- (QZ_CompanyDetailView2 *)detailView2 {
    if (_detailView2 == nil) {
        _detailView2 = [[NSBundle mainBundle] loadNibNamed:@"QZ_CompanyDetailView2" owner:nil options:nil].lastObject;
    }
    [_detailView2.leftBtn addTarget:self action:@selector(leftBtnPress) forControlEvents:UIControlEventTouchUpInside];
    [_detailView2.rightBtn addTarget:self action:@selector(rightBtnPress) forControlEvents:UIControlEventTouchUpInside];
    return _detailView2;
}

- (UITableView *)left_tbView {
    if (_left_tbView == nil) {
        _left_tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 69) style:UITableViewStylePlain];
        _left_tbView.delegate = self;
        _left_tbView.dataSource = self;
        _left_tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _left_tbView.backgroundColor = BackgroundColor;
        
        _left_tbView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _leftPage = 1;
            [self mainComApiNet];
        }];
        _left_tbView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            if (_leftDataArray.count == 0 && _leftPage) {
                _leftPage = 1;
            }else {
                _leftPage ++;
            }
            [self commentListApiNet];
        }];
        
    }
    return _left_tbView;
}

- (UITableView *)right_tbView {
    if (_right_tbView == nil) {
        _right_tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        _right_tbView.delegate = self;
        _right_tbView.dataSource = self;
        _right_tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _right_tbView.backgroundColor = BackgroundColor;
        _right_tbView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _rightPage = 1;
            [self giveJobsListApiNet];
        }];
        _right_tbView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            if (_rightDataArray.count == 0 && _rightPage) {
                _rightPage = 1;
            }else {
                _rightPage ++;
            }
            [self giveJobsListApiNet];
        }];
    }
    return _right_tbView;
}

- (void)setFrame {
    self.detailView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, 629);
    self.detailView2.frame = CGRectMake(0, 0, SCREEN_WIDTH, 227);
}

@end
