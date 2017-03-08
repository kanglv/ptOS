//
//  QiuzhiViewController.m
//  ptOS
//
//  Created by 周瑞 on 16/8/30.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "QiuzhiViewController.h"
#import "QZ_JobsNavView.h"
#import "QZ_SearchNavView.h"
#import "QZ_SortView.h"
#import "QZ_JobsTableViewCell.h"
#import "QZ_CompanyTableViewCell.h"
#import "JobsDetailViewController.h"
#import "CompanyDetailViewController.h"
#import "QZ_JobListApi.h"
#import "QZ_CompanyListApi.h"
#import "MJRefresh.h"
#import "GlobalData.h"
#import "AFHTTPRequestOperation.h"
#import "QZ_JobSearchApi.h"
#import "QZ_ComSearchApi.h"
#import "QZ_SearchNumApi.h"
#import "QZ_seachNumModel.h"
#import "QZ_JobModel.h"
#import "QZ_CompanyModel.h"
#import "UIImageView+WebCache.h"
#import "QRCScanner.h"
#import "LoginNetApi.h"
#import "QQLogin.h"


#import "OSSManager.h"



#import "ScannerViewController.h"
#import "NSDate+JKExtension.h"

#import "XHToast.h"

#import <AMapFoundationKit/AMapFoundationKit.h>

#import <AMapLocationKit/AMapLocationKit.h>

#import <AVFoundation/AVFoundation.h>

#define GMap_APPKEY @"04c0b7d2c1edacac03e5527fd3cb4b86"

//creat by kanglv
#import "SelectCityViewController.h"
#import "screenView.h"

@interface QiuzhiViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,QRCodeScanneDelegate,ScannerViewControllerDelegate,AMapLocationManagerDelegate>
{
    int _money;
    int _time;
    int _distance;
    
    NSInteger _leftPage;
    NSInteger _rightPage;
    NSString *_sort;
    
    NSInteger _search_leftPage;
    NSInteger _search_rightPage;
    
    NSString *_lastSort;
    BOOL _hasSearch;
}




@property (nonatomic,strong)LoginNetApi *loginApi;

@property (nonatomic, strong)QZ_JobsNavView *jobsNavView;
@property (nonatomic, strong)QZ_SearchNavView *searchNavView;
@property (nonatomic, strong)QZ_SortView *sortView;

@property (nonatomic, strong)UITableView *job_tbView;
@property (nonatomic, strong)UITableView *company_tbView;


@property (nonatomic, strong)UIImageView *imgView;

@property (nonatomic, strong)QZ_JobListApi *jobListApi;
@property (nonatomic, strong)QZ_CompanyListApi *companyListApi;
@property (nonatomic, strong)QZ_JobSearchApi *searchJobApi;
@property (nonatomic, strong)QZ_ComSearchApi *searchComApi;
@property (nonatomic, strong)QZ_SearchNumApi *searNumApi;

@property (nonatomic, strong)NSMutableArray * leftDataArray;
@property (nonatomic, strong)NSMutableArray *rightDataArray;

@property (nonatomic, strong)NSMutableArray *search_leftDataArray;
@property (nonatomic, strong)NSMutableArray *search_rightDataArray;

@property (nonatomic, assign)BOOL isSearch;

@property (nonatomic,strong)ScannerViewController *scanCtrl;



@property (nonatomic, strong)AMapLocationManager *locationManager;

@property (nonatomic,strong)QQLogin *qqLoginApi;

@property (nonatomic, strong)UIImageView *nodataImgView;

@property (nonatomic ,strong)screenView *chooseView;

@end

@implementation QiuzhiViewController

#pragma mark - lifeCycles

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self addLaunch];
    [self autiLoginNet];

    _hasSearch = NO;
    
    sleep(0.9);
    _money = 0;
    _time = 0;
    _distance = 0;
    _leftPage = 1;
    _rightPage = 1;
    
    _search_leftPage = 1;
    _search_rightPage = 1;
    _sort = @"0";
    
    self.isSearch = NO;
    self.needNav = NO;
   
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getCoor];
    });
    [self initUI];
    
    [self getResume];
    
    NSLog(@"%@",[NSBundle mainBundle].bundleIdentifier);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addObserverForCondition:) name:@"sure" object:nil];
    
    //添加城市选择的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addObserverForCity:) name:@"city" object:nil];
    
    //添加薪资范围监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addObserverForSalary:) name:@"salary" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [self.jobListApi stop];
    [self.companyListApi stop];
    [self.searchJobApi stop];
    [self.searchComApi stop];
    
    //移除时移出监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sure" object:nil];
    //移除城市选择的监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"city" object:nil];
    
    //移除薪资监听
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"salary" object:nil];
}

#pragma mark - customFuncs
- (void)autiLoginNet {
    if (self.loginApi && !self.loginApi.requestOperation.isFinished) {
        [self.loginApi stop];
    }
    NSString *usrName = [UserDefault objectForKey:PhoneKey];
    NSString *psw = [UserDefault objectForKey:PswKey];
    if (isValidStr(usrName) && isValidStr(psw)) {
        self.loginApi = [[LoginNetApi alloc]initWithUserName:usrName withUserPsw:psw];
        self.loginApi.netLoadingDelegate = self;
        
        [self.loginApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            LoginNetApi *result = (LoginNetApi *)request;
            if (result.isCorrectResult) {
                
                
                [GlobalData sharedInstance].selfInfo = [result getUserInfo];
                [self downloadHeaderImage];
                
                [JPUSHService setAlias:[GlobalData sharedInstance].selfInfo.userName callbackSelector:nil object:nil];
                [UserDefault synchronize];
            }else {
                
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            NSLog(@"登陆失败");
            [JPUSHService setAlias:@"" callbackSelector:nil object:nil];
        }];
    }else if (isValidStr([UserDefault objectForKey:UIDKey])) {
        [self qqLoginApiNetWithOpenId:[UserDefault objectForKey:UIDKey]];
    }
    
}

- (void)downloadHeaderImage {
    NSString *fileName = [NSString stringWithFormat:@"%@.png",[GlobalData sharedInstance].selfInfo.userName];
    [[OSSManager sharedManager] downloadObjectAsyncWithFileName:fileName andBDName:@"bd-header" andGetImage:^(BOOL isSuccess, UIImage *image) {
        if (isSuccess) {
            if (image != nil) {
                NSData *data = UIImageJPEGRepresentation(image, 1.0);
                [[NSUserDefaults standardUserDefaults] setValue:data forKey:HeaderKey];
                [NotificationCenter postNotificationName:@"refreshFace" object:nil];
            }
        }
    }];
}


- (void)qqLoginApiNetWithOpenId:(NSString *)openId {
    if (self.qqLoginApi && !self.qqLoginApi.requestOperation.isFinished) {
        [self.qqLoginApi stop];
    }
    self.qqLoginApi = [[QQLogin alloc]initWithOpenId:openId];
    self.qqLoginApi.netLoadingDelegate = self;
    
    [self.qqLoginApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        QQLogin *result = (QQLogin *)request;
        if (result.isCorrectResult) {
            UserInfoModel *model = [result getUserInfo];
            if (![model.sessionId isKindOfClass:[NSNull class]] && isValidStr(model.sessionId) && model.sessionId != nil) {
                
                [GlobalData sharedInstance].selfInfo = [result getUserInfo];
                [JPUSHService setAlias:[GlobalData sharedInstance].selfInfo.userName callbackSelector:nil object:nil];
                [UserDefault setObject:[GlobalData sharedInstance].selfInfo.phone forKey:PhoneKey];
                [UserDefault setObject:[GlobalData sharedInstance].selfInfo.psw forKey:PswKey];
                
                [UserDefault synchronize];
            }else {
                [JPUSHService setAlias:@"" callbackSelector:nil object:nil];
            }
        }else {
            
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"登陆失败");
    }];
}



- (void)getResume {
    
}

- (void)getCoor {
    [AMapServices sharedServices].apiKey = GMap_APPKEY;
    
    self.locationManager = [[AMapLocationManager alloc] init];
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
     [self.locationManager setDelegate:self];
    //   定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout =2;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 2;
    
    
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
        NSLog(@"location:%@", location);
        [GlobalData sharedInstance].coordinate = [NSString stringWithFormat:@"%f,%f",location.coordinate.latitude,location.coordinate.longitude];
        NSLog(@"%@",[GlobalData sharedInstance].coordinate);
        
        if (regeocode)
        {
            NSLog(@"reGeocode:%@", regeocode);
            [GlobalData sharedInstance].location = regeocode.formattedAddress;
            //定位到当前城市
            self.selectedCity = regeocode.city;
        }
    }];
}
- (void) addLaunch {
    self.imgView = [[UIImageView alloc]init];
    NSArray *gifArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"dengluye2"],
                         [UIImage imageNamed:@"dengluye3"],
                         [UIImage imageNamed:@"dengluye4"],
                         [UIImage imageNamed:@"dengluye5"],nil];
    self.imgView.animationImages = gifArray;
    self.imgView.animationDuration = 1;
    self.imgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.imgView.animationRepeatCount = 1;
    
    [[[UIApplication sharedApplication].delegate window] addSubview:self.imgView];
    [[[UIApplication sharedApplication].delegate window] bringSubviewToFront:self.imgView];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.imgView startAnimating];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self.imgView removeFromSuperview];
        });
    });
}

- (void)initUI {
    [self.view addSubview:self.jobsNavView];
    [self.view addSubview:self.sortView];
    [self.view addSubview:self.searchNavView];
    [self.view addSubview:self.job_tbView];
    [self.view addSubview:self.company_tbView];
    
    self.searchNavView.hidden = YES;
    self.company_tbView.hidden = YES;
    
    [self setFrame];
    [self jobsListApiNet];
    [self CompanyListApiNet];
}

//点击左上角位置
- (void)locationBtnPress{
    
    //跳转到新页面，地区选择页面
    SelectCityViewController *selectCity = [[SelectCityViewController alloc]init];
    
    selectCity.indexCity = self.selectedCity;
    
    [self.navigationController pushViewController:selectCity animated:YES];
}

//选择新城市后的监听
-(void)addObserverForCity:(NSNotification *)notification {
    NSLog(@"ggg");
    NSString * city = [notification.userInfo objectForKey:@"0"];
    self.selectedCity = city;
    [self.jobsNavView.locationBtn setTitle:city forState:UIControlStateNormal];
    
    
    //调用网络接口请求工作列表
    [GlobalData sharedInstance].location = city;
    NSLog(@"当前城市:%@",[GlobalData sharedInstance].location);
    [self jobsListApiNet];
    
    
    
    
    
    
}

- (void)jobsBtnPress {
    self.sortView.hidden = NO;
    self.job_tbView.hidden = NO;
    self.company_tbView.hidden = YES;
    if(self.jobsNavView.jobsBtn.selected) {
        [self jobsListApiNet];
    }
    self.jobsNavView.jobsBtn.selected = YES;
    self.jobsNavView.companyBtn.selected = NO;
   
}

- (void)companyBtnPress {
    if(!self.jobsNavView.companyBtn.selected){
        
        [self removeScreenView];
        self.sortView.moneyBtn.selected = NO;
        
        if(_nodataImgView) {
            [self removePlaceHolderView];
        }
        
        self.sortView.hidden = YES;
        self.job_tbView.hidden = YES;
        self.company_tbView.hidden = NO;
        
        if(self.jobsNavView.companyBtn.selected) {
            [self CompanyListApiNet];
        }
        
        self.jobsNavView.jobsBtn.selected = NO;
        self.jobsNavView.companyBtn.selected = YES;
    }
    
    
}




#pragma creat a choose view

- (void)addScreenView {
    
    if(self.chooseView) {
        [self.view bringSubviewToFront:self.chooseView];
    } else {
        self.chooseView = [[screenView alloc] initWithFrame:CGRectMake(15, 111, SCREEN_WIDTH-30, SCREEN_HEIGHT - 111 - 49) withString:@"123"];
        self.chooseView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.chooseView];
    }
    
        
}

- (void)removeScreenView {
    [self.view sendSubviewToBack:self.chooseView];
    
}

//添加一个监听，监听薪资范围
- (void)addObserverForSalary:(NSNotification *)notification {
    
    self.chooseView.salary.text = [notification.userInfo objectForKey:@"0"];
    
    NSLog(@"%@",[notification.userInfo objectForKey:@"0"]);
}

//添加一个监听，监听筛选条件
- (void)addObserverForCondition:(NSNotification *)notification {
    
    [self removeScreenView];
    self.sortView.moneyBtn.selected = NO;
    //需要做新的网络请求去获取工作信息
    [self jobsListApiNet];
    
    NSLog(@"%@",[notification.userInfo objectForKey:@"0"]);
}

- (void)sort_money {
    
    self.sortView.timeBtn.selected = NO;
    self.sortView.distanceBtn.selected = NO;
    
    self.sortView.timeImageView.image = [UIImage imageNamed:@"icon_paixu_no"];
    self.sortView.distanceImageview.image = [UIImage imageNamed:@"icon_paixu_no"];
    
    _time = 0;
    _distance = 0;
    
    
    //弹出一个选择页面,初始时点击数位0，点一次加一,以此控制筛选view弹出收起
    
    if(!self.sortView.moneyBtn.selected){
        
         [self addScreenView];
        self.sortView.moneyBtn.selected = YES;
        [self.sortView.moneyBtn setTitle:@"已选择" forState:UIControlStateNormal];
        
        
    } else {
        self.sortView.moneyBtn.selected = NO;
         [self removeScreenView];
    }
}

- (void)sort_time {
    
    if( !self.sortView.timeBtn.selected){
        
        [self removeScreenView];
        self.sortView.moneyBtn.selected = NO;
        
        self.sortView.timeBtn.selected = YES;
        self.sortView.distanceBtn.selected = NO;
        
        self.sortView.moneyImageView.image = [UIImage imageNamed:@"icon_paixu_no"];
        self.sortView.distanceImageview.image = [UIImage imageNamed:@"icon_paixu_no"];
        
        
        _distance = 0;
        
        _time ++;
        if (_time % 2 ==0) {
            //down
            self.sortView.timeImageView.image = [UIImage imageNamed:@"icon_paixu_down"];
            _sort = @"4";
        }else {
            //up
            self.sortView.timeImageView.image = [UIImage imageNamed:@"icon_paixu_up"];
            _sort = @"3";
        }
        
        if (self.isSearch) {
            _search_leftPage = 1;
            [self searchJobApiNet];
        }else {
            _leftPage = 1;
            [self jobsListApiNet];
        }
        
        _lastSort = @"2";

    }
}

- (void)sort_distance {
    
    if( !self.sortView.distanceBtn.selected){
        if (!isValidStr([GlobalData sharedInstance].coordinate)) {
            [XHToast showCenterWithText:@"未获取到当前位置"];
            return;
        }
        
        [self removeScreenView];
        self.sortView.moneyBtn.selected = NO;
        self.sortView.timeBtn.selected = NO;
        self.sortView.distanceBtn.selected = YES;
        
        self.sortView.moneyImageView.image = [UIImage imageNamed:@"icon_paixu_no"];
        self.sortView.timeImageView.image = [UIImage imageNamed:@"icon_paixu_no"];
        
        _time = 0;
        
        _distance ++;
        if (_distance % 2 == 0) {
            //down
            self.sortView.distanceImageview.image = [UIImage imageNamed:@"icon_paixu_down"];
            _sort = @"6";
        }else {
            //up
            self.sortView.distanceImageview.image = [UIImage imageNamed:@"icon_paixu_up"];
            _sort = @"5";
        }
        
        if (self.isSearch) {
            _search_leftPage = 1;
            [self searchJobApiNet];
        }else {
            _leftPage = 1;
            [self jobsListApiNet];
        }
        
        _lastSort = @"3";
    }
}

- (void)refreshView {
    
}

- (void)backToNormal {
    self.sortView.allBtn.selected = YES;
    self.sortView.moneyBtn.selected = NO;
    self.sortView.timeBtn.selected = NO;
    self.sortView.distanceBtn.selected = NO;
    
    self.sortView.moneyImageView.image = [UIImage imageNamed:@"icon_paixu_no"];
    self.sortView.timeImageView.image = [UIImage imageNamed:@"icon_paixu_no"];
    self.sortView.distanceImageview.image = [UIImage imageNamed:@"icon_paixu_no"];
    
}

- (void)searchAction {
    self.searchNavView.hidden = NO;
    self.jobsNavView.hidden = YES;
    self.searchNavView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    self.searchNavView.jobsBtn.hidden = YES;
    self.searchNavView.companyBtn.hidden = YES;
    self.sortView.frame = CGRectMake(0, 64, SCREEN_WIDTH, 37);
    self.job_tbView.frame = CGRectMake(0, 101, SCREEN_WIDTH, SCREEN_HEIGHT - 101 - 49);
    self.company_tbView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49);
    
    
    self.isSearch = YES;
    _search_leftPage = 1;
    _search_rightPage = 1;
    [self.job_tbView reloadData];
    [self.company_tbView reloadData];
    [self.searchNavView.searchField becomeFirstResponder];
}

- (void)cancelSearch {
    
    [self.view endEditing:YES];
    [self.search_leftDataArray removeAllObjects];
    [self.search_rightDataArray removeAllObjects];
    _hasSearch = NO;
    
    self.searchNavView.hidden = YES;
    self.jobsNavView.hidden = NO;
    self.sortView.frame = CGRectMake(0, 64, SCREEN_WIDTH, 37);
    self.job_tbView.frame = CGRectMake(0, 101, SCREEN_WIDTH, SCREEN_HEIGHT - 101 - 49);
    self.company_tbView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49);
    
    self.isSearch = NO;
    _search_leftPage = 1;
    _search_rightPage = 1;
    [_job_tbView reloadData];
    [_company_tbView reloadData];
    self.searchNavView.searchField.text = @"";
}

- (void)search_jobBtnPress {
    self.searchNavView.jobsBtn.selected = YES;
    self.searchNavView.companyBtn.selected = NO;
    
    self.sortView.hidden = NO;
    self.job_tbView.hidden = NO;
    self.company_tbView.hidden = YES;
}

- (void)search_companyBtnPress {
    
    
    self.searchNavView.jobsBtn.selected = NO;
    self.searchNavView.companyBtn.selected = YES;
    
    self.sortView.hidden = YES;
    self.job_tbView.hidden = YES;
    self.company_tbView.hidden = NO;
}

- (void)QRCodeAction {
    NSLog(@"二维码按钮点击");
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您的设备无法拍照，请至设置中打开相机" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }else {
        self.scanCtrl = [[ScannerViewController alloc] initWithType:YES];
        self.scanCtrl.delegate = self;
        [self.navigationController pushViewController:self.scanCtrl animated:YES];
    }
}
#pragma mark - Netapi

//获取工作列表
- (void)jobsListApiNet {
    if (self.jobListApi && !self.jobListApi.requestOperation.isFinished) {
        [self.jobListApi stop];
    }
     self.jobListApi = [[QZ_JobListApi alloc]initWithPage:[NSString stringWithFormat:@"%ld",(long)_leftPage] withSort:_sort withCoordinate:[GlobalData sharedInstance].coordinate widthCity:[GlobalData sharedInstance].location withMinSalary:[GlobalData sharedInstance].minSalary withMaxSalary:[GlobalData sharedInstance].maxSalary withExperience:[GlobalData sharedInstance].experience withEducations:[GlobalData sharedInstance].educations withJobNatures:[GlobalData sharedInstance].jobNatures];
    self.jobListApi.netLoadingDelegate = self;
    self.jobListApi.noNetWorkingDelegate = self;
    [self.jobListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        QZ_JobListApi *result = (QZ_JobListApi *)request;
         NSLog(@"%@",result);
        if (result.isCorrectResult) {
            
            [self removePlaceHolderView];
            NSLog(@"%@",result);
            if (_leftPage == 1) {
                self.leftDataArray = [NSMutableArray arrayWithArray:[result getJobsList]];
            }else {
                [self.leftDataArray addObjectsFromArray:[result getJobsList]];
            }
            [self.job_tbView reloadData];
            NSInteger count = [result getJobsList].count;
            if (count == 0) {
                [(MJRefreshAutoFooter *)self.job_tbView.mj_footer setHidden:YES];
                [self addPlaceHolderView];
            }else {
                [(MJRefreshAutoFooter *)self.job_tbView.mj_footer setHidden:NO];
            }
        }else {
            if (_leftPage > 1) {
                _leftPage --;
            }else {
                self.leftDataArray = [NSMutableArray array];
                [self.job_tbView reloadData];
                [self addPlaceHolderView];
            }
        }
        [self.job_tbView.mj_header endRefreshing];
        [self.job_tbView.mj_footer endRefreshing];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (_leftPage > 1) {
            _leftPage --;
        }else {
            [self.job_tbView.mj_header endRefreshing];
            [self.job_tbView.mj_footer endRefreshing];
        }
    }];
}

//获取公司列表
- (void)CompanyListApiNet {
    if (self.companyListApi && !self.companyListApi.requestOperation.isFinished) {
        [self.companyListApi stop];
    }
    self.companyListApi = [[QZ_CompanyListApi alloc]initWithPage:[NSString stringWithFormat:@"%ld",(long)_rightPage] withCoordinate:[GlobalData sharedInstance].coordinate widtCity:[GlobalData sharedInstance].location];
    self.companyListApi.netLoadingDelegate = self;
    self.companyListApi.noNetWorkingDelegate = self;
    [self.companyListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        QZ_CompanyListApi *result = (QZ_CompanyListApi *)request;
        if (result.isCorrectResult) {
            [self removePlaceHolderView];
            
            if (_rightPage == 1) {
                self.rightDataArray = [NSMutableArray arrayWithArray:[result getCompanyList]];
            }else {
                [self.rightDataArray addObjectsFromArray:[result getCompanyList]];
            }
            [self.company_tbView reloadData];
            NSInteger count = [result getCompanyList].count;
            if (count == 0) {
                [(MJRefreshAutoFooter *)self.company_tbView.mj_footer setHidden:YES];
            }else {
                [(MJRefreshAutoFooter *)self.company_tbView.mj_footer setHidden:NO];
            }
        }else {
            if (_rightPage > 1) {
                _rightPage --;
            }else {
                self.rightDataArray = [NSMutableArray array];
                [self.company_tbView reloadData];
                [self addPlaceHolderView];
            }
        }
        [self showNoDataView];
        [self.company_tbView.mj_header endRefreshing];
        [self.company_tbView.mj_footer endRefreshing];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
         [self addPlaceHolderView];
        if (_rightPage > 1) {
            _rightPage --;
        }else {
            [self.company_tbView.mj_header endRefreshing];
            [self.company_tbView.mj_footer endRefreshing];
        }
    }];
}


- (void)searchJobApiNet {
    if (self.searchJobApi && !self.searchJobApi.requestOperation.isFinished) {
        [self.searchJobApi stop];
    }
    self.searchJobApi = [[QZ_JobSearchApi alloc]initWithPage:[NSString stringWithFormat:@"%ld",(long)_search_leftPage] withSort:_sort withKeyword:self.searchNavView.searchField.text withCoordinate:[GlobalData sharedInstance].coordinate withCity:[GlobalData sharedInstance].location withMinSalary:[GlobalData sharedInstance].minSalary withMaxSalary:[GlobalData sharedInstance].maxSalary withExperience:[GlobalData sharedInstance].experience withEducations:[GlobalData sharedInstance].educations withJobNatures:[GlobalData sharedInstance].jobNatures] ;
    self.searchJobApi.netLoadingDelegate = self;
    self.searchJobApi.noNetWorkingDelegate = self;
    [self.searchJobApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        QZ_JobSearchApi *result = (QZ_JobSearchApi *)request;
        if (result.isCorrectResult) {
            if (_search_leftPage == 1) {
                self.search_leftDataArray = [NSMutableArray arrayWithArray:[result getJobSearchList]];
            }else {
                [self.search_leftDataArray addObjectsFromArray:[result getJobSearchList]];
            }
            [self.job_tbView reloadData];
            NSInteger count = [result getJobSearchList].count;
            if (count == 0) {
                [(MJRefreshAutoFooter *)self.job_tbView.mj_footer setHidden:YES];
            }else {
                [(MJRefreshAutoFooter *)self.job_tbView.mj_footer setHidden:NO];
            }
        }else {
            if (_search_leftPage > 1) {
                _search_leftPage --;
            }else {
                self.search_leftDataArray = [NSMutableArray array];
                [self.job_tbView reloadData];
            }
        }
        [self.job_tbView.mj_header endRefreshing];
        [self.job_tbView.mj_footer endRefreshing];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (_search_leftPage > 1) {
            _search_leftPage --;
        }else {
            [self.job_tbView.mj_header endRefreshing];
            [self.job_tbView.mj_footer endRefreshing];
        }
    }];
}

- (void)searchComApiNet {
    if (self.searchComApi && !self.searchComApi.requestOperation.isFinished) {
        [self.searchComApi stop];
    }
    self.searchComApi = [[QZ_ComSearchApi alloc]initWithPage:[NSString stringWithFormat:@"%ld",_search_rightPage] withCoordinate:[GlobalData sharedInstance].coordinate withKeyword:self.searchNavView.searchField.text withCity:[GlobalData sharedInstance].location];
    self.searchComApi.netLoadingDelegate = self;
    self.searchComApi.noNetWorkingDelegate = self;
    [self.searchComApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        QZ_ComSearchApi *result = (QZ_ComSearchApi *)request;
        if (result.isCorrectResult) {
            if (_search_rightPage == 1) {
                self.search_rightDataArray = [NSMutableArray arrayWithArray:[result getCompanySearchList]];
            }else {
                [self.search_rightDataArray addObjectsFromArray:[result getCompanySearchList]];
            }
            [self.job_tbView reloadData];
            NSInteger count = [result getCompanySearchList].count;
            if (count == 0) {
                [(MJRefreshAutoFooter *)self.job_tbView.mj_footer setHidden:YES];
            }else {
                [(MJRefreshAutoFooter *)self.job_tbView.mj_footer setHidden:NO];
            }
        }else {
            if (_search_rightPage > 1) {
                _search_rightPage --;
            }else {
                self.search_rightDataArray = [NSMutableArray array];
                [self.job_tbView reloadData];
            }
        }
        [self.job_tbView.mj_header endRefreshing];
        [self.job_tbView.mj_footer endRefreshing];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (_search_rightPage > 1) {
            _search_rightPage --;
        }else {
            [self.job_tbView.mj_header endRefreshing];
            [self.job_tbView.mj_footer endRefreshing];
        }
    }];
}

- (void)searchNumApiNet {
    if(self.searNumApi && !self.searNumApi.requestOperation.isFinished)
    {
        [self.searNumApi stop];
    }
    
    self.searNumApi = [[QZ_SearchNumApi alloc]initWithKeyword:self.searchNavView.searchField.text withCity:[GlobalData sharedInstance].location];
    self.searNumApi.netLoadingDelegate = self;
    [self.searNumApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        QZ_SearchNumApi *result = (QZ_SearchNumApi *)request;
        if(result.isCorrectResult)
        {
            QZ_seachNumModel *model = [result getSearchNum];
            [self.searchNavView.jobsBtn setTitle:[NSString stringWithFormat:@"职位（%@）",model.zwNum] forState:UIControlStateNormal];
            [self.searchNavView.companyBtn setTitle:[NSString stringWithFormat:@"公司（%@）",model.gsNum] forState:(UIControlStateNormal)];
            [self.searchNavView.jobsBtn setTitle:[NSString stringWithFormat:@"职位（%@）",model.zwNum] forState:UIControlStateSelected];
            [self.searchNavView.companyBtn setTitle:[NSString stringWithFormat:@"公司（%@）",model.gsNum] forState:(UIControlStateSelected)];
        }
        
    } failure:^(YTKBaseRequest *request) {
        
    }];
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.job_tbView) {
        if (self.isSearch) {
            return self.search_leftDataArray.count;
        }else {
            return self.leftDataArray.count;
        }
    }else if (tableView == self.company_tbView) {
        if (self.isSearch) {
            return self.search_rightDataArray.count;
        }else {
            return self.rightDataArray.count;
        }
        return 10;
    }else {
        return 0;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.job_tbView) {
        NSInteger count;
        if (self.isSearch) {
            count = self.search_leftDataArray.count;
        }else{
            count = self.leftDataArray.count;
        }
        if (indexPath.row == count - 1) {
            return 190;
        }
        return 180;
    }else if (tableView == self.company_tbView) {
        return 193;
    }else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.job_tbView) {
        static NSString *jobsIdentifier = @"QZ_JobsTableViewCell";
        QZ_JobsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:jobsIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"QZ_JobsTableViewCell" owner:nil options:nil].lastObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        QZ_JobModel *model = [[QZ_JobModel alloc]init];
        if (self.isSearch) {
            model = self.search_leftDataArray[indexPath.row];
        }else {
            model = self.leftDataArray[indexPath.row];
        }
        cell.jobNameLabel.text = model.zwName;
        NSString *timenow = [NSDate jk_timeInfoWithDateString:model.time];
        cell.timeLabel.text = timenow;
        cell.moneyLabel.text = model.salary;
        CGFloat width1 = [ControlUtil widthWithContent:model.salary withFont:[UIFont systemFontOfSize:16] withHeight:14];
        cell.moneyLabel.width = width1;
        cell.unitLabel.text = @"元/月";
        cell.unitLabel.x = 12 + width1 + 5;
        
        cell.xzrzLabel.x = cell.unitLabel.x + cell.unitLabel.width + 5;
        
        if ([model.isXZRZ isEqualToString:@"1"]) {
            cell.xzrzLabel.hidden = NO;
        }else {
            cell.xzrzLabel.hidden = YES;
        }
        cell.cityLabel.text = model.city;
        cell.educationLabel.text = model.education;
        cell.sexLabel.text = model.sex;
        cell.ageLabel.text = model.age;
        [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.companyImage] placeholderImage:[UIImage imageNamed:@"moren_pt"]];
        ZRViewRadius(cell.headerImageView, 23);
        cell.companyLabel.text = model.company;
        CGFloat width2 = [ControlUtil widthWithContent:model.company withFont:[UIFont systemFontOfSize:13] withHeight:13];
//        cell.companyLabel.width = width2;
        if (width2 > FITWIDTH(163)) {
            width2 = FITWIDTH(163);
        }
        cell.nameWidthCons.constant = width2;
        if (SCREEN_WIDTH < 321) {
            if (width2 > FITWIDTH(150)) {
                width2 = FITWIDTH(150)-25;
            }
            cell.nameWidthCons.constant = width2;
        }
        
        CGFloat wdi = [ControlUtil widthWithContent:[NSString stringWithFormat:@"距%@km",model.distance] withFont:[UIFont systemFontOfSize:10] withHeight:11];
        
        if ([model.isZZ isEqualToString:@"1"]) {
            cell.zhizhaoLabel.image = [UIImage imageNamed:@"icon_zhizhao"];
        }else {
            cell.zhizhaoLabel.image = [UIImage imageNamed:@"tab_zhongjie"];
        }

        cell.distanceLabel.text = [NSString stringWithFormat:@"距%@km",model.distance];
        cell.distanceWidthCons.constant = wdi;
        
        CGFloat width11 = [ControlUtil widthWithContent:model.city withFont:[UIFont systemFontOfSize:11] withHeight:11];
        CGFloat width12 = [ControlUtil widthWithContent:model.education withFont:[UIFont systemFontOfSize:11] withHeight:11];
        CGFloat width13 = [ControlUtil widthWithContent:model.sex withFont:[UIFont systemFontOfSize:11] withHeight:11];
        CGFloat width14 = [ControlUtil widthWithContent:model.age withFont:[UIFont systemFontOfSize:11] withHeight:11];
        cell.widthCons1.constant = width11;
        cell.widthCons2.constant = width12;
        cell.widthCons3.constant = width13;
        cell.widthCons4.constant = width14;
        return cell;
    }else if (tableView == self.company_tbView) {
        static NSString *jobsIdentifier = @"QZ_CompanyTableViewCell";
        QZ_CompanyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:jobsIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"QZ_CompanyTableViewCell" owner:nil options:nil].lastObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        QZ_CompanyModel *model = [[QZ_CompanyModel alloc]init];
        if (self.isSearch) {
            model = self.search_rightDataArray[indexPath.row];
        }else {
            model = self.rightDataArray[indexPath.row];
        }
        [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.companyImage] placeholderImage:[UIImage imageNamed:@"moren_pt"]];
        ZRViewRadius(cell.headerImageView, 23);
        cell.jobNameLabel.text = model.company;
        if ([model.isZZ isEqualToString:@"1"]) {
            cell.zhizhaoView.image = [UIImage imageNamed:@"icon_zhizhao"];
        }else {
            cell.zhizhaoView.image = [UIImage imageNamed:@"tab_zhongjie"];
        }
        cell.jobsNum.text = model.zzzwNum;
        cell.personNum.text = model.zzrsNum;
        if ([model.zprsMonthNum isKindOfClass:[NSNull class]] || [model.zprsMonthNum isEqualToString:@""] || [model.zprsMonthNum isEqualToString:@"null"]) {
            model.zprsMonthNum = @"0";
        }
        cell.nearlyNum.text = model.zprsMonthNum;
        cell.distanceLabel.text = [NSString stringWithFormat:@"距%@km",model.distance];
        NSString *timenow = [NSDate jk_timeInfoWithDateString:model.time];
        cell.timeLabel.text = [NSString stringWithFormat:@"最近更新：%@",timenow];
        
        CGFloat width = [ControlUtil widthWithContent:model.company withFont:[UIFont systemFontOfSize:16] withHeight:43];
        if (width > FITWIDTH(230)) {
            width = FITWIDTH(230);
        }
        cell.nameWidthCons.constant = width;
        
//        cell.zhizhaoView.x = cell.jobNameLabel.x + width + 5;
        return cell;
    }else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.job_tbView) {
        JobsDetailViewController *jobCtrl = [[JobsDetailViewController alloc]init];
        QZ_JobModel *model;
        if (_isSearch) {
            model = self.search_leftDataArray[indexPath.row];
        }else {
            model = self.leftDataArray[indexPath.row];
        }
        
        jobCtrl.zwId = model.zwId;
        [self.navigationController pushViewController:jobCtrl animated:YES];
    }else if (tableView == self.company_tbView) {
//        if (!isValidStr([GlobalData sharedInstance].selfInfo.sessionId))
//        {
//            [self presentLoginCtrl];
//            return;
//        }
        QZ_CompanyModel *model;
        if (_isSearch) {
            model  = self.search_rightDataArray[indexPath.row];
        }else {
          model  = self.rightDataArray[indexPath.row];
        }
        
        CompanyDetailViewController *companyCtrl = [[CompanyDetailViewController alloc]init];
        companyCtrl.companyId = model.companyId;
        [self.navigationController pushViewController:companyCtrl animated:YES];
    }
}

//textfield
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (!isValidStr(textField.text)) {
        [XHToast showCenterWithText:@"请输入关键词"];
        return NO;
    }
    
    
    
    [self backToNormal];
    _hasSearch = YES;
    
    self.searchNavView.hidden = NO;
    self.jobsNavView.hidden = YES;
    self.searchNavView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 101);
    self.searchNavView.jobsBtn.hidden = NO;
    self.searchNavView.companyBtn.hidden = NO;
    self.sortView.frame = CGRectMake(0, 99, SCREEN_WIDTH, 37);
    self.job_tbView.frame = CGRectMake(0, 136, SCREEN_WIDTH, SCREEN_HEIGHT - 136 - 49);
    self.company_tbView.frame = CGRectMake(0, 99, SCREEN_WIDTH, SCREEN_HEIGHT - 99 - 49);
    
    [self.job_tbView reloadData];
    [self.company_tbView reloadData];
    
    [self searchJobApiNet];
    [self searchNumApiNet];
    [self searchComApiNet];
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - 扫描二维码完成后的代理方法
- (void)didFinshedScanning:(NSString *)result
{
    NSLog(@"%@",result);
}

- (void)didFinshedScanningQRCode:(NSString *)result {
    NSLog(@"%@",result);
}

#pragma mark -- lazyViews

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

- (NSMutableArray *)search_leftDataArray {
    if (_search_leftDataArray == nil) {
        _search_leftDataArray = [[NSMutableArray alloc]init];
    }
    return _search_leftDataArray;
}

- (NSMutableArray *)search_rightDataArray {
    if (_search_rightDataArray == nil) {
        _search_rightDataArray = [[NSMutableArray alloc]init];
    }
    return _search_rightDataArray;
}

- (QZ_JobsNavView *)jobsNavView {
    if (_jobsNavView == nil) {
        _jobsNavView = [[[NSBundle mainBundle] loadNibNamed:@"QZ_JobsNavView" owner:nil options:nil] lastObject];
        _jobsNavView.jobsBtn.selected = YES;
        _jobsNavView.companyBtn.selected = NO;
        
        //如果获取到定位，显示当前城市。默认显示常州
        NSLog(@"---%@",self.selectedCity);
        
        if([GlobalData sharedInstance].location) {
             [_jobsNavView.locationBtn  setTitle:[GlobalData sharedInstance].location forState:UIControlStateNormal];
            
        } else {
             [_jobsNavView.locationBtn  setTitle:@"常州" forState:UIControlStateNormal];
             [GlobalData sharedInstance].location= @"常州";
        }
        
        [_jobsNavView.locationBtn addTarget:self action:@selector(locationBtnPress) forControlEvents:UIControlEventTouchUpInside];
        
        [_jobsNavView.jobsBtn addTarget:self action:@selector(jobsBtnPress) forControlEvents:UIControlEventTouchUpInside];
        [_jobsNavView.companyBtn addTarget:self action:@selector(companyBtnPress) forControlEvents:UIControlEventTouchUpInside];
        [_jobsNavView.QRcodeBtn addTarget:self action:@selector(QRCodeAction) forControlEvents:UIControlEventTouchUpInside];
        [_jobsNavView.searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _jobsNavView;
}

- (QZ_SearchNavView *)searchNavView {
    if (_searchNavView == nil) {
        _searchNavView = [[NSBundle mainBundle] loadNibNamed:@"QZ_SearchNavView" owner:nil options:nil].lastObject;
        UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 0, 15, 15)];
        leftView.image = [UIImage imageNamed:@"icon_shousuo"];
        UIView *reaLeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 45, 15)];
        [reaLeftView addSubview:leftView];
        _searchNavView.searchField.leftView = reaLeftView;
        _searchNavView.searchField.textColor = WhiteColor;
        [_searchNavView.searchField setValue:WhiteColor forKeyPath:@"_placeholderLabel.textColor"];
        _searchNavView.searchField.leftViewMode = UITextFieldViewModeAlways;
        UIImageView *rightView = [[UIImageView alloc]initWithFrame:CGRectMake(21, 1.5, 12, 12)];
        UIView *reaRightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 45, 15)];
        [reaRightView addSubview:rightView];
        rightView.image = [UIImage imageNamed:@"icon_guanbi"];
        _searchNavView.searchField.rightView = reaRightView;
        _searchNavView.searchField.delegate = self;
        _searchNavView.searchField.rightViewMode = UITextFieldViewModeWhileEditing;
        [_searchNavView.cancelBtn addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
        [_searchNavView.jobsBtn addTarget:self action:@selector(search_jobBtnPress) forControlEvents:UIControlEventTouchUpInside];
        [_searchNavView.companyBtn addTarget:self action:@selector(search_companyBtnPress) forControlEvents:UIControlEventTouchUpInside];
        _searchNavView.jobsBtn.selected = YES;
        _searchNavView.companyBtn.selected = NO;
    }
    return _searchNavView;
}

- (QZ_SortView *)sortView {
    if (_sortView == nil) {
        _sortView = [[NSBundle mainBundle] loadNibNamed:@"QZ_SortView" owner:nil options:nil].lastObject;
        [_sortView.timeBtn addTarget:self action:@selector(sort_time) forControlEvents:UIControlEventTouchUpInside];
        [_sortView.moneyBtn addTarget:self action:@selector(sort_money) forControlEvents:UIControlEventTouchUpInside];
        [_sortView.distanceBtn addTarget:self action:@selector(sort_distance) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sortView;
}

- (UITableView *)job_tbView {
    if (_job_tbView == nil) {
        _job_tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 101, SCREEN_WIDTH, SCREEN_HEIGHT - 101 - 49) style:UITableViewStylePlain];
        _job_tbView.delegate = self;
        _job_tbView.dataSource = self;
        _job_tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _job_tbView.backgroundColor = BackgroundColor;
        
        _job_tbView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if (self.isSearch) {
                _search_leftPage = 1;
                [self searchJobApiNet];
            }else {
                _leftPage = 1;
            [self jobsListApiNet];
            }
            
        }];
        _job_tbView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            if (self.isSearch) {
                if (_search_leftDataArray.count == 0 && _search_leftPage) {
                    _search_leftPage = 1;
                }else {
                    _search_leftPage ++;
                }
                [self searchJobApiNet];
            }else {
                if (_leftDataArray.count == 0 && _leftPage) {
                    _leftPage = 1;
                }else {
                    _leftPage ++;
                }
                [self jobsListApiNet];
            }
            
            
        }];
    }
    return _job_tbView;
}

- (UITableView *)company_tbView {
    if (_company_tbView == nil) {
        _company_tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) style:UITableViewStylePlain];
        _company_tbView.delegate = self;
        _company_tbView.dataSource = self;
        _company_tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _company_tbView.backgroundColor = BackgroundColor;
        
        _company_tbView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            if (self.isSearch) {
                _search_rightPage = 1;
                [self searchComApiNet];
            }else {
                _rightPage = 1;
                [self CompanyListApiNet];
            }
            
        }];
        _company_tbView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            
            if (self.isSearch) {
                
                if (_search_rightDataArray.count == 0 && _search_rightPage) {
                    _search_rightPage = 1;
                }else {
                    _search_rightPage ++;
                }
                [self searchComApiNet];
                
            }else {
                if (_rightDataArray.count == 0 && _rightPage) {
                    _rightPage = 1;
                }else {
                    _rightPage ++;
                }
                [self CompanyListApiNet];
            }
        }];
    }
    return _company_tbView;
}

//没有数据时添加占位的view

- (void)addPlaceHolderView {
    _nodataImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 250, FITWIDTH(200) * 2.2, FITWIDTH(200))];  //需要调整
    _nodataImgView.centerX = self.view.centerX;
    _nodataImgView.image = [UIImage imageNamed:@"kongbai"];
    [self.view addSubview: _nodataImgView];
}

//有数据时清除占位图

- (void)removePlaceHolderView {
    
    [_nodataImgView removeFromSuperview];
}

//- (UIImageView *)nodataImgView {
//    if (_nodataImgView == nil) {
//        _nodataImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 250, FITWIDTH(200) * 2.2, FITWIDTH(200))];
//        _nodataImgView.centerX = self.view.centerX;
//        _nodataImgView.image = [UIImage imageNamed:@"kongbai"];
//    }
//    return _nodataImgView;
//}


- (void)setFrame {
    self.jobsNavView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    self.searchNavView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
    self.sortView.frame = CGRectMake(0, 64, SCREEN_WIDTH, 37);
}


@end
