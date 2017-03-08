//
//  MyInfo3ViewController.m
//  ptOS
//
//  Created by 周瑞 on 16/8/31.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "MyInfo3ViewController.h"
#import "MY_PostReumeApi.h"
#import "AFHTTPRequestOperation.h"
#import "AJPhotoPickerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "AJPhotoBrowserViewController.h"
#import "OSSManager.h"
#import "UIButton+WebCache.h"

@interface MyInfo3ViewController ()<AJPhotoPickerProtocol,AJPhotoBrowserDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    BOOL _is1;
    BOOL _is2;
    BOOL _is3;
    NSInteger n;
    NSInteger m;
}
@property (weak, nonatomic) IBOutlet UIButton *zs1Btn;
@property (weak, nonatomic) IBOutlet UIButton *zs2Btn;
@property (weak, nonatomic) IBOutlet UIButton *zs3Btn;
@property (nonatomic,strong)MY_PostReumeApi *postResumeApi;
@property (weak, nonatomic) IBOutlet UILabel *threeLabel;
@property (weak, nonatomic) IBOutlet UITextView *workExpTV;
@property (weak, nonatomic) IBOutlet UITextView *skillsTV;


@end

@implementation MyInfo3ViewController

#pragma mark - lifeCycles

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.zs1Btn setImage:self.image1 forState:UIControlStateNormal];
    [self.zs2Btn setImage:self.image2 forState:UIControlStateNormal];
    [self.zs3Btn setImage:self.image3 forState:UIControlStateNormal];

    [self.navigationItem setTitle:@"基本信息"];
    
    ZRViewRadius(self.threeLabel, 12.5);
    
    
    n = 0;
    m = 0;
    
    _is1 = NO;
    _is2 = NO;
    _is3 = NO;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake(0, 0, 60, 40)];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:@"上一步" forState:UIControlStateNormal];
    [btn1 setTitleColor:WhiteColor forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(down) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setFrame:CGRectMake(0, 0, 60, 40)];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc]initWithCustomView:btn1];
    self.navigationItem.leftBarButtonItem = rightItem1;
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
- (void)next {
//    if (!_is1 || !_is2 || !_is3) {
//        [XHToast showCenterWithText:@"请填写完整"];
//        return;
//    }
    [GlobalData sharedInstance].jl_workExp = self.workExpTV.text;
    [GlobalData sharedInstance].jl_skills = self.skillsTV.text;
    [self postResumeApiNet];

//    [self uploadImageWithImage:[GlobalData sharedInstance].zs1];
//    [self uploadImageWithImage:[GlobalData sharedInstance].zs2];
//    [self uploadImageWithImage:[GlobalData sharedInstance].zs3];

    
}

- (void)uploadImageWithImage:(UIImage *)image withFileName:(NSString *)fileName {
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    
    [[OSSManager sharedManager] uploadObjectAsyncWithData:data andFileName:fileName andBDName:@"bd-resume" andIsSuccess:^(BOOL isSuccess, UIImage *image) {
        NSLog(@"上传成功");
    } andProgressBlock:^(int64_t has, int64_t total, int64_t will) {
        
    }];
}

- (void)down {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)zs1Actio:(id)sender {
    AJPhotoPickerViewController *picker = [[AJPhotoPickerViewController alloc] init];
    m = n;
    n = 1;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = YES;
    picker.delegate=self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return YES;
    }];
    
    [self presentViewController:picker animated:YES completion:nil];
    
}
- (IBAction)zs2Action:(id)sender {
    AJPhotoPickerViewController *picker = [[AJPhotoPickerViewController alloc] init];
    m = n;
    n = 2;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = YES;
    picker.delegate=self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return YES;
    }];
    
    [self presentViewController:picker animated:YES completion:nil];
    
}
- (IBAction)zs3Action:(id)sender {
    AJPhotoPickerViewController *picker = [[AJPhotoPickerViewController alloc] init];
    m = n;
    n = 3;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = YES;
    picker.delegate=self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return YES;
    }];
    
    [self presentViewController:picker animated:YES completion:nil];
    
}

#pragma mark - NetworkApis
- (void)postResumeApiNet {
    if (!isValidStr([GlobalData sharedInstance].selfInfo.sessionId))
    {
        [self presentLoginCtrl];
        return;
    }
    
    if(self.postResumeApi&& !self.postResumeApi.requestOperation.isFinished)
    {
        [self.postResumeApi stop];
    }
    
    self.postResumeApi = [[MY_PostReumeApi alloc] initWithName:[GlobalData sharedInstance].jl_name WithSex:[GlobalData sharedInstance].jl_sex WithBirth:[GlobalData sharedInstance].jl_birth WithEducation:[GlobalData sharedInstance].jl_education Withphone:[GlobalData sharedInstance].jl_phone WithCardPicFrontUrl:[GlobalData sharedInstance].jl_cardPicFont WithCardPicBackUrl:[GlobalData sharedInstance].jl_cardPicBack WithEducationPic:[GlobalData sharedInstance].jl_educationPiC Withzs1PicUrl:[GlobalData sharedInstance].jl_zs1 Withzs2PicUrl:[GlobalData sharedInstance].jl_zs2 Withzs3PicUrl:[GlobalData sharedInstance].jl_zs3 WithWorkExp:[GlobalData sharedInstance].jl_workExp WithSkills:[GlobalData sharedInstance].jl_skills];
    self.postResumeApi.sessionDelegate = self;
    [self.postResumeApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        MY_PostReumeApi *result = (MY_PostReumeApi *)request;
        if(result.isCorrectResult)
        {
            [self uploadImageWithImage:[GlobalData sharedInstance].cardPicFont withFileName:[GlobalData sharedInstance].cardPicFontName];
            [self uploadImageWithImage:[GlobalData sharedInstance].cardPicBack withFileName:[GlobalData sharedInstance].cardPicBackName];
            [self uploadImageWithImage:[GlobalData sharedInstance].educationPiC withFileName:[GlobalData sharedInstance].educationPiCName];
            [XHToast showCenterWithText:@"保存成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [GlobalData sharedInstance].jl_name = nil;
            [GlobalData sharedInstance].jl_sex = nil;
            [GlobalData sharedInstance].jl_birth = nil;
            [GlobalData sharedInstance].jl_education = nil;
            [GlobalData sharedInstance].jl_phone = nil;
            [GlobalData sharedInstance].jl_cardPicFont = nil;
            [GlobalData sharedInstance].jl_cardPicBack = nil;
            [GlobalData sharedInstance].jl_educationPiC = nil;
            [GlobalData sharedInstance].jl_zs1 = nil;
            [GlobalData sharedInstance].jl_zs2 = nil;
            [GlobalData sharedInstance].jl_zs3 = nil;
            [GlobalData sharedInstance].jl_workExp = nil;
            [GlobalData sharedInstance].jl_skills = nil;
        }
    } failure:^(YTKBaseRequest *request) {
        
    }];
}

#pragma mark - delegate
#pragma mark - BoPhotoPickerProtocol
- (void)photoPickerDidCancel:(AJPhotoPickerViewController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    n = m;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *) picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    n = m;
}

- (void)photoPicker:(AJPhotoPickerViewController *)picker didSelectAssets:(NSArray *)assets {
    if (assets.count > 0) {
        
    
    ALAsset *asset = assets[0];
    UIImage *tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
    if (n == 1) {
        [self.zs1Btn setImage:tempImg forState:UIControlStateNormal];
        NSString *url = [NSString stringWithFormat:@"%@%@%@",@"http://bd-resume.img-cn-shanghai.aliyuncs.com/",timeSp,@".png"];
        [GlobalData sharedInstance].jl_zs1 = url;
        _is1 = YES;
        [GlobalData sharedInstance].cardPicFont = tempImg;
    }else if (n == 2) {
        [self.zs2Btn setImage:tempImg forState:UIControlStateNormal];
        NSString *url = [NSString stringWithFormat:@"%@%@_zs2%@",@"http://bd-resume.img-cn-shanghai.aliyuncs.com/",timeSp,@".png"];
        [GlobalData sharedInstance].jl_zs2 = url;
        _is2 = YES;
        [GlobalData sharedInstance].cardPicBack = tempImg;
    }else if (n == 3) {
        [self.zs3Btn setImage:tempImg forState:UIControlStateNormal];
        NSString *url = [NSString stringWithFormat:@"%@%@_zs3%@",@"http://bd-resume.img-cn-shanghai.aliyuncs.com/",timeSp,@".png"];
        [GlobalData sharedInstance].jl_zs3 = url;
        _is3 = YES;
        [GlobalData sharedInstance].educationPiC = tempImg;
    }
    
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *tempImg;
    if (CFStringCompare((CFStringRef) mediaType,kUTTypeImage, 0)== kCFCompareEqualTo) {
        tempImg = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
    if (n == 1) {
        [self.zs1Btn setImage:tempImg forState:UIControlStateNormal];
        NSString *url = [NSString stringWithFormat:@"%@%@_zs1%@",@"http://bd-resume.img-cn-shanghai.aliyuncs.com/",timeSp,@".png"];
        [GlobalData sharedInstance].jl_zs1 = url;
        _is1 = YES;
        [GlobalData sharedInstance].cardPicFont = tempImg;
    }else if (n == 2) {
        [self.zs2Btn setImage:tempImg forState:UIControlStateNormal];
        NSString *url = [NSString stringWithFormat:@"%@%@_zs2%@",@"http://bd-resume.img-cn-shanghai.aliyuncs.com/",timeSp,@".png"];
        [GlobalData sharedInstance].jl_zs2 = url;
        _is2 = YES;
        [GlobalData sharedInstance].cardPicBack = tempImg;
    }else if (n == 3) {
        [self.zs3Btn setImage:tempImg forState:UIControlStateNormal];
        NSString *url = [NSString stringWithFormat:@"%@%@_zs3%@",@"http://bd-resume.img-cn-shanghai.aliyuncs.com/",timeSp,@".png"];
        [GlobalData sharedInstance].jl_zs3 = url;
        _is3 = YES;
        [GlobalData sharedInstance].educationPiC = tempImg;
    }
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)photoPickerTapCameraAction:(AJPhotoPickerViewController *)picker {
    [self checkCameraAvailability:^(BOOL auth) {
        if (!auth) {
            NSLog(@"没有访问相机权限");
            return;
        }
        
        [picker dismissViewControllerAnimated:NO completion:nil];
        UIImagePickerController *cameraUI = [UIImagePickerController new];
        cameraUI.allowsEditing = NO;
        cameraUI.delegate = self;
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraUI.cameraFlashMode=UIImagePickerControllerCameraFlashModeAuto;
        
        [self presentViewController: cameraUI animated: YES completion:nil];
    }];
}


- (void)checkCameraAvailability:(void (^)(BOOL auth))block {
    BOOL status = NO;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        status = YES;
    } else if (authStatus == AVAuthorizationStatusDenied) {
        status = NO;
    } else if (authStatus == AVAuthorizationStatusRestricted) {
        status = NO;
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){
                if (block) {
                    block(granted);
                }
            } else {
                if (block) {
                    block(granted);
                }
            }
        }];
        return;
    }
    if (block) {
        block(status);
    }
}


#pragma mark - lazyViews

@end
