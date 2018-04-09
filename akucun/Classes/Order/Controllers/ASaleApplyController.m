//
//  ASaleApplyController.m
//  akucun
//
//  Created by Jarry on 2017/9/11.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ASaleApplyController.h"
#import "Gallop.h"
#import "RequestAftersaleApply.h"
#import "ASaleOptionsView.h"
#import "FormTextField.h"
#import "TextButton.h"
#import "ImagePickerUtility.h"
#import "IQKeyboardManager.h"

@interface ASaleApplyController () <UIScrollViewDelegate, UITextFieldDelegate, LWAsyncDisplayViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) ASaleOptionsView *problemView, *serviceView;
//@property (nonatomic, strong) NSArray *loufaOptions, *tuihuoOptions;

@property (nonatomic, strong) LWAsyncDisplayView* asyncDisplayView;

@property (nonatomic, strong) UIView *detailView;
@property (nonatomic, strong) FormTextField *detailTextField;
@property (nonatomic, strong) TextButton *cameraButton;
@property (nonatomic, strong) UILabel *imageLabel;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UIButton *submitButton;

@property (nonatomic, assign) NSInteger problemtype, expecttype;

@end

@implementation ASaleApplyController

- (instancetype) initWithProduct:(CartProduct *)cartProduct
{
    self = [self init];
    if (self) {
        self.cartProduct = cartProduct;
        [self initView];
    }
    return self;
}

- (void) didReceiveMemoryWarning
{
    ERRORLOG(@"--> !! didReceiveMemoryWarning ");
}

- (void) setupContent
{
    [super setupContent];
    self.view.backgroundColor = COLOR_BG_LIGHTGRAY;
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.title = @"申请售后服务";
    
    [self.rightButton setTitleFont:FA_ICONFONTSIZE(20)];
    [self.rightButton setNormalTitle:FA_ICONFONT_KEFU];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];

//    _loufaOptions = @[@"客服审核通过后将为您补发",
//                      @"客服审核通过后将退还货品金额"];
//    _tuihuoOptions = @[@"客服收到您退回的货品后将为您补发",
//                       @"客服收到您退回的货品后将退还货品金额"];
}

- (void) initView
{
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.asyncDisplayView];
    
    CGFloat offset = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;

    self.problemView.top = self.asyncDisplayView.bottom + offset;
    [self.scrollView addSubview:self.problemView];
    self.serviceView.top = self.problemView.bottom + offset;
    [self.scrollView addSubview:self.serviceView];
    
    self.detailView.top = self.serviceView.bottom + offset;
    [self.scrollView addSubview:self.detailView];
    
    self.tipLabel.top = self.detailView.bottom + offset;
    [self.scrollView addSubview:self.tipLabel];

    self.submitButton.top = self.tipLabel.bottom + offset;
    [self.scrollView addSubview:self.submitButton];
}

-(void) viewDidLayoutSubviews
{
    CGFloat offset = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
    CGFloat height = self.submitButton.bottom+offset+80;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, height);
}

#pragma mark - Actions

- (IBAction) leftButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction) rightButtonAction:(id)sender
{
//    ServiceViewController *controller = [ServiceViewController new];
//    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction) cameraAction:(id)sender
{
    [[ImagePickerUtility instance] showActionSheet:self
                                             title:@"上传图片"
                                           started:^
     {
     }
                                        completion:^(id content)
     {
         self.imageView.image = content;
         self.imageView.hidden = NO;
         self.imageLabel.hidden = YES;
         
     } canceled:^{
         
     }];
}

- (IBAction) submitAction:(id)sender
{
    [self sendRequest];
}

#pragma mark - Request

- (void) sendRequest
{
    if (self.problemtype <= 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择问题类型 ！"];
        return;
    }
    if (self.expecttype <= 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择服务类型 ！"];
        return;
    }
    
    if (self.detailTextField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入问题详细描述 ！"];
        return;
    }
    
    if (self.problemtype > 1 && self.imageView.hidden) {
        [SVProgressHUD showInfoWithStatus:@"请上传问题货品的图片 ！"];
        return;
    }
    
    [SVProgressHUD showWithStatus:nil];
    
    RequestAftersaleApply *request = [RequestAftersaleApply new];
    request.cartproductid = self.cartProduct.cartproductid;
    request.problemdesc = self.detailTextField.text;
    request.problemtype = self.problemtype;
    request.expecttype = self.expecttype;
    
    if (!self.imageView.hidden) {
        UIImage *image = self.imageView.image;
        NSData *imageData = UIImageJPEGRepresentation(image, 0.2);
        NSString *base64Data = [imageData base64EncodedStringWithOptions:0];
        request.pingzheng = @[base64Data];
    }
    
    [SCHttpServiceFace serviceWithPostRequest:request
                                    onSuccess:^(id content)
     {
         [SVProgressHUD showSuccessWithStatus:@"售后申请已提交 ！"];
         
         GCD_DELAY(^{
             [self dismissViewControllerAnimated:YES completion:nil];
             if (self.finishedBlock) {
                 self.finishedBlock((int)self.problemtype);
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
        _scrollView.bounces = YES;
//        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.view.height);
//        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (ASaleOptionsView *) problemView
{
    if (!_problemView) {
        NSArray *options = @[@"货品漏发",@"质量问题",@"发错款号",@"发错颜色",@"发错尺码"];
        _problemView = [[ASaleOptionsView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) options:options];
        _problemView.title = @"选择问题";
        _problemView.despTitle = @"请选择您的货品问题";

        NSArray *options1 = @[@"漏发退款"];
        NSArray *options2 = @[@"退货退款"];
        @weakify(self)
        _problemView.selectBlock = ^(int index) {
            @strongify(self)
            self.problemtype = index + 1;
            self.serviceView.options = (index==0) ? options1 : options2;
            [UIView animateWithDuration:.2f animations:^{
                self.serviceView.alpha = 1.0f;
            }];
            // 默认选中
            [self.serviceView selectItem:0];
        };
    }
    return _problemView;
}

- (ASaleOptionsView *) serviceView
{
    if (!_serviceView) {
        NSArray *options = @[@"漏发退款"];
        _serviceView = [[ASaleOptionsView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) options:options];
        _serviceView.title = @"选择服务";
        _serviceView.despTitle = @"请选择您需要的服务";

        @weakify(self)
        _serviceView.selectBlock = ^(int index) {
            @strongify(self)
            self.expecttype = 2;
            if (self.problemtype > 1) {
                self.expecttype = 4;
            }
            [UIView animateWithDuration:.2f animations:^{
                self.detailView.alpha = 1.0f;
                self.tipLabel.alpha = 1.0f;
                self.submitButton.alpha = 1.0f;
            }];
        };

        _serviceView.alpha = 0.0f;
    }
    return _serviceView;
}

- (UIView *) detailView
{
    if (!_detailView) {
        _detailView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        _detailView.backgroundColor = WHITE_COLOR;

        CGFloat offset = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;

        UILabel *titleLabel = [UILabel new];
        titleLabel.textColor = COLOR_TEXT_DARK;
        titleLabel.font = [FontUtils smallFont];
        titleLabel.text = @"问题描述";
        [titleLabel sizeToFit];
        titleLabel.left = kOFFSET_SIZE;
        titleLabel.top = offset;
        [_detailView addSubview:titleLabel];
        
        self.detailTextField.frame = CGRectMake(kOFFSET_SIZE, offset+25, SCREEN_WIDTH-kOFFSET_SIZE*2, 50);
        [_detailView addSubview:self.detailTextField];
        
        self.cameraButton.top = self.detailTextField.bottom + 10.0f;
        self.cameraButton.right = _detailView.width;
        [_detailView addSubview:self.cameraButton];
        
        _imageLabel = [UILabel new];
        _imageLabel.textColor = RED_COLOR;
        _imageLabel.font = [FontUtils smallFont];
        _imageLabel.text = @"请上传问题货品照片";
        [_imageLabel sizeToFit];
        _imageLabel.left = kOFFSET_SIZE;
        _imageLabel.centerY = self.cameraButton.centerY;
        [_detailView addSubview:_imageLabel];
        
        self.imageView.left = kOFFSET_SIZE + 5.0f;
        self.imageView.centerY = self.cameraButton.centerY;
        [_detailView addSubview:self.imageView];
        
        _detailView.height = offset*0.5f + self.cameraButton.bottom;
        _detailView.alpha = 0.0f;
    }
    return _detailView;
}

- (FormTextField *) detailTextField
{
    if (!_detailTextField) {
        _detailTextField = [[FormTextField alloc] init];
        _detailTextField.backgroundColor = RGBCOLOR(0xF9, 0xF9, 0xF9);
        _detailTextField.borderStyle = UITextBorderStyleNone;
        _detailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _detailTextField.clipsToBounds = YES;
        _detailTextField.layer.cornerRadius = 3.0f;
        _detailTextField.layer.borderWidth = kPIXEL_WIDTH;
        _detailTextField.layer.borderColor = COLOR_SEPERATOR_LINE.CGColor;
        
        _detailTextField.font = [FontUtils smallFont];
        _detailTextField.textColor = COLOR_TEXT_DARK;
        _detailTextField.placeholder = @"请您描述问题的详细信息";
        _detailTextField.returnKeyType = UIReturnKeyDone;
        
        _detailTextField.delegate = self;
    }
    return _detailTextField;
}

- (TextButton *) cameraButton
{
    if (!_cameraButton) {
        _cameraButton = [TextButton buttonWithType:UIButtonTypeCustom];
        _cameraButton.frame = CGRectMake(0, 0, 80, 40);
        _cameraButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kOFFSET_SIZE);
        
        [_cameraButton setTitleFont:FA_ICONFONTSIZE(20)];
        [_cameraButton setTitleAlignment:NSTextAlignmentRight];
        
        [_cameraButton setTitle:FA_ICONFONT_CAMERA forState:UIControlStateNormal];
        [_cameraButton setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
        [_cameraButton setTitleColor:COLOR_SELECTED forState:UIControlStateHighlighted];
        
        [_cameraButton addTarget:self action:@selector(cameraAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraButton;
}

- (UIImageView *) imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = CGRectMake(0, 0, 30, 30);
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.hidden = YES;
    }
    return _imageView;
}

- (UILabel *) tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.font = [FontUtils smallFont];
        _tipLabel.textColor = COLOR_TEXT_LIGHT;
        _tipLabel.numberOfLines = 0;
        _tipLabel.width = SCREEN_WIDTH - kOFFSET_SIZE*2;
        _tipLabel.text = @"提交服务单后，售后专员可能与您电话沟通，请保持手机畅通。";
        [_tipLabel sizeToFit];
        _tipLabel.left = kOFFSET_SIZE;
        
        _tipLabel.alpha = 0.0f;
    }
    return _tipLabel;
}

- (UIButton *) submitButton
{
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        CGFloat fieldHeight = isPad ? kFIELD_HEIGHT_PAD : kFIELD_HEIGHT;
        _submitButton.frame = CGRectMake(kOFFSET_SIZE, 0, SCREEN_WIDTH-kOFFSET_SIZE*2, fieldHeight);
        _submitButton.clipsToBounds = YES;
        _submitButton.layer.cornerRadius = 5;
        _submitButton.layer.borderWidth = 0.5f;
        _submitButton.layer.borderColor = RGBCOLOR(225, 225, 225).CGColor;
        
        _submitButton.titleLabel.font = BOLDSYSTEMFONT(16);
        
        [_submitButton setNormalColor:WHITE_COLOR highlighted:COLOR_TEXT_LIGHT selected:nil];
        [_submitButton setBackgroundColor:COLOR_SELECTED];
        [_submitButton setNormalTitle:@"提　交"];
        
        [_submitButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _submitButton.alpha = 0.0f;
    }
    return _submitButton;
}

- (LWAsyncDisplayView *) asyncDisplayView
{
    if (!_asyncDisplayView) {
        _asyncDisplayView = [[LWAsyncDisplayView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        _asyncDisplayView.backgroundColor = WHITE_COLOR;
        _asyncDisplayView.displaysAsynchronously = NO;
        _asyncDisplayView.delegate = self;
        
        LWLayout *layout = [self setupLayout];
        _asyncDisplayView.layout = layout;
        
        _asyncDisplayView.height = [layout suggestHeightWithBottomMargin:(isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE)];
    }
    return _asyncDisplayView;
}

- (LWLayout *) setupLayout
{
    LWLayout *layout = [[LWLayout alloc] init];
    //
    CGFloat imageWidth = 80.0f;
    LWImageStorage* imageStorage = [[LWImageStorage alloc] initWithIdentifier:nil];
    imageStorage.contentMode = UIViewContentModeScaleAspectFill;
    imageStorage.clipsToBounds = YES;
    imageStorage.frame = CGRectMake(kOFFSET_SIZE, kOFFSET_SIZE, imageWidth, imageWidth);
    imageStorage.backgroundColor = RGB(240, 240, 240, 1);
    imageStorage.contents = [NSURL URLWithString:[self.cartProduct imageUrl]];
    
    CGFloat offset = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
    // 正文内容模型 contentTextStorage
    LWTextStorage* contentTextStorage = [[LWTextStorage alloc] init];
    contentTextStorage.text = [self.cartProduct productDesc];
    contentTextStorage.font = [FontUtils smallFont];
    contentTextStorage.textColor = COLOR_TEXT_DARK;
    CGFloat left = kOFFSET_SIZE*2 + imageWidth;
    CGFloat contentWidth = SCREEN_WIDTH - left - kOFFSET_SIZE;
    contentTextStorage.frame = CGRectMake(left, offset, contentWidth, CGFLOAT_MAX);
    
    LWTextStorage* amountTextStorage = [[LWTextStorage alloc] init];
    amountTextStorage.text = [self.cartProduct jiesuanPrice];
    amountTextStorage.font = [FontUtils smallFont];
    amountTextStorage.textColor = COLOR_TEXT_DARK;
    amountTextStorage.textAlignment = NSTextAlignmentRight;
    amountTextStorage.frame = CGRectMake(contentTextStorage.left,
                                         contentTextStorage.bottom+10,
                                         contentWidth,
                                         CGFLOAT_MAX);
    
    LWTextStorage* skuTextStorage = [[LWTextStorage alloc] init];
    if (self.cartProduct.sku) {
        skuTextStorage.text = FORMAT(@"%@ x1%@", self.cartProduct.sku.chima, self.cartProduct.danwei);
    }
    else {
        skuTextStorage.text = FORMAT(@"%@ x1%@", self.cartProduct.chima, self.cartProduct.danwei);
    }
    skuTextStorage.font = [FontUtils smallFont];
    skuTextStorage.textColor = COLOR_TEXT_NORMAL;
    skuTextStorage.frame = CGRectMake(contentTextStorage.left,
                                      amountTextStorage.top,
                                      contentWidth-5-amountTextStorage.width,
                                      CGFLOAT_MAX);
    
    [layout addStorage:imageStorage];
    [layout addStorage:contentTextStorage];
    [layout addStorage:amountTextStorage];
    [layout addStorage:skuTextStorage];
    
    return layout;
}

#pragma mark - LWAsyncDisplayViewDelegate
// 额外的绘制
- (void) extraAsyncDisplayIncontext:(CGContextRef)context
                               size:(CGSize)size
                        isCancelled:(LWAsyncDisplayIsCanclledBlock)isCancelled
{
    if (!isCancelled()) {
        CGContextMoveToPoint(context, 0.0f, size.height-kPIXEL_WIDTH);
        CGContextAddLineToPoint(context, size.width, size.height-kPIXEL_WIDTH);
        CGContextSetLineWidth(context, kPIXEL_WIDTH);
        CGContextSetStrokeColorWithColor(context,COLOR_SEPERATOR_LINE.CGColor);
        CGContextStrokePath(context);
    }
}

@end
