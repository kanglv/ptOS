//
//  MyChangeHeaderViewController.m
//  ptOS
//
//  Created by 周瑞 on 16/9/28.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "MyChangeHeaderViewController.h"
#import "OSSManager.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImageView+WebCache.h"
#import "XHToast.h"
#import "UIImage+NTES.h"
#import "NTESFileLocationHelper.h"
#import "NIMCommonTableDelegate.h"
#import "NIMCommonTableData.h"
#import "NTESUserUtil.h"

@interface MyChangeHeaderViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,NIMUserManagerDelegate>
{
    UIImageView *_headerImageView;
}

@property (nonatomic,strong) NIMCommonTableDelegate *delegator;

@property (nonatomic,copy)   NSArray *data;

@end

@implementation MyChangeHeaderViewController

- (void)dealloc{
    [[NIMSDK sharedSDK].userManager removeDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildData];
    __weak typeof(self) wself = self;
    self.delegator = [[NIMCommonTableDelegate alloc] initWithTableData:^NSArray *{
        return wself.data;
    }];
    
    [[NIMSDK sharedSDK].userManager addDelegate:self];
    
    [self createPortaitView];
}

- (void)buildData{
    NIMUser *me = [[NIMSDK sharedSDK].userManager userInfo:[[NIMSDK sharedSDK].loginManager currentAccount]];
    NSArray *data = @[
                      @{
                          HeaderTitle:@"",
                          RowContent :@[
                                  @{
                                      ExtraInfo     : me.userId ? me.userId : [NSNull null],
                                      CellClass     : @"NTESSettingPortraitCell",
                                      RowHeight     : @(100),
                                      CellAction    : @"onTouchPortrait:",
                                      ShowAccessory : @(YES)
                                      },
                                  ],
                          FooterTitle:@""
                          },
                      @{
                          HeaderTitle:@"",
                          RowContent :@[
                                  @{
                                      Title      :@"昵称",
                                      DetailTitle:me.userInfo.nickName.length ? me.userInfo.nickName : @"未设置",
                                      CellAction :@"onTouchNickSetting:",
                                      RowHeight     : @(50),
                                      ShowAccessory : @(YES),
                                      },
                                  @{
                                      Title      :@"性别",
                                      DetailTitle:[NTESUserUtil genderString:me.userInfo.gender],
                                      CellAction :@"onTouchGenderSetting:",
                                      RowHeight     : @(50),
                                      ShowAccessory : @(YES)
                                      },
                                  @{
                                      Title      :@"生日",
                                      DetailTitle:me.userInfo.birth.length ? me.userInfo.birth : @"未设置",
                                      CellAction :@"onTouchBirthSetting:",
                                      RowHeight     : @(50),
                                      ShowAccessory : @(YES)
                                      },
                                  @{
                                      Title      :@"手机",
                                      DetailTitle:me.userInfo.mobile.length ? me.userInfo.mobile : @"未设置",
                                      CellAction :@"onTouchTelSetting:",
                                      RowHeight     : @(50),
                                      ShowAccessory : @(YES)
                                      },
                                  @{
                                      Title      :@"邮箱",
                                      DetailTitle:me.userInfo.email.length ? me.userInfo.email : @"未设置",
                                      CellAction :@"onTouchEmailSetting:",
                                      RowHeight     : @(50),
                                      ShowAccessory : @(YES)
                                      },
                                  @{
                                      Title      :@"签名",
                                      DetailTitle:me.userInfo.sign.length ? me.userInfo.sign : @"未设置",
                                      CellAction :@"onTouchSignSetting:",
                                      RowHeight     : @(50),
                                      ShowAccessory : @(YES)
                                      },
                                  ],
                          FooterTitle:@""
                          },
                      ];
    self.data = [NIMCommonTableSection sectionsWithData:data];
}

- (void)createPortaitView {
    self.needNav = NO;
    self.title = @"修改头像";
    _headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0 , SCREEN_WIDTH, SCREEN_WIDTH)];
    _headerImageView.centerX = self.view.centerX;
    
    UIImage *image = [UIImage imageWithData:[UserDefault objectForKey:HeaderKey]];
    if (image) {
        _headerImageView.image = image;
    }else {
        _headerImageView.image = [UIImage imageNamed:@"morentouxiang"];
    }
    
    [self.view addSubview:_headerImageView];
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    selectBtn.frame = CGRectMake(48, FITWIDTH(401), FITWIDTH(326), FITWIDTH(41));
    [selectBtn  setTitleColor:RGB(148, 148, 148) forState:UIControlStateNormal];
    selectBtn.backgroundColor = [UIColor whiteColor];
    selectBtn.centerX = self.view.centerX;
    [selectBtn setTitle:@"从相册内选取" forState:UIControlStateNormal];
    [selectBtn addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
    selectBtn.layer.borderColor = RGB(148, 148, 148).CGColor;
    selectBtn.layer.borderWidth = 0.5f;
    [self.view addSubview:selectBtn];
    
    UIButton *takePhotoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    takePhotoBtn.frame = CGRectMake(48 , FITWIDTH(454), FITWIDTH(326), FITWIDTH(41));
    [takePhotoBtn setTitleColor:RGB(148, 148, 148) forState:UIControlStateNormal];
    takePhotoBtn.backgroundColor = [UIColor whiteColor];
    takePhotoBtn.layer.borderColor = RGB(148, 148, 148).CGColor;
    takePhotoBtn.layer.borderWidth = 0.5f;
    takePhotoBtn.centerX = self.view.centerX;
    [takePhotoBtn setTitle:@"拍照" forState:UIControlStateNormal];
    [takePhotoBtn addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:takePhotoBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelBtn.frame = CGRectMake(48, FITWIDTH(507), FITWIDTH(326), FITWIDTH(41));
    [cancelBtn setTitleColor:RGB(148, 148, 148) forState:UIControlStateNormal];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    cancelBtn.layer.borderColor = RGB(148, 148, 148).CGColor;
    cancelBtn.layer.borderWidth = 0.5f;
    cancelBtn.centerX = self.view.centerX;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    
    //    UIImageView *imageView = [UIImageView alloc]init
}


- (void)selectImage:(UIButton *)sender {
    NSLog(@"选择照片");
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        [self getPhotoWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    else
    {
        [self getPhotoWithSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    }
}

- (void)takePhoto:(UIButton *)sender {
    NSLog(@"拍照");
    
    
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您的设备无法拍照，请至设置中打开相机" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }else {
        [self getPhotoWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    
}

- (void)cancelAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)getPhotoWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = sourceType;
    imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    __block UIImage *photoImg = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData *imageData = UIImageJPEGRepresentation(photoImg, 0.1);
    _headerImageView.image = photoImg;
    //    while (imageData.length > 204800) {
    //        CGFloat n = imageData.length / 204800;
    //        imageData = UIImageJPEGRepresentation(photoImg, n);
    //    }
    NSString *fileName = [NSString stringWithFormat:@"%@.png",[GlobalData sharedInstance].selfInfo.userName];
    [[OSSManager sharedManager] uploadObjectAsyncWithData:imageData andFileName:fileName andBDName:@"bd-header" andIsSuccess:^(BOOL isSuccess, UIImage *image) {
        
        if (isSuccess) {
            [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:HeaderKey];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self uploadImage:photoImg];
                
                [XHToast showCenterWithText:@"上传成功"];
                [SVProgressHUD dismiss];
                [self.navigationController popViewControllerAnimated:YES];
                
            });
            
            [[OSSManager sharedManager] downloadObjectAsyncWithFileName:fileName andBDName:@"bd-header" andGetImage:^(BOOL isSuccess, UIImage *image) {
                if (isSuccess) {
                    NSData *data = UIImageJPEGRepresentation(image, 1.0);
                    [[NSUserDefaults standardUserDefaults] setObject:data forKey:HeaderKey];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _headerImageView.image = image;
                    });
                    
                    
                }else {
                    NSLog(@"下载失败");
                }
            }];
        }else {
            NSLog(@"上传失败");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [XHToast showCenterWithText:@"上传失败"];
            });
            
            //            [SVProgressHUD showErrorWithStatus:@"上传失败"];
        }
    } andProgressBlock:^(int64_t has, int64_t total, int64_t will) {
        
    }];
    
    
    
    
}

- (void)uploadImage:(UIImage *)image{
    UIImage *imageForAvatarUpload = [image imageForAvatarUpload];
    NSString *fileName = [NTESFileLocationHelper genFilenameWithExt:@"jpg"];
    NSString *filePath = [[NTESFileLocationHelper getAppDocumentPath] stringByAppendingPathComponent:fileName];
    NSData *data = UIImageJPEGRepresentation(imageForAvatarUpload, 1.0);
    BOOL success = data && [data writeToFile:filePath atomically:YES];
    
    if (success) {
        [[NIMSDK sharedSDK].resourceManager upload:filePath progress:nil completion:^(NSString *urlString, NSError *error) {
            
            if (!error) {
                [[NIMSDK sharedSDK].userManager updateMyUserInfo:@{@(NIMUserInfoUpdateTagAvatar):urlString} completion:^(NSError *error) {
                    if (!error) {
                        [[SDWebImageManager sharedManager] saveImageToCache:imageForAvatarUpload forURL:[NSURL URLWithString:urlString]];
                        
                    }else{
                        
                    }
                }];
            }else{
                
            }
        }];
    }else{
        
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    //    [SVProgressHUD dismiss];
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}




- (void)refreshFace:(UIImage *)image
{
    if(image)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            _headerImageView.image = image;
        });
    }
    else
    {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:HeaderKey];
        UIImage *image = [UIImage imageWithData:data];
        if (image != nil) {
            _headerImageView.image = image;
        }else {
            _headerImageView.image = [UIImage imageNamed:@"morentouxiang"];
        }
        
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
