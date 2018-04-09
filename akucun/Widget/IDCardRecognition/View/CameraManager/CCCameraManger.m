//
//  CCCameraManger.m
//  CustomCamera
//
//  Created by zhouke on 16/8/31.
//  Copyright © 2016年 zhongkefuchuang. All rights reserved.
//

#import "CCCameraManger.h"
#import "RectManager.h"
#import "UIImage+Extend.h"

// iPhone5/5c/5s/SE 4英寸 屏幕宽高：320*568点 屏幕模式：2x 分辨率：1136*640像素
#define iPhone5or5cor5sorSE ([UIScreen mainScreen].bounds.size.height == 568.0)

// iPhone6/6s/7 4.7英寸 屏幕宽高：375*667点 屏幕模式：2x 分辨率：1334*750像素
#define iPhone6or6sor7 ([UIScreen mainScreen].bounds.size.height == 667.0)

// iPhone6 Plus/6s Plus/7 Plus 5.5英寸 屏幕宽高：414*736点 屏幕模式：3x 分辨率：1920*1080像素
#define iPhone6Plusor6sPlusor7Plus ([UIScreen mainScreen].bounds.size.height == 736.0)

// iPhoneX 5.5英寸 屏幕宽高：375*812点 屏幕模式：3x 分辨率：1920*1080像素
#define iPhoneX ([UIScreen mainScreen].bounds.size.height == 812.0)

@interface CCCameraManger ()<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) dispatch_queue_t           sessionQueue;
@property (nonatomic, strong) AVCaptureSession           *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) AVCaptureDeviceInput       *backCameraInput; // 后置摄像头输入
@property (nonatomic, strong) AVCaptureDeviceInput       *frontCameraInput; // 前置摄像头输入
@property (nonatomic, strong) AVCaptureDeviceInput       *currentCameraInput;
@property (nonatomic, strong) AVCaptureStillImageOutput  *stillImageOutput;
@property (nonatomic, strong) AVCaptureMetadataOutput    *metaDataOutput;
@property (nonatomic, strong) AVCaptureVideoDataOutput   *videoDataOutput;

@property (nonatomic, strong) UIImageView                *focusImageView;
@property (nonatomic, assign) BOOL                       isManualFocus; // 判断是否手动对焦

@property (nonatomic, strong) UIImageView                *faceImageView;
@property (nonatomic, assign) BOOL                       isStartFaceRecognition;

@end

@implementation CCCameraManger

- (void)dealloc
{
    [self.session stopRunning];
    self.sessionQueue = nil;
    self.session = nil;
    self.previewLayer = nil;
    self.backCameraInput = nil;
    self.frontCameraInput = nil;
    self.stillImageOutput = nil;
    self.metaDataOutput = nil;
    self.videoDataOutput = nil;
    NSLog(@"CCCameraManger---dealloc");
}

- (instancetype)initWithParentView:(UIView *)parent
{
    if (self = [super init]) {
        self.parentView = parent;
        [self.parentView addSubview:self.focusImageView];
        [self.parentView addSubview:self.faceImageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClcik:)];
        [self.parentView addGestureRecognizer:tap];
    }
    return self;
}

- (void)startUp
{
    dispatch_async(self.sessionQueue, ^{
        [self.session startRunning];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isStartFaceRecognition = YES;
    });
}

- (void)stopSession {
    dispatch_async(self.sessionQueue, ^{
        [self.session stopRunning];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isStartFaceRecognition = NO;
    });
}

- (void)tapClcik:(UITapGestureRecognizer *)tap
{
    CGPoint location = [tap locationInView:self.parentView];
    [self focusInPoint:location];
}

#pragma mark - 拍照
- (void)takePhotoWithImageBlock:(void (^)(UIImage *, UIImage *, UIImage *, BOOL))block
{
    __weak typeof(self) weak = self;
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:[self imageConnection] completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            
            // 此处结束会话，避免拍好了，还可以动
            [self stopSession];
            NSLog(@"内部结束会话了----stopSession");
            
            UIImage *originImage = [[UIImage alloc] initWithData:imageData];
            self.isStartGetImage = NO;
            CGFloat squareLength = weak.previewLayer.bounds.size.width;
            CGFloat previewLayerH = weak.previewLayer.bounds.size.height;
            CGSize size = CGSizeMake(squareLength * 2, previewLayerH * 2);
            UIImage *scaledImage = [originImage resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:size interpolationQuality:kCGInterpolationHigh];
            
            //        CGRect cropFrame = CGRectMake((scaledImage.size.width - size.width) / 2, (scaledImage.size.height - size.height) / 2, size.width, size.height);
            //        UIImage *croppedImage = [scaledImage croppedImage:cropFrame];
            
            //        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
            //        if (orientation != UIDeviceOrientationPortrait) {
            //            CGFloat degree = 0;
            //            if (orientation == UIDeviceOrientationPortraitUpsideDown) {
            //                degree = 180;// M_PI;
            //            } else if (orientation == UIDeviceOrientationLandscapeLeft) {
            //                degree = -90;// -M_PI_2;
            //            } else if (orientation == UIDeviceOrientationLandscapeRight) {
            //                degree = 90;// M_PI_2;
            //            }
            //            croppedImage = [croppedImage rotatedByDegrees:degree];
            //            scaledImage = [scaledImage rotatedByDegrees:degree];
            //            originImage = [originImage rotatedByDegrees:degree];
            
            CGFloat degree = -90;
            scaledImage = [scaledImage rotatedByDegrees:degree];
            originImage = [originImage rotatedByDegrees:degree];
            
            //CGRect cropRotaFrame = CGRectMake((scaledImage.size.width-size.width-100)/2, (scaledImage.size.height-size.height)/2-140, size.width+100, size.height+100);
            
            UIImage *croppedImage;
            if (isPad) {
                CGRect cropRotaFrame = CGRectMake((scaledImage.size.width-size.width+600)/2, (scaledImage.size.height-size.height-120)/2, size.width-590, size.height-210);
                croppedImage = [scaledImage croppedImage:cropRotaFrame];
            } else {
                CGRect cropRotaFrame = CGRectMake((scaledImage.size.width-size.width-100)/2, (scaledImage.size.height-size.height-100)/2, size.width+100, size.height+100);
                croppedImage = [scaledImage croppedImage:cropRotaFrame];
            }
            
            if (block) {
                block(originImage,scaledImage,croppedImage,NO);
            }
            
        } else {
            NSLog(@"error----拍照%@",error);
            if (block) {
                block(nil,nil,nil,YES);
            }
            return ;
        }

    }];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (self.faceRecognition) {
        for(AVMetadataObject *metadataObject in metadataObjects) {
            if([metadataObject.type isEqualToString:AVMetadataObjectTypeFace]) {
                AVMetadataObject *transform = [self.previewLayer transformedMetadataObjectForMetadataObject:metadataObject];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showFaceImageWithFrame:transform.bounds];
                });
            }
        }
    }
}
- (void)showFaceImageWithFrame:(CGRect)rect
{
    if (self.isStartFaceRecognition) {
        self.isStartFaceRecognition = NO;
        self.faceImageView.frame = rect;
        
        self.faceImageView.transform = CGAffineTransformMakeScale(1.5, 1.5);
        __weak typeof(self) weak = self;
        [UIView animateWithDuration:0.3f animations:^{
            weak.faceImageView.alpha = 1.f;
            weak.faceImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:2.f animations:^{
                weak.faceImageView.alpha = 0.f;
            } completion:^(BOOL finished) {
                weak.isStartFaceRecognition = YES;
            }];
        }];
    }
}

//开启闪光灯
- (void)openFlashLight
{
    AVCaptureDevice *backCamera = [self backCamera];
    if (backCamera.torchMode == AVCaptureTorchModeOff) {
        [backCamera lockForConfiguration:nil];
        backCamera.torchMode = AVCaptureTorchModeOn;
        backCamera.flashMode = AVCaptureFlashModeOn;
        [backCamera unlockForConfiguration];
    }
}
//关闭闪光灯
- (void)closeFlashLight
{
    AVCaptureDevice *backCamera = [self backCamera];
    if (backCamera.torchMode == AVCaptureTorchModeOn) {
        [backCamera lockForConfiguration:nil];
        backCamera.torchMode = AVCaptureTorchModeOff;
        backCamera.flashMode = AVCaptureTorchModeOff;
        [backCamera unlockForConfiguration];
    }
}

- (void)changeCameraAnimation
{
    CATransition *changeAnimation = [CATransition animation];
    changeAnimation.delegate = self;
    changeAnimation.duration = 0.55;
    changeAnimation.type = @"oglFlip";
    changeAnimation.subtype = kCATransitionFromRight;
    changeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.previewLayer addAnimation:changeAnimation forKey:@"changeAnimation"];
}

#pragma mark - 聚焦
- (void)focusInPoint:(CGPoint)devicePoint
{
    if (!CGRectContainsPoint(self.previewLayer.bounds, devicePoint)) {
        return;
    }
    self.isManualFocus = YES;
    [self focusImageAnimateWithCenterPoint:devicePoint];
    devicePoint = [self.previewLayer captureDevicePointOfInterestForPoint:devicePoint];
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposeWithMode:AVCaptureExposureModeContinuousAutoExposure atDevicePoint:devicePoint monitorSubjectAreaChange:YES];
}

- (void)focusImageAnimateWithCenterPoint:(CGPoint)point
{
    [self.focusImageView setCenter:point];
    self.focusImageView.transform = CGAffineTransformMakeScale(2.0, 2.0);
    __weak typeof(self) weak = self;
    [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionAllowUserInteraction animations:^{
        weak.focusImageView.alpha = 1.f;
        weak.focusImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionAllowUserInteraction animations:^{
            weak.focusImageView.alpha = 0.f;
        } completion:^(BOOL finished) {
            weak.isManualFocus = NO;
        }];
    }];
}

- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposeWithMode:(AVCaptureExposureMode)exposureMode atDevicePoint:(CGPoint)point monitorSubjectAreaChange:(BOOL)monitorSubjectAreaChange
{
    dispatch_async(self.sessionQueue, ^{
        AVCaptureDevice *device = [self.currentCameraInput device];
        NSError *error = nil;
        if ([device lockForConfiguration:&error]) {
            if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:focusMode]) {
                [device setFocusMode:focusMode];
                [device setFocusPointOfInterest:point];
            }
            if ([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:exposureMode]) {
                [device setExposureMode:exposureMode];
                [device setExposurePointOfInterest:point];
            }
            [device setSubjectAreaChangeMonitoringEnabled:monitorSubjectAreaChange];
            [device unlockForConfiguration];
        } else {
            NSLog(@"%@", error);
        }
    });
}

#pragma mark - 从输出数据流捕捉单一的图像帧
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    if (self.isStartGetImage) {
        UIImage *originImage = [self imageFromSampleBuffer:sampleBuffer];
        CGFloat squareLength = self.previewLayer.bounds.size.width;
        CGFloat previewLayerH = self.previewLayer.bounds.size.height;
        CGSize size = CGSizeMake(squareLength*2, previewLayerH*2);
        UIImage *scaledImage = [originImage resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:size interpolationQuality:kCGInterpolationHigh];
        CGRect cropFrame = CGRectMake((scaledImage.size.width - size.width) / 2, (scaledImage.size.height - size.height) / 2, size.width, size.height);
        UIImage *croppedImage = [scaledImage croppedImage:cropFrame];
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        if (orientation != UIDeviceOrientationPortrait) {
            CGFloat degree = 0;
            if (orientation == UIDeviceOrientationPortraitUpsideDown) {
                degree = 180;// M_PI;
            } else if (orientation == UIDeviceOrientationLandscapeLeft) {
                degree = 18;//-90;// -M_PI_2;
            } else if (orientation == UIDeviceOrientationLandscapeRight) {
                degree = 90;// M_PI_2;
            }
            croppedImage = [croppedImage rotatedByDegrees:degree];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.getimageBlock) {
                self.getimageBlock(croppedImage);
                self.getimageBlock = nil;
            }
        });
        self.isStartGetImage = NO;
    }
}

// 通过抽样缓存数据创建一个UIImage对象
- (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIImage *image = [UIImage imageWithCGImage:quartzImage scale:1.0f orientation:UIImageOrientationRight];
    
    CGImageRelease(quartzImage);
    
    return (image);
}

#pragma mark - getter/setter
- (void)setParentView:(UIView *)parentView
{
    _parentView = parentView;
    
    self.previewLayer.frame = parentView.bounds;
    [parentView.layer insertSublayer:self.previewLayer atIndex:0];
}

- (dispatch_queue_t)sessionQueue
{
    if (!_sessionQueue) {
        _sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
    }
    return _sessionQueue;
}

- (AVCaptureVideoPreviewLayer *)previewLayer
{
    if (!_previewLayer) {
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return _previewLayer;
}

- (AVCaptureSession *)session
{
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
- (AVCaptureConnection *)imageConnection
{
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

// 后置摄像头输入
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

// 前置摄像头输入
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
- (void)changeCameraInputDeviceisFront:(BOOL)isFront {
    [self changeCameraAnimation];
    __weak typeof(self) weak = self;
    dispatch_async(self.sessionQueue, ^{
        [weak.session beginConfiguration];
        if (isFront) {
            [weak.session removeInput:weak.backCameraInput];
            if ([weak.session canAddInput:weak.frontCameraInput]) {
                [weak.session addInput:weak.frontCameraInput];
                weak.currentCameraInput = weak.frontCameraInput;
            }
        }else {
            [weak.session removeInput:weak.frontCameraInput];
            if ([weak.session canAddInput:weak.backCameraInput]) {
                [weak.session addInput:weak.backCameraInput];
                weak.currentCameraInput = weak.backCameraInput;
            }
        }
        [weak.session commitConfiguration];
    });
}

// 用来返回是前置摄像头还是后置摄像头
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position {
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

- (UIImageView *)faceImageView
{
    if (_faceImageView == nil) {
        _faceImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"face"]];
        _faceImageView.alpha = 0;
    }
    return _faceImageView;
}

@end
