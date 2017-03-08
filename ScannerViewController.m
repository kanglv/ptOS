//
//  ScannerViewController.m
//  lxt
//
//  Created by xhw on 15/12/12.
//  Copyright © 2015年 SM. All rights reserved.
//

#import "ScannerViewController.h"
#import "QRCScanner.h"

@interface ScannerViewController ()<QRCodeScanneDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation ScannerViewController
{
    BOOL _isRegister;
}

- (id)initWithType:(BOOL)isRegister
{
    self = [super init];
    if(self)
    {
        _isRegister = isRegister;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"扫描二维码";
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [self.view addSubview:bgView];

    QRCScanner *scanner = [[QRCScanner alloc]initQRCScannerWithView:bgView];
    if(!_isRegister)
    {
        scanner.notiInfoString = @"扫描二维码";
    }
    else
    {
        scanner.notiInfoString = @"扫描二维码";
    }
    scanner.delegate = self;
    [bgView addSubview:scanner];

    //从相册选取二维码
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(readerImage)];
    
}

#pragma mark - 扫描二维码成功后结果的代理方法
- (void)didFinshedScanningQRCode:(NSString *)result{
    
    [self.navigationController popViewControllerAnimated:NO];

    if ([self.delegate respondsToSelector:@selector(didFinshedScanning:)]) {
        [self.delegate didFinshedScanning:result];
    }
    else{
        NSLog(@"没有收到扫描结果，看看是不是没有实现协议！");
    }
}

#pragma mark - 从相册获取二维码图片
- (void)readerImage{
    UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
    photoPicker.delegate = self;
    photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    photoPicker.view.backgroundColor = [UIColor whiteColor];
    [self presentViewController:photoPicker animated:YES completion:NULL];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
    
    
    UIImage *srcImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSString *result = [QRCScanner scQRReaderForImage:srcImage];
    
    [self.navigationController popViewControllerAnimated:NO];

    if ([self.delegate respondsToSelector:@selector(didFinshedScanning:)]) {
        [self.delegate didFinshedScanning:result];
    }
    else{
        NSLog(@"没有收到扫描结果，看看是不是没有实现协议！");
    }
}
@end
