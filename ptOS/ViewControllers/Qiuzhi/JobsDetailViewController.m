//
//  JobsDetailViewController.m
//  ptOS
//
//  Created by 周瑞 on 16/9/8.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "JobsDetailViewController.h"
#import "QZ_JobsDetailView.h"
#import "QZ_JobDetailModel.h"
#import "QZ_JobDetailApi.h"
#import "AFHTTPRequestOperation.h"
#import "UIImageView+WebCache.h"
#import "QZ_JobDetail_ApplyJobApi.h"
#import "QZ_JobDetailCollectJobApi.h"
#import "CompanyDetailViewController.h"
#import "MyInfo1ViewController.h"
#import "MJRefresh.h"
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDK/ShareSDK.h>

#import "MSTableViewCell.h"
#import "AddressTableViewCell.h"

#import <MAMapKit/MAMapKit.h>
#import <MapKit/MapKit.h>
#import "ReadApi.h"
@interface JobsDetailViewController ()<JLDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSString *_zwms;
    NSString *_coor;
    NSString *m_title;
    
    NSString *_address;
    
    BOOL _hasData;
    
    BOOL _isAll;
}
@property (nonatomic, strong)UIScrollView *scrView;
@property (nonatomic, strong)UIButton *applyBtn;
@property (nonatomic, strong)QZ_JobsDetailView *detailView;

@property (nonatomic, strong)QZ_JobDetailApi *jobDetailApi;
@property (nonatomic, strong)QZ_JobDetail_ApplyJobApi *applyJobApi;
@property (nonatomic, strong)QZ_JobDetailCollectJobApi *collectJobApi;

@property (nonatomic, strong)ReadApi *readApi;

@property (nonatomic, strong)NSString *companyId;

@property (nonatomic,strong)UITableView *m_tbView;

@end

@implementation JobsDetailViewController

#pragma mark - lifeCycles

- (void)viewDidLoad {
    _hasData = NO;
    _isAll = NO;
    [super viewDidLoad];
    self.navigationItem.title = @"职位详情";
    
    [self initUI];
    
//    [self readApiNet];
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
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setImage:[UIImage imageNamed:@"icon_aixin"] forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"icon_aixin_press"] forState:UIControlStateSelected];
    [btn1 addTarget:self action:@selector(favoriteAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setFrame:CGRectMake(0, 0, 18, 18)];
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc]initWithCustomView:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setImage:[UIImage imageNamed:@"icon_fenxiang_white"] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(sharedAction) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setFrame:CGRectMake(0, 0, 18, 18)];
    UIBarButtonItem *rightItem2 = [[UIBarButtonItem alloc]initWithCustomView:btn2];
    
    UIView *space = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
    UIBarButtonItem *rightItem3 = [[UIBarButtonItem alloc]initWithCustomView:space];
    
    self.navigationItem.rightBarButtonItems = @[rightItem2,rightItem3,rightItem1];
    
    
//    [self.view addSubview:self.scrView];
    [self.view addSubview:self.m_tbView];
    [self.view addSubview:self.applyBtn];
    
    [self setFrame];
    [self jobDetailApiNet];
    
    
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

- (void)companyAction {
//    if (!isValidStr([GlobalData sharedInstance].selfInfo.sessionId))
//    {
//        [self presentLoginCtrl];
//        return;
//    }
    CompanyDetailViewController *ctrl = [[CompanyDetailViewController alloc]init];
    ctrl.companyId = self.companyId;
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void)applyAction {
    if (!isValidStr([GlobalData sharedInstance].selfInfo.sessionId)) {
        [self presentLoginCtrl];
        return;
    }
    [self applyJobApiNet];
}

- (void)favoriteAction:(UIButton *)btn {
    if (!isValidStr([GlobalData sharedInstance].selfInfo.sessionId)) {
        [self presentLoginCtrl];
        return;
    }
    btn.selected = !btn.selected;
    [self collectJobApiNet];
}


- (void)sharedAction {
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"shareImg.png"]];
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"你有一份新职位邀请，请查收！"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/pu-tong-gong-zuo/id1167899764"]
                                          title:m_title
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

- (void)seeAllAction {
    NSLog(@"haha");
    _isAll = YES;
//    CGFloat height1 = [ControlUtil heightWithContent:_zwms withFont:[UIFont systemFontOfSize:14] withWidth:SCREEN_WIDTH - 32];
//    if (height1 > 102) {
//        self.detailView.miaoshuHeightCons.constant = height1 + 40;
//        self.detailView.labelHeightCons.constant = height1;
//        self.detailView.seeallBtn.hidden = NO;
//    }else {
//        self.detailView.miaoshuHeightCons.constant = height1 + 40;
//        self.detailView.labelHeightCons.constant = height1;
//        self.detailView.seeallBtn.hidden = YES;
//    }
//    
//    self.scrView.contentSize = CGSizeMake(SCREEN_WIDTH, 888 - 242 + self.detailView.miaoshuHeightCons.constant);
 
    [self.m_tbView reloadData];
}

#pragma mark - Netapi
- (void)jobDetailApiNet {
    if(self.jobDetailApi && !self.jobDetailApi.requestOperation.isFinished)
    {
        [self.jobDetailApi stop];
    }
    
    self.jobDetailApi = [[QZ_JobDetailApi alloc] initWithZWID:self.zwId];
    self.jobDetailApi.netLoadingDelegate = self;
    [self.jobDetailApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        QZ_JobDetailApi *result = (QZ_JobDetailApi *)request;
        if(result.isCorrectResult)
        {
            QZ_JobDetailModel *model = [result getJobDetail];
            self.detailView.jobNameLabel.text = model.zwName;
            m_title = model.zwName;
            self.detailView.attentionNumLabel.text = [NSString stringWithFormat:@"%@人关注",model.collectNum];
            self.detailView.salaryLabel.text = model.salary;
            [self.detailView.companyHeaderImgView sd_setImageWithURL:[NSURL URLWithString:model.companyImage] placeholderImage:[UIImage imageNamed:@"moren_pt"]];
            ZRViewRadius(self.detailView.companyHeaderImgView, 10);
            self.detailView.comNameLabel.text = model.companyName;
            self.detailView.comTypeLabel.text = model.gsxz;
            self.detailView.educationLabel.text = model.education;
            self.detailView.gzxzLabel.text = model.gzxz;
            self.detailView.sexLabel.text = model.sex;
            self.detailView.gzjyLabel.text = model.gzjy;
            self.detailView.ageLabel.text = model.age;
            self.detailView.qtyqLabel.text = model.qtyq;
            self.detailView.zxsjLabel.text = model.zxsj;
            if ([model.isZP isEqualToString:@"0"]) {
                [self.applyBtn setBackgroundColor:[UIColor lightGrayColor]];
                self.applyBtn.userInteractionEnabled = NO;
            }else {
                [self.applyBtn setBackgroundColor:MainColor];
                self.applyBtn.userInteractionEnabled = YES;
            }
            _coor = model.coordinate;
            
            self.detailView.cityLabel.text = model.city;
            
            if (![model.zprs isEqualToString:@"无限"]) {
                self.detailView.zprsLabel.text = [NSString stringWithFormat:@"%@",model.zprs];
            }else {
                self.detailView.zprsLabel.text = model.zprs;
            }
            self.detailView.ybmLabel.text = [NSString stringWithFormat:@"%@人",model.ybm];
            self.detailView.zwmsLabel.text = model.zwms;
            
            _zwms = model.zwms;
            _address = model.address;
            
            _hasData = YES;
            
            self.detailView.addressLabel.text = model.address;
            if ([model.isXZRZ isEqualToString:@"1"]) {
                self.detailView.xzrzImageView.hidden = NO;
            }else {
                self.detailView.xzrzImageView.hidden = YES;
            }
            
            NSString *fuliStr = model.fuli;
            NSArray *fuliArray = [fuliStr componentsSeparatedByString:@","];
//            if (fuliArray.count <= 3) {
//                self.detailView.heightCons.constant = 109;
//            }else {
//                self.detailView.heightCons.constant = 139;
//            }
            NSInteger i = fuliArray.count;
            if (i == 1) {
                self.detailView.fuli2View.hidden = YES;
                self.detailView.fuli2Label.hidden = YES;
                self.detailView.fuli3View.hidden = YES;
                self.detailView.fuli3Label.hidden = YES;
                self.detailView.fuli4View.hidden = YES;
                self.detailView.fuli4Label.hidden = YES;
                self.detailView.fuli5View.hidden = YES;
                self.detailView.fuli5Label.hidden = YES;
                self.detailView.fuli6View.hidden = YES;
                self.detailView.fuli6Label.hidden = YES;
                
                self.detailView.fuli1View.image = [self getImageName:fuliArray[0]];
                self.detailView.fuli1Label.text = fuliArray[0];
            }else if (i == 2) {
                self.detailView.fuli3View.hidden = YES;
                self.detailView.fuli3Label.hidden = YES;
                self.detailView.fuli4View.hidden = YES;
                self.detailView.fuli4Label.hidden = YES;
                self.detailView.fuli5View.hidden = YES;
                self.detailView.fuli5Label.hidden = YES;
                self.detailView.fuli6View.hidden = YES;
                self.detailView.fuli6Label.hidden = YES;
                self.detailView.fuli1View.image = [self getImageName:fuliArray[0]];
                self.detailView.fuli1Label.text = fuliArray[0];
                
                self.detailView.fuli2View.hidden = NO;
                self.detailView.fuli2Label.hidden = NO;
                self.detailView.fuli2View.image = [self getImageName:fuliArray[1]];
                self.detailView.fuli2Label.text = fuliArray[1];
            }else if (i == 3) {
                self.detailView.fuli4View.hidden = YES;
                self.detailView.fuli4Label.hidden = YES;
                self.detailView.fuli5View.hidden = YES;
                self.detailView.fuli5Label.hidden = YES;
                self.detailView.fuli6View.hidden = YES;
                self.detailView.fuli6Label.hidden = YES;
                self.detailView.fuli1View.image = [self getImageName:fuliArray[0]];
                self.detailView.fuli1Label.text = fuliArray[0];
                
                self.detailView.fuli2View.hidden = NO;
                self.detailView.fuli2Label.hidden = NO;
                self.detailView.fuli2View.image = [self getImageName:fuliArray[1]];
                self.detailView.fuli2Label.text = fuliArray[1];
                
                self.detailView.fuli3View.hidden = NO;
                self.detailView.fuli3Label.hidden = NO;
                self.detailView.fuli3View.image = [self getImageName:fuliArray[2]];
                self.detailView.fuli3Label.text = fuliArray[2];
                
            }else if (i == 4) {
                self.detailView.fuli5View.hidden = YES;
                self.detailView.fuli5Label.hidden = YES;
                self.detailView.fuli6View.hidden = YES;
                self.detailView.fuli6Label.hidden = YES;
                self.detailView.fuli1View.image = [self getImageName:fuliArray[0]];
                self.detailView.fuli1Label.text = fuliArray[0];
                
                self.detailView.fuli2View.hidden = NO;
                self.detailView.fuli2Label.hidden = NO;
                self.detailView.fuli2View.image = [self getImageName:fuliArray[1]];
                self.detailView.fuli2Label.text = fuliArray[1];
                
                self.detailView.fuli3View.hidden = NO;
                self.detailView.fuli3Label.hidden = NO;
                self.detailView.fuli3View.image = [self getImageName:fuliArray[2]];
                self.detailView.fuli3Label.text = fuliArray[2];
                
                self.detailView.fuli4View.hidden = NO;
                self.detailView.fuli4Label.hidden = NO;
                self.detailView.fuli4View.image = [self getImageName:fuliArray[3]];
                self.detailView.fuli4Label.text = fuliArray[3];
                
            }else if (i == 5) {
                self.detailView.fuli6View.hidden = YES;
                self.detailView.fuli6Label.hidden = YES;
                self.detailView.fuli1View.hidden = NO;
                self.detailView.fuli1Label.hidden = NO;
                self.detailView.fuli1View.image = [self getImageName:fuliArray[0]];
                self.detailView.fuli1Label.text = fuliArray[0];
                
                self.detailView.fuli2View.hidden = NO;
                self.detailView.fuli2Label.hidden = NO;
                self.detailView.fuli2View.image = [self getImageName:fuliArray[1]];
                self.detailView.fuli2Label.text = fuliArray[1];
                
                self.detailView.fuli3View.hidden = NO;
                self.detailView.fuli3Label.hidden = NO;
                self.detailView.fuli3View.image = [self getImageName:fuliArray[2]];
                self.detailView.fuli3Label.text = fuliArray[2];
                
                self.detailView.fuli4View.hidden = NO;
                self.detailView.fuli4Label.hidden = NO;
                self.detailView.fuli4View.image = [self getImageName:fuliArray[3]];
                self.detailView.fuli4Label.text = fuliArray[3];
                
                self.detailView.fuli5View.hidden = NO;
                self.detailView.fuli5Label.hidden = NO;
                self.detailView.fuli5View.image = [self getImageName:fuliArray[4]];
                self.detailView.fuli5Label.text = fuliArray[4];
                
            }else if (i == 6) {
                self.detailView.fuli1View.image = [self getImageName:fuliArray[0]];
                self.detailView.fuli1Label.text = fuliArray[0];
                
                self.detailView.fuli2View.hidden = NO;
                self.detailView.fuli2Label.hidden = NO;
                self.detailView.fuli2View.image = [self getImageName:fuliArray[1]];
                self.detailView.fuli2Label.text = fuliArray[1];
                
                self.detailView.fuli3View.hidden = NO;
                self.detailView.fuli3Label.hidden = NO;
                self.detailView.fuli3View.image = [self getImageName:fuliArray[2]];
                self.detailView.fuli3Label.text = fuliArray[2];
                
                self.detailView.fuli4View.hidden = NO;
                self.detailView.fuli4Label.hidden = NO;
                self.detailView.fuli4View.image = [self getImageName:fuliArray[3]];
                self.detailView.fuli4Label.text = fuliArray[3];
                
                self.detailView.fuli5View.hidden = NO;
                self.detailView.fuli5Label.hidden = NO;
                self.detailView.fuli5View.image = [self getImageName:fuliArray[4]];
                self.detailView.fuli5Label.text = fuliArray[4];
                
                self.detailView.fuli6View.hidden = NO;
                self.detailView.fuli6Label.hidden = NO;
                self.detailView.fuli6View.image = [self getImageName:fuliArray[5]];
                self.detailView.fuli6Label.text = fuliArray[5];
            }
            
            
            self.companyId = model.companyId;
            CGFloat width = [ControlUtil widthWithContent:model.salary withFont:[UIFont systemFontOfSize:16] withHeight:14];
            self.detailView.salaryLabel.width = width;
            self.detailView.unitLabel.x = self.detailView.salaryLabel.x + width + 5;
            self.detailView.xzrzImageView.x = self.detailView.unitLabel.x + self.detailView.width + 5;
            
//            CGFloat height1 = [ControlUtil heightWithContent:model.zwms withFont:[UIFont systemFontOfSize:14] withWidth:SCREEN_WIDTH - 32];
//            if (height1 > 102) {
//                if (SCREEN_WIDTH <= 320) {
//                    self.detailView.miaoshuHeightCons.constant = 102 + 95;
//                }
//                self.detailView.miaoshuHeightCons.constant = 102 + 95;
//                self.detailView.labelHeightCons.constant = 102;
//                self.detailView.seeallBtn.hidden = NO;
//            
//                UIButton *seeallBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                [seeallBtn setTitle:@"查看全部" forState:UIControlStateNormal];
//                [seeallBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//                [seeallBtn addTarget:self action:@selector(seeAllAction) forControlEvents:UIControlEventTouchUpInside];
//                [seeallBtn setFrame:CGRectMake(0, 29 + 102 + 25, 170, 24)];
//                seeallBtn.centerX = self.detailView.centerX;
//                ZRViewBorderRadius(seeallBtn, 1, [UIColor redColor]);
//                seeallBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//                [self.detailView.bottomView4 addSubview:seeallBtn];
//            }else {
//                self.detailView.miaoshuHeightCons.constant = height1 + 40;
//                self.detailView.labelHeightCons.constant = height1;
//                self.detailView.seeallBtn.hidden = YES;
//            }
            
            
//            self.scrView.contentSize = CGSizeMake(SCREEN_WIDTH, 888 - 242 + self.detailView.miaoshuHeightCons.constant);
            [self.m_tbView reloadData];
            
//            [self.scrView.mj_header endRefreshing];
        }
        
    } failure:^(YTKBaseRequest *request) {

    }];
}

- (UIImage *)getImageName:(NSString *)str {
    if ([str isEqualToString:@"五险一金"]) {
        UIImage *image = [UIImage imageNamed:@"icon_wuxian"];
        return image;
    }else if ([str isEqualToString:@"包吃饭"]) {
        UIImage *image = [UIImage imageNamed:@"icon_baochi"];
        return image;
    }else if ([str isEqualToString:@"包住宿"]) {
        UIImage *image = [UIImage imageNamed:@"icon_baozhu"];
        return image;
    }else if ([str isEqualToString:@"年底双薪"]) {
        UIImage *image = [UIImage imageNamed:@"icon_niandi"];
        return image;
    }else if ([str isEqualToString:@"饭补"]) {
        UIImage *image = [UIImage imageNamed:@"icon_fanbu"];
        return image;
    }else if ([str isEqualToString:@"加班补助"]) {
        UIImage *image = [UIImage imageNamed:@"icon_jiaban"];
        return image;
    }
    NSInteger i = arc4random()%2 ;
    if (i == 0) {
        return [UIImage imageNamed:@"icon_tongyong1"];
    }else {
        return [UIImage imageNamed:@"icon_tongyong2"];
    }
}

- (void)applyJobApiNet {
    if (!isValidStr([GlobalData sharedInstance].selfInfo.sessionId))
    {
        [self presentLoginCtrl];
        return;
    }
    
    if(self.applyJobApi&& !self.applyJobApi.requestOperation.isFinished)
    {
        [self.applyJobApi stop];
    }
    self.applyJobApi.sessionDelegate = self;
    self.applyJobApi.jlDelegate = self;
    self.applyJobApi = [[QZ_JobDetail_ApplyJobApi alloc] initWithZWID:self.zwId];
    [self.applyJobApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        QZ_JobDetail_ApplyJobApi *result = (QZ_JobDetail_ApplyJobApi *)request;
        if(result.isCorrectResult)
        {
            [XHToast showCenterWithText:@"报名成功"];
        }else {
            NSString *num = [UserDefault objectForKey:JLKey];
            if ([num isEqualToString:@"0"]) {
                [XHToast showCenterWithText:@"请先完善简历"];
                MyInfo1ViewController *ctrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyInfo1ViewController"];
                [self.navigationController pushViewController:ctrl animated:YES];
            }
            
        }
    } failure:^(YTKBaseRequest *request) {
        
    }];
}

- (void)readApiNet {
    
    if(self.readApi&& !self.readApi.requestOperation.isFinished)
    {
        [self.readApi stop];
    }
    self.readApi.sessionDelegate = self;
    self.readApi = [[ReadApi alloc] initWithZwId:self.zwId];
    [self.readApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {

        ReadApi *result = (ReadApi *)request;
        if(result.isCorrectResult)
        {
           
        }
    } failure:^(YTKBaseRequest *request) {
        
    }];
}

- (void)collectJobApiNet {
    if (!isValidStr([GlobalData sharedInstance].selfInfo.sessionId))
    {
        [self presentLoginCtrl];
        return;
    }
    
    if(self.collectJobApi&& !self.collectJobApi.requestOperation.isFinished)
    {
        [self.collectJobApi stop];
    }
    self.collectJobApi.sessionDelegate = self;
    self.collectJobApi = [[QZ_JobDetailCollectJobApi alloc] initWithZWID:self.zwId];
    [self.collectJobApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        QZ_JobDetailCollectJobApi *result = (QZ_JobDetailCollectJobApi *)request;
        if(result.isCorrectResult)
        {
            
        }
    } failure:^(YTKBaseRequest *request) {
        
    }];
}

#pragma mark - delegate
- (void)jumpToJL {
    MyInfo1ViewController *ctrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyInfo1ViewController"];
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat msHeight;
    CGFloat height1 = [ControlUtil heightWithContent:_zwms withFont:[UIFont systemFontOfSize:14] withWidth:FITWIDTH(343)];

    if (height1 > 102) {
        msHeight = 102 + 114;
        
    }else {
        msHeight = height1 + 70;
    }
    if (_isAll) {
        msHeight = height1 + 70;
    }
    if (indexPath.row == 0) {
        return msHeight;
    }else if (indexPath.row == 1) {
        return 63;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_hasData) {
        return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *jobsIdentifier = @"MSTableViewCell";
        MSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:jobsIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"MSTableViewCell" owner:nil options:nil].lastObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.seeAllBtn addTarget:self action:@selector(seeAllAction) forControlEvents:UIControlEventTouchUpInside];
        CGFloat msHeight;
        CGFloat height1 = [ControlUtil heightWithContent:_zwms withFont:[UIFont systemFontOfSize:14] withWidth:FITWIDTH(343)];
        if (height1 >= 102) {
            if (_isAll) {
                msHeight = height1;
                cell.seeAllBtn.hidden = YES;
            }else {
                msHeight = 102;
            }
        }else {
            msHeight = height1;
        }
        cell.labelHeightCons.constant = msHeight;
        cell.contentLabel.text = _zwms;
        
        return cell;
    }else if (indexPath.row == 1) {
        static NSString *jobsIdentifier = @"AddressTableViewCell";
        AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:jobsIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"AddressTableViewCell" owner:nil options:nil].lastObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.addressLabel.text = _address;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        [self navAction];
    }
}



#pragma mark - lazyViews
- (UIScrollView *)scrView {
    if (_scrView == nil) {
        _scrView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 45)];
        _scrView.backgroundColor = BackgroundColor;
        _scrView.contentSize = CGSizeMake(SCREEN_WIDTH, 888);
        _scrView.showsVerticalScrollIndicator = YES;
        _scrView.showsHorizontalScrollIndicator = NO;
        _scrView.userInteractionEnabled = YES;
        
        _scrView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self jobDetailApiNet];
        }];
    }
    return _scrView;
}

- (UIButton *)applyBtn {
    if (_applyBtn == nil) {
        _applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _applyBtn.backgroundColor = MainColor;
        [_applyBtn setTitle:@"点击报名" forState:UIControlStateNormal];
        [_applyBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        _applyBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_applyBtn addTarget:self action:@selector(applyAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyBtn;
}

- (QZ_JobsDetailView *)detailView {
    if (_detailView == nil) {
        _detailView = [[NSBundle mainBundle] loadNibNamed:@"QZ_JobsDetailView" owner:nil options:nil].lastObject;
    }
    
//    _detailView.fuli1View.hidden = YES;
//    _detailView.fuli1Label.hidden = YES;
//    
//    _detailView.fuli2View.hidden = YES;
//    _detailView.fuli2Label.hidden = YES;
//    
//    _detailView.fuli3View.hidden = YES;
//    _detailView.fuli3Label.hidden = YES;
//    
//    _detailView.fuli4View.hidden = YES;
//    _detailView.fuli4Label.hidden = YES;
//    
//    _detailView.fuli5View.hidden = YES;
//    _detailView.fuli5Label.hidden = YES;
//    
//    _detailView.fuli6View.hidden = YES;
//    _detailView.fuli6Label.hidden = YES;
    
    [_detailView.comBtn addTarget:self action:@selector(companyAction) forControlEvents:UIControlEventTouchUpInside];
    ZRViewBorderRadius(_detailView.seeallBtn, 1, [UIColor redColor]);
    ZRViewRadius(_detailView.seeallBtn, 5);
    [_detailView.addressBtn addTarget:self action:@selector(navAction) forControlEvents:UIControlEventTouchUpInside];
    _detailView.bottomView5.userInteractionEnabled = YES;
    UIGestureRecognizer *g = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(seeAllAction)];
    
    [_detailView.bottomView5 addGestureRecognizer:g];
    
    _detailView.seeallBtn.userInteractionEnabled = YES;
    [_detailView.seeallBtn addTarget:self action:@selector(seeAllAction) forControlEvents:UIControlEventTouchUpInside];
    return _detailView;
}

- (UITableView *)m_tbView {
    if (_m_tbView == nil) {
        _m_tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 45) style:UITableViewStylePlain];
        _m_tbView.delegate = self;
        _m_tbView.dataSource = self;
        _m_tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_m_tbView setBackgroundColor:RGB(239, 239, 239)];
        _m_tbView.tableHeaderView = self.detailView;
    }
    return _m_tbView;
}

- (void)setFrame {
    self.applyBtn.frame = CGRectMake(0, SCREEN_HEIGHT - 45 - 64, SCREEN_WIDTH, 45);
    self.detailView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 573);
}
@end
