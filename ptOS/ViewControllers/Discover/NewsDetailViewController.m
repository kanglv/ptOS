//
//  NewsDetailViewController.m
//  ptOS
//
//  Created by 吕康 on 17/3/19.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "UIImageView+WebCache.h"
@interface NewsDetailViewController ()

@property (strong ,nonatomic)UIImageView *imgView;
@property (strong,nonatomic)UILabel *titleLabel;
@property (strong, nonatomic)UILabel *contentLabel;

@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:self.model.imageUrl] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
    [self.view addSubview:self.imgView];
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
