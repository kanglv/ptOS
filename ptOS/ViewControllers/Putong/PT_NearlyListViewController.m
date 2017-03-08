//
//  PT_NearlyListViewController.m
//  ptOS
//
//  Created by 吕康 on 17/3/6.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "PT_NearlyListViewController.h"
#import "PT_NearlyListModel.h"
#import "PT_NearlyListApi.h"
#import "PT_NearlyListTableViewCell.h"

#import "UIImageView+WebCache.h"
#import "MJRefresh.h"

@interface PT_NearlyListViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger _page;
}

@property (strong , nonatomic)PT_NearlyListApi *getNearlyApi;



@property (strong ,nonatomic)UITableView *tableView;

@property (strong, nonatomic)NSMutableArray *dataArr;

@property (strong , nonatomic)UIImageView *noDataImageView;

@end

@implementation PT_NearlyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    self.title = @"附近的";
    _page = 1 ;
  
    
    [self getNearlyApiNet];
   
    [self initTableView];
    
}


- (void)initTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height-84) ];
    self.tableView.backgroundColor = BackgroundColor ;
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    self.tableView.separatorStyle = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [self.dataArr objectAtIndex:indexPath.row];
    static NSString *jobsIdentifier = @"PT_NearlyListTableViewCell";
    PT_NearlyListTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:jobsIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"PT_NearlyListTableViewCell" owner:nil options:nil].lastObject;
    }
    
    PT_NearlyListModel *model = [[ PT_NearlyListModel alloc]initWithDic:dic];
    NSString *urlString;
    
    if([model.type isEqualToString:@"1"]){
        //个人用户头像需要拼接
        NSString *str = @"http://bd-header.img-cn-shanghai.aliyuncs.com/";
        NSString *str1 = [str stringByAppendingString:model.name];
        urlString = [str1 stringByAppendingString:@".png@600h_600w"];
        
    } else {
        //公司用户直接取icon
        urlString = model.icon;
    }
    
    [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"moren_pt"]];
    cell.nickNameLabel.text = model.name;
    if([model.isAttention isEqualToString:@"1"]){
        [cell.stateBtn setTitle:@"已关注" forState:UIControlStateNormal];
        [cell.stateBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        cell.stateBtn.backgroundColor = [UIColor orangeColor];
    } else{
        [cell.stateBtn setTitle:@"申请加入" forState:UIControlStateNormal];
        [cell.stateBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [cell.stateBtn addTarget:self action:@selector(applyToJoin:) forControlEvents:UIControlEventTouchUpInside]; //申请加入按钮点击事件
        cell.stateBtn.backgroundColor = WhiteColor;
    }
    cell.companyNameLabel.text = model.companyName;
    double distance = [model.distance doubleValue] / 1000;
    NSString * realDistance = [[NSString stringWithFormat:@"%.2f",distance] stringByAppendingString:@"km"];
    
    cell.distanceLabel.text = realDistance;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [self.dataArr objectAtIndex:indexPath.row];
    PT_NearlyListModel *model = [[ PT_NearlyListModel alloc]initWithDic:dic];
    if([model.isAttention isEqualToString:@"1"]){
            //  跳转到聊天页面，传入imId   model.imId
    }
    
}

//申请加入
-(void)applyToJoin:(UIButton *)sender{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (void)getNearlyApiNet {
    if (self.getNearlyApi && !self.getNearlyApi.requestOperation) {
        [self.getNearlyApi stop];
    }
    
    NSLog(@"%@",[GlobalData sharedInstance].selfInfo.sessionId);
    self.getNearlyApi = [[PT_NearlyListApi alloc]initWithSessionId:[GlobalData sharedInstance].selfInfo.sessionId andWithPage:[NSString stringWithFormat:@"%ld",(long)_page]];
    self.getNearlyApi.noNetWorkingDelegate = self;
    [self.getNearlyApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        PT_NearlyListApi *result = (PT_NearlyListApi *)request;
        if (result.isCorrectResult) {
            if (_page == 1) {
                self.dataArr = [NSMutableArray arrayWithArray:[result getNearlyList]];
            }else {
                [self.dataArr addObjectsFromArray:[result getNearlyList]];
            }
            [self.tableView reloadData];
            NSInteger count = self.dataArr.count;
            if (count == 0) {
                [(MJRefreshAutoFooter *)self.tableView.mj_footer setHidden:YES];
            }else {
                [(MJRefreshAutoFooter *)self.tableView.mj_footer setHidden:NO];
            }
        }else {
            if (_page > 1) {
                _page --;
            }else {
                self.dataArr = [NSMutableArray array];
                [self.tableView reloadData];
            }
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (_page > 1) {
            _page --;
        }else {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}
//没有数据时添加占位的view

- (void)addPlaceHolderView {
    _noDataImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 250, FITWIDTH(200) * 2.2, FITWIDTH(200))];  //需要调整
    _noDataImageView.centerX = self.view.centerX;
    _noDataImageView.image = [UIImage imageNamed:@"kongbai"];
    [self.view addSubview: _noDataImageView];
}

//有数据时清除占位图

- (void)removePlaceHolderView {
    
    [_noDataImageView removeFromSuperview];
}




@end
