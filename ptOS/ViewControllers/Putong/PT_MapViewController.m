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

@interface PT_MapViewController ()

@property (nonatomic, strong)PT_MsgDetailApi *detailApi;



@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *d_timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *ziliaoLabel;


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
    
    self.refuseBtn.hidden = YES;
    self.acceptBtn.hidden = YES;
    [self detailApiNet];
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
