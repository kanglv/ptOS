//
//  PT_MapViewController.m
//  ptOS
//
//  Created by 周瑞 on 16/9/9.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "PT_MapViewController.h"
#import "PT_MsgDetailApi.h"
#import "PT_MsgDetailModel.h"
#import "AFHTTPRequestOperation.h"
#import <MAMapKit/MAMapKit.h>
#import <MapKit/MapKit.h>
#import "TQLocationConverter.h"
#import "PT_OperNoticeNetApi.h"

@interface PT_MapViewController ()

@property (nonatomic, strong)PT_MsgDetailApi *detailApi;
@property (nonatomic,strong)PT_OperNoticeNetApi *operNoticeApi;


@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *d_timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *ziliaoLabel;

@property (strong, nonatomic) IBOutlet UILabel *connectPerson;
@property (strong, nonatomic) IBOutlet UILabel *connectMethod;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *metrialLabel;

@property (nonatomic,strong)NSString *coordinate;

@property (weak, nonatomic) IBOutlet MAMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;
@property (weak, nonatomic) IBOutlet UIButton *refuseBtn;
@end

@implementation PT_MapViewController

#pragma mark - lifeCycles

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    self.mapView.showsUserLocation = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.mapView.mapType = MAMapTypeStandard;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - customFuncs

#pragma mark - Networkapis
- (void)initUI {
    
    [self.refuseBtn addTarget:self action:@selector(refuseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.acceptBtn addTarget:self action:@selector(acceptBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
//    self.refuseBtn.hidden = YES;
//    self.acceptBtn.hidden = YES;
    [self detailApiNet];
}

- (void)acceptBtnClick {
    //接受
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认接受？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self operNoticeApiNet:@"1"];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)refuseBtnClick {
    //放弃
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认放弃？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self operNoticeApiNet:@"2"];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)operNoticeApiNet:(NSString *)oper {
    if(self.operNoticeApi && !self.operNoticeApi.requestOperation.isFinished)
    {
        [self.operNoticeApi stop];
    }
    
    self.operNoticeApi.sessionDelegate = self;
    self.operNoticeApi = [[PT_OperNoticeNetApi alloc] initWithJobresumeId:self.msgId withJobresumeStatus:@"" withOper:oper];
    self.operNoticeApi.netLoadingDelegate = self;
    [self.operNoticeApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        PT_OperNoticeNetApi *result = (PT_OperNoticeNetApi *)request;
        if(result.isCorrectResult){
            [XHToast showCenterWithText:@"操作成功"];
        }
    } failure:^(YTKBaseRequest *request) {
        [XHToast showCenterWithText:@"操作失败"];
    }];

}

- (void)detailApiNet {
    if(self.detailApi && !self.detailApi.requestOperation.isFinished)
    {
        [self.detailApi stop];
    }
    
    self.detailApi.sessionDelegate = self;
    self.detailApi = [[PT_MsgDetailApi alloc] initWithMsgId:self.msgId];
    self.detailApi.netLoadingDelegate = self;
    [self.detailApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        PT_MsgDetailApi *result = (PT_MsgDetailApi *)request;
        if(result.isCorrectResult)
        {
            PT_MsgDetailModel *model = [result getMsgDetail];
            [self.navigationItem setTitle:model.title];
            self.mainTitleLabel.text = model.content;
            self.timeLabel.text = model.postTime;
            self.d_timeLabel.text = model.time;
            self.addressLabel.text = model.address;
            self.metrialLabel.text = model.material;
            self.connectPerson.text = @"";
            self.connectMethod.text = @"";
            
            if ([model.material isEqualToString:@""]) {
                self.metrialLabel.text = @"无";
            }
            
            CGFloat height = [ControlUtil heightWithContent:model.material withFont:[UIFont systemFontOfSize:15] withWidth:FITWIDTH(199)];
            if (height <= 21) {
                self.metrialLabel.height = 21;
                self.ziliaoLabel.height = 21;
            }else {
                self.metrialLabel.height = height;
                self.ziliaoLabel.height = height;
            }
            
            NSString *coor = model.coordinate;
            self.coordinate = model.coordinate;
            NSArray *array = [coor componentsSeparatedByString:@","];
            if (array.count > 1) {
                NSString *longti = array[0];
                NSString *lati = array[1];
                CLLocationCoordinate2D cl2d = CLLocationCoordinate2DMake(lati.doubleValue, longti.doubleValue);
                _mapView.zoomLevel = 18;
                [_mapView setCenterCoordinate:cl2d];
                
                MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
                pointAnnotation.coordinate = CLLocationCoordinate2DMake(lati.doubleValue, longti.doubleValue);
                pointAnnotation.title = model.address;
                
                [_mapView addAnnotation:pointAnnotation];
            }
            
        }
        
    } failure:^(YTKBaseRequest *request) {
        
    }];
}

- (IBAction)navAction:(id)sender {
    NSArray *array = [self.coordinate componentsSeparatedByString:@","];
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



#pragma mark - delegate



@end
