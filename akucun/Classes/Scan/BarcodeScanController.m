//
//  BarcodeScanController.m
//  akucun
//
//  Created by Jarry Z on 2018/3/23.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "BarcodeScanController.h"
#import "SGQRCode.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PermissonManger.h"
#import "UpDownButton.h"
#import "RequestBarcodeSearch.h"
#import "RequestReportScan.h"
#import "PopupPeihuoView.h"

#define  COLOR_CONTENT_BG   RGBCOLOR(0xF0, 0xF0, 0xF0)

@interface BarcodeScanController () <SGQRCodeScanManagerDelegate,SGQRCodeAlbumManagerDelegate>

@property (nonatomic, strong) SGQRCodeScanManager  *scanManager;
@property (nonatomic, strong) SGQRCodeScanningView *scanningView;

@property (nonatomic, strong) UILabel  *promptLabel;
@property (nonatomic, strong) UILabel  *titleTextLabel;
@property (nonatomic, strong) UpDownButton *backButton;     // 返回按钮
@property (nonatomic, strong) UpDownButton *albumButton;    // 相册按钮
@property (nonatomic, strong) UpDownButton *longBrightBtn;  // 手电筒按钮(一直显示)

@property (nonatomic, strong) UIView  *contentView;
@property (nonatomic, strong) UILabel  *resultLabel;
@property (nonatomic, strong) UILabel  *statusLabel;

@property (nonatomic, strong) NSMutableArray *products;

@property (nonatomic, assign) BOOL  isSelectedFlashlightBtn;
@property (nonatomic, assign) BOOL  isDetected;

@end

@implementation BarcodeScanController

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
//    [toolBar addSubview:self.albumButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(toolBar).offset(-120);
        make.top.equalTo(toolBar).offset(10);
        make.width.height.equalTo(@45);
    }];
//    [self.albumButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(toolBar);
//        make.top.equalTo(self.backButton);
//        make.width.height.equalTo(@45);
//    }];
    if (!isPad) {
        [self.view addSubview:self.longBrightBtn];
        [self.longBrightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(toolBar).offset(120);
            make.top.equalTo(self.backButton);
            make.width.height.equalTo(@45);
        }];
    }
    
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(toolBar.mas_bottom);
    }];
    
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

    [self showStatus:0 barcode:nil];
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
    NSArray *metadataTypeArray = @[AVMetadataObjectTypeAztecCode,
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

    
    // 根据类型，设置相应的参数
    CGFloat scanViewW = SCREEN_WIDTH;
    CGFloat scanViewH = 0.5*SCREEN_HEIGHT;
    
    //    [self.scanManager cancelSampleBufferDelegate]; // 关闭手电筒自动调节的方法
    self.scanManager.delegate = self;
    // 开启扫描相关
    // AVCaptureSessionPreset1920x1080 推荐使用，对于小型的二维码读取率较高
    [self.scanManager setupSessionPreset:AVCaptureSessionPreset1920x1080
                     metadataObjectTypes:metadataTypeArray
                       currentController:self];
    
    // 有效识别范围
    CGFloat w = 0.96*scanViewW;
    CGFloat h = 0.4*w;
    CGFloat x = 0.02*scanViewW;
    CGFloat y = 0.5*(scanViewH - w)+0.3*w;
    CGRect rect = CGRectMake(y/SCREEN_HEIGHT, x/SCREEN_WIDTH, h/SCREEN_HEIGHT, w/SCREEN_WIDTH);
    self.scanManager.scanRect = rect;
}

#pragma mark -

- (void) showBarcodeResult:(NSArray *)products barcode:(NSString *)barcode
{
    if (!products || products.count == 0) {
        
        [self showStatus:3 barcode:barcode];
        //
        [self reportProductScan:@"" barcode:barcode status:0];
        return;
    }
    
    self.products = [NSMutableArray arrayWithArray:products];
    CartProduct *product = [self getProduct];
    if (product) {
        [self showProduct:product barcode:barcode];
    }
    else {
        [self showStatus:0 barcode:nil];
    }
}

- (CartProduct *) getProduct
{
    for (CartProduct *p in self.products) {
        if (p.scanstatu == 0) {
            return p;
        }
    }
    for (CartProduct *p in self.products) {
        return p;
    }
    return nil;
}

- (void) showProduct:(CartProduct *)product barcode:(NSString *)barcode
{
    PopupPeihuoView *popupView = [[PopupPeihuoView alloc] initWithProduct:product];
    @weakify(self)
    popupView.finishBlock = ^{
        @strongify(self)
        if (product.scanstatu == 0) {
            [self reportProductScan:product.cartproductid barcode:barcode status:1];
        }
        else {
            [self showStatus:0 barcode:nil];
        }
    };
    popupView.cancelBlock = ^{
        @strongify(self)
        [self.products removeAllObjects];
        [self showStatus:0 barcode:nil];
    };
    popupView.skipBlock = ^{
        @strongify(self)
        [self.products removeObject:product];
        CartProduct *next = [self getProduct];
        if (next) {
            [self showProduct:next barcode:barcode];
        }
        [self showStatus:0 barcode:nil];
    };
    [popupView show];
}

- (void) requestBarcodeSearch:(NSString *)barcode
{
    [SVProgressHUD showWithStatus:nil];
    
    RequestBarcodeSearch *request = [RequestBarcodeSearch new];
    request.barcode = barcode;
    if (self.liveId) {
        request.liveid = self.liveId;
    }
    
    [SCHttpServiceFace serviceWithRequest:request onSuccess:^(id content)
     {
         //
         [SVProgressHUD dismiss];
         
         ResponseBarcodeSearch *response = content;
         [self showBarcodeResult:response.result barcode:barcode];
         
     } onFailed:^(id content) {
         [self showStatus:0 barcode:nil];
     } onError:^(id content) {
         [self showStatus:0 barcode:nil];
     }];
}

- (void) reportProductScan:(NSString *)productId barcode:(NSString *)barcode status:(NSInteger)status
{
    [SVProgressHUD showWithStatus:nil];
    
    RequestReportScan *request = [RequestReportScan new];
    request.cartproduct = productId;
    //    request.adorderid = self.adOrder.adorderid;
    request.barcode = barcode;
    request.statu = status;
    
    [SCHttpServiceFace serviceWithPostRequest:request
                                    onSuccess:^(id content)
     {
         if (productId.length > 0) {
             [self showStatus:2 barcode:barcode];
         }
         else {
             [SVProgressHUD dismiss];
         }
         
     } onFailed:^(id content) {
         [self showStatus:0 barcode:nil];
     } onError:^(id content) {
         [self showStatus:0 barcode:nil];
     }];
}

// 0: 初始态   1: 已识别  2: 成功   3: 失败   4: 已拣货
- (void) showStatus:(NSInteger)status barcode:(NSString *)barcode
{
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.font = SYSTEMFONT(16);
    switch (status) {
        case 0:
        {
            self.isDetected = NO;
            self.resultLabel.textColor = GREEN_COLOR;
            self.statusLabel.textColor = COLOR_TEXT_NORMAL;
            self.resultLabel.text = @"扫码分拣中...";
            self.statusLabel.text = @"通过扫描商品条码，自动识别订单中的商品，\n\n您可以通过备注信息快速定位该商品的买家";
            self.statusLabel.textAlignment = NSTextAlignmentLeft;
        }
            break;
            
        case 1:
        {
            self.resultLabel.textColor = COLOR_TEXT_NORMAL;
            self.statusLabel.textColor = COLOR_TEXT_NORMAL;
            self.resultLabel.text = barcode;
            self.statusLabel.text = @"商品条码已识别，正在处理中...";
        }
            break;

        case 2:
        {
            [SVProgressHUD showSuccessWithStatus:@"已分拣成功 ！"];
            self.resultLabel.textColor = WHITE_COLOR;
            self.statusLabel.textColor = WHITE_COLOR;
            self.contentView.backgroundColor = GREEN_COLOR;
            self.statusLabel.font = SYSTEMFONT(30);
            
            self.resultLabel.text = @"已分拣";
            self.statusLabel.text = barcode;

            [UIView animateWithDuration:1.0f
                             animations:^
             {
                 self.resultLabel.textColor = GREEN_COLOR;
                 self.statusLabel.textColor = GREEN_COLOR;
                 self.contentView.backgroundColor = COLOR_CONTENT_BG;
                 
             } completion:^(BOOL finished) {
             }];
            
            @weakify(self)
            GCD_DELAY(^{
                @strongify(self)
                [self showStatus:0 barcode:nil];
            }, 2.0f);
        }
            break;
            
        case 3:
        {
            self.resultLabel.textColor = WHITE_COLOR;
            self.statusLabel.textColor = WHITE_COLOR;
            self.contentView.backgroundColor = RED_COLOR;

            self.resultLabel.text = barcode;
            self.statusLabel.text = @"请确认商品条码是否正确 ! \n\n您可以尝试扫一下另一个条码 !";
            
            [UIView animateWithDuration:1.0f
                             animations:^
            {
                self.resultLabel.textColor = RED_COLOR;
                self.statusLabel.textColor = RED_COLOR;
                self.contentView.backgroundColor = COLOR_CONTENT_BG;
                
            } completion:^(BOOL finished) {
            }];
            
            @weakify(self)
            GCD_DELAY(^{
                @strongify(self)
                [self showStatus:0 barcode:nil];
            }, 3.0f);
        }
            break;
            
        case 4:
        {
            self.statusLabel.text = @"\n该商品已拣货，请勿重复操作";
        }
            break;
    }
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
//        [scanManager stopRunning];
//        [scanManager videoPreviewLayerRemoveFromSuperlayer];
        
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        // 特殊处理
        NSString *result = [obj stringValue];
        if ([result hasPrefix:@"0"] && result.length == 13) {
            result = [result substringFromIndex:1];
        }
        
        INFOLOG(@"----> Scan Result : %@", result);
        
        [self showStatus:1 barcode:result];
        [self requestBarcodeSearch:result];

//        if (self.scanResultBlock && self.isSendResult == NO) {
//            self.isSendResult = YES;
//            self.scanResultBlock(result);
//        }
        
//        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
//        POPUPINFO(@"无法识别的二维码,请重新扫描");
    }
}

- (void) QRCodeScanManager:(SGQRCodeScanManager *)scanManager brightnessValue:(CGFloat)brightnessValue
{
    self.promptLabel.text = @"将条码对准框内, 即可自动扫描";
}

#pragma mark -

/** 二维码及条码等扫描 */
- (SGQRCodeScanningView *) scanningView
{
    if (!_scanningView) {
        _scanningView = [[SGQRCodeScanningView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5 * SCREEN_HEIGHT)];
        _scanningView.backgroundColor = CLEAR_COLOR;
        _scanningView.cornerWidth     = 3.f;
        _scanningView.backgroundAlpha = 0.4f;
        _scanningView.cornerLocation  = CornerLoactionInside;
        _scanningView.scanningType    = ScanningTypeBarCode;
        //_scanningView.scanningImageName = @"SGQRCode.bundle/QRCodeScanningLineGrid";
        //_scanningView.scanningAnimationStyle = ScanningAnimationStyleGrid;
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
        _titleTextLabel.text = @"扫码分拣";
    }
    return _titleTextLabel;
}

- (UILabel *) promptLabel
{
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.backgroundColor = [UIColor clearColor];
        CGFloat promptLabelX = 0;
        CGFloat promptLabelY = 0.43 * SCREEN_HEIGHT;
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

- (UIView *) contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = COLOR_CONTENT_BG;
        
        [_contentView addSubview:self.resultLabel];
        [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentView).offset(kOFFSET_SIZE);
            make.left.right.equalTo(_contentView);
        }];

        [_contentView addSubview:self.statusLabel];
        [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.resultLabel.mas_bottom).offset(2*kOFFSET_SIZE);
            make.left.equalTo(_contentView).offset(kOFFSET_SIZE);
            make.right.equalTo(_contentView).offset(-kOFFSET_SIZE);
        }];
    }
    return _contentView;
}

- (UILabel *) resultLabel
{
    if (!_resultLabel) {
        _resultLabel = [[UILabel alloc] init];
        _resultLabel.backgroundColor = [UIColor clearColor];
        _resultLabel.textAlignment = NSTextAlignmentCenter;
        _resultLabel.adjustsFontSizeToFitWidth = YES;
        _resultLabel.font = SYSTEMFONT(30);
        _resultLabel.textColor = GREEN_COLOR;
        _resultLabel.text = @"扫码分拣中...";
    }
    return _resultLabel;
}

- (UILabel *) statusLabel
{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textAlignment = NSTextAlignmentLeft;
        _statusLabel.font = SYSTEMFONT(16);
        _statusLabel.textColor = COLOR_TEXT_NORMAL;
        _statusLabel.numberOfLines = 0;
        _statusLabel.text = @"通过扫描商品条码，自动识别订单中的商品，\n\n您可以通过备注信息快速定位该商品的买家";
    }
    return _statusLabel;
}

@end
