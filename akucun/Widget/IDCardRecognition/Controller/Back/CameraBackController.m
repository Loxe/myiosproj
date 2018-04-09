//
//  CameraBackController.m
//  akucun
//
//  Created by deepin do on 2018/1/11.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "CameraBackController.h"
#import "UIAlertController+Extend.h"
#import "IDCardBackScaningView.h"
#import "CCCameraManger.h"
#import "IDInfoBackController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PermissonManger.h"
#import "UIImage+Extend.h"
#import "UIAlertController+Extend.h"

@interface CameraBackController ()

// 摄像头设备
@property (nonatomic,strong) AVCaptureDevice *device;

// 是否打开手电筒
@property (nonatomic,assign,getter = isTorchOn) BOOL torchOn;

@property(nonatomic, strong) UIButton *recognitBtn;

@property (nonatomic, strong) CCCameraManger *manger;

@property(nonatomic, strong) IDCardBackScaningView *preview;

@end

@implementation CameraBackController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareNav];
    [self prepareSubView];
}

- (void)prepareNav {
    self.view.backgroundColor = BLACK_COLOR;
    self.navigationItem.title = @"拍摄身份证";
    
    // 添加rightBarButtonItem为打开／关闭手电筒
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(turnOnOrOffTorch)];
}

- (void)prepareSubView {
    self.preview = [[IDCardBackScaningView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.preview];
    [self.preview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    //添加拍照按钮
    [self.view addSubview:self.recognitBtn];
    [self.recognitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.height.equalTo(@65);
        make.bottom.equalTo(self.view).offset(-30);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // rightBarButtonItem设为原样
    self.torchOn = NO;
    self.navigationItem.rightBarButtonItem.image = [[UIImage imageNamed:@"nav_torch_off"] originalImage];
    
    // 将扫描框颜色重置为白色
    self.preview.IDCardScanningWindowLayer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.manger startUp];
    [self.recognitBtn setEnabled:YES];
}

-(void)turnOnOrOffTorch {
    self.torchOn = !self.isTorchOn;
    
    if ([self.device hasTorch]){ // 判断是否有闪光灯
        [self.device lockForConfiguration:nil];// 请求独占访问硬件设备
        
        if (self.isTorchOn) {
            self.navigationItem.rightBarButtonItem.image = [[UIImage imageNamed:@"nav_torch_on"] originalImage];
            [self.device setTorchMode:AVCaptureTorchModeOn];
        } else {
            self.navigationItem.rightBarButtonItem.image = [[UIImage imageNamed:@"nav_torch_off"] originalImage];
            [self.device setTorchMode:AVCaptureTorchModeOff];
        }
        [self.device unlockForConfiguration];// 请求解除独占访问硬件设备
    }else {
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [self alertControllerWithTitle:@"提示" message:@"您的设备没有闪光设备，不能提供手电筒功能，请检查" okAction:okAction cancelAction:nil];
    }
}

- (void)takePicture {
#if TARGET_IPHONE_SIMULATOR //模拟器
#elif TARGET_OS_IPHONE      //真机
    
    // 先判断相机权限
    AVAuthorizationStatus avAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (avAuthStatus == AVAuthorizationStatusRestricted || avAuthStatus == AVAuthorizationStatusDenied) {
        [self showSettingSuggetAlert];
    } else if (avAuthStatus == AVAuthorizationStatusNotDetermined) {
        //NSLog(@"avAuthStatus == AVAuthorizationStatusNotDetermined");
    } else {
        //NSLog(@"有摄像头权限");
    }
    
    // 再判断相册写入权限
    ALAuthorizationStatus alAuthStatus = [ALAssetsLibrary authorizationStatus];
    if (alAuthStatus == ALAuthorizationStatusRestricted || alAuthStatus == ALAuthorizationStatusDenied) {
        // 若是已经拒绝，弹框跳到设置页面
        [self showSettingSuggetAlert];
        
    } else if (alAuthStatus == ALAuthorizationStatusNotDetermined) {
        NSLog(@"alAuthStatus == ALAuthorizationStatusNotDetermined");
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.recognitBtn setEnabled:NO];
                    [self startRecognitAction];
                });
            } else {
                //NSLog(@"AVCaptureDevice not granted");
            }
        }];
    } else {
        //NSLog(@"直接就有权限");
        [self.recognitBtn setEnabled:NO];
        [self startRecognitAction];
    }
#endif
}

- (void)startRecognitAction {

    // 将扫描框颜色设置为绿色
    self.preview.IDCardScanningWindowLayer.borderColor = [UIColor greenColor].CGColor;
    
    [self.manger takePhotoWithImageBlock:^(UIImage *originImage, UIImage *scaledImage, UIImage *croppedImage,BOOL isError) {
        NSLog(@"----->%@",croppedImage);

        if (isError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 拍完将框变成绿色
                self.preview.IDCardScanningWindowLayer.borderColor = [UIColor whiteColor].CGColor;
                POPUPINFO(@"拍摄出错，请重新拍照");
                [NSThread sleepForTimeInterval:3.0];
                [_recognitBtn setEnabled:YES];
            });
            
        } else {
            IDInfoBackController *IDInfoVC = [[IDInfoBackController alloc] init];
            IDInfoVC.IDImage = croppedImage;// 身份证图像
            [self.navigationController pushViewController:IDInfoVC animated:YES];
        }
    }];
}

- (void)showSettingSuggetAlert {
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"权限设置" message:@"当前未有摄像头、麦克风或者相册的访问权限" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *settingAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[PermissonManger new] toSettingPage];
    }];
    [vc addAction:cancelAction];
    [vc addAction:settingAction];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - 展示UIAlertController
- (void)alertControllerWithTitle:(NSString *)title message:(NSString *)message okAction:(UIAlertAction *)okAction cancelAction:(UIAlertAction *)cancelAction {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message okAction:okAction cancelAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - lazy

- (CCCameraManger *)manger
{
    if (!_manger) {
        _manger = [[CCCameraManger alloc] initWithParentView:self.preview];
        _manger.faceRecognition = NO;
    }
    return _manger;
}

- (UIButton *)recognitBtn {
    
    if (_recognitBtn == nil) {
        _recognitBtn = [[UIButton alloc]init];
        _recognitBtn.backgroundColor = [UIColor clearColor];
        [_recognitBtn setEnabled:NO];
//        _recognitBtn.layer.cornerRadius = 40;
//        _recognitBtn.layer.masksToBounds = YES;
//        _recognitBtn.layer.borderColor = [UIColor whiteColor].CGColor;
//        _recognitBtn.layer.borderWidth = 1;
        
        [_recognitBtn setImage:[UIImage imageNamed:@"recogniteWhite"] forState:UIControlStateNormal];
        [_recognitBtn setImage:[UIImage imageNamed:@"recogniteSelected"] forState:UIControlStateSelected];
        [_recognitBtn setImage:[UIImage imageNamed:@"recogniteSelected"] forState:UIControlStateHighlighted];
//        [_recognitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_recognitBtn setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
//        [_recognitBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
//        [_recognitBtn setTitle:@"识别" forState:UIControlStateNormal];
        [_recognitBtn addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recognitBtn;
}

- (AVCaptureDevice *)device {
    if (_device == nil) {
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        NSError *error = nil;
        if ([_device lockForConfiguration:&error]) {
            if ([_device isSmoothAutoFocusSupported]) {// 平滑对焦
                _device.smoothAutoFocusEnabled = YES;
            }
            
            if ([_device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {// 自动持续对焦
                _device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
            }
            
            if ([_device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure ]) {// 自动持续曝光
                _device.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
            }
            
            if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {// 自动持续白平衡
                _device.whiteBalanceMode = AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance;
            }
            
            [_device unlockForConfiguration];
        }
    }
    
    return _device;
}

@end
