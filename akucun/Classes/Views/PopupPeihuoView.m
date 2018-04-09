//
//  PopupPeihuoView.m
//  akucun
//
//  Created by Jarry on 2017/7/24.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "PopupPeihuoView.h"
#import "Gallop.h"

@interface PopupPeihuoView () <LWAsyncDisplayViewDelegate>

@property (nonatomic, strong) UIView      *titleView;
@property (nonatomic, strong) UILabel     *titleLabel;

@property (nonatomic, strong) UIButton    *cancelButton;
@property (nonatomic, strong) UIButton    *okButton;

@property (nonatomic,strong) LWAsyncDisplayView* asyncDisplayView;

@property (nonatomic, copy) NSString *title;

@end

@implementation PopupPeihuoView

- (void) actionCancel
{
    [self hide];
    
    if (self.skipBlock) {
        self.skipBlock();
    }
}

- (void) actionOK
{
    [self hide];
    
    if (self.finishBlock) {
        self.finishBlock();
    }
}

- (instancetype) initWithProduct:(CartProduct *)product
{
    self = [super init];
    
    if ( self )
    {
        [MMPopupWindow sharedWindow].touchWildToHide = YES;
        
        self.type = MMPopupTypeSheet;
        self.product = product;
        
        self.title = @"扫码拣货确认";
        if (product.scanstatu > 0) {
            self.title = @"该商品已拣货，请勿重复操作！";
        }
        
        self.backgroundColor = MMHexColor(0xCCCCCCFF);
        
        [self setupContent];
    }
    
    return self;
}

- (void) setupContent
{
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
    }];
    [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
    
    MASViewAttribute *lastAttribute = self.mas_top;
    if ( self.title.length > 0 )
    {
        self.titleView = [UIView new];
        [self addSubview:self.titleView];
        [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
        }];
        self.titleView.backgroundColor = WHITE_COLOR;
        
        CGFloat insets = kOFFSET_SIZE * 0.8f;
        self.titleLabel = [UILabel new];
        [self.titleView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.titleView).insets(UIEdgeInsetsMake(insets, insets, insets, insets));
        }];
        self.titleLabel.textColor = COLOR_APP_GREEN;
        self.titleLabel.font = BOLDSYSTEMFONT(15);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.text = self.title;
        
        lastAttribute = self.titleView.mas_bottom;
    }
    
    if (self.product.scanstatu > 0) {
        self.titleLabel.textColor = RED_COLOR;
        self.asyncDisplayView.backgroundColor = GREEN_COLOR;
    }
    
    [self addSubview:self.asyncDisplayView];
    CGFloat height = [self.asyncDisplayView.layout suggestHeightWithBottomMargin:kOFFSET_SIZE];
    [self.asyncDisplayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(lastAttribute).offset(1.0f);
        make.height.mas_equalTo(@(height));
    }];
    lastAttribute = self.asyncDisplayView.mas_bottom;
    
    CGFloat okHeight = isIPhoneX ? (44+kSafeAreaBottomHeight) : 60;
    self.cancelButton = [UIButton mm_buttonWithTarget:self action:@selector(actionCancel)];
    [self addSubview:self.cancelButton];
    self.cancelButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, kSafeAreaBottomHeight*0.5, 0);
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.mas_equalTo(@(SCREEN_WIDTH*0.5f));
        make.height.mas_equalTo(okHeight);
        make.top.equalTo(lastAttribute).offset(0.5f);
    }];
    self.cancelButton.titleLabel.font = [FontUtils buttonFont];
    [self.cancelButton setBackgroundImage:[UIImage mm_imageWithColor:WHITE_COLOR] forState:UIControlStateNormal];
    [self.cancelButton setBackgroundImage:[UIImage mm_imageWithColor:MMHexColor(0xEFEDE7FF)] forState:UIControlStateHighlighted];
    [self.cancelButton setTitle:@"忽 略" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:COLOR_SELECTED forState:UIControlStateHighlighted];
    lastAttribute = self.cancelButton.mas_bottom;
    
    self.okButton = [UIButton mm_buttonWithTarget:self action:@selector(actionOK)];
    [self addSubview:self.okButton];
    self.okButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, kSafeAreaBottomHeight*0.5, 0);
    [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.left.equalTo(self.cancelButton.mas_right).offset(0.5);
        make.top.width.height.equalTo(self.cancelButton);
    }];
    self.okButton.titleLabel.font = [FontUtils buttonFont];
    [self.okButton setBackgroundImage:[UIImage mm_imageWithColor:WHITE_COLOR] forState:UIControlStateNormal];
    [self.okButton setBackgroundImage:[UIImage mm_imageWithColor:WHITE_COLOR] forState:UIControlStateDisabled];
    [self.okButton setBackgroundImage:[UIImage mm_imageWithColor:MMHexColor(0xEFEDE7FF)] forState:UIControlStateHighlighted];
    [self.okButton setTitle:@"确 定" forState:UIControlStateNormal];
    [self.okButton setTitleColor:COLOR_SELECTED forState:UIControlStateNormal];
    [self.okButton setTitleColor:RED_COLOR forState:UIControlStateHighlighted];
    [self.okButton setTitleColor:COLOR_TEXT_LIGHT forState:UIControlStateDisabled];
    lastAttribute = self.okButton.mas_bottom;

    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastAttribute);
    }];
}

- (LWLayout *) setupLayout
{
    LWLayout *layout = [[LWLayout alloc] init];
    // 发布的图片模型 imgsStorage
    CGFloat imageWidth = 100.0f;
    LWImageStorage* imageStorage = [[LWImageStorage alloc] initWithIdentifier:@"image"];
    imageStorage.clipsToBounds = YES;
    imageStorage.contentMode = UIViewContentModeScaleAspectFill;
    imageStorage.frame = CGRectMake(kOFFSET_SIZE,
                                    kOFFSET_SIZE,
                                    imageWidth,
                                    imageWidth);
    imageStorage.backgroundColor = RGB(240, 240, 240, 1);
    NSString* URLString = [self.product imageUrl];
    imageStorage.contents = [NSURL URLWithString:URLString];
    
    CGFloat contentWidth = SCREEN_WIDTH - imageWidth - kOFFSET_SIZE*3;

    // 正文内容模型 contentTextStorage
    LWTextStorage* contentTextStorage = [[LWTextStorage alloc] init];
    contentTextStorage.maxNumberOfLines = 15;//设置最大行数，超过则折叠
    contentTextStorage.text = [self.product productDesc];
    contentTextStorage.font = [FontUtils normalFont];
    contentTextStorage.textColor = COLOR_TEXT_DARK;
    CGFloat left = kOFFSET_SIZE*2 + imageWidth;
    contentTextStorage.frame = CGRectMake(left,
                                          kOFFSET_SIZE,
                                          contentWidth,
                                          CGFLOAT_MAX);
/*
    LWTextStorage* amountTextStorage = [[LWTextStorage alloc] init];
    amountTextStorage.text = [self.product jiesuanPrice];
    amountTextStorage.font = [FontUtils smallFont];
    amountTextStorage.textColor = COLOR_SELECTED;
    amountTextStorage.textAlignment = NSTextAlignmentRight;
    amountTextStorage.frame = CGRectMake(contentTextStorage.left,
                                         contentTextStorage.bottom + 10,
                                         contentWidth,
                                         CGFLOAT_MAX);
*/
    LWTextStorage* skuTextStorage = [[LWTextStorage alloc] init];
    if (self.product.sku) {
        skuTextStorage.text = FORMAT(@"%@ x1%@", self.product.sku.chima, self.product.danwei);
    }
    else {
        skuTextStorage.text = FORMAT(@"%@ x1%@", self.product.chima, self.product.danwei);
    }
    skuTextStorage.font = [FontUtils smallFont];
    skuTextStorage.textColor = COLOR_SELECTED;
    skuTextStorage.frame = CGRectMake(contentTextStorage.left,
                                      contentTextStorage.bottom + 10,
                                      contentWidth,
                                      CGFLOAT_MAX);
    
    CGFloat remarkY = MAX(imageWidth+kOFFSET_SIZE*1.5f, skuTextStorage.bottom + 10);
    LWTextStorage* barcodeTextStorage = [[LWTextStorage alloc] init];
    barcodeTextStorage.text = FORMAT(@"条码：%@", self.product.sku.barcode);
    barcodeTextStorage.font = [FontUtils smallFont];
    barcodeTextStorage.textColor = COLOR_SELECTED;
    barcodeTextStorage.frame = CGRectMake(kOFFSET_SIZE,
                                         remarkY,
                                         SCREEN_WIDTH - kOFFSET_SIZE*2,
                                         CGFLOAT_MAX);

    LWTextStorage* remarkTextStorage = [[LWTextStorage alloc] init];
    remarkTextStorage.text = FORMAT(@"备注：%@", self.product.remark);
    remarkTextStorage.font = [FontUtils smallFont];
    remarkTextStorage.textColor = COLOR_SELECTED;
    remarkTextStorage.frame = CGRectMake(kOFFSET_SIZE,
                                         barcodeTextStorage.bottom + 10,
                                         SCREEN_WIDTH - kOFFSET_SIZE*2,
                                         CGFLOAT_MAX);

    [layout addStorage:imageStorage];
    [layout addStorage:contentTextStorage];
    [layout addStorage:skuTextStorage];
    [layout addStorage:barcodeTextStorage];
    [layout addStorage:remarkTextStorage];

    return layout;
}

#pragma mark - Getter

- (LWAsyncDisplayView *) asyncDisplayView
{
    if (!_asyncDisplayView) {
        _asyncDisplayView = [[LWAsyncDisplayView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        _asyncDisplayView.displaysAsynchronously = NO;
        _asyncDisplayView.delegate = self;
        
        LWLayout *layout = [self setupLayout];
        _asyncDisplayView.layout = layout;
    }
    return _asyncDisplayView;
}

@end
