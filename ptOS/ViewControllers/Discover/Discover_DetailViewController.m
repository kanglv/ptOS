//
//  Discover_DetailViewController.m
//  ptOS
//
//  Created by 周瑞 on 16/9/15.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "Discover_DetailViewController.h"
#import "SHLUILabel.h"
#import "FX_ReplyApi.h"
#import "FX_TzDetailApi.h"
#import "FX_GiveGreatApi.h"
#import "AFHTTPRequestOperation.h"
#import "JuBaoViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

#import "FX_TZDetailModel.h"
#import "UIImageView+WebCache.h"

#import "DiscoverLabel.h"

#import "LayoutTextView.h"
#import "QZTopTextView.h"

#import "IQKeyboardManager.h"

#import "UIButton+JKTouchAreaInsets.h"

#import "UITextView+JKPlaceHolder.h"

@interface Discover_DetailViewController ()<ReplyDelegate,QZTopTextViewDelegate>
{
    BOOL _isFirst;
    NSString *_replyId;
    NSString *_replyName;
    
    QZTopTextView * _textView;
    
    BOOL _isReply;
    
    NSString *m_content;
}
@property (weak, nonatomic) IBOutlet UIView *navView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *dianzanBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *jubaoBtn;
@property (weak, nonatomic) IBOutlet UIView *shuView;
@property (weak, nonatomic) IBOutlet UIView *fengeView;

@property (weak, nonatomic) IBOutlet UIImageView *smallImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;

@property (nonatomic, strong)FX_TzDetailApi *detailApi;
@property (nonatomic, strong)FX_ReplyApi *replyApi;
@property (nonatomic, strong)FX_GiveGreatApi *giveGreatApi;

@property (nonatomic, strong)NSMutableArray *dataArray;


@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCons;

@property (weak, nonatomic) IBOutlet UIButton *addressView;

@property (weak, nonatomic) IBOutlet UIImageView *zanBtnBlue;
@property (weak, nonatomic) IBOutlet UILabel *zanLabel;

@property (nonatomic,strong)LayoutTextView *layoutTextView;

@property (nonatomic,strong)NSString *repluId;
@property (nonatomic,strong)NSString *replyName;

@end

@implementation Discover_DetailViewController

#pragma mark - lifeCycles

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needNav = NO;
    _replyId = @"";
    _replyName = @"";
    self.view.backgroundColor = WhiteColor;
    _isFirst = YES;
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - customFuncs
- (void)initUI {

    self.backBtn.jk_touchAreaInsets = UIEdgeInsetsMake(30, 30, 30, 30);
    
    [self detailApiNet];
    
    
    _textView =[QZTopTextView topTextView];
    _textView.delegate = self;
    [self.view addSubview:_textView];
    
    [self.dianzanBtn setImage:[UIImage imageNamed:@"icon_dianzan_white"] forState:UIControlStateNormal];
    [self.dianzanBtn setImage:[UIImage imageNamed:@"icon_dianzan_press"] forState:UIControlStateSelected];
    

    
    [NotificationCenter addObserver:self selector:@selector(disappear) name:UIKeyboardDidHideNotification object:nil];
}

- (void)sendComment {
    NSString *str = _textView.lpTextView.text;
    if (str.length > 140) {
        [XHToast showCenterWithText:@"字数过多"];
        return;
    }
    [self.view endEditing:YES];
    [self replyApiNetwithContent:str];
}

- (void)disappear {

    _isReply = NO;
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)dianzanAction:(id)sender {
    if (!isValidStr([GlobalData sharedInstance].selfInfo.sessionId)) {
        [self presentLoginCtrl];
        return;
    }
    self.dianzanBtn.selected = !self.dianzanBtn.selected;
    [self giveGreateApiNet];
}
- (IBAction)shareAction:(id)sender {
    
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"shareImg.png"]];
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:m_content
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
- (IBAction)jubaoAction:(id)sender {
    JuBaoViewController *ctrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"JuBaoViewController"];
    [self.navigationController pushViewController:ctrl animated:YES];
}

#pragma mark - NetworkApis
- (void)detailApiNet {
    if (self.detailApi && !self.detailApi.requestOperation.isFinished) {
        [self.detailApi stop];
    }
    self.detailApi = [[FX_TzDetailApi alloc]initWithtzId:self.tzId];
    self.detailApi.netLoadingDelegate = self;
    self.detailApi.noNetWorkingDelegate = self;
    [self.detailApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        FX_TzDetailApi *result = (FX_TzDetailApi *)request;
        if (result.isCorrectResult) {

            if ([[GlobalData sharedInstance].selfInfo.companyName isEqualToString:@""] || [GlobalData sharedInstance].selfInfo.companyName == nil || [[GlobalData sharedInstance].selfInfo.companyName isKindOfClass:[NSNull class]]) {
                self.shuView.hidden = YES;
            }else {
                self.shuView.hidden = NO;
            }
            
            FX_TZDetailModel *model = [result getTzDetail];
            [self.smallImageView sd_setImageWithURL:[NSURL URLWithString:model.headerUrl] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
            ZRViewRadius(self.smallImageView, 12);
            self.nickNameLabel.text = model.nickName;
            [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"moren_pt"]];
            self.companyNameLabel.text = model.companyName;
            m_content = model.content;
            self.timeLabel.text = model.time;
            [self.addressBtn setTitle:model.address forState:UIControlStateNormal];
            self.contentLabel.text = model.content;
            if ([model.isLike isEqualToString:@"1"]) {
                self.dianzanBtn.selected = YES;
            }else {
                self.dianzanBtn.selected = NO;
            }
            self.zanLabel.text = model.greatPeople;
            //排列回复
            
            DiscoverLabel *view = [[DiscoverLabel alloc]initWithArray:model.replyList];
            view.delegate = self;
            ZRViewRadius(view, 10);
            NSString *height = [UserDefault objectForKey:@"height"];
            view.frame = CGRectMake(12, 240, FITWIDTH(351), [view getHeightWithArray:model.replyList] + 5);
            [self.contentView addSubview:view];
            CGFloat width1 = [ControlUtil widthWithContent:model.nickName withFont:[UIFont systemFontOfSize:14] withHeight:13];
            self.nickNameLabel.width = width1;
            self.shuView.x = self.nickNameLabel.x + width1 + 5;
            self.companyNameLabel.x = self.shuView.x + 5;
            CGFloat height1;
            if ([model.imgUrl isEqualToString:@""] || model.imgUrl == nil || model.imgUrl.length < 5) {
                height1 = [ControlUtil heightWithContent:model.content withFont:[UIFont systemFontOfSize:15] withWidth:FITWIDTH(333)];
                self.contentLabel.width = FITWIDTH(333);
                self.bigImageView.hidden = YES;
            }else {
                height1 = [ControlUtil heightWithContent:model.content withFont:[UIFont systemFontOfSize:15] withWidth:FITWIDTH(242)];
                self.bigImageView.hidden = NO;
            }
            
            CGFloat height2 = [ControlUtil heightWithContent:model.greatPeople withFont:[UIFont systemFontOfSize:12] withWidth:FITWIDTH(290)];
            if (height2 < 21) {
                height2 = 20;
            }
            self.zanLabel.height = height2;
            self.contentLabel.height = height1;
            
            if (height1 > 60 ) {
                self.addressView.y = 166  + height1 - 60;
                self.addressBtn.y = 170 + height1 - 60;
                self.zanBtnBlue.y = 204 + height1 - 60;
                self.zanLabel.y = 201 + height1 - 60;
                
                view.y = 240 + height1 - 60 + height2 - 20;
                
            }
            if (view.height < 10) {
                view.height = 0;
            }
            
            CGFloat totalHeight = view.y + height.floatValue;
            if (totalHeight < 480) {
                totalHeight = 480;
            }
            NSLog(@"%f",self.addressView.y);
            self.fengeView.y = self.addressView.y;
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(16, self.smallImageView.y + self.smallImageView.height + 11 , 346, 1)];
            lineView.backgroundColor = UIColorWithRGB(0xF2F2F2);
            [self.contentView addSubview:lineView];
            NSLog(@"%f",self.fengeView.y);
            if ([model.greatPeople isEqualToString:@""] || model.greatPeople == nil) {
                self.zanBtnBlue.hidden = YES;
            }
            self.heightCons.constant = totalHeight + 20 + 45 + 20;
            _isFirst = NO;
            
            if (model.replyList.count == 0) {
                view.hidden = YES;
            }else {
                view.hidden = NO;
            }
            
        }else {
            
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {

    }];
}

- (void)giveGreateApiNet {
    if (!isValidStr([GlobalData sharedInstance].selfInfo.sessionId))
    {
        [self presentLoginCtrl];
        return;
    }
    
    if(self.giveGreatApi&& !self.giveGreatApi.requestOperation.isFinished)
    {
        [self.giveGreatApi stop];
    }
    self.giveGreatApi.sessionDelegate = self;
    self.giveGreatApi = [[FX_GiveGreatApi alloc]initWithtzId:self.tzId];
    
    [self.giveGreatApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        FX_GiveGreatApi *result = (FX_GiveGreatApi *)request;
        if(result.isCorrectResult)
        {
        }
    } failure:^(YTKBaseRequest *request) {
        
    }];
}

- (void)replyApiNetwithContent:(NSString *)content {
    if (!isValidStr([GlobalData sharedInstance].selfInfo.sessionId))
    {
        [self presentLoginCtrl];
        return;
    }
    
    if(self.replyApi&& !self.replyApi.requestOperation.isFinished)
    {
        [self.replyApi stop];
    }
    self.replyApi.sessionDelegate = self;
    
    NSLog(@"id              %@",self.repluId);
    self.replyApi = [[FX_ReplyApi alloc]initWithTzId:self.tzId withRepliedName:self.replyName withContent:content withReplyId:self.repluId];
    self.repluId = @"";
    self.replyName = @"";
    [self.replyApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        FX_ReplyApi *result = (FX_ReplyApi *)request;
        if(result.isCorrectResult)
        {
            [self detailApiNet];
        }
    } failure:^(YTKBaseRequest *request) {
        
    }];
}

#pragma mark - delegate
- (void)replyWithId:(NSString *)Id withRepliedName:(NSString *)name {
    _isReply = YES;
    self.repluId = Id;
    self.replyName = name;
    [_textView.lpTextView becomeFirstResponder];

//    _textView.lpTextView.placeholderText = [NSString stringWithFormat:@"回复%@",name];
}
#pragma mark - lazyViews
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

@end
