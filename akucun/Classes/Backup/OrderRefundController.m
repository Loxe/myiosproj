//
//  OrderRefundController.m
//  akucun
//
//  Created by Jarry on 2017/6/20.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "OrderRefundController.h"
#import "CameraUtils.h"
#import "RequestOrderRefund.h"
#import "RequestProductBuy.h"
#import "YYText.h"
#import "FormTextField.h"
#import "TextButton.h"
#import "Gallop.h"
#import "ProductsManager.h"
#import "SCZBarViewController.h"
#import "OptionsPopupView.h"

@interface OrderRefundController () <UIScrollViewDelegate, UITextFieldDelegate, LWAsyncDisplayViewDelegate, SCZBarDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UILabel *textLabel, *addressLabel;

@property (nonatomic, strong) FormTextField *wuliuTextField, *bianhaoTextField;
@property (nonatomic, strong) UIButton *scanButton;

@property (nonatomic, strong) TextButton *reasonButton;

@property (nonatomic, strong) UIButton *copyaButton;
@property (nonatomic, strong) UIButton *saveButton;

@property (nonatomic, assign) NSInteger selectReason;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) LWAsyncDisplayView* asyncDisplayView;

@property (nonatomic, strong) LWTextStorage* skuStorage;
@property (nonatomic, strong) ProductSKU* selectSKU;
@property (nonatomic, strong) ProductModel *product;

@property (strong, nonatomic) SCZBarViewController *scanReader;

@end

@implementation OrderRefundController

- (instancetype) initWithType:(NSInteger)type cartProduct:(CartProduct *)cartProduct
{
    self = [self init];
    if (self) {
        self.type = type;
        self.cartProduct = cartProduct;
        self.productId = cartProduct.productid;
        [self initView];
    }
    return self;
}

- (void) setupContent
{
    [super setupContent];
//    self.view.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void) initView
{
    [self.view addSubview:self.scrollView];

    [self.scrollView addSubview:self.textLabel];
    [self.scrollView addSubview:self.addressLabel];
    [self.scrollView addSubview:self.wuliuTextField];
    [self.scrollView addSubview:self.copyaButton];
    [self.scrollView addSubview:self.reasonButton];
    [self.scrollView addSubview:self.saveButton];
    
    UIView *bianhaoView = [[UIView alloc] init];
    bianhaoView.backgroundColor = WHITE_COLOR;
    bianhaoView.clipsToBounds = YES;
    bianhaoView.layer.borderColor = COLOR_TEXT_LIGHT.CGColor;
    bianhaoView.layer.borderWidth = 0.5f;
    bianhaoView.layer.cornerRadius = 5.0f;
    [bianhaoView addSubview:self.bianhaoTextField];
    [bianhaoView addSubview:self.scanButton];
    [self.scrollView addSubview:bianhaoView];

    CGFloat fieldHeight = isPad ? 50 : kFIELD_HEIGHT;

    MASViewAttribute *lastAttribute = nil;
    if (self.type == 1) {
        if ([self.product isQuehuo]) {
            self.title = @"申请退货退款";
        }
        else {
            self.title = @"申请换货";
            [self setText:@"换货先对原货品退货退款，再重新下单\n订单已发货，请输入退货快递单号\n客服收到货品会退回货品金额到您的账户余额"];
        }
        [self.scrollView addSubview:self.asyncDisplayView];
        //
        CGFloat height = [self.asyncDisplayView.layout suggestHeightWithBottomMargin:0];
        [self.asyncDisplayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bianhaoTextField.mas_bottom).with.offset(kOFFSET_SIZE);
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(@(height));
        }];
        lastAttribute = self.asyncDisplayView.mas_bottom;
    }
    else {
        self.title = @"申请退货退款";
        lastAttribute = self.bianhaoTextField.mas_bottom;
    }
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_top).with.offset(kOFFSET_SIZE);
        make.left.equalTo(self.view.mas_left).offset(kOFFSET_SIZE);
        make.right.equalTo(self.view.mas_right).offset(-kOFFSET_SIZE);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLabel.mas_bottom).with.offset(kOFFSET_SIZE);
        make.left.equalTo(self.view.mas_left).offset(kOFFSET_SIZE);
        make.right.equalTo(self.view.mas_right).offset(-kOFFSET_SIZE);
    }];
    
    [self.reasonButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressLabel.mas_bottom).with.offset(kOFFSET_SIZE);
        make.left.equalTo(self.view.mas_left).offset(kOFFSET_SIZE);
        make.right.equalTo(self.view.mas_right).offset(-kOFFSET_SIZE);
        make.height.mas_equalTo(@(fieldHeight));
    }];
    
    [self.wuliuTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.reasonButton.mas_bottom).with.offset(kOFFSET_SIZE);
        make.left.equalTo(self.view.mas_left).offset(kOFFSET_SIZE);
        make.right.equalTo(self.view.mas_right).offset(-kOFFSET_SIZE);
        make.height.mas_equalTo(@(fieldHeight));
    }];
    [bianhaoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wuliuTextField.mas_bottom).with.offset(kOFFSET_SIZE);
        make.left.equalTo(self.view.mas_left).offset(kOFFSET_SIZE);
        make.right.equalTo(self.view.mas_right).offset(-kOFFSET_SIZE);
        make.height.mas_equalTo(@(fieldHeight));
    }];
    
    [self.scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(bianhaoView);
        make.width.mas_equalTo(@(40));
    }];
    
    [self.bianhaoTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(bianhaoView);
        make.right.equalTo(self.scanButton.mas_left);
        make.height.mas_equalTo(@(fieldHeight));
    }];
    
    [self.copyaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.addressLabel.mas_bottom);
        make.right.equalTo(self.view.mas_right).offset(-kOFFSET_SIZE);
        make.width.mas_equalTo(@(70));
        make.height.mas_equalTo(@(28));
    }];
    
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastAttribute).with.offset(kOFFSET_SIZE*1.5f);
        make.left.equalTo(self.view.mas_left).offset(kOFFSET_SIZE);
        make.right.equalTo(self.view.mas_right).offset(-kOFFSET_SIZE);
        make.height.mas_equalTo(@(fieldHeight));
    }];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

- (void) setProductId:(NSString *)productId
{
    _productId = productId;
    
    self.product = [[ProductsManager instance] productById:productId];
}

- (void) setText:(NSString *)text
{
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
    attributedText.yy_font = [FontUtils buttonFont];
    attributedText.yy_color = COLOR_TEXT_DARK;
    attributedText.yy_lineSpacing = 5.0f;
    self.textLabel.attributedText = attributedText;
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

- (IBAction) reasonAction:(id)sender
{
    [self.view endEditing:YES];
    
    NSArray *options = @[@"质量问题", @"发错款号", @"发错颜色", @"发错尺码"];
    
    OptionsPopupView *optionsView = [[OptionsPopupView alloc] initWithTitle:@"选择退货原因" options:options selected:self.selectReason];
    optionsView.completeBolck = ^(int index, id content) {
        //
        self.selectReason = index;
        [self.reasonButton setNormalTitle:FORMAT(@"退货原因 ： %@", options[index])];
    };
    [optionsView show];
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
    
    if (self.type == 1 && ![self.product isQuehuo] && !self.selectSKU) {
        [SVProgressHUD showInfoWithStatus:@"请选择换货的尺码"];
        return;
    }
    
    [self requestOrderRefund];
}

- (IBAction) scanAction:(id)sender
{
    if ([CameraUtils isCameraNotDetermined]) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    // 用户授权
                    [self presentViewController:self.scanReader animated:YES completion:nil];
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
        [self presentViewController:self.scanReader animated:YES completion:nil];
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

#pragma mark - Request

- (void) requestOrderRefund
{
    [SVProgressHUD showWithStatus:nil];
    
    RequestOrderRefund *request = [RequestOrderRefund new];
    request.orderid = self.orderModel.orderid;
    request.cartproductid = self.cartProduct.cartproductid;
    request.wuliugongsi = self.wuliuTextField.text;
    request.wuliuhao = self.bianhaoTextField.text;
    request.reason = self.selectReason + 1;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         //
         if (self.type == 1 && self.selectSKU) {
             [self requestBuyProduct:self.selectSKU];
         }
         else {
             [SVProgressHUD showSuccessWithStatus:@"申请已提交"];
             GCD_DELAY(^{
                 [self leftButtonAction:nil];
                 if (self.finishedBlock) {
                     self.finishedBlock();
                 }
             }, 1.0f);
         }
     }
                                 onFailed:^(id content)
     {
         
     }];
}

- (void) requestBuyProduct:(ProductSKU *)sku
{
    [SVProgressHUD showWithStatus:nil];
    
    RequestProductBuy *request = [RequestProductBuy new];
    request.productId = self.cartProduct.productid;
    request.skuId = sku.Id;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [SVProgressHUD showSuccessWithStatus:@"原货品已退货,请到购物车结算更换的货品"];
         sku.shuliang -= 1;
         
         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ADD_TO_CART object:nil];
         
         GCD_DELAY(^{
             [self leftButtonAction:nil];
             if (self.finishedBlock) {
                 self.finishedBlock();
             }
         }, 1.0f);
     }
                                 onFailed:^(id content)
     {
         
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

#pragma mark - LWAsyncDisplayViewDelegate

// 点击LWTextStorage
- (void) lwAsyncDisplayView:(LWAsyncDisplayView *)asyncDisplayView
     didCilickedTextStorage:(LWTextStorage *)textStorage
                   linkdata:(id)data
{
    if ([data isKindOfClass:[ProductSKU class]]) {
        ProductSKU *sku = data;
        BOOL checked = sku.isChecked;
        if (!checked) {
            if (self.skuStorage) {
                self.skuStorage.textBackgroundColor = COLOR_BG_TEXT;
                self.skuStorage.textColor = COLOR_TEXT_LINK;
            }
            if (self.selectSKU) {
                self.selectSKU.isChecked = NO;
            }
            textStorage.textBackgroundColor = COLOR_SELECTED;
            textStorage.textColor = WHITE_COLOR;
//            self.okButton.enabled = YES;
            //
            self.skuStorage = textStorage;
            self.selectSKU = sku;
        }
        else {
            textStorage.textBackgroundColor = COLOR_BG_TEXT;
            textStorage.textColor = COLOR_TEXT_LINK;
//            self.okButton.enabled = NO;
            //
            self.skuStorage = nil;
            self.selectSKU = nil;
        }
        sku.isChecked = !checked;
    }
}

#pragma mark - ZBar Scan

- (void) scanDidFinished:(NSString *)scanResult
{
    INFOLOG(@"二维码数据 ： %@", scanResult);
    self.bianhaoTextField.text = scanResult;
}

- (void) scanDidCanceled
{
    INFOLOG(@"取消扫描");
}

- (SCZBarViewController *) scanReader
{
    if (!_scanReader) {
        _scanReader = [[SCZBarViewController alloc] init];
        _scanReader.barcodeEnabled = YES;
        _scanReader.scanDelegate = self;
    }
    return _scanReader;
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
        
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:@"订单已发货，请输入退货快递单号\n客服收到货品会退回货品金额到您的账户余额"];
        attributedText.yy_font = [FontUtils buttonFont];
        attributedText.yy_color = COLOR_TEXT_DARK;
        attributedText.yy_lineSpacing = 5.0f;
        _textLabel.attributedText = attributedText;
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
    }
    return _addressLabel;
}

- (FormTextField *) wuliuTextField
{
    if (!_wuliuTextField) {
        _wuliuTextField = [[FormTextField alloc] init];
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
        _bianhaoTextField = [[FormTextField alloc] init];
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

- (TextButton *) reasonButton
{
    if (_reasonButton) {
        return _reasonButton;
    }
    
    _reasonButton = [TextButton buttonWithType:UIButtonTypeCustom];
    _reasonButton.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    _reasonButton.clipsToBounds = YES;
    _reasonButton.layer.borderColor = COLOR_TEXT_NORMAL.CGColor;
    _reasonButton.layer.borderWidth = 0.5f;
    _reasonButton.layer.cornerRadius = 5.0f;
    
    _reasonButton.titleEdgeInsets = UIEdgeInsetsMake(0, kOFFSET_SIZE, 0, kOFFSET_SIZE);
    [_reasonButton setTitleFont:[FontUtils normalFont]];
    [_reasonButton setNormalColor:COLOR_SELECTED highlighted:COLOR_TEXT_NORMAL selected:nil];
    
    self.selectReason = 0;
    [_reasonButton setNormalTitle:@"退货原因 ： 质量问题"];
    
    [_reasonButton addTarget:self action:@selector(reasonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return _reasonButton;
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

- (LWLayout *) setupLayout
{
    LWLayout *layout = [[LWLayout alloc] init];
    // 发布的图片模型 imgsStorage
    CGFloat imageWidth = 50.0f;
    NSArray *images = [self.product imagesUrl];
    NSInteger imageCount = [images count];
    NSMutableArray* imageStorageArray = [[NSMutableArray alloc] initWithCapacity:imageCount];
    NSMutableArray* imagePositionArray = [[NSMutableArray alloc] initWithCapacity:imageCount];
    
    NSInteger row = 0;
    NSInteger column = 0;
    for (NSInteger i = 0; i < imageCount; i ++) {
        CGRect imageRect = CGRectMake(kOFFSET_SIZE + (column * (imageWidth + 5.0f)),
                                      kOFFSET_SIZE + (row * (imageWidth + 5.0f)),
                                      imageWidth,
                                      imageWidth);
        
        NSString* imagePositionString = NSStringFromCGRect(imageRect);
        [imagePositionArray addObject:imagePositionString];
        LWImageStorage* imageStorage = [[LWImageStorage alloc] initWithIdentifier:@"image"];
        imageStorage.clipsToBounds = YES;
        imageStorage.contentMode = UIViewContentModeScaleAspectFill;
        imageStorage.tag = i;
        imageStorage.frame = imageRect;
        imageStorage.backgroundColor = RGB(240, 240, 240, 1);
        NSString* URLString = [images objectAtIndex:i];
        imageStorage.contents = [NSURL URLWithString:URLString];
        [imageStorageArray addObject:imageStorage];
        column = column + 1;
        if (imageCount == 4 && column > 1) {
            column = 0;
            row = row + 1;
        }
        else if (column > 2) {
            column = 0;
            row = row + 1;
        }
    }
    
    // 正文内容模型 contentTextStorage
    LWTextStorage* contentTextStorage = [[LWTextStorage alloc] init];
    contentTextStorage.maxNumberOfLines = 15;//设置最大行数，超过则折叠
    contentTextStorage.text = self.product.desc;
    contentTextStorage.font = [FontUtils normalFont];
    contentTextStorage.textColor = COLOR_TEXT_DARK;
    CGFloat left = kOFFSET_SIZE*2 + 105;
    contentTextStorage.frame = CGRectMake(left,
                                          kOFFSET_SIZE,
                                          SCREEN_WIDTH - left - kOFFSET_SIZE ,
                                          CGFLOAT_MAX);
    
    LWTextStorage* infoTextStorage = [[LWTextStorage alloc] init];
    if ([self.product isQuehuo]) {
        infoTextStorage.text = @"无可换尺码 直接申请退货退款";
        infoTextStorage.textColor = RED_COLOR;
    }
    else {
        infoTextStorage.text = @"先选尺码 再按确定换货";
        infoTextStorage.textColor = COLOR_TEXT_LIGHT;
    }
    infoTextStorage.font = [FontUtils normalFont];
    infoTextStorage.frame = CGRectMake(kOFFSET_SIZE,
                                       kOFFSET_SIZE*2 + 105,
                                       SCREEN_WIDTH - kOFFSET_SIZE*2,
                                       CGFLOAT_MAX);
    
    NSArray *skus = self.product.skus;
    NSInteger skuCount = skus.count;
    NSMutableArray* skuStorageArray = [[NSMutableArray alloc] initWithCapacity:skuCount];
    CGFloat spacing = 12.0f;
    row = 0;
    CGFloat x = kOFFSET_SIZE;
    CGRect skuBgRect = CGRectMake(kOFFSET_SIZE,
                                  infoTextStorage.bottom + 10.0f,
                                  SCREEN_WIDTH-kOFFSET_SIZE*2,
                                  60);
    
    CGFloat skuWidth = 0.0f;
    for (NSInteger i = 0; i < skuCount; i ++) {
        if (x + skuWidth > skuBgRect.origin.x + skuBgRect.size.width) { //column > 2
            row = row + 1;
            x = kOFFSET_SIZE;
        }
        CGFloat y = skuBgRect.origin.y + (row * (24 + 10));
        CGRect skuRect = CGRectMake(x, y, skuBgRect.size.width, 24);
        ProductSKU *sku = skus[i];
        sku.isChecked = NO;
        NSString *skuText = FORMAT(@"　 %@ 　", sku.chima);
        
        LWTextStorage* skuStorage = [[LWTextStorage alloc] init];
        skuStorage.textBackgroundColor = COLOR_BG_TEXT_DISABLED;
        skuStorage.frame = skuRect;
        skuStorage.text = skuText;
        skuStorage.font = TNRFONTSIZE(15);
        skuStorage.textColor = COLOR_TEXT_DISABLED;
        skuStorage.linespacing = 10.0f;
        
        if (sku.shuliang > 0) {
            skuStorage.textBackgroundColor = COLOR_BG_TEXT;
            [skuStorage lw_addLinkWithData:sku
                                     range:NSMakeRange(0, skuText.length)
                                 linkColor:COLOR_TEXT_LINK
                            highLightColor:COLOR_BG_TEXT];
        }
        
        [skuStorageArray addObject:skuStorage];
        x = (skuStorage.right + spacing) + 18;
        skuWidth = skuStorage.width + spacing;
    }
    skuBgRect.size.height = (row + 2) * (24 + spacing);
    
    //    [layout addStorage:logoStorage];
    //    [layout addStorage:nameTextStorage];
    [layout addStorage:contentTextStorage];
    [layout addStorages:imageStorageArray];
    [layout addStorage:infoTextStorage];
    [layout addStorages:skuStorageArray];
    
    return layout;
}

- (LWAsyncDisplayView *) asyncDisplayView
{
    if (!_asyncDisplayView) {
        _asyncDisplayView = [[LWAsyncDisplayView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        _asyncDisplayView.backgroundColor = CLEAR_COLOR;
        _asyncDisplayView.displaysAsynchronously = NO;
        _asyncDisplayView.delegate = self;
        
        LWLayout *layout = [self setupLayout];
        _asyncDisplayView.layout = layout;
    }
    return _asyncDisplayView;
}

@end
