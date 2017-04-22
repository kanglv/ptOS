//
//  SuggestionViewController.m
//  ptOS
//
//  Created by 吕康 on 17/3/7.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "SuggestionViewController.h"
#import "GroundTableViewCell.h"
#import "GroundNoImageTableViewCell.h"
#import "GroupSpeechTableViewCell.h"
#import "DiscoverNavView.h"
#import "PubLishQunaziViewController.h"

#import "DisCover_SearchNavView.h"

#import "MJRefresh.h"
#import "AFHTTPRequestOperation.h"
#import "FX_GroudListApi.h"


#import "FX_GiveGreatApi.h"

#import "UIImageView+WebCache.h"

#import "FX_GetCompanyOtherNoticeApi.h"
#import "FX_CompanyNoticeModel.h"
#import "Discover_DetailViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <AVFoundation/AVFoundation.h>
@interface SuggestionViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UITextFieldDelegate>
{
    NSInteger _leftPage;
    NSInteger _rightPage;
    NSInteger _searchPage;
    NSString *m_content;
    
    BOOL _hasPress;
}
@property (nonatomic,strong)DiscoverNavView *navView;
@property (nonatomic,strong)UITableView *left_tbView;

@property (nonatomic,strong)DisCover_SearchNavView *searchNavView;

@property (nonatomic,strong)UIView *searchView1;
@property (nonatomic,strong)UIView *searchView2;



@property (nonatomic, strong)NSMutableArray * leftDataArray;


@property (nonatomic, strong)NSMutableArray *searchDataArray;

@property (nonatomic, strong)FX_GiveGreatApi *giveGreatApi;
@property (nonatomic, strong)FX_GroudListApi *groundListApi;

@property (nonatomic, strong)FX_GetCompanyOtherNoticeApi *getCompanyApi;

@property (nonatomic,assign)BOOL isSearch;

@property (nonatomic,assign)BOOL isGround;

@property (nonatomic ,strong)UIImageView *placeholderImageView;


@property (nonatomic, strong)UIImageView *nodataImgView;



@property (nonatomic, strong)UITapGestureRecognizer *tapGestureReconizer;

@property (nonatomic, strong)AVAudioPlayer *player;

@end

@implementation SuggestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needNav = NO;
    _hasPress = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _leftPage = 1;
    self.title = @"工友集";
    _searchPage = 1;
    self.isSearch = NO;
    self.isGround = YES;
    
    [self getCompanyOtherNoticeApiNet];
    [self initUI];
    
}

- (void)dealloc {
    
}

//添加一个占位图
- (void)addPlaceholder {
    _placeholderImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"kongbai"]];
    _placeholderImageView.frame = CGRectMake(0, 250, self.view.frame.size.width, FITWIDTH(200));//待调整
    [self.view addSubview:_placeholderImageView];
    
}

//移除占位图
- (void)removePlaceholder {
    
    [_placeholderImageView removeFromSuperview];
}

#pragma mark - customFuncs
- (void)initUI {
    
    [self.view addSubview:self.left_tbView];
    
    [self.view addSubview:self.searchNavView];
    
    [self.view addSubview:self.navView];
    
    
    
    
    [self setFrame];
    
    
}



- (void)shareActionWithContent:(UIButton *)sender {
    GroundNoImageTableViewCell *cell = (GroundNoImageTableViewCell *)sender.superview.superview.superview;
    NSIndexPath *indexpath = [self.left_tbView indexPathForCell:cell];
    FX_CompanyNoticeModel *model = [[FX_CompanyNoticeModel alloc]init];
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




- (void)searchBtnPress {
    
    self.navView.hidden = YES;
    self.searchNavView.hidden = NO;
    self.searchView1.hidden = YES;
    self.searchView2.hidden = YES;
    
    
    self.isSearch = YES;
    [self.searchDataArray removeAllObjects];
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
    
    [self.left_tbView reloadData];
}

- (void)refresh {
    
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
    }else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.left_tbView) {
        FX_CompanyNoticeModel *model = [[FX_CompanyNoticeModel alloc]init];
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
                return 231;
            }else {
                return 181 - 60 + height;
            }
        }else if([model.fileType isEqualToString:@"2"]){
            
            return 154 ;
        } else {
            return 231;
        }
        
    }else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.leftDataArray[indexPath.row ];
    FX_CompanyNoticeModel *model = [[FX_CompanyNoticeModel alloc]initWithDic:dic];
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
            
            [cell.commentBtn addTarget:self action:@selector(commentBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
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
             [cell.commentBtn addTarget:self action:@selector(commentBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
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
            [cell.zanBtn addTarget:self action:@selector(dianzanActionHas:) forControlEvents:UIControlEventTouchUpInside];
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
        
        [cell.commentBtn addTarget:self action:@selector(commentBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
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
        
         [cell.commentBtn addTarget:self action:@selector(commentBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.leftDataArray[indexPath.row ];
    FX_CompanyNoticeModel *model = [[FX_CompanyNoticeModel alloc]initWithDic:dic];
    Discover_DetailViewController *ctrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Discover_DetailViewController"];
    ctrl.tzId = model.tzId;
    [self.navigationController pushViewController:ctrl animated:YES];
    
    
}

- (void)playSpeech:(UIButton *)sender{
    //广场列表的播放录音
    FX_CompanyNoticeModel *model = [[FX_CompanyNoticeModel alloc]init];
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
        
        
        NSString *amrfilePath = [NSString stringWithFormat:@"%@/%@.aac", docDirPath , model.tzId];
        
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


- (void)commentBtnClicked:(UIButton *)sender {
    if (!isValidStr([GlobalData sharedInstance].selfInfo.sessionId))
    {
        [self presentLoginCtrl];
        return;
    }
    GroundNoImageTableViewCell *cell = (GroundNoImageTableViewCell *)sender.superview.superview.superview;
    NSIndexPath *indexpath = [self.left_tbView indexPathForCell:cell];
     FX_CompanyNoticeModel *model = [[FX_CompanyNoticeModel alloc]init];
    if (_isSearch) {
        model = self.searchDataArray[indexpath.row];
    }else {
        model = self.leftDataArray[indexpath.row];
    }
    Discover_DetailViewController *ctrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Discover_DetailViewController"];
    ctrl.tzId = model.tzId;
    [self.navigationController pushViewController:ctrl animated:YES];
}


- (void)dianzanActionNO:(UIButton *)sender {
    if (!isValidStr([GlobalData sharedInstance].selfInfo.sessionId))
    {
        [self presentLoginCtrl];
        return;
    }
    
    GroundNoImageTableViewCell *cell = (GroundNoImageTableViewCell *)sender.superview.superview.superview;
    NSIndexPath *indexpath = [self.left_tbView indexPathForCell:cell];
    FX_CompanyNoticeModel *model = [[FX_CompanyNoticeModel alloc]init];
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
    FX_CompanyNoticeModel *model = [[FX_CompanyNoticeModel alloc]init];
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


#pragma mark - NetworkApis
- (void)getCompanyOtherNoticeApiNet {
    if (self.getCompanyApi && !self.getCompanyApi.requestOperation.isFinished) {
        [self.getCompanyApi stop];
    }
    self.getCompanyApi = [[FX_GetCompanyOtherNoticeApi alloc]initWithPage:[NSString stringWithFormat:@"%ld",(long)_leftPage] withSessionId:[GlobalData sharedInstance].selfInfo.sessionId withType:@"3"];
    self.getCompanyApi .netLoadingDelegate = self;
    self.getCompanyApi .noNetWorkingDelegate = self;
    [self.getCompanyApi  startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        FX_GetCompanyOtherNoticeApi *result = (FX_GetCompanyOtherNoticeApi *)request;
        if (result.isCorrectResult) {
            [self removePlaceholder];
            if (_leftPage == 1) {
                self.leftDataArray = [NSMutableArray arrayWithArray:[result getCompanyOtherNotice]];
            }else {
                [self.leftDataArray addObjectsFromArray:[result getCompanyOtherNotice]];
            }
            [self.left_tbView reloadData];
            NSInteger count = [result getCompanyOtherNotice].count;
            if (count == 0) {
                [self addPlaceholder];
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
        [self addPlaceholder];
        [self.left_tbView reloadData];
        if (_leftPage > 1) {
            _leftPage --;
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





- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (!isValidStr(textField.text)) {
        [XHToast showCenterWithText:@"请输入关键词"];
        return NO;
    }
    self.left_tbView.hidden = NO;
    //插入搜索api
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



- (NSMutableArray *)searchDataArray {
    if (_searchDataArray == nil) {
        _searchDataArray = [NSMutableArray array];
    }
    return _searchDataArray;
}

- (UITableView *)left_tbView {
    if (_left_tbView == nil) {
        _left_tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 ) style:UITableViewStylePlain];
        _left_tbView.delegate = self;
        _left_tbView.dataSource = self;
        _left_tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _left_tbView.backgroundColor = BackgroundColor;
        _left_tbView.tableHeaderView = self.searchView1;
        
        
        _left_tbView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _leftPage = 1;
            
        }];
        _left_tbView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            if (_leftDataArray.count == 0 && _leftPage) {
                _leftPage = 1;
            }else {
                _leftPage ++;
            }
            
        }];
    }
    return _left_tbView;
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (DiscoverNavView *)navView {
    if (_navView == nil) {
        _navView = [[NSBundle mainBundle] loadNibNamed:@"DiscoverNavView" owner:nil options:nil].lastObject;
        
        [_navView.publishBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [_navView.publishBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [_navView.groundBtn2 setTitle:@"意见征集" forState:UIControlStateNormal];
        _navView.groundBtn.hidden = YES;
        _navView.companyBtn.hidden = YES;
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
