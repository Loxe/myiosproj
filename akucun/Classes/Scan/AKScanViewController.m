//
//  AKScanViewController.m
//  akucun
//
//  Created by Jarry Z on 2018/3/31.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "AKScanViewController.h"
#import "SGQRCode.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PermissonManger.h"
#import "UpDownButton.h"

@interface AKScanViewController () <SGQRCodeScanManagerDelegate,SGQRCodeAlbumManagerDelegate>

@property (nonatomic, strong) SGQRCodeScanManager  *scanManager;
@property (nonatomic, strong) SGQRCodeScanningView *scanningView;

@property (nonatomic, strong) UILabel  *promptLabel;
@property (nonatomic, strong) UILabel  *titleTextLabel;
@property (nonatomic, strong) UpDownButton *backButton;     // 返回按钮
@property (nonatomic, strong) UpDownButton *albumButton;    // 相册按钮
@property (nonatomic, strong) UpDownButton *longBrightBtn;  // 手电筒按钮(一直显示)

@property (nonatomic, assign) BOOL  isSelectedFlashlightBtn;
@property (nonatomic, assign) BOOL  isDetected;

@end

@implementation AKScanViewController

- (void) setTitle:(NSString *)title
{
    self.titleTextLabel.text = title;
}

- (void) setupContent
{
    [super setupContent];
    self.view.backgroundColor = BLACK_COLOR;
}

- (void) initViewData
{
    [self.view addSubview:self.scanningView];
    [self.view addSubview:self.promptLabel];
    [self.view addSubview:self.titleTextLabel];
    
    UIView *toolBar = [UIView new];
    toolBar.backgroundColor = [BLACK_COLOR colorWithAlphaComponent:0.4f];
    [self.view addSubview:toolBar];
    [toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.scanningView.mas_bottom);
        make.height.equalTo(@65);
    }];
    
    [toolBar addSubview:self.backButton];
    [toolBar addSubview:self.albumButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(toolBar).offset(-120);
        make.top.equalTo(toolBar).offset(10);
        make.width.height.equalTo(@45);
    }];
    [self.albumButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(toolBar);
        make.top.equalTo(self.backButton);
        make.width.height.equalTo(@45);
    }];
    
    if (!isPad) {
        [self.view addSubview:self.longBrightBtn];
        [self.longBrightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(toolBar).offset(120);
            make.top.equalTo(self.backButton);
            make.width.height.equalTo(@45);
        }];
    }
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupQRCodeScanning];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.scanningView addTimer];
    [self.scanManager resetSampleBufferDelegate];
    self.scanManager.delegate = self;
    [self.scanManager startRunning];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.scanManager stopRunning];
    [self.scanningView removeTimer];
    [self.scanManager cancelSampleBufferDelegate];
    self.scanManager.delegate = nil;
}

- (BOOL) willDealloc
{
    return NO;
}

- (void) setupQRCodeScanning
{
    // 初始化类型数组
    self.scanManager = [SGQRCodeScanManager sharedManager];
    
    NSArray *metadataTypeArray = @[AVMetadataObjectTypeQRCode,
                                   AVMetadataObjectTypeDataMatrixCode,
                                   AVMetadataObjectTypeAztecCode,
                                   AVMetadataObjectTypeCode128Code,
                                   AVMetadataObjectTypeCode39Code,
                                   AVMetadataObjectTypeCode39Mod43Code,
                                   AVMetadataObjectTypeCode93Code,
                                   AVMetadataObjectTypeEAN13Code,
                                   AVMetadataObjectTypeEAN8Code,
                                   AVMetadataObjectTypePDF417Code,
                                   AVMetadataObjectTypeInterleaved2of5Code,
                                   AVMetadataObjectTypeITF14Code,
                                   AVMetadataObjectTypeUPCECode];
    
    self.scanningView.scanningType = ScanningTypeDefault;
    
    if (self.scanningType == AKScanningTypeBarCode) {
        metadataTypeArray = @[AVMetadataObjectTypeAztecCode,
                              AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypeCode39Code,
                              AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeCode93Code,
                              AVMetadataObjectTypeEAN13Code,
                              AVMetadataObjectTypeEAN8Code,
                              AVMetadataObjectTypePDF417Code,
                              AVMetadataObjectTypeInterleaved2of5Code,
                              AVMetadataObjectTypeITF14Code,
                              AVMetadataObjectTypeUPCECode];
        self.scanningView.scanningType = ScanningTypeBarCode;
    }
    else if (self.scanningType == AKScanningTypeQRCode) {
        metadataTypeArray = @[AVMetadataObjectTypeQRCode,
                              AVMetadataObjectTypeDataMatrixCode];
    }
    
    // 根据类型，设置相应的参数
    CGFloat scanViewW = SCREEN_WIDTH;
    CGFloat scanViewH = 0.9*SCREEN_HEIGHT;
    
    //    [self.scanManager cancelSampleBufferDelegate]; // 关闭手电筒自动调节的方法
    self.scanManager.delegate = self;
    // 开启扫描相关
    // AVCaptureSessionPreset1920x1080 推荐使用，对于小型的二维码读取率较高
    [self.scanManager setupSessionPreset:AVCaptureSessionPreset1920x1080
                     metadataObjectTypes:metadataTypeArray
                       currentController:self];
    
    // 有效识别范围
    CGFloat w = 0.9*scanViewW;
    CGFloat h = 0.4*w;
    CGFloat x = 0.05*scanViewW;
    CGFloat y = 0.5*(scanViewH - w)+0.3*w;
    CGRect rect = CGRectMake(y/SCREEN_HEIGHT, x/SCREEN_WIDTH, h/SCREEN_HEIGHT, w/SCREEN_WIDTH);
    self.scanManager.scanRect = rect;
}


#pragma mark - Action

- (IBAction) cancelAction:(id)sender
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

/** 打开相册 */
- (IBAction) albumAction:(id)sender
{
    // 再判断相册写入权限
    ALAuthorizationStatus alAuthStatus = [ALAssetsLibrary authorizationStatus];
    if (alAuthStatus == ALAuthorizationStatusRestricted || alAuthStatus == ALAuthorizationStatusDenied) {
        // 若是已经拒绝，弹框跳到设置页面
        [self showSettingSuggetAlert];
        
    } else {
        SGQRCodeAlbumManager *manager = [SGQRCodeAlbumManager sharedManager];
        [manager readQRCodeFromAlbumWithCurrentController:self];
        manager.delegate = self;
        
        if (manager.isPHAuthorization == YES) {
            [self.scanningView removeTimer];
        }
    }
}

- (void) showSettingSuggetAlert
{
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"权限设置" message:@"当前没有相册的访问权限" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *settingAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[PermissonManger new] toSettingPage];
    }];
    [vc addAction:cancelAction];
    [vc addAction:settingAction];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction) manualFlashlightAction:(id)sender
{
    UpDownButton *button = sender;
    if (button.selected == NO) {
        button.topIcon.image = [UIImage imageNamed:@"SGQRCodeFlashlightCloseImage"];
        button.bottomLabel.textColor = [UIColor colorWithRed:80/255.0 green:152/255.0 blue:66/255.0 alpha:1];
        [SGQRCodeHelperTool SG_openFlashlight];
        self.isSelectedFlashlightBtn = YES;
        button.selected = YES;
        
    } else {
        button.topIcon.image = [UIImage imageNamed:@"SGQRCodeFlashlightOpenImage"];
        button.bottomLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        
        [SGQRCodeHelperTool SG_CloseFlashlight];
        self.isSelectedFlashlightBtn = NO;
        button.selected = NO;
    }
}

#pragma mark - SGQRCodeAlbumManagerDelegate
- (void) QRCodeAlbumManagerDidCancelWithImagePickerController:(SGQRCodeAlbumManager *)albumManager
{
    //    [self.view addSubview:self.scanningView];
    [self.view insertSubview:self.scanningView belowSubview:self.promptLabel];
}

- (void) QRCodeAlbumManager:(SGQRCodeAlbumManager *)albumManager didFinishPickingMediaWithResult:(NSString *)result
{
    INFOLOG(@"----> Scan Result : %@", result);
    //    if (self.scanResultBlock) {
    //        self.scanResultBlock(result);
    //    }
    //    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SGQRCodeScanManagerDelegate
- (void) QRCodeScanManager:(SGQRCodeScanManager *)scanManager didOutputMetadataObjects:(NSArray *)metadataObjects
{
    if (metadataObjects != nil && metadataObjects.count > 0) {
        
        // 防止快速扫描多次，添加isDetected标记
        if (self.isDetected) {
            return;
        }
        
        self.isDetected = YES;
        
        [scanManager palySoundName:@"SGQRCode.bundle/sound.caf"];
        
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        // 特殊处理
        NSString *result = [obj stringValue];
        if ([result hasPrefix:@"0"] && result.length == 13) {
            result = [result substringFromIndex:1];
        }
        
        INFOLOG(@"----> Scan Result : %@", result);

        if (self.scanResultBlock) {
            self.scanResultBlock(result);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    else {
        //        POPUPINFO(@"无法识别的二维码,请重新扫描");
    }
}

- (void) QRCodeScanManager:(SGQRCodeScanManager *)scanManager brightnessValue:(CGFloat)brightnessValue
{
    if (self.scanningType == AKScanningTypeBarCode) {
        self.promptLabel.text = @"将条码对准框内, 即可自动扫描";
    }
    else if (self.scanningType == AKScanningTypeQRCode) {
        self.promptLabel.text = @"将二维码对准框内, 即可自动扫描";
    }
    else {
        self.promptLabel.text = @"将二维码/条码对准框内, 即可自动扫描";
    }
}

#pragma mark -

/** 二维码及条码等扫描 */
- (SGQRCodeScanningView *) scanningView
{
    if (!_scanningView) {
        _scanningView = [[SGQRCodeScanningView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.9 * SCREEN_HEIGHT)];
        _scanningView.backgroundColor = CLEAR_COLOR;
        _scanningView.cornerWidth     = 3.f;
        _scanningView.backgroundAlpha = 0.4f;
        _scanningView.cornerLocation  = CornerLoactionInside;
//        _scanningView.scanningType    = ScanningTypeBarCode;
//        _scanningView.scanningImageName = @"SGQRCode.bundle/QRCodeScanningLineGrid";
//        _scanningView.scanningAnimationStyle = ScanningAnimationStyleGrid;
        //_scanningView.cornerColor = [UIColor orangeColor];
    }
    return _scanningView;
}

- (UILabel *) titleTextLabel
{
    if (!_titleTextLabel) {
        _titleTextLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, isIPhoneX ? 44 : 20, SCREEN_WIDTH, 44)];
        _titleTextLabel.backgroundColor = CLEAR_COLOR;
        _titleTextLabel.textColor = WHITE_COLOR;
        _titleTextLabel.font = [FontUtils bigFont];
        _titleTextLabel.textAlignment = NSTextAlignmentCenter;
        _titleTextLabel.text = @"扫 描";
    }
    return _titleTextLabel;
}

- (UILabel *) promptLabel
{
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.backgroundColor = [UIColor clearColor];
        CGFloat promptLabelX = 0;
        CGFloat promptLabelY = 0.73 * SCREEN_HEIGHT;
        CGFloat promptLabelW = SCREEN_WIDTH;
        CGFloat promptLabelH = 25;
        
        _promptLabel.frame = CGRectMake(promptLabelX, promptLabelY, promptLabelW, promptLabelH);
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.font = [UIFont boldSystemFontOfSize:13.0];
        _promptLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        _promptLabel.text = @"摄像头开启中，请稍候...";
    }
    return _promptLabel;
}

- (UpDownButton *) backButton
{
    if (!_backButton) {
        _backButton = [[UpDownButton alloc]init];
        [_backButton initWithTitle:@"退出" Image:@"SGQRCode.bundle/QRCodeScan_Down"];
        
        [_backButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UpDownButton *) albumButton
{
    if (!_albumButton) {
        _albumButton = [[UpDownButton alloc]init];
        [_albumButton initWithTitle:@"相册" Image:@"SGQRCode.bundle/SGQRCodeAlbum"];
        
        [_albumButton addTarget:self action:@selector(albumAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _albumButton;
}

- (UpDownButton *) longBrightBtn
{
    if (!_longBrightBtn) {
        _longBrightBtn = [[UpDownButton alloc]init];
        [_longBrightBtn initWithTitle:@"手电筒" Image:@"SGQRCodeFlashlightOpenImage"];
        
        [_longBrightBtn addTarget:self action:@selector(manualFlashlightAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _longBrightBtn;
}

@end
