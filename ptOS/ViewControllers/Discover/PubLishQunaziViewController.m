//
//  PubLishQunaziViewController.m
//  ptOS
//
//  Created by 周瑞 on 16/8/31.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "PubLishQunaziViewController.h"
#import "AFHTTPRequestOperation.h"
#import "FX_PublishTZApi.h"
#import "AJPhotoPickerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "AJPhotoBrowserViewController.h"
#import "UITextView+JKPlaceHolder.h"
#import "UITextView+JKSelect.h"
#import "OSSManager.h"

@interface PubLishQunaziViewController ()<AJPhotoPickerProtocol,AJPhotoBrowserDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>
{
    BOOL _hasPic;
}
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *addPicBtn;
@property (weak, nonatomic) IBOutlet UILabel *letterNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
@property (weak, nonatomic) IBOutlet UISwitch *swich;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (nonatomic,strong)FX_PublishTZApi *publishApi;

@end

@implementation PubLishQunaziViewController

#pragma mark - lifeCycles

- (void)viewDidLoad {
    [super viewDidLoad];
    _hasPic = NO;
    [NotificationCenter addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:nil];
    [self initUI];
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

- (void)dealloc {
    [NotificationCenter removeObserver:self];
}

#pragma mark - customFuncs

- (void)textChange {
    NSInteger num = [self.textView jk_getInputLengthWithText:self.textView.text];
    NSInteger realNum = num / 2.0;
    self.letterNumLabel.text = [NSString stringWithFormat:@"%@/140",[NSString stringWithFormat:@"%ld",(long)realNum]];
    if (realNum > 140) {
        self.letterNumLabel.textColor = [UIColor redColor];
        self.letterNumLabel.text = @"140/140";
        NSString *text = [self.textView.text substringToIndex:140];
        self.textView.text = text;
    }else {
        self.letterNumLabel.textColor = RGB(142, 142, 142);
    }
}
- (void)initUI {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"    发表" forState:UIControlStateNormal];
    [btn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake(0, 0, 60, 40)];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.addressLabel.text = [GlobalData sharedInstance].location;
    
    [self.textView jk_addPlaceHolder:@"  说点什么吧"];
}
- (void)next {
    if (!isValidStr([GlobalData sharedInstance].selfInfo.sessionId))
    {
        [self presentLoginCtrl];
        return;
    }
    UIImage *image = self.addPicBtn.imageView.image;
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
    NSString *fileName = [NSString stringWithFormat:@"%@.png",timeSp];
    [[OSSManager sharedManager] uploadObjectAsyncWithData:data andFileName:fileName andBDName:@"bd-image" andIsSuccess:^(BOOL isSuccess, UIImage *image) {
//        [XHToast showTopWithText:@"发表成功"];
    } andProgressBlock:^(int64_t has, int64_t total, int64_t will) {
        
    }];
    if (_hasPic) {
        [self publishApiNetWithImgUrl:[NSString stringWithFormat:@"http://bd-image.img-cn-shanghai.aliyuncs.com/%@.png",timeSp]];

        
    }else {
        [self publishApiNetWithImgUrl:@""];
    }
}

- (void)publishApiNetWithImgUrl:(NSString *)url {
    
    if(self.publishApi&& !self.publishApi.requestOperation.isFinished)
    {
        [self.publishApi stop];
    }
    self.publishApi.sessionDelegate = self;
    NSString *isQYQ = @"0";
    if (self.swich.isOn) {
        isQYQ = @"1";
    }
    self.publishApi = [[FX_PublishTZApi alloc]initWithContent:self.textView.text withImgUrl:url withAddress:self.addressLabel.text withIsQYQ:isQYQ];
    
    [self.publishApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        FX_PublishTZApi *result = (FX_PublishTZApi *)request;
        if(result.isCorrectResult)
        {
//            [XHToast showCenterWithText:@"发表成功"];
            [NotificationCenter postNotificationName:@"publish_refresh" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(YTKBaseRequest *request) {
        
    }];
}

- (IBAction)addPicAction:(id)sender {
    AJPhotoPickerViewController *picker = [[AJPhotoPickerViewController alloc] init];
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = YES;
    picker.delegate=self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return YES;
    }];
    
    [self presentViewController:picker animated:YES completion:nil];
}
- (IBAction)addressBtn:(id)sender {
    self.addressLabel.text = [GlobalData sharedInstance].location;
}
#pragma mark - Networkapis

#pragma mark - delegate
#pragma mark - BoPhotoPickerProtocol
- (void)imagePickerControllerDidCancel:(UIImagePickerController *) picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    _hasPic = NO;
}

- (void)photoPickerDidCancel:(AJPhotoPickerViewController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    _hasPic = NO;
}

- (void)photoPicker:(AJPhotoPickerViewController *)picker didSelectAssets:(NSArray *)assets {
    if (assets.count > 0) {
        
    ALAsset *asset = assets[0];
    UIImage *tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
    [self.addPicBtn setImage:tempImg forState:UIControlStateNormal];
    _hasPic = YES;
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    }
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *tempImg;
    if (CFStringCompare((CFStringRef) mediaType,kUTTypeImage, 0)== kCFCompareEqualTo) {
        tempImg = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    
    [self.addPicBtn setImage:tempImg forState:UIControlStateNormal];
    _hasPic = YES;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
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
