//
//  SCZBarViewController.m
//  Sucang
//
//  Created by Jarry on 16/12/13.
//  Copyright © 2016年 Sucang. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "SCZBarViewController.h"

@interface SCZBarViewController () <ZBarReaderDelegate, ScanOverlayDelegate>

@property (nonatomic, strong) ScanOverlayView *overlayView;

@end

@implementation SCZBarViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.overlayView startAnimation];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.overlayView cancelAnimation];
}

- (BOOL) willDealloc
{
    return NO;
}

- (void) setTitle:(NSString *)title
{
    [super setTitle:title];
    self.overlayView.title = title;
}

- (instancetype) init
{
    return [self initWithTitle:@"扫一扫"];
}

- (instancetype) initWithTitle:(NSString *)title
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    [self.readerView.session setSessionPreset:AVCaptureSessionPresetHigh];
    self.readerView.torchMode = 0;
    self.readerDelegate = self;
    self.videoQuality = UIImagePickerControllerQualityTypeHigh;
    self.supportedOrientationsMask = ZBarOrientationMaskAll;
    self.showsZBarControls = NO;
    self.showsCameraControls = NO;
    self.showsHelpOnFail = NO;
    
    [self.scanner setSymbology:0 config:ZBAR_CFG_ENABLE to:0];

//    [self.scanner setSymbology:(ZBAR_I25|ZBAR_EAN13|ZBAR_EAN8|ZBAR_CODE128|ZBAR_CODE39)
//                        config:ZBAR_CFG_ENABLE
//                            to:1];

    _overlayView = [[ScanOverlayView alloc] initWithFrame:SCREEN_FRAME title:title];
    _overlayView.delegate = self;
    [self.view addSubview:_overlayView];
    
//    self.scanCrop = [self getScanCropRect:[_overlayView scanRect]];
    
    return self;
}

- (void) setQrcodeEnabled:(BOOL)qrcodeEnabled
{
    _qrcodeEnabled = qrcodeEnabled;
    
    if (qrcodeEnabled) {
        [self.scanner setSymbology:ZBAR_QRCODE config:ZBAR_CFG_ENABLE to:1];
    }
}

- (void) setBarcodeEnabled:(BOOL)barcodeEnabled
{
    if (barcodeEnabled) {
        [self.scanner setSymbology:ZBAR_EAN13 config:ZBAR_CFG_ENABLE to:1];
        [self.scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:1];
        [self.scanner setSymbology:ZBAR_EAN8 config:ZBAR_CFG_ENABLE to:1];
        [self.scanner setSymbology:ZBAR_CODE128 config:ZBAR_CFG_ENABLE to:1];
        [self.scanner setSymbology:ZBAR_CODE39 config:ZBAR_CFG_ENABLE to:1];
    }
}

- (CGRect) getScanCropRect:(CGRect)scanRect
{
    CGFloat x = scanRect.origin.x / self.readerView.bounds.size.width;
    CGFloat y = scanRect.origin.y / self.readerView.bounds.size.height;
    CGFloat width = scanRect.size.width / self.readerView.bounds.size.width;
    CGFloat height = scanRect.size.height / self.readerView.bounds.size.height;
    return CGRectMake(x, y, width, height);
}

- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL) prefersStatusBarHidden
{
    return YES;
}

#pragma mark - ZBarReaderDelegate

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    ZBarSymbol * symbol;
    for(symbol in results)
        break;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSString *result = symbol.data;
    if ([result hasPrefix:@"0"] && result.length == 13) {
        result = [result substringFromIndex:1];
    }

    // 
    if (self.scanDelegate && [self.scanDelegate respondsToSelector:@selector(scanDidFinished:)]) {
        [self.scanDelegate scanDidFinished:result];
    }
}

#pragma mark - ScanOverlayDelegate

- (void) scanViewDidCanceled
{
    // 取消扫描回调
    if (self.scanDelegate && [self.scanDelegate respondsToSelector:@selector(scanDidCanceled)]) {
        [self.scanDelegate scanDidCanceled];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) scanViewFlashlamp:(BOOL)lampOn
{
    self.readerView.torchMode = lampOn ? 1 : 0;
}

@end
