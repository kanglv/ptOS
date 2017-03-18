//
//  PublishSpeechViewController.m
//  ptOS
//
//  Created by 吕康 on 17/2/20.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "PublishSpeechViewController.h"

#import "AFHTTPRequestOperation.h"
#import "FX_PublishTZApi.h"
#import "AJPhotoPickerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "AJPhotoBrowserViewController.h"
#import "OSSManager.h"

@interface PublishSpeechViewController ()<AVAudioPlayerDelegate,AVAudioRecorderDelegate,UIGestureRecognizerDelegate>


@property (nonatomic,strong)FX_PublishTZApi *publishApi;

//录音存储路径
@property (nonatomic, strong)NSURL *tmpFile;
//录音
@property (nonatomic, strong)AVAudioRecorder *recorder;
//播放
@property (nonatomic, strong)AVAudioPlayer *player;
//录音状态(是否录音)
@property (nonatomic, assign)BOOL isRecoding;

@property (nonatomic, strong)AVAudioSession * audioSession;

@property (nonatomic, strong)UILongPressGestureRecognizer *longPressGesture;

@property (nonatomic, strong)NSTimer *timer;

@property (nonatomic, strong)UILabel *timeLabel;

@property (nonatomic, strong)UIButton *deleteBtn;

@property (nonatomic, strong)NSString *filePath;

@property int time;

@end

@implementation PublishSpeechViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布圈子";
    _isRecoding = NO;
    [self initUI];
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];

}

- (void)dealloc {
}

#pragma mark - customFuncs



- (void)initUI {
    
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"    发表" forState:UIControlStateNormal];
    [btn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake(0, 0, 60, 40)];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
   
    
    self.topView.backgroundColor = MainColor;
    
    [self addTimeLabel];
    self.time = 0;
    
    self.record.backgroundColor = MainColor;
    
    //录音按钮
    self.longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    self.longPressGesture.delegate = self;
    
   
    [self.record addGestureRecognizer:self.longPressGesture];
    


    
   
    self.locationLabel.text = [GlobalData sharedInstance].location; //显示当前定位
    
}

- (void)addTimeLabel{
    self.timeLabel = [ [UILabel alloc]initWithFrame:CGRectMake(0, 60, self.topView.frame.size.width, 40)];
    self.timeLabel.text = @"00:00";
    self.timeLabel.textAlignment= NSTextAlignmentCenter;
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.font = [UIFont fontWithName:@"Arial" size:25];
    [self.topView addSubview: self.timeLabel];

}

//录音结束后添加删除按钮
- (void)addDeleteBtn {
    
    self.deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(230, 50, 40, 20)];
    
    [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    
    self.deleteBtn.titleLabel.font = [UIFont fontWithName:@"Arial" size:15];
    self.deleteBtn.layer.borderWidth = 1;
    self.deleteBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.deleteBtn.layer.cornerRadius = 10;
    [self.deleteBtn addTarget:self action:@selector(deleteRecord) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.deleteBtn];
}

- (void)deleteRecord {
    //按钮移除
//    [self.audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
//    self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:_tmpFile error:
//                             nil];
//    NSLog(@"%@",_tmpFile);
//    [self.player play];
    [self.recorder deleteRecording];
    [self.deleteBtn removeFromSuperview];
    self.timeLabel.text = @"00:00";
}
- (void)handleLongPress:(UILongPressGestureRecognizer *)longPressGesture{
    if (longPressGesture.state ==  UIGestureRecognizerStateBegan) {
        
       

        [self.record setTitle:@"松开停止" forState:UIControlStateNormal];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerMove) userInfo:nil repeats:YES];
        
        [self PT_StartRecord];
    }
    
    if (longPressGesture.state == UIGestureRecognizerStateChanged) {
        NSLog(@"UIGestureRecognizerStateEnded");
    }
    
    if (longPressGesture.state == UIGestureRecognizerStateEnded) {
        
        NSLog(@"UIGestureRecognizerStateEnded");
        //长按结束后显示删除按钮
        [self.record setTitle:@"按住说两句" forState:UIControlStateNormal];
        [self.timer invalidate];
        self.timer=nil;
        self.time = 0; //计时器归0
        [self addDeleteBtn]; //添加删除按钮
        
    }
}


- (void)timerMove{
    self.time ++;
    int minute = ceilf(self.time/60);
    int second = self.time % 60;
    NSLog(@"当前录音时间：%d",minute);
    if(minute <1){
        if(second<10){
            self.timeLabel.text = [NSString stringWithFormat:@"00:0%d",second];
        } else {
            self.timeLabel.text = [NSString stringWithFormat:@"00:%d",second];
        }
    } else if (minute>1&&minute<10){
        if(second<10){
            self.timeLabel.text = [NSString stringWithFormat:@"0%d:0%d",minute, second];
        } else {
            self.timeLabel.text = [NSString stringWithFormat:@"0%d:%d",minute,second];
        }
    } else{
        if(second<10){
            self.timeLabel.text = [NSString stringWithFormat:@"%d:0%d",minute,second];
        } else {
            self.timeLabel.text = [NSString stringWithFormat:@"%d:%d",minute, second];
        }
    }
}

//录音
- (void)PT_StartRecord {
    
    _audioSession = [AVAudioSession sharedInstance];
    NSError *setCategoryError = nil;
    //设置AVAudioSession
    [_audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&setCategoryError];
    if(setCategoryError) {
         NSLog(@"%@", [setCategoryError description]);
    }else {
        
        [_audioSession setActive:YES error:nil];
        
    }
    
    
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [NSNumber numberWithFloat: 44100],AVSampleRateKey, //采样率
                                   [NSNumber numberWithInt: kAudioFormatMPEG4AAC],AVFormatIDKey,
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数 默认 16
                                   [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,//通道的数目
                                  
                                   nil];
//然后直接把文件保存成.aac就好了
    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    self.filePath = [NSString stringWithFormat:@"%@/%5.2f.aac", docDirPath ,[[NSDate date] timeIntervalSince1970] ];
    _tmpFile = [NSURL URLWithString:self.filePath];
    
    NSLog(@"%@",_tmpFile);
    
    //初始化录音控件
    self.recorder = [[AVAudioRecorder alloc] initWithURL:_tmpFile settings:recordSetting error:nil];
    self.recorder.delegate = self;
    
    if ([self.recorder prepareToRecord]) {
        //开始
         self.recorder.meteringEnabled =YES;
        [self.recorder record];
    }
    
}



- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    
}
//停止录音后

- (void)endRecord:(UIButton *)sender {
   
    _isRecoding = NO;
    [self.audioSession setActive:NO error:nil];

    [ self.recorder stop];
    [self.record setTitle:@"按住说两句" forState:UIControlStateNormal];
    
}



- (void)next {
    if (!isValidStr([GlobalData sharedInstance].selfInfo.sessionId))
    {
        [self presentLoginCtrl];
        return;
    }
   
    NSData *data = [NSData dataWithContentsOfFile:self.filePath];
    
    
    //音频文件命名
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
    NSString *fileName = [NSString stringWithFormat:@"%@.aac",timeSp];
    [[OSSManager sharedManager] uploadObjectAsyncWithData:data andFileName:fileName andBDName:@"bd-image" andIsSuccess:^(BOOL isSuccess, UIImage *image) {
        if(isSuccess){
            //将音频文件地址上传到本机服务器
            [self publishApiNetWithImgUrl:[NSString stringWithFormat:@"http://bd-image.img-cn-shanghai.aliyuncs.com/%@",fileName]];
        }
    } andProgressBlock:^(int64_t has, int64_t total, int64_t will) {
        
    }];
    
}

- (void)publishApiNetWithImgUrl:(NSString *)url {
    
    if(self.publishApi&& !self.publishApi.requestOperation.isFinished)
    {
        [self.publishApi stop];
    }
    self.publishApi.sessionDelegate = self;
    NSString *isQYQ = @"0";
    if (self.switchBtn.isOn) {
        isQYQ = @"1";
    }
     self.publishApi = [[FX_PublishTZApi alloc]initWithContent:@"1" withImgUrl:url withAddress:self.locationLabel.text withIsQYQ:isQYQ];
    
    [self.publishApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        FX_PublishTZApi *result = (FX_PublishTZApi *)request;
        if(result.isCorrectResult)
        {
            //            [XHToast showCenterWithText:@"发表成功"];
            [NotificationCenter postNotificationName:@"publish_refresh" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(YTKBaseRequest *request) {
        
    }];
}














@end
