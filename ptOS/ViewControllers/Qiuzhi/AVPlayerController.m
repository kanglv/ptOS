//
//  AVPlayerController.m
//  PlayerDemo
//
//  Created by yuedong on 16/7/13.
//  Copyright © 2016年 e_chenyuqing@126.com. All rights reserved.
//

#import "AVPlayerController.h"
#import <AVFoundation/AVFoundation.h>

//播放地址
//static NSString *urlString = @"http://file.bmob.cn/M02/9D/18/oYYBAFZJkRqAYlYAADGhrfBK7Tg193.mp4";

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface AVPlayerController ()

@property (strong,nonatomic) AVPlayerItem *playerItem;
@property (strong,nonatomic) AVPlayer *player;
@property (strong,nonatomic) AVAsset *asset;
@property (strong,nonatomic) AVPlayerLayer *playerLayer;

@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footerBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerTop;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *videoTitleLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong,nonatomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIButton *BigScreenBtn;
@property (weak, nonatomic) IBOutlet UILabel *runTimeLabel;
@property (assign,nonatomic) BOOL isPlay;
@end

@implementation AVPlayerController

//销毁时移除监听
- (void)dealloc{
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [self.timer invalidate];
    self.timer = nil;
    [self.player pause];
    
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self addPlayer];
    
    self.videoTitleLabel.text = @"公司环境";
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setHideOrShowOrPause)];
    [self.view addGestureRecognizer:tap];
    
}

//添加播放器
- (void)addPlayer{
    
    //创建播放器
    self.asset = [AVAsset assetWithURL:[NSURL URLWithString:self.url]];
    
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.asset];
    [self.playerItem addObserver:self forKeyPath:@"status" options:0 context:nil];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.backgroundColor = [UIColor blackColor].CGColor;
    self.playerLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.view.layer addSublayer:self.playerLayer];
    
    //获取进度条信息
    CMTime cmtime = self.asset.duration;
    int seconds = (int)cmtime.value/cmtime.timescale;//视频的时长／视频压缩比
    self.slider.maximumValue = seconds;//设置slide的最大值为换算后的总时间值
    self.slider.value = 0;//设置slide的初始值为0
    //视频总时间 以 mm:ss 的格式显示在lable中
    
    self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",seconds/60/60,seconds/60,seconds%60];
    //初始化播放进度 为 00:00
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(refreshSlideTime) userInfo:nil repeats:YES];
    
    [self.view addSubview:self.footerView];
    [self.view addSubview:self.headerView];
}
//刷新进度时间,进度条
-(void)refreshSlideTime{
    
    //获取当前视频的播放时长，根据当前的压缩比转换后， 以mm:ss 格式显示在label中
    if (self.isPlay) {
        //获取进度条信息
        double time = self.player.currentTime.value / self.player.currentTime.timescale;
        self.slider.value = time;
        NSString *runTimeStr = [NSString stringWithFormat:@"%02d:%02d:%02d",(int)time/60/60,(int)time/60,(int)time%60];
        self.runTimeLabel.text = runTimeStr;
        //当视频结束时，停止定时器并将标志位置为 NO，以便点击play按钮时，可以直接播放视频，但是要注意在slide的事件下处理定时器
        
        if (self.slider.value == self.playerItem.duration.value/self.playerItem.duration.timescale){
            [self.playBtn setSelected:NO];
            [self.timer invalidate];
            
        }

    }
    
}

//暂停或播放
- (IBAction)playOrPauseClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (!sender.selected) {
        [self.player pause];
        self.isPlay = NO;
    }else{
        [self.player play];
        self.isPlay = YES;
    }
}
//拖放进度条
- (IBAction)sliderValueChange{
    
    if (self.slider.value <= self.slider.maximumValue){
        
        CMTime moveTime = CMTimeMake(self.player.currentTime.timescale*self.slider.value, self.player.currentTime.timescale);
        [self.player seekToTime:moveTime];
        [self.player play];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(refreshSlideTime) userInfo:nil repeats:YES];
    }else{
        [self.player pause];
    }
    
  
}
//关闭
- (IBAction)closeClick:(id)sender {

    [self dismissViewControllerAnimated:NO completion:nil];
    
}
//全屏/小屏切换
- (IBAction)smallBigScreenClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        [UIView animateWithDuration:0.5 animations:^{
            CGAffineTransform transform = CGAffineTransformMakeRotation(90 * M_PI/180.0);
            [self.view setTransform:transform];
            [self.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            [self.playerLayer setFrame:self.view.bounds];
        }];
        
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            CGAffineTransform transform = CGAffineTransformMakeRotation(0 * M_PI/180.0);
            [self.view setTransform:transform];
            [self.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            [self.playerLayer setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        }];

    }
    
}
//隐藏/显示控制栏
- (void)setHideOrShowOrPause{
    
    if (self.headerTop.constant == 0) {
        //隐藏
        [self hideFooterAndHeader];
    }else{
        //显示+暂停
        [self showFooterAndHeader];
    }
    
}

- (void)hideFooterAndHeader{
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.5f animations:^{
       
        self.headerTop.constant = -44;
        self.footerBottom.constant = -44;
        [self.view layoutIfNeeded];
        
    }];
    
}

- (void)showFooterAndHeader{
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.5f animations:^{
        
        self.headerTop.constant = 0;
        self.footerBottom.constant = 0;
        [self.view layoutIfNeeded];
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideFooterAndHeader];
    });


}

//监听视频状态,是否可以正常播放
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        NSLog(@"%@", self.playerItem.error);
        
        switch (self.playerItem.status) {
            case AVPlayerItemStatusReadyToPlay:{
                NSLog(@"AVPlayerItemStatusReadyToPlay");
                [self.player play];
                self.isPlay = YES;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self hideFooterAndHeader];
                });
            }
                break;
            case AVPlayerItemStatusUnknown:
                NSLog(@"AVPlayerItemStatusUnknown");
                break;
            case AVPlayerItemStatusFailed:
                NSLog(@"AVPlayerItemStatusFailed");
                break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
