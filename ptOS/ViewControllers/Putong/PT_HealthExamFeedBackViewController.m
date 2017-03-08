//
//  PT_HealthExamFeedBackViewController.m
//  ptOS
//
//  Created by 周瑞 on 16/9/1.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "PT_HealthExamFeedBackViewController.h"
#import "PT_HearthFeedBackApi.h"
#import "AFHTTPRequestOperation.h"
#import "AJPhotoPickerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "AJPhotoBrowserViewController.h"
#import "OSSManager.h"
@interface PT_HealthExamFeedBackViewController ()<AJPhotoPickerProtocol,AJPhotoBrowserDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    BOOL _is1;
    BOOL _is2;
    BOOL _is3;
    BOOL _is4;
    BOOL _is5;
    BOOL _is6;
    BOOL _is7;
    BOOL _is8;
    NSInteger m;
    NSInteger n;
    NSMutableArray *_imgArray;
}
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (nonatomic, strong)PT_HearthFeedBackApi *feedbackApi;
@end

@implementation PT_HealthExamFeedBackViewController

#pragma mark - lifeCycles

- (void)viewDidLoad {
    [super viewDidLoad];
    
    n = 0;
    m = 0;
    
    _is1 = NO;
    _is2 = NO;
    _is3 = NO;
    _is4 = NO;
    _is5 = NO;
    _is6 = NO;
    _is7 = NO;
    _is8 = NO;
    
    [self.navigationItem setTitle:@"体检反馈"];
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
- (IBAction)imgAction1:(id)sender {
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
- (IBAction)submitAction:(id)sender {
//    if (_is1 && _is2 && _is3 && _is4 && _is5 && _is6 && _is7 && _is8) {
//        NSString *str = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%@|%@",[GlobalData sharedInstance].health1Url,[GlobalData sharedInstance].health1Ur2,[GlobalData sharedInstance].health1Ur3,[GlobalData sharedInstance].health1Ur4,[GlobalData sharedInstance].health1Ur5,[GlobalData sharedInstance].health1Ur6,[GlobalData sharedInstance].health1Ur7,[GlobalData sharedInstance].health1Ur8];
//        [self feedbackApiNetwithArray:str];
//        [self uploadImageWithImage:[GlobalData sharedInstance].health1];
//        [self uploadImageWithImage:[GlobalData sharedInstance].health2];
//        [self uploadImageWithImage:[GlobalData sharedInstance].health3];
//        [self uploadImageWithImage:[GlobalData sharedInstance].health4];
//        [self uploadImageWithImage:[GlobalData sharedInstance].health5];
//        [self uploadImageWithImage:[GlobalData sharedInstance].health6];
//        [self uploadImageWithImage:[GlobalData sharedInstance].health7];
//        [self uploadImageWithImage:[GlobalData sharedInstance].health8];
//
//    }else {
//        [XHToast showCenterWithText:@"必须上传8张图片"];
//    }
    if (_is1 || _is2 || _is3 || _is4 || _is5 || _is6 || _is7 || _is8) {
        NSString *str = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%@|%@",[GlobalData sharedInstance].health1Url,[GlobalData sharedInstance].health1Ur2,[GlobalData sharedInstance].health1Ur3,[GlobalData sharedInstance].health1Ur4,[GlobalData sharedInstance].health1Ur5,[GlobalData sharedInstance].health1Ur6,[GlobalData sharedInstance].health1Ur7,[GlobalData sharedInstance].health1Ur8];
        [self feedbackApiNetwithArray:str];
        if (isValidStr([GlobalData sharedInstance].health1Name)) {
            [self uploadImageWithImage:[GlobalData sharedInstance].health1 withImageName:[GlobalData sharedInstance].health1Name];

        }
        
        if (isValidStr([GlobalData sharedInstance].health2Name)) {
            [self uploadImageWithImage:[GlobalData sharedInstance].health2 withImageName:[GlobalData sharedInstance].health2Name];
        }
        
        if (isValidStr([GlobalData sharedInstance].health3Name)) {
            [self uploadImageWithImage:[GlobalData sharedInstance].health3 withImageName:[GlobalData sharedInstance].health3Name];
        }
        
        if (isValidStr([GlobalData sharedInstance].health4Name)) {
            [self uploadImageWithImage:[GlobalData sharedInstance].health4 withImageName:[GlobalData sharedInstance].health4Name];
        }
        
        if (isValidStr([GlobalData sharedInstance].health5Name)) {
            [self uploadImageWithImage:[GlobalData sharedInstance].health5 withImageName:[GlobalData sharedInstance].health5Name];
        }
        
        if (isValidStr([GlobalData sharedInstance].health6Name)) {
            [self uploadImageWithImage:[GlobalData sharedInstance].health6 withImageName:[GlobalData sharedInstance].health6Name];
        }
        
        if (isValidStr([GlobalData sharedInstance].health7Name)) {
            [self uploadImageWithImage:[GlobalData sharedInstance].health7 withImageName:[GlobalData sharedInstance].health7Name];
        }
        
        if (isValidStr([GlobalData sharedInstance].health8Name)) {
            [self uploadImageWithImage:[GlobalData sharedInstance].health8 withImageName:[GlobalData sharedInstance].health8Name];
        }
        
        
    }else {
        [XHToast showCenterWithText:@"请至少上传一张图片"];
    }
}

- (void)uploadImageWithImage:(UIImage *)image withImageName:(NSString *)fileName {
    if (image) {
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    [[OSSManager sharedManager] uploadObjectAsyncWithData:data andFileName:fileName andBDName:@"bd-resume" andIsSuccess:^(BOOL isSuccess, UIImage *image) {
        NSLog(@"上传成功");
    } andProgressBlock:^(int64_t has, int64_t total, int64_t will) {
        
    }];
    }
}

- (IBAction)imgAction2:(id)sender {
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
- (IBAction)imgAction3:(id)sender {
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
- (IBAction)imgAction4:(id)sender {
    AJPhotoPickerViewController *picker = [[AJPhotoPickerViewController alloc] init];
    m = n;
    n = 4;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = YES;
    picker.delegate=self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return YES;
    }];
    
    [self presentViewController:picker animated:YES completion:nil];
}
- (IBAction)imgAction5:(id)sender {
    AJPhotoPickerViewController *picker = [[AJPhotoPickerViewController alloc] init];
    m = n;
    n = 5;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = YES;
    picker.delegate=self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return YES;
    }];
    
    [self presentViewController:picker animated:YES completion:nil];
}
- (IBAction)imgAction6:(id)sender {
    AJPhotoPickerViewController *picker = [[AJPhotoPickerViewController alloc] init];
    m = n;
    n = 6;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = YES;
    picker.delegate=self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return YES;
    }];
    
    [self presentViewController:picker animated:YES completion:nil];
}
- (IBAction)imgAction7:(id)sender {
    AJPhotoPickerViewController *picker = [[AJPhotoPickerViewController alloc] init];
    m = n;
    n = 7;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = YES;
    picker.delegate=self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return YES;
    }];
    
    [self presentViewController:picker animated:YES completion:nil];
}
- (IBAction)imgAction8:(id)sender {
    AJPhotoPickerViewController *picker = [[AJPhotoPickerViewController alloc] init];
    m = n;
    n = 8;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = YES;
    picker.delegate=self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return YES;
    }];
    
    [self presentViewController:picker animated:YES completion:nil];
}


#pragma mark - Networkapis
- (void)feedbackApiNetwithArray:(NSString *)array {
    if(self.feedbackApi && !self.feedbackApi.requestOperation.isFinished)
    {
        [self.feedbackApi stop];
    }
    
    self.feedbackApi = [[PT_HearthFeedBackApi alloc]initWithMsgId:self.msgId withImageUrls:array];
    self.feedbackApi.netLoadingDelegate = self;
    [self.feedbackApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        PT_HearthFeedBackApi *result = (PT_HearthFeedBackApi *)request;
        if(result.isCorrectResult)
        {
            [XHToast showCenterWithText:@"上传完成"];
            [NotificationCenter postNotificationName:@"refreshList" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [XHToast showCenterWithText:@"上传失败"];
            [self.navigationController popViewControllerAnimated:YES];
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
        [self.img1 setImage:tempImg forState:UIControlStateNormal];
        _is1 = YES;
        NSString *url = [NSString stringWithFormat:@"%@_health1%@%@",@"http://bd-resume.img-cn-shanghai.aliyuncs.com/",timeSp,@".png"];
        [GlobalData sharedInstance].health1Url = url;
        [GlobalData sharedInstance].health1 = tempImg;
        [GlobalData sharedInstance].health1Name = [NSString stringWithFormat:@"%@.png",timeSp];
    }else if (n == 2) {
        [self.img2 setImage:tempImg forState:UIControlStateNormal];
        _is2 = YES;
        NSString *url = [NSString stringWithFormat:@"%@_health2%@%@",@"http://bd-resume.img-cn-shanghai.aliyuncs.com/",timeSp,@".png"];
        [GlobalData sharedInstance].health1Ur2 = url;
        [GlobalData sharedInstance].health2 = tempImg;
        [GlobalData sharedInstance].health2Name = [NSString stringWithFormat:@"%@.png",timeSp];
    }else if (n == 3) {
        [self.img3 setImage:tempImg forState:UIControlStateNormal];
        _is3 = YES;
        NSString *url = [NSString stringWithFormat:@"%@_health3%@%@",@"http://bd-resume.img-cn-shanghai.aliyuncs.com/",timeSp,@".png"];
        [GlobalData sharedInstance].health1Ur3 = url;
        [GlobalData sharedInstance].health3 = tempImg;
        [GlobalData sharedInstance].health3Name = [NSString stringWithFormat:@"%@.png",timeSp];
    }else if (n == 4) {
        [self.img4 setImage:tempImg forState:UIControlStateNormal];
        _is4 = YES;
        NSString *url = [NSString stringWithFormat:@"%@_health4%@%@",@"http://bd-resume.img-cn-shanghai.aliyuncs.com/",timeSp,@".png"];
        [GlobalData sharedInstance].health1Ur4 = url;
        [GlobalData sharedInstance].health4 = tempImg;
        [GlobalData sharedInstance].health4Name = [NSString stringWithFormat:@"%@.png",timeSp];
    }else if (n == 5) {
        [self.img5 setImage:tempImg forState:UIControlStateNormal];
        _is5 = YES;
        NSString *url = [NSString stringWithFormat:@"%@_health5%@%@",@"http://bd-resume.img-cn-shanghai.aliyuncs.com/",timeSp,@".png"];
        [GlobalData sharedInstance].health1Ur5 = url;
        [GlobalData sharedInstance].health5 = tempImg;
        [GlobalData sharedInstance].health5Name = [NSString stringWithFormat:@"%@.png",timeSp];
    }else if (n == 6) {
        [self.img6 setImage:tempImg forState:UIControlStateNormal];
        _is6 = YES;
        NSString *url = [NSString stringWithFormat:@"%@_health6%@%@",@"http://bd-resume.img-cn-shanghai.aliyuncs.com/",timeSp,@".png"];
        [GlobalData sharedInstance].health1Ur6 = url;
        [GlobalData sharedInstance].health6 = tempImg;
        [GlobalData sharedInstance].health6Name = [NSString stringWithFormat:@"%@.png",timeSp];
    }else if (n == 7) {
        [self.img7 setImage:tempImg forState:UIControlStateNormal];
        _is7 = YES;
        NSString *url = [NSString stringWithFormat:@"%@_health7%@%@",@"http://bd-resume.img-cn-shanghai.aliyuncs.com/",timeSp,@".png"];
        [GlobalData sharedInstance].health1Ur7 = url;
        [GlobalData sharedInstance].health7 = tempImg;
        [GlobalData sharedInstance].health7Name = [NSString stringWithFormat:@"%@.png",timeSp];
    }else if (n == 8) {
        [self.img8 setImage:tempImg forState:UIControlStateNormal];
        _is8 = YES;
        NSString *url = [NSString stringWithFormat:@"%@_health8%@%@",@"http://bd-resume.img-cn-shanghai.aliyuncs.com/",timeSp,@".png"];
        [GlobalData sharedInstance].health1Ur8 = url;
        [GlobalData sharedInstance].health8 = tempImg;
        [GlobalData sharedInstance].health8Name = [NSString stringWithFormat:@"%@.png",timeSp];
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
        [self.img1 setImage:tempImg forState:UIControlStateNormal];
        _is1 = YES;
        NSString *url = [NSString stringWithFormat:@"%@_health1%@%@",@"http://bd-resume.img-cn-shanghai.aliyuncs.com/",timeSp,@".png"];
        [GlobalData sharedInstance].health1Url = url;
        [GlobalData sharedInstance].health1 = tempImg;
    }else if (n == 2) {
        [self.img2 setImage:tempImg forState:UIControlStateNormal];
        _is2 = YES;
        NSString *url = [NSString stringWithFormat:@"%@_health2%@%@",@"http://bd-resume.img-cn-shanghai.aliyuncs.com/",timeSp,@".png"];
        [GlobalData sharedInstance].health1Ur2 = url;
        [GlobalData sharedInstance].health2 = tempImg;
    }else if (n == 3) {
        [self.img3 setImage:tempImg forState:UIControlStateNormal];
        _is3 = YES;
        NSString *url = [NSString stringWithFormat:@"%@_health3%@%@",@"http://bd-resume.img-cn-shanghai.aliyuncs.com/",timeSp,@".png"];
        [GlobalData sharedInstance].health1Ur3 = url;
        [GlobalData sharedInstance].health3 = tempImg;
    }else if (n == 4) {
        [self.img4 setImage:tempImg forState:UIControlStateNormal];
        _is4 = YES;
        NSString *url = [NSString stringWithFormat:@"%@_health4%@%@",@"http://bd-resume.img-cn-shanghai.aliyuncs.com/",timeSp,@".png"];
        [GlobalData sharedInstance].health1Ur4 = url;
        [GlobalData sharedInstance].health4 = tempImg;
    }else if (n == 5) {
        [self.img5 setImage:tempImg forState:UIControlStateNormal];
        _is5 = YES;
        NSString *url = [NSString stringWithFormat:@"%@_health5%@%@",@"http://bd-resume.img-cn-shanghai.aliyuncs.com/",timeSp,@".png"];
        [GlobalData sharedInstance].health1Ur5 = url;
        [GlobalData sharedInstance].health5 = tempImg;
    }else if (n == 6) {
        [self.img6 setImage:tempImg forState:UIControlStateNormal];
        _is6 = YES;
        NSString *url = [NSString stringWithFormat:@"%@_health6%@%@",@"http://bd-resume.img-cn-shanghai.aliyuncs.com/",timeSp,@".png"];
        [GlobalData sharedInstance].health1Ur6 = url;
        [GlobalData sharedInstance].health6 = tempImg;
    }else if (n == 7) {
        [self.img7 setImage:tempImg forState:UIControlStateNormal];
        _is7 = YES;
        NSString *url = [NSString stringWithFormat:@"%@_health7%@%@",@"http://bd-resume.img-cn-shanghai.aliyuncs.com/",timeSp,@".png"];
        [GlobalData sharedInstance].health1Ur7 = url;
        [GlobalData sharedInstance].health7 = tempImg;
    }else if (n == 8) {
        [self.img8 setImage:tempImg forState:UIControlStateNormal];
        _is8 = YES;
        NSString *url = [NSString stringWithFormat:@"%@_health8%@%@",@"http://bd-resume.img-cn-shanghai.aliyuncs.com/",timeSp,@".png"];
        [GlobalData sharedInstance].health1Ur8 = url;
        [GlobalData sharedInstance].health8 = tempImg;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
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
