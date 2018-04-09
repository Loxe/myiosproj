//
//  PopupProductView.m
//  akucun
//
//  Created by Jarry on 2017/6/16.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "PopupProductView.h"
#import "Gallop.h"

@interface PopupProductView () <LWAsyncDisplayViewDelegate>

@property (nonatomic, strong) UIView      *titleView;
@property (nonatomic, strong) UILabel     *titleLabel;

@property (nonatomic, strong) UIButton    *cancelButton;
@property (nonatomic, strong) UIButton    *okButton;

@property (nonatomic,strong) LWAsyncDisplayView* asyncDisplayView;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) LWTextStorage* skuStorage;
@property (nonatomic, strong) ProductSKU* selectSKU;

@end

@implementation PopupProductView

- (void) actionCancel
{
    [self hide];
}

- (void) actionOK
{
    [self hide];
    
    if (self.finishBlock) {
        self.finishBlock(self.selectSKU);
    }
}

- (instancetype) initWithProduct:(ProductModel*)product title:(NSString *)title isChange:(BOOL)change
{
    self = [super init];
    
    if ( self )
    {
        [MMPopupWindow sharedWindow].touchWildToHide = YES;
        
        self.type = MMPopupTypeSheet;
        self.product = product;
        self.title = title;
        self.isChange = change;

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
        self.titleLabel.textColor = COLOR_TEXT_NORMAL;
        self.titleLabel.font = SYSTEMFONT(15);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.text = self.title;
        
        lastAttribute = self.titleView.mas_bottom;
    }
    
    [self addSubview:self.asyncDisplayView];
    CGFloat height = [self.asyncDisplayView.layout suggestHeightWithBottomMargin:kOFFSET_SIZE*2];
    [self.asyncDisplayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(lastAttribute).offset(1.0f);
        make.height.mas_equalTo(@(height));
    }];
    lastAttribute = self.asyncDisplayView.mas_bottom;
    
    self.okButton = [UIButton mm_buttonWithTarget:self action:@selector(actionOK)];
    [self addSubview:self.okButton];
    [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(44);
        make.top.equalTo(lastAttribute).offset(8.0f);
    }];
    self.okButton.titleLabel.font = [FontUtils buttonFont];
    [self.okButton setBackgroundImage:[UIImage mm_imageWithColor:WHITE_COLOR] forState:UIControlStateNormal];
    [self.okButton setBackgroundImage:[UIImage mm_imageWithColor:WHITE_COLOR] forState:UIControlStateDisabled];
    [self.okButton setBackgroundImage:[UIImage mm_imageWithColor:MMHexColor(0xEFEDE7FF)] forState:UIControlStateHighlighted];
    [self.okButton setTitle:@"确 定" forState:UIControlStateNormal];
    [self.okButton setTitleColor:COLOR_SELECTED forState:UIControlStateNormal];
    [self.okButton setTitleColor:RED_COLOR forState:UIControlStateHighlighted];
    [self.okButton setTitleColor:COLOR_TEXT_LIGHT forState:UIControlStateDisabled];
    self.okButton.enabled = NO;
    lastAttribute = self.okButton.mas_bottom;
    
    self.cancelButton = [UIButton mm_buttonWithTarget:self action:@selector(actionCancel)];
    [self addSubview:self.cancelButton];
    self.cancelButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, kSafeAreaBottomHeight*0.5, 0);
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(44+kSafeAreaBottomHeight);
        make.top.equalTo(lastAttribute).offset(0.5f);
    }];
    self.cancelButton.titleLabel.font = [FontUtils buttonFont];
    [self.cancelButton setBackgroundImage:[UIImage mm_imageWithColor:WHITE_COLOR] forState:UIControlStateNormal];
    [self.cancelButton setBackgroundImage:[UIImage mm_imageWithColor:MMHexColor(0xEFEDE7FF)] forState:UIControlStateHighlighted];
    [self.cancelButton setTitle:@"取 消" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:COLOR_SELECTED forState:UIControlStateHighlighted];
    lastAttribute = self.cancelButton.mas_bottom;
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastAttribute);
    }];
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
    contentTextStorage.maxNumberOfLines = 6;//设置最大行数，超过则折叠
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
        infoTextStorage.text = self.isChange ? @"无可换尺码" : @"商品缺货";
        infoTextStorage.textColor = RED_COLOR;
    }
    else {
        infoTextStorage.text = self.isChange ? @"先选尺码 再按确定换尺码" : @"先选尺码 再按确定下单，请到购物车结算";
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

//点击LWTextStorage
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
            self.okButton.enabled = YES;
            //
            self.skuStorage = textStorage;
            self.selectSKU = sku;
        }
        else {
            textStorage.textBackgroundColor = COLOR_BG_TEXT;
            textStorage.textColor = COLOR_TEXT_LINK;
            self.okButton.enabled = NO;
            //
            self.skuStorage = nil;
            self.selectSKU = nil;
        }
        sku.isChecked = !checked;
    }
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
