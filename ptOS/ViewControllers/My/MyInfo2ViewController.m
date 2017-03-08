//
//  MyInfo2ViewController.m
//  ptOS
//
//  Created by 周瑞 on 16/8/31.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "MyInfo2ViewController.h"
#import "MyInfo3ViewController.h"
#import "AJPhotoPickerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "AJPhotoBrowserViewController.h"
#import "UIButton+WebCache.h"

@interface MyInfo2ViewController ()<AJPhotoPickerProtocol,AJPhotoBrowserDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    BOOL _is1;
    BOOL _is2;
    BOOL _is3;
    NSInteger n;
    NSInteger m;
}


@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UIButton *frontBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *educationBtn;

@end

@implementation MyInfo2ViewController

#pragma mark - lifeCycles

- (void)viewDidLoad {
    [super viewDidLoad];
    _is1 = NO;
    _is2 = NO;
    _is3 = NO;
    if (isValidStr([GlobalData sharedInstance].jl_cardPicFont)) {
        [self.frontBtn sd_setImageWithURL:[NSURL URLWithString:[GlobalData sharedInstance].jl_cardPicFont] forState:UIControlStateNormal];
        NSLog(@"%@",[GlobalData sharedInstance].jl_cardPicFont);
        _is1 = YES;
    }
    
    if (isValidStr([GlobalData sharedInstance].jl_cardPicBack)) {
        [self.backBtn sd_setImageWithURL:[NSURL URLWithString:[GlobalData sharedInstance].jl_cardPicBack] forState:UIControlStateNormal];
        NSLog(@"%@",[GlobalData sharedInstance].jl_cardPicBack);
        _is2 = YES;
    }
    
    if (isValidStr([GlobalData sharedInstance].jl_educationPiC)) {
        [self.educationBtn sd_setImageWithURL:[NSURL URLWithString:[GlobalData sharedInstance].jl_educationPiC] forState:UIControlStateNormal];
        NSLog(@"%@",[GlobalData sharedInstance].jl_educationPiC);
        _is3 = YES;
    }
    
    [self.navigationItem setTitle:@"基本信息"];
    
    n = 0;
    m = 0;
    
    
    
    ZRViewRadius(self.twoLabel, 12.5);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"下一步" forState:UIControlStateNormal];
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
    MyInfo3ViewController *ctrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyInfo3ViewController"];
    if (!_is1 || !_is2 || !_is3) {
        [XHToast showCenterWithText:@"请填写完整"];
        return;
    }
    UIImage *image1 = self.frontBtn.imageView.image;
    UIImage *image2 = self.backBtn.imageView.image;
    UIImage *image3 = self.educationBtn.imageView.image;
    ctrl.image1 = image1;
    ctrl.image2 = image2;
    ctrl.image3 = image3;
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void)down {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)frontBtnPress:(id)sender {
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

- (IBAction)backBtnPress:(id)sender {
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

- (IBAction)eduBtnPress:(id)sender {
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
            [self.frontBtn setImage:tempImg forState:UIControlStateNormal];
            _is1 = YES;
            NSString *url = [NSString stringWithFormat:@"%@%@%@",@"http://bd-resume.img-cn-shanghai.aliyuncs.com/",timeSp,@".png"];
            [GlobalData sharedInstance].jl_cardPicFont = url;
            [GlobalData sharedInstance].cardPicFontName = [NSString stringWithFormat:@"%@.png",timeSp];
            [GlobalData sharedInstance].cardPicFont = tempImg;
        }else if (n == 2) {
            [self.backBtn setImage:tempImg forState:UIControlStateNormal];
            _is2 = YES;
            NSString *url = [NSString stringWithFormat:@"%@%@%@",@"http://bd-resume.img-cn-shanghai.aliyuncs.com/",timeSp,@".png"];
            [GlobalData sharedInstance].jl_cardPicBack = url;
           [GlobalData sharedInstance].cardPicBackName = [NSString stringWithFormat:@"%@.png",timeSp];
            [GlobalData sharedInstance].cardPicBack = tempImg;
        }else if (n == 3) {
            [self.educationBtn setImage:tempImg forState:UIControlStateNormal];
            _is3 = YES;
            NSString *url = [NSString stringWithFormat:@"%@%@%@",@"http://bd-resume.img-cn-shanghai.aliyuncs.com/",timeSp,@".png"];
            [GlobalData sharedInstance].jl_educationPiC = url;
            [GlobalData sharedInstance].educationPiCName = [NSString stringWithFormat:@"%@.png",timeSp];
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
        [self.frontBtn setImage:tempImg forState:UIControlStateNormal];
        _is1 = YES;
        NSString *url = [NSString stringWithFormat:@"%@%@_cardPicFont%@",@"http://bd-resume.img-cn-shanghai.aliyuncs.com/",timeSp,@".png"];
        [GlobalData sharedInstance].jl_cardPicFont = url;
        [GlobalData sharedInstance].cardPicFont = tempImg;
    }else if (n == 2) {
        [self.backBtn setImage:tempImg forState:UIControlStateNormal];
        _is2 = YES;
        NSString *url = [NSString stringWithFormat:@"%@%@_cardPicBack%@",@"http://bd-resume.img-cn-shanghai.aliyuncs.com/",timeSp,@".png"];
        [GlobalData sharedInstance].jl_cardPicBack = url;
        [GlobalData sharedInstance].cardPicBack = tempImg;
    }else if (n == 3) {
        [self.educationBtn setImage:tempImg forState:UIControlStateNormal];
        _is3 = YES;
        NSString *url = [NSString stringWithFormat:@"%@%@_educationPiC%@",@"http://bd-resume.img-cn-shanghai.aliyuncs.com/",timeSp,@".png"];
        [GlobalData sharedInstance].jl_educationPiC = url;
        [GlobalData sharedInstance].educationPiC = tempImg;
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
