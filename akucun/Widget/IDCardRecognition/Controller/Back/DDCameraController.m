//
//  DDCameraController.m
//  akucun
//
//  Created by deepin do on 2018/1/12.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "DDCameraController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "IDCardBackScaningView.h"
#import "IDInfoBackController.h"
#import "UIAlertController+Extend.h"
#import "UIImage+Extend.h"

@interface DDCameraController ()<AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureMetadataOutputObjectsDelegate>

//@property (nonatomic, strong) AVCaptureSession           *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) AVCaptureStillImageOutput  *stillImageOutput;

// 摄像头设备
@property (nonatomic,strong) AVCaptureDevice *device;

@property (nonatomic, strong) AVCaptureDeviceInput       *backCameraInput; //后置摄像头输入
@property (nonatomic, strong) AVCaptureDeviceInput       *frontCameraInput; //前置摄像头输入
@property (nonatomic, strong) AVCaptureDeviceInput       *currentCameraInput;


@property (nonatomic, strong) AVCaptureMetadataOutput    *metaDataOutput;
@property (nonatomic, strong) AVCaptureVideoDataOutput   *videoDataOutput;

@property (nonatomic, strong) UIImageView                *focusImageView;
@property (nonatomic, assign) BOOL                       isManualFocus; // 判断是否手动对焦

@property (nonatomic, strong) dispatch_queue_t           sessionQueue;

// 预览图层
//@property (nonatomic,strong) AVCaptureVideoPreviewLayer *previewLayer;
// AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
@property (nonatomic,strong) AVCaptureSession *session;
@property (nonatomic, strong) dispatch_queue_t   queue;
@property (nonatomic,strong) IDCardBackScaningView *IDCardScaningView;
// 输出格式
@property (nonatomic,strong) NSNumber *outPutSetting;

// 是否打开手电筒
@property (nonatomic,assign,getter = isTorchOn) BOOL torchOn;

@property(nonatomic, strong) UIButton *recognitBtn;

@end

@implementation DDCameraController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareNav];
    [self prepareSubView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //将AVCaptureViewController的navigationBar调为透明
    //[[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
    //[self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    // 每次展现AVCaptureViewController的界面时，都检查摄像头使用权限
    [self checkAuthorizationStatus];
    
    // rightBarButtonItem设为原样
    self.torchOn = NO;
    self.navigationItem.rightBarButtonItem.image = [[UIImage imageNamed:@"nav_torch_off"] originalImage];
    
    // 将扫描框颜色重置为白色
    self.IDCardScaningView.IDCardScanningWindowLayer.borderColor = [UIColor whiteColor].CGColor;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    // 将AVCaptureViewController的navigationBar调为不透明
//    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
//    //[self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
//
    [self stopSession];
}

- (void)dealloc {
    [self.IDCardScaningView stopTimer];
}

- (void)prepareNav {
    self.view.backgroundColor = BLACK_COLOR;
    self.navigationItem.title = @"扫描身份证";
    
    // 添加rightBarButtonItem为打开／关闭手电筒
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(turnOnOrOffTorch)];
}

- (void)prepareSubView {
    
    // 添加预览图层
    [self.view.layer addSublayer:self.previewLayer];
    
    // 添加自定义的扫描界面（中间有一个镂空窗口和来回移动的扫描线）
    self.IDCardScaningView = [[IDCardBackScaningView alloc] initWithFrame:self.view.frame];
//    self.faceDetectionFrame = self.IDCardScaningView.facePathRect;
    [self.view addSubview:self.IDCardScaningView];
    
    //添加拍照按钮
    [self.view addSubview:self.recognitBtn];
    [self.recognitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
        make.bottom.equalTo(self.view).offset(-20);
    }];
}

#pragma mark - 打开／关闭手电筒
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

#pragma mark - 权限相关

/** 检测摄像头权限 */
- (void)checkAuthorizationStatus {
    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    switch (authorizationStatus) {
        case AVAuthorizationStatusNotDetermined:[self showAuthorizationNotDetermined]; break;// 用户尚未决定授权与否，那就请求授权
        case AVAuthorizationStatusAuthorized:[self showAuthorizationAuthorized]; break;// 用户已授权，那就立即使用
        case AVAuthorizationStatusDenied:[self showAuthorizationDenied]; break;// 用户明确地拒绝授权，那就展示提示
        case AVAuthorizationStatusRestricted:[self showAuthorizationRestricted]; break;// 无法访问相机设备，那就展示提示
    }
}

/** 用户还未决定是否授权使用相机 */
- (void)showAuthorizationNotDetermined {
    __weak __typeof__(self) weakSelf = self;
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        granted? [weakSelf runSession]: [weakSelf showAuthorizationDenied];
    }];
}

#pragma mark 被授权使用相机
- (void)showAuthorizationAuthorized {
    [self runSession];
}

#pragma mark 未被授权使用相机
- (void)showAuthorizationDenied {
    NSString *title = @"相机未授权";
    NSString *message = @"请到系统的“设置-隐私-相机”中授权此应用使用您的相机";
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 跳转到该应用的隐私设授权置界面
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    [self alertControllerWithTitle:title message:message okAction:okAction cancelAction:cancelAction];
}

#pragma mark 使用相机设备受限
- (void)showAuthorizationRestricted {
    NSString *title = @"相机设备受限";
    NSString *message = @"请检查您的手机硬件或设置";
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [self alertControllerWithTitle:title message:message okAction:okAction cancelAction:nil];
}

#pragma mark - 展示UIAlertController
- (void)alertControllerWithTitle:(NSString *)title message:(NSString *)message okAction:(UIAlertAction *)okAction cancelAction:(UIAlertAction *)cancelAction {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message okAction:okAction cancelAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - 运行session

/** 运行session */
// session开始，即输入设备和输出设备开始数据传递
- (void)runSession {
    if (![self.session isRunning]) {
        dispatch_async(self.queue, ^{
            [self.session startRunning];
        });
    }
}

/** 停止session */
// session停止，即输入设备和输出设备结束数据传递
-(void)stopSession {
    if ([self.session isRunning]) {
        dispatch_async(self.queue, ^{
            [self.session stopRunning];
        });
    }
}

#pragma mark - 懒加载

//- (dispatch_queue_t)queue {
//    if (_queue == nil) {
//        //_queue = dispatch_queue_create("AVCaptureSession_Start_Running_Queue", DISPATCH_QUEUE_SERIAL);
//        _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    }
//
//    return _queue;
//}
- (dispatch_queue_t)queue {
    if (_queue == nil) {
        _queue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
    }
    return _queue;
}

//- (dispatch_queue_t)sessionQueue {
//    if (!_sessionQueue) {
//        _sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
//    }
//    return _sessionQueue;
//}

- (AVCaptureVideoPreviewLayer *)previewLayer {
    if (!_previewLayer) {
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return _previewLayer;
}

- (AVCaptureSession *)session {
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
        _session.sessionPreset = AVCaptureSessionPresetPhoto;
        
        // 添加后置摄像头的输入
        if ([_session canAddInput:self.backCameraInput]) {
            [_session addInput:self.backCameraInput];
            self.currentCameraInput = self.backCameraInput;
        }
        // 添加视频输出
        if ([_session canAddOutput:self.videoDataOutput]) {
            [_session addOutput:self.videoDataOutput];
        }
        // 添加静态图片输出（拍照）
        if ([_session canAddOutput:self.stillImageOutput]) {
            [_session addOutput:self.stillImageOutput];
        }
        // 添加元素输出（识别）
        if ([_session canAddOutput:self.metaDataOutput]) {
            [_session addOutput:self.metaDataOutput];
            // 人脸识别
            [_metaDataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeFace]];
            // 二维码，一维码识别
            //        [_metaDataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode93Code]];
            [_metaDataOutput setMetadataObjectsDelegate:self queue:self.sessionQueue];
        }
    }
    return _session;
}

// 连接
- (AVCaptureConnection *)imageConnection {
    AVCaptureConnection *imageConnection = nil;
    for (AVCaptureConnection *connection in self.stillImageOutput.connections) {
        for (AVCaptureInputPort *port in connection.inputPorts) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                imageConnection = connection;
                break;
            }
        }
        if (imageConnection) {
            break;
        }
    }
    return imageConnection;
}

/** 后置摄像头输入 */
- (AVCaptureDeviceInput *)backCameraInput {
    if (_backCameraInput == nil) {
        NSError *error;
        _backCameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:&error];
        if (error) {
            NSLog(@"获取后置摄像头失败~");
        }
    }
    return _backCameraInput;
}

/** 前置摄像头输入 */
- (AVCaptureDeviceInput *)frontCameraInput {
    if (_frontCameraInput == nil) {
        NSError *error;
        _frontCameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontCamera] error:&error];
        if (error) {
            NSLog(@"获取前置摄像头失败~");
        }
    }
    return _frontCameraInput;
}

// 返回前置摄像头
- (AVCaptureDevice *)frontCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

// 返回后置摄像头
- (AVCaptureDevice *)backCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

// 切换前后置摄像头
//- (void)changeCameraInputDeviceisFront:(BOOL)isFront {
//    [self changeCameraAnimation];
//    __weak typeof(self) weak = self;
//    dispatch_async(self.sessionQueue, ^{
//        [weak.session beginConfiguration];
//        if (isFront) {
//            [weak.session removeInput:weak.backCameraInput];
//            if ([weak.session canAddInput:weak.frontCameraInput]) {
//                [weak.session addInput:weak.frontCameraInput];
//                weak.currentCameraInput = weak.frontCameraInput;
//            }
//        }else {
//            [weak.session removeInput:weak.frontCameraInput];
//            if ([weak.session canAddInput:weak.backCameraInput]) {
//                [weak.session addInput:weak.backCameraInput];
//                weak.currentCameraInput = weak.backCameraInput;
//            }
//        }
//        [weak.session commitConfiguration];
//    });
//}

// 用来返回是前置摄像头还是后置摄像头
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    // 返回和视频录制相关的所有默认设备
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    // 遍历这些设备返回跟position相关的设备
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

// 视频输出
- (AVCaptureVideoDataOutput *)videoDataOutput {
    if (_videoDataOutput == nil) {
        _videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
        [_videoDataOutput setSampleBufferDelegate:self queue:self.sessionQueue];
        NSDictionary* setcapSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange], kCVPixelBufferPixelFormatTypeKey,
                                        nil];
        _videoDataOutput.videoSettings = setcapSettings;
    }
    return _videoDataOutput;
}

// 静态图像输出
- (AVCaptureStillImageOutput *)stillImageOutput
{
    if (_stillImageOutput == nil) {
        _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
        _stillImageOutput.outputSettings = outputSettings;
    }
    return _stillImageOutput;
}

// 识别
- (AVCaptureMetadataOutput *)metaDataOutput
{
    if (_metaDataOutput == nil) {
        _metaDataOutput = [[AVCaptureMetadataOutput alloc] init];
    }
    return _metaDataOutput;
}

- (UIImageView *)focusImageView
{
    if (_focusImageView == nil) {
        _focusImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"touch_focus"]];
        _focusImageView.alpha = 0;
    }
    return _focusImageView;
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
            
            //NSError *error1;
            //CMTime frameDuration = CMTimeMake(1, 30); // 默认是1秒30帧
            //NSArray *supportedFrameRateRanges = [_device.activeFormat videoSupportedFrameRateRanges];
            //BOOL frameRateSupported = NO;
            //for (AVFrameRateRange *range in supportedFrameRateRanges) {
            //if (CMTIME_COMPARE_INLINE(frameDuration, >=, range.minFrameDuration) && CMTIME_COMPARE_INLINE(frameDuration, <=, range.maxFrameDuration)) {
            //frameRateSupported = YES;
            //}
            //}
            //
            //if (frameRateSupported && [self.device lockForConfiguration:&error1]) {
            //[_device setActiveVideoMaxFrameDuration:frameDuration];
            //[_device setActiveVideoMinFrameDuration:frameDuration];
            //[self.device unlockForConfiguration];
            //}
            
            [_device unlockForConfiguration];
        }
    }
    
    return _device;
}

#pragma mark outPutSetting
- (NSNumber *)outPutSetting {
    if (_outPutSetting == nil) {
        _outPutSetting = @(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange);
    }
    
    return _outPutSetting;
}


//- (UIImageView *)faceImageView
//{
//    if (_faceImageView == nil) {
//        _faceImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"face"]];
//        _faceImageView.alpha = 0;
//    }
//    return _faceImageView;
//}

- (UIButton *)recognitBtn {
    
    if (_recognitBtn == nil) {
        _recognitBtn = [[UIButton alloc]init];
        _recognitBtn.backgroundColor = [UIColor clearColor];
        _recognitBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _recognitBtn.layer.borderWidth = 1;
        [_recognitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_recognitBtn setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
        [_recognitBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_recognitBtn setTitle:@"识别" forState:UIControlStateNormal];
        [_recognitBtn addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recognitBtn;
}

@end
