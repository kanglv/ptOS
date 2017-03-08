//
//  ViewController.m
//  ptOS
//
//  Created by 吕康 on 17/2/12.
//  Copyright © 2016年 商盟. All rights reserved.
//

#import "SelectCityViewController.h"

@interface SelectCityViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong , nonatomic) UITableView *cityList;

@property (strong , nonatomic) NSMutableArray *cityArray;

@end

@implementation SelectCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",self.indexCity);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //城市列表，是否通过接口获取，便于修改。。
    NSArray * cityArr = [NSArray arrayWithObjects:@"常州",@"无锡",@"苏州" , @"全国", nil];
    
    //列表的数据源
    self.cityArray = [[NSMutableArray alloc]initWithArray:cityArr];
    
    self.title = @"选择城市";
    self.cityList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.cityList.delegate = self;
    self.cityList.dataSource = self;
    [self.view addSubview:self.cityList];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = self.cityArray .count ;
    return count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:TableSampleIdentifier];
    }
    
    
    cell.textLabel.text = [self.cityArray objectAtIndex:indexPath.row];
    if([cell.textLabel.text isEqualToString: self.indexCity]) {
        cell.textLabel.textColor = [UIColor grayColor];
    } else {
        cell.textLabel.textColor = [UIColor blackColor];
    }
    return cell;
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //需要一个协议方法将选中的城市回传给首页
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:[self.cityArray objectAtIndex:indexPath.row] ,@"0" ,nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"city" object:self userInfo:dic];
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
