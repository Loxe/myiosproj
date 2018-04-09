//
//  ASaleTuihuoController.m
//  akucun
//
//  Created by Jarry on 2017/9/12.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ASaleTuihuoController.h"
#import "CameraUtils.h"
#import "FormTextField.h"
#import "YYText.h"
#import "RequestAftersaleTuihuo.h"
#import "AKScanViewController.h"

@interface ASaleTuihuoController () <UIScrollViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UILabel *textLabel, *addressLabel;

@property (nonatomic, strong) FormTextField *wuliuTextField, *bianhaoTextField;
@property (nonatomic, strong) UIButton *scanButton;

@property (nonatomic, strong) UIButton *copyaButton;
@property (nonatomic, strong) UIButton *saveButton;

@end

@implementation ASaleTuihuoController

- (instancetype) initWithProduct:(NSString *)cartProductId
{
    self = [self init];
    if (self) {
        self.productId = cartProductId;
        [self initView];
    }
    return self;
}

- (void) setupContent
{
    [super setupContent];
    //    self.view.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = @"填写退货信息";
//    self.navigationItem.leftBarButtonItem = nil;
}

- (void) initView
{
    [self.view addSubview:self.scrollView];
    
    CGFloat offset = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
    
    self.textLabel.top = offset;
    [self.scrollView addSubview:self.textLabel];
    
    self.addressLabel.top = self.textLabel.bottom + offset;
    [self.scrollView addSubview:self.addressLabel];
    
    self.wuliuTextField.top = self.addressLabel.bottom + offset*1.5f;
    [self.scrollView addSubview:self.wuliuTextField];
    
    self.copyaButton.bottom = self.addressLabel.bottom;
    [self.scrollView addSubview:self.copyaButton];
    
    CGFloat fieldHeight = isPad ? 50 : kFIELD_HEIGHT;
    UIView *bianhaoView = [[UIView alloc] initWithFrame:CGRectMake(kOFFSET_SIZE, 0, SCREEN_WIDTH-kOFFSET_SIZE*2, fieldHeight)];
    bianhaoView.backgroundColor = WHITE_COLOR;
    bianhaoView.clipsToBounds = YES;
    bianhaoView.layer.borderColor = COLOR_TEXT_LIGHT.CGColor;
    bianhaoView.layer.borderWidth = 0.5f;
    bianhaoView.layer.cornerRadius = 5.0f;
    [bianhaoView addSubview:self.bianhaoTextField];
    [bianhaoView addSubview:self.scanButton];
    bianhaoView.top = self.wuliuTextField.bottom + offset;
    [self.scrollView addSubview:bianhaoView];
    
    [self.scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(bianhaoView);
        make.width.mas_equalTo(@(40));
    }];
    
    self.saveButton.top = bianhaoView.bottom + offset * 2;
    [self.scrollView addSubview:self.saveButton];
    

    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.saveButton.bottom+offset);
}


#pragma mark - Actions

- (IBAction) leftButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction) copyAction:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.addressLabel.text;
    [SVProgressHUD showSuccessWithStatus:@"地址已复制"];
}

- (IBAction) saveAction:(id)sender
{
    [self.view endEditing:YES];
    
    if (self.wuliuTextField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入物流公司名称"];
        return;
    }
    if (self.bianhaoTextField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入快递单号"];
        return;
    }
    
    [self sendRequest];
}

- (IBAction) scanAction:(id)sender
{
    if ([CameraUtils isCameraNotDetermined]) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    // 用户授权
//                    [self presentViewController:self.scanReader animated:YES completion:nil];
                    [self showSGQScanVC];
                }
                else {
                    // 用户拒绝授权
                    [self showCameraDenied];
                }
            });
        }];
    }
    else if ([CameraUtils isCameraDenied]) {
        // 摄像头已被禁用
        [self showCameraDenied];
    }
    else {
        // 用户允许访问摄像头
//        [self presentViewController:self.scanReader animated:YES completion:nil];
        [self showSGQScanVC];
    }
}

- (void) showCameraDenied
{
    [self confirmWithTitle:@"摄像头未授权" detail:@"摄像头访问未授权，您可以在设置中打开" btnText:@"去设置" block:^{
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    } canceled:nil];
}

- (void) showSGQScanVC
{
    AKScanViewController *vc = [[AKScanViewController alloc] init];
    vc.title    = @"扫码搜索";
    vc.scanningType = AKScanningTypeBarCode;
    
    @weakify(self)
    vc.scanResultBlock = ^(NSString *codeString) {
        @strongify(self)
        INFOLOG(@"扫描结果: %@", codeString);
        self.bianhaoTextField.text = codeString;
    };
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Request

- (void) sendRequest
{
    [SVProgressHUD showWithStatus:nil];
    
    RequestAftersaleTuihuo *request = [RequestAftersaleTuihuo new];
    request.refundcorp = self.wuliuTextField.text;
    request.refundhao = self.bianhaoTextField.text;
    request.cartproductid = self.productId;
    
    [SCHttpServiceFace serviceWithPostRequest:request
                                    onSuccess:^(id content)
    {
        [SVProgressHUD showSuccessWithStatus:@"已成功提交 ！"];
        GCD_DELAY(^{
            [self dismissViewControllerAnimated:YES completion:nil];
            if (self.finishedBlock) {
                self.finishedBlock();
            }
        }, 1.0f);
        
    } onFailed:^(id content) {
        
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIScrollViewDelegate

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark -

- (UIScrollView *) scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = CLEAR_COLOR;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.view.height);
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UILabel *) textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.numberOfLines = 0;
        
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:@"将您的货品寄回到以下地址，请输入退货快递单号"];
        attributedText.yy_font = [FontUtils buttonFont];
        attributedText.yy_color = COLOR_TEXT_DARK;
        attributedText.yy_lineSpacing = 5.0f;
        _textLabel.attributedText = attributedText;
        [_textLabel sizeToFit];
        
        _textLabel.left = kOFFSET_SIZE;
        _textLabel.width = SCREEN_WIDTH - kOFFSET_SIZE*2;
    }
    return _textLabel;
}

- (UILabel *) addressLabel
{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.numberOfLines = 0;

        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:@"退货地址：上海市闵行区沪闵路1871号8号楼302\n收件人：爱库存\n电 话：021-31133229"];
        attributedText.yy_font = [FontUtils normalFont];
        attributedText.yy_color = COLOR_TEXT_DARK;
        attributedText.yy_lineSpacing = 5.0f;
        _addressLabel.attributedText = attributedText;
        [_addressLabel sizeToFit];
        
        _addressLabel.left = kOFFSET_SIZE;
        _addressLabel.width = SCREEN_WIDTH - kOFFSET_SIZE*2;
    }
    return _addressLabel;
}

- (FormTextField *) wuliuTextField
{
    if (!_wuliuTextField) {
        CGFloat fieldHeight = isPad ? 50 : kFIELD_HEIGHT;
        _wuliuTextField = [[FormTextField alloc] initWithFrame:CGRectMake(kOFFSET_SIZE, 0, SCREEN_WIDTH-kOFFSET_SIZE*2, fieldHeight)];
        _wuliuTextField.backgroundColor = WHITE_COLOR;
        _wuliuTextField.borderStyle = UITextBorderStyleRoundedRect;
        _wuliuTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _wuliuTextField.font = [FontUtils normalFont];
        _wuliuTextField.textColor = COLOR_TEXT_DARK;
        _wuliuTextField.placeholder = @"请输入物流公司名称";
        _wuliuTextField.returnKeyType = UIReturnKeyDone;
        
        _wuliuTextField.delegate = self;
    }
    return _wuliuTextField;
}

- (FormTextField *) bianhaoTextField
{
    if (!_bianhaoTextField) {
        CGFloat fieldHeight = isPad ? 50 : kFIELD_HEIGHT;
        _bianhaoTextField = [[FormTextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-kOFFSET_SIZE*2-40, fieldHeight)];
        _bianhaoTextField.backgroundColor = WHITE_COLOR;
        _bianhaoTextField.borderColor = CLEAR_COLOR;
        _bianhaoTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _bianhaoTextField.font = [FontUtils normalFont];
        _bianhaoTextField.textColor = COLOR_TEXT_DARK;
        _bianhaoTextField.placeholder = @"请输入快递单号";
        _bianhaoTextField.returnKeyType = UIReturnKeyDone;
        _bianhaoTextField.keyboardType = UIKeyboardTypeNumberPad;
        
        _bianhaoTextField.delegate = self;
    }
    return _bianhaoTextField;
}

- (UIButton *) scanButton
{
    if (_scanButton) {
        return _scanButton;
    }
    
    _scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _scanButton.frame = CGRectMake(0, 0, 40, 40);
    
    UIImage *image = [IMAGENAMED(@"icon_scan") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _scanButton.imageView.tintColor = COLOR_APP_GREEN;
    [_scanButton setImage:image forState:UIControlStateNormal];
    
    [_scanButton addTarget:self action:@selector(scanAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return _scanButton;
}

- (UIButton *) saveButton
{
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        CGFloat fieldHeight = isPad ? 50 : kFIELD_HEIGHT;
        _saveButton.frame = CGRectMake(kOFFSET_SIZE, 0, SCREEN_WIDTH-kOFFSET_SIZE*2, fieldHeight);
        _saveButton.clipsToBounds = YES;
        _saveButton.layer.cornerRadius = 5;
        _saveButton.layer.borderWidth = 0.5f;
        _saveButton.layer.borderColor = RGBCOLOR(225, 225, 225).CGColor;
        
        _saveButton.titleLabel.font = BOLDSYSTEMFONT(16);
        
        [_saveButton setNormalColor:WHITE_COLOR highlighted:COLOR_TEXT_LIGHT selected:nil];
        [_saveButton setBackgroundColor:COLOR_SELECTED];
        [_saveButton setNormalTitle:@"确　定"];
        
        [_saveButton addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

- (UIButton *) copyaButton
{
    if (_copyaButton) {
        return _copyaButton;
    }
    _copyaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _copyaButton.frame = CGRectMake(0, 0, 70, 28);
    _copyaButton.right = SCREEN_WIDTH - kOFFSET_SIZE;
    _copyaButton.backgroundColor = CLEAR_COLOR;
    _copyaButton.clipsToBounds = YES;
    _copyaButton.layer.cornerRadius = 3.0f;
    _copyaButton.layer.borderWidth = 0.5f;
    _copyaButton.layer.borderColor = COLOR_TEXT_NORMAL.CGColor;
    _copyaButton.titleLabel.font = [FontUtils smallFont];
    [_copyaButton setNormalTitle:@"复制地址"];
    [_copyaButton setNormalColor:COLOR_TEXT_NORMAL highlighted:RED_COLOR selected:nil];
    
    [_copyaButton addTarget:self action:@selector(copyAction:)
           forControlEvents:UIControlEventTouchUpInside];
    
    return _copyaButton;
}

@end
