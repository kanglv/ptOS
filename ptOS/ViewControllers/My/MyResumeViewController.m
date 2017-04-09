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
#import "MY_PostReumeApi.h"
#import "MyInfo1ViewController.h"
#import "MyInfo2ViewController.h"
#import "MyInfo3ViewController.h"
#import "WorkExperienceViewController.h"

#import "OSSManager.h"
#import "AFHTTPRequestOperation.h"
#import "GetResumeApi.h"
#import "MyResumeModel.h"
#import "AFNetworking.h"
@interface MyResumeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *basicInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardLabel;
@property (weak, nonatomic) IBOutlet UILabel *workExpLabel;
@property (weak, nonatomic) IBOutlet UILabel *skillsLabel;

@property (nonatomic,strong)MY_ResumeDetailApi *detailApi;
@property (nonatomic,strong)GetResumeApi *getResumeApi;
@property (nonatomic,strong)MY_PostReumeApi *postResumeApi;

@end

@implementation MyResumeViewController

#pragma mark - lifeCycles

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"简历概况"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake(0, 0, 60, 40)];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;

    
    [self detailApiNet];
    [self getResumeApiNet];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)next {
    
       [self postResumeApiNet];
}

- (void)uploadImageWithImage:(UIImage *)image withFileName:(NSString *)fileName {
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    
    [[OSSManager sharedManager] uploadObjectAsyncWithData:data andFileName:fileName andBDName:@"bd-resume" andIsSuccess:^(BOOL isSuccess, UIImage *image) {
        NSLog(@"上传成功");
    } andProgressBlock:^(int64_t has, int64_t total, int64_t will) {
        
    }];
}

- (void)postResumeApiNet{
    NSMutableDictionary *argument = [NSMutableDictionary dictionary];
    
    [argument setCustomString:[GlobalData sharedInstance].jl_resumeId forKey:@"id"];
    [argument setCustomString:[GlobalData sharedInstance].jl_name forKey:@"name"];
    [argument setCustomString:[GlobalData sharedInstance].jl_sex forKey:@"sex"];
    [argument setCustomString:[GlobalData sharedInstance].jl_birth forKey:@"birth"];
    [argument setCustomString:[GlobalData sharedInstance].jl_education forKey:@"education"];
    [argument setCustomString:[GlobalData sharedInstance].jl_phone forKey:@"phone"];
    [argument setCustomString:[GlobalData sharedInstance].jl_cardPicFont forKey:@"cardPicFront"];
    [argument setCustomString:[GlobalData sharedInstance].jl_cardPicBack forKey:@"cardPicBack"];
    [argument setCustomString:[GlobalData sharedInstance].jl_educationPiC forKey:@"educationPic"];
    [argument setCustomString:[GlobalData sharedInstance].jl_skills forKey:@"skills"];
    [argument setCustomString:[GlobalData sharedInstance].jl_skillsvoice forKey:@"skillsvoice"];
    [argument setValue:[GlobalData sharedInstance].jl_workExp forKey:@"expers"];

    
   NSString *string = @"http://139.196.230.156/ptApp/postResume?sessionId=";
    NSString *str = [string stringByAppendingString:[GlobalData sharedInstance].selfInfo.sessionId];
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    sessionManager.requestSerializer.timeoutInterval = 3;//设置登录超时为15s
    
    [sessionManager.requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    [sessionManager  POST:str parameters:argument success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
                    [self uploadImageWithImage:[GlobalData sharedInstance].cardPicFont withFileName:[GlobalData sharedInstance].cardPicFontName];
                    [self uploadImageWithImage:[GlobalData sharedInstance].cardPicBack withFileName:[GlobalData sharedInstance].cardPicBackName];
                    [self uploadImageWithImage:[GlobalData sharedInstance].educationPiC withFileName:[GlobalData sharedInstance].educationPiCName];
                    [XHToast showCenterWithText:@"保存成功"];
        //            [self.navigationController popToRootViewControllerAnimated:YES];
                    [GlobalData sharedInstance].jl_name = nil;
                    [GlobalData sharedInstance].jl_sex = nil;
                    [GlobalData sharedInstance].jl_birth = nil;
                    [GlobalData sharedInstance].jl_education = nil;
                    [GlobalData sharedInstance].jl_phone = nil;
                    [GlobalData sharedInstance].jl_cardPicFont = nil;
                    [GlobalData sharedInstance].jl_cardPicBack = nil;
                    [GlobalData sharedInstance].jl_educationPiC = nil;
                    [GlobalData sharedInstance].jl_workExp = nil;
                    [GlobalData sharedInstance].jl_skills = nil;
                    [GlobalData sharedInstance].jl_resumeId = nil;

        [XHToast showCenterWithText:@"保存成功"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [XHToast showCenterWithText:@"保存失败"];
    }];
    
}


//- (void)postResumeApiNet {
//    if (!isValidStr([GlobalData sharedInstance].selfInfo.sessionId))
//    {
//        [self presentLoginCtrl];
//        return;
//    }
//    
//    
//    if(self.postResumeApi&& !self.postResumeApi.requestOperation.isFinished)
//    {
//        [self.postResumeApi stop];
//    }
//    NSString *string;
//    if([GlobalData sharedInstance].jl_resumeId){
//        string = [GlobalData sharedInstance].jl_resumeId;
//    } else {
//        string = [GlobalData sharedInstance].selfInfo.userId;
//    }
//    
//    self.postResumeApi = [[MY_PostReumeApi alloc] initWithName:[GlobalData sharedInstance].jl_name WithSex:[GlobalData sharedInstance].jl_sex WithBirth:[GlobalData sharedInstance].jl_birth WithEducation:[GlobalData sharedInstance].jl_education Withphone:[GlobalData sharedInstance].jl_phone WithCardPicFrontUrl:[GlobalData sharedInstance].jl_cardPicFont WithCardPicBackUrl:[GlobalData sharedInstance].jl_cardPicBack  WithEducationPic:[GlobalData sharedInstance].jl_educationPiC WithWorkExp:[GlobalData sharedInstance].jl_workExp WithSkills:[GlobalData sharedInstance].jl_skills WithSkillVoice:@"" WithId:string ];
//    
//    self.postResumeApi.sessionDelegate = self;
//    [self.postResumeApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
//        
//        MY_PostReumeApi *result = (MY_PostReumeApi *)request;
//        if(result.isCorrectResult)
//        {
//            [self uploadImageWithImage:[GlobalData sharedInstance].cardPicFont withFileName:[GlobalData sharedInstance].cardPicFontName];
//            [self uploadImageWithImage:[GlobalData sharedInstance].cardPicBack withFileName:[GlobalData sharedInstance].cardPicBackName];
//            [self uploadImageWithImage:[GlobalData sharedInstance].educationPiC withFileName:[GlobalData sharedInstance].educationPiCName];
//            [XHToast showCenterWithText:@"保存成功"];
////            [self.navigationController popToRootViewControllerAnimated:YES];
//            [GlobalData sharedInstance].jl_name = nil;
//            [GlobalData sharedInstance].jl_sex = nil;
//            [GlobalData sharedInstance].jl_birth = nil;
//            [GlobalData sharedInstance].jl_education = nil;
//            [GlobalData sharedInstance].jl_phone = nil;
//            [GlobalData sharedInstance].jl_cardPicFont = nil;
//            [GlobalData sharedInstance].jl_cardPicBack = nil;
//            [GlobalData sharedInstance].jl_educationPiC = nil;
//            [GlobalData sharedInstance].jl_workExp = nil;
//            [GlobalData sharedInstance].jl_skills = nil;
//            [GlobalData sharedInstance].jl_resumeId = nil;
//        } else{
//            [XHToast showCenterWithText:@"保存失败"];
//        }
//    } failure:^(YTKBaseRequest *request) {
//        NSLog(@"上传失败");
//        
//    }];
//}


#pragma mark - customFuncs
//跳转基本信息详情页
- (IBAction)baseInformationBtnClicked:(id)sender {
    MyInfo1ViewController *ctr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyInfo1ViewController"];
    [self.navigationController pushViewController:ctr animated:YES];
}

//跳转证书页
- (IBAction)certificateBtnClicked:(id)sender {
    MyInfo2ViewController *ctr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyInfo2ViewController"];
    [self.navigationController pushViewController:ctr animated:YES];
}

//跳转工作经历
- (IBAction)workExperienceBtnClicked:(id)sender {
    WorkExperienceViewController *ctr =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WorkExperienceViewController"];
    [self.navigationController pushViewController:ctr animated:YES];

}
- (IBAction)skillsBtnClicked:(id)sender {
    
    MyInfo3ViewController *ctr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyInfo3ViewController"];
    [self.navigationController pushViewController:ctr animated:YES];
  
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
            [GlobalData sharedInstance].jl_resumeId = model.resumeId;
            [GlobalData sharedInstance].jl_name = model.name;
            [GlobalData sharedInstance].jl_sex  = model.sex;
            [GlobalData sharedInstance].jl_birth = model.birth;
            [GlobalData sharedInstance].jl_education = model.education;
            [GlobalData sharedInstance].jl_phone = model.phone;
            [GlobalData sharedInstance].jl_cardPicFont = model.cardPicFront;
            [GlobalData sharedInstance].jl_cardPicBack = model.cardPicBack;
            [GlobalData sharedInstance].jl_educationPiC = model.educationPic;
//            [GlobalData sharedInstance].jl_zs1 = model.zs1;
//            [GlobalData sharedInstance].jl_zs2 = model.zs2;
//            [GlobalData sharedInstance].jl_zs3 = model.zs3;
            [GlobalData sharedInstance].jl_workExp = model.workExp;
            [GlobalData sharedInstance].jl_skills = model.skills;
        }
        
    } failure:^(YTKBaseRequest *request) {
        
    }];
}

#pragma mark - delegate


#pragma mark - lazyViews

@end
