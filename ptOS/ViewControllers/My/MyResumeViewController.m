//
//  MyResumeViewController.m
//  ptOS
//
//  Created by 周瑞 on 16/8/31.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "MyResumeViewController.h"
#import "MyResumeModel.h"
#import "MY_ResumeDetailApi.h"
#import "MY_ResumeDetailModel.h"
#import "MyInfo1ViewController.h"
#import "AFHTTPRequestOperation.h"
#import "GetResumeApi.h"
#import "MyResumeModel.h"
@interface MyResumeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *jumpBtn;
@property (weak, nonatomic) IBOutlet UILabel *basicInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardLabel;
@property (weak, nonatomic) IBOutlet UILabel *workExpLabel;
@property (weak, nonatomic) IBOutlet UILabel *skillsLabel;

@property (nonatomic,strong)MY_ResumeDetailApi *detailApi;
@property (nonatomic,strong)GetResumeApi *getResumeApi;

@end

@implementation MyResumeViewController

#pragma mark - lifeCycles

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"简历概况"];
    
    [self detailApiNet];
    [self getResumeApiNet];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - customFuncs
- (IBAction)gotoResume:(id)sender {
    NSString *num = [UserDefault objectForKey:JLKey];
    if ([num isEqualToString:@"1"]) {
        
    }
    MyInfo1ViewController *ctrll = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyInfo1ViewController"];
    [self.navigationController pushViewController:ctrll animated:YES];
}

#pragma mark - Networkapis
- (void)detailApiNet {
    if(self.detailApi && !self.detailApi.requestOperation.isFinished)
    {
        [self.detailApi stop];
    }
    
    self.detailApi = [[MY_ResumeDetailApi alloc]init];
    self.detailApi.netLoadingDelegate = self;
    [self.detailApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        MY_ResumeDetailApi *result = (MY_ResumeDetailApi *)request;
        if(result.isCorrectResult)
        {
            MY_ResumeDetailModel *model = [result getResumeDetail];
            self.basicInfoLabel.text = model.basicInfo;
            self.cardLabel.text = model.certificate;
            self.workExpLabel.text = model.workExp;
            self.skillsLabel.text = model.skills;
        }
        
    } failure:^(YTKBaseRequest *request) {
        
    }];
}

- (void)getResumeApiNet{
    if(self.getResumeApi && !self.getResumeApi.requestOperation.isFinished)
    {
        [self.getResumeApi stop];
    }
    
    self.getResumeApi = [[GetResumeApi alloc]init];
    self.getResumeApi.netLoadingDelegate = self;
    [self.getResumeApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        GetResumeApi *result = (GetResumeApi *)request;
        if(result.isCorrectResult)
        {
            MyResumeModel *model = [result getMyResume];
            [GlobalData sharedInstance].jl_name = model.name;
            [GlobalData sharedInstance].jl_sex  = model.sex;
            [GlobalData sharedInstance].jl_birth = model.birth;
            [GlobalData sharedInstance].jl_education = model.education;
            [GlobalData sharedInstance].jl_phone = model.phone;
            [GlobalData sharedInstance].jl_cardPicFont = model.cardPicFront;
            [GlobalData sharedInstance].jl_cardPicBack = model.cardPicBack;
            [GlobalData sharedInstance].jl_educationPiC = model.educationPic;
            [GlobalData sharedInstance].jl_zs1 = model.zs1;
            [GlobalData sharedInstance].jl_zs2 = model.zs2;
            [GlobalData sharedInstance].jl_zs3 = model.zs3;
            [GlobalData sharedInstance].jl_workExp = model.workExp;
            [GlobalData sharedInstance].jl_skills = model.skills;
        }
        
    } failure:^(YTKBaseRequest *request) {
        
    }];
}

#pragma mark - delegate


#pragma mark - lazyViews

@end
