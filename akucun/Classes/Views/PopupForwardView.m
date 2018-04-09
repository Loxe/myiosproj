//
//  PopupForwardView.m
//  akucun
//
//  Created by Jarry on 2017/5/14.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "PopupForwardView.h"
#import "Gallop.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ProductsManager.h"
#import "LiveManager.h"
#import "IconButton.h"
#import "MMAlertView.h"
#import "PopupLivesView.h"
#import "CoverLayerView.h"
#import "RequestGetSKU.h"
#import "UserManager.h"

@interface PopupForwardView ()

@property (nonatomic, strong) UIView      *titleView;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UIButton    *prevButton;
@property (nonatomic, strong) UIButton    *nextButton;
@property (nonatomic, strong) UIButton    *okButton;
@property (nonatomic, strong) UIButton    *gotoButton;
@property (nonatomic, strong) UIButton    *pinpaiButton;

@property (nonatomic, strong) IconButton  *iconButton, *button1, *button2;

@property (nonatomic, strong) LWAsyncDisplayView* asyncDisplayView;

@property (nonatomic, strong) CoverLayerView* coverLayer;

//@property (nonatomic, strong) UIImageView *productImage;
//@property (nonatomic, strong) NSMutableArray *productImages;
//@property (nonatomic, strong) UILabel *productLabel;

@property (nonatomic, assign) NSInteger index;

@end

@implementation PopupForwardView

- (void) showNext
{
    [self actionNext];
    [self show];
}

- (instancetype) initWithProduct:(ProductModel*)product title:(NSString *)title
{
    self = [super init];
    
    if ( self )
    {
//        [MMPopupWindow sharedWindow].windowLevel = 0;
        [MMPopupWindow sharedWindow].touchWildToHide = YES;
        
        self.type = MMPopupTypeSheet;
        self.product = product;
        
        self.backgroundColor = MMHexColor(0xCCCCCCFF);
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
        }];
        [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
        
        MASViewAttribute *lastAttribute = self.mas_top;
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
        self.titleLabel.font = [FontUtils buttonFont];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.text = title;

        lastAttribute = self.titleView.mas_bottom;
        
        UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        settingButton.frame = CGRectMake(0, 0, 20, 44);
        [settingButton.titleLabel setFont:FA_ICONFONTSIZE(20)];
        [settingButton setTitle:FA_ICONFONT_SETTING forState:UIControlStateNormal];
        [settingButton setTitleColor:[COLOR_TITLE colorWithAlphaComponent:0.6f] forState:UIControlStateNormal];
        [settingButton setTitleColor:COLOR_SELECTED forState:UIControlStateHighlighted];
        [settingButton addTarget:self action:@selector(settingAction) forControlEvents:UIControlEventTouchUpInside];
        [self.titleView addSubview:settingButton];
        [settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(self.titleView);
            make.width.equalTo(@(50));
        }];
        
        CGFloat height = [self.asyncDisplayView.layout suggestHeightWithBottomMargin:0];
        
        UIView *contentView = [UIView new];
        contentView.backgroundColor = WHITE_COLOR;
        [self addSubview:contentView];
        [contentView addSubview:self.asyncDisplayView];

        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(lastAttribute).offset(1.0f);
            make.bottom.equalTo(self.asyncDisplayView.mas_bottom).offset(100);
        }];
        [self.asyncDisplayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(lastAttribute).offset(1.0f);
            make.height.mas_equalTo(@(height));
        }];
        lastAttribute = contentView.mas_bottom;

        self.button1 = [[IconButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        [self.button1 setTitleFont:SYSTEMFONT(14)];
        [self.button1 setTitle:@"朋友圈（四张图）" icon:FA_ICONFONT_UNCHECK1];
        [self.button1 setTextColor:RED_COLOR];
        [self.button1 setIconColor:RED_COLOR];
        [self.button1 addTarget:self action:@selector(button1Action:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:self.button1];
        [self.button1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.asyncDisplayView.mas_bottom);
            make.left.equalTo(self).offset(kOFFSET_SIZE);
            make.width.equalTo(@(300));
            make.height.equalTo(@(30));
        }];
        
        self.iconButton = [[IconButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        [self.iconButton setTitleFont:SYSTEMFONT(14)];
        [self.iconButton setTitle:@"微信群（合并一张图）" icon:FA_ICONFONT_UNCHECK1];
        [self.iconButton setTextColor:RED_COLOR];
        [self.iconButton setIconColor:RED_COLOR];
        [self.iconButton addTarget:self action:@selector(iconButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:self.iconButton];
        [self.iconButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.button1.mas_bottom);
            make.left.equalTo(self).offset(kOFFSET_SIZE);
            make.width.equalTo(@(300));
            make.height.equalTo(@(30));
        }];
        
        self.button2 = [[IconButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        [self.button2 setTitleFont:SYSTEMFONT(14)];
        [self.button2 setTitle:@"微信群（五张图）" icon:FA_ICONFONT_UNCHECK1];
        [self.button2 setTextColor:RED_COLOR];
        [self.button2 setIconColor:RED_COLOR];
        [self.button2 addTarget:self action:@selector(button2Action:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:self.button2];
        [self.button2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconButton.mas_bottom);
            make.left.equalTo(self).offset(kOFFSET_SIZE);
            make.width.equalTo(@(300));
            make.height.equalTo(@(30));
        }];
        
        UserConfig *config = [UserManager instance].userConfig;
        BOOL checked1 = (config.imageOption==ShareOptionMergedPicture);
        [self setButton:self.iconButton checked:checked1];
        BOOL checked2 = (config.imageOption==ShareOptionOnlyPictures);
        [self setButton:self.button1 checked:checked2];
        BOOL checked3 = (config.imageOption==ShareOptionPicturesAndText);
        [self setButton:self.button2 checked:checked3];

        self.pinpaiButton = [UIButton mm_buttonWithTarget:self action:@selector(actionPinpai)];
        [self addSubview:self.pinpaiButton];
        [self.pinpaiButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.mas_equalTo(44);
            make.top.equalTo(lastAttribute).offset(8);
        }];
        self.pinpaiButton.titleLabel.font = [FontUtils buttonFont];
        [self.pinpaiButton setBackgroundImage:[UIImage mm_imageWithColor:WHITE_COLOR] forState:UIControlStateNormal];
        [self.pinpaiButton setBackgroundImage:[UIImage mm_imageWithColor:MMHexColor(0xEFEDE7FF)] forState:UIControlStateHighlighted];
        LiveInfo *pinpai = [ProductsManager getForwardLive];
        [self.pinpaiButton setTitle:FORMAT(@"选择品牌：%@", pinpai.pinpaiming) forState:UIControlStateNormal];
        [self.pinpaiButton setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
        [self.pinpaiButton setTitleColor:COLOR_SELECTED forState:UIControlStateHighlighted];
        lastAttribute = self.pinpaiButton.mas_bottom;

        self.gotoButton = [UIButton mm_buttonWithTarget:self action:@selector(actionGoto)];
        [self addSubview:self.gotoButton];
        [self.gotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.mas_equalTo(44);
            make.top.equalTo(lastAttribute).offset(0.5f);
        }];
        self.gotoButton.titleLabel.font = [FontUtils buttonFont];
        [self.gotoButton setBackgroundImage:[UIImage mm_imageWithColor:WHITE_COLOR] forState:UIControlStateNormal];
        [self.gotoButton setBackgroundImage:[UIImage mm_imageWithColor:MMHexColor(0xEFEDE7FF)] forState:UIControlStateHighlighted];
        NSInteger xuhao = product ? product.xuhao : 0;
        [self.gotoButton setTitle:FORMAT(@"跳到第 %03ld 号", (long)(xuhao)) forState:UIControlStateNormal];
        [self.gotoButton setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
        [self.gotoButton setTitleColor:COLOR_SELECTED forState:UIControlStateHighlighted];
        lastAttribute = self.gotoButton.mas_bottom;

        UIButton *prevButton = [UIButton mm_buttonWithTarget:self action:@selector(actionPrev)];
        [self addSubview:prevButton];
        self.prevButton = prevButton;
        [prevButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.mas_equalTo(44);
            make.top.equalTo(lastAttribute).offset(0.5f);
        }];
        prevButton.titleLabel.font = [FontUtils buttonFont];
        [prevButton setBackgroundImage:[UIImage mm_imageWithColor:WHITE_COLOR] forState:UIControlStateNormal];
        [prevButton setBackgroundImage:[UIImage mm_imageWithColor:MMHexColor(0xEFEDE7FF)] forState:UIControlStateHighlighted];
        [prevButton setTitle:@"上一条" forState:UIControlStateNormal];
        [prevButton setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
        [prevButton setTitleColor:COLOR_SELECTED forState:UIControlStateHighlighted];
        [prevButton setTitleColor:COLOR_TEXT_LIGHT forState:UIControlStateDisabled];
        lastAttribute = prevButton.mas_bottom;

        UIButton *nextButton = [UIButton mm_buttonWithTarget:self action:@selector(actionNext)];
        [self addSubview:nextButton];
        self.nextButton = nextButton;
        [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.mas_equalTo(44);
            make.top.equalTo(lastAttribute).offset(0.5f);
        }];
        nextButton.titleLabel.font = [FontUtils buttonFont];
        [nextButton setBackgroundImage:[UIImage mm_imageWithColor:WHITE_COLOR] forState:UIControlStateNormal];
        [nextButton setBackgroundImage:[UIImage mm_imageWithColor:MMHexColor(0xEFEDE7FF)] forState:UIControlStateHighlighted];
        [nextButton setTitle:@"下一条" forState:UIControlStateNormal];
        [nextButton setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
        [nextButton setTitleColor:COLOR_SELECTED forState:UIControlStateHighlighted];
        [nextButton setTitleColor:COLOR_TEXT_LIGHT forState:UIControlStateDisabled];

        self.okButton = [UIButton mm_buttonWithTarget:self action:@selector(actionOK)];
        self.okButton.enabled = YES;//product ? ![product isQuehuo] : NO;
        [self addSubview:self.okButton];
        self.okButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, kSafeAreaBottomHeight*0.5, 0);
        CGFloat okHeight = isIPhoneX ? (44+kSafeAreaBottomHeight) : 60;
        [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.mas_equalTo(okHeight);
            make.top.equalTo(nextButton.mas_bottom).offset(0.5f);
        }];
        self.okButton.titleLabel.font = [FontUtils buttonFont];
        [self.okButton setBackgroundImage:[UIImage mm_imageWithColor:WHITE_COLOR] forState:UIControlStateNormal];
        [self.okButton setBackgroundImage:[UIImage mm_imageWithColor:MMHexColor(0xEFEDE7FF)] forState:UIControlStateHighlighted];
        [self.okButton setTitle:@"转 发" forState:UIControlStateNormal];
        [self.okButton setTitleColor:COLOR_SELECTED forState:UIControlStateNormal];
        [self.okButton setTitleColor:RED_COLOR forState:UIControlStateHighlighted];
        [self.okButton setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateDisabled];
        
        if (config.priceOption > 0) {
            NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc] initWithString:FORMAT(@"转 发  (+%ld元)", (long)config.priceOption)];
            NSDictionary * attributes = @{ NSFontAttributeName:BOLDSYSTEMFONT(12),NSForegroundColorAttributeName:RED_COLOR };
            [attributeStr setAttributes:attributes range:NSMakeRange(0, attributeStr.length)];
            [attributeStr setAttributes:@{ NSFontAttributeName:[FontUtils buttonFont],NSForegroundColorAttributeName:RED_COLOR } range:NSMakeRange(0, 3)];
            [self.okButton setAttributedTitle:attributeStr forState:UIControlStateNormal];
        }

        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.okButton.mas_bottom).offset(0);
        }];
        
        [self.asyncDisplayView addSubview:self.coverLayer];
        
        [self updateLayout:product];
    }
    
    return self;
}

- (void) iconButtonAction:(IconButton*)btn
{
    BOOL checked = btn.selected;
    if (checked) {
        return;
    }
    btn.selected = !checked;
    [btn setIcon:checked ? FA_ICONFONT_UNCHECK1 : FA_ICONFONT_CHECKED1];
    if (!checked) {
        self.button1.selected = NO;
        [self.button1 setIcon:FA_ICONFONT_UNCHECK1];
        self.button2.selected = NO;
        [self.button2 setIcon:FA_ICONFONT_UNCHECK1];
    }
}

- (void) settingAction
{
    [self hide];

    if (self.settingBlock) {
        self.settingBlock();
    }
}

- (void) button1Action:(IconButton*)btn
{
    BOOL checked = btn.selected;
    if (checked) {
        return;
    }
    btn.selected = !checked;
    [btn setIcon:checked ? FA_ICONFONT_UNCHECK1 : FA_ICONFONT_CHECKED1];
    if (!checked) {
        self.iconButton.selected = NO;
        [self.iconButton setIcon:FA_ICONFONT_UNCHECK1];
        self.button2.selected = NO;
        [self.button2 setIcon:FA_ICONFONT_UNCHECK1];
    }
}

- (void) button2Action:(IconButton*)btn
{
    BOOL checked = btn.selected;
    if (checked) {
        return;
    }
    btn.selected = !checked;
    [btn setIcon:checked ? FA_ICONFONT_UNCHECK1 : FA_ICONFONT_CHECKED1];
    if (!checked) {
        self.iconButton.selected = NO;
        [self.iconButton setIcon:FA_ICONFONT_UNCHECK1];
        self.button1.selected = NO;
        [self.button1 setIcon:FA_ICONFONT_UNCHECK1];
    }
}

- (void) setButton:(IconButton *)btn checked:(BOOL)checked
{
    btn.selected = checked;
    [btn setIcon:checked ? FA_ICONFONT_CHECKED1 : FA_ICONFONT_UNCHECK1];
}

// 跳过
- (void) actionPrev
{
    NSInteger xuhao = [ProductsManager getForwardIndex];
    NSInteger nextIndex = [ProductsManager updatePrevValidIndex:xuhao];
    if (nextIndex == xuhao) {
        [SVProgressHUD showInfoWithStatus:@"已经是最后一条了"];
//        [self hide];
        return;
    }
//    [ProductsManager updateForwardIndex:(xuhao+1)];
    ProductModel *product = [ProductsManager getForwardProduct:nextIndex];
    [self updateLayout:product];
    [self.gotoButton setTitle:FORMAT(@"跳到第 %03ld 号", (long)(product.xuhao)) forState:UIControlStateNormal];
}

- (void) actionNext
{
    NSInteger xuhao = [ProductsManager getForwardIndex];
    NSInteger nextIndex = [ProductsManager updateNextValidIndex:xuhao];
    if (nextIndex == xuhao) {
//        [SVProgressHUD showInfoWithStatus:@"已经是最后一条了"];
//        [self hide];
        
        NSInteger pinpaiIndex = [ProductsManager instance].forwardPinpai;
        LiveInfo *liveInfo = [LiveManager liveInfoAtIndex:(pinpaiIndex+1)];
        if (!liveInfo) {
            [SVProgressHUD showInfoWithStatus:@"该活动已转发完成"];
            return;
        }
        
        [SVProgressHUD showInfoWithStatus:FORMAT(@"该活动已转发完成，开始转发下一场活动\n【%@】",liveInfo.pinpaiming)];
        [self.pinpaiButton setTitle:FORMAT(@"选择品牌：%@", liveInfo.pinpaiming) forState:UIControlStateNormal];
        
        [ProductsManager instance].forwardPinpai = pinpaiIndex+1;
        [ProductsManager updateForwardIndex:1];
        
        if ([LiveManager periodTime] != 0) {
            [ProductsManager syncProductsWith:liveInfo.liveid
                                     finished:^(id content)
             {
                 ProductModel *product = [ProductsManager getForwardProduct:0];
                 [self updateLayout:product];
                 [self.gotoButton setTitle:FORMAT(@"跳到第 %03ld 号", (long)(product.xuhao)) forState:UIControlStateNormal];
             } failed:nil];
        }
        else {
            ProductModel *product = [ProductsManager getForwardProduct:0];
            [self updateLayout:product];
            [self.gotoButton setTitle:FORMAT(@"跳到第 %03ld 号", (long)(product.xuhao)) forState:UIControlStateNormal];
        }
        return;
    }
    //    [ProductsManager updateForwardIndex:(xuhao+1)];
    ProductModel *product = [ProductsManager getForwardProduct:nextIndex];
    [self updateLayout:product];
    [self.gotoButton setTitle:FORMAT(@"跳到第 %03ld 号", (long)(product.xuhao)) forState:UIControlStateNormal];
}

- (void) actionOK
{
    [self hide];
 
    if (!self.product) {
        [SVProgressHUD showInfoWithStatus:@"找不到活动商品"];
        return;
    }
    
    if ([self.product shouldUpdateSKU]) {
        [self requestGetSKU:self.product finished:^(id content) {
            if (self.finishBlock) {
                self.finishBlock(content, self.iconButton.selected, self.button2.selected);
            }
        }];
    }
    else {
        if (self.finishBlock) {
            self.finishBlock(self.product, self.iconButton.selected, self.button2.selected);
        }
    }
}

- (void) actionGoto
{
    MMAlertView *alertView =
    [[MMAlertView alloc] initWithInputTitle:@"输入商品序号"
                                     detail:@" "
                                placeholder:@"请输入商品序号后3位"
                                   keyboard:UIKeyboardTypeNumberPad
                                    handler:^(NSString *text)
     
    {
        if (text.length > 3) {
            [SVProgressHUD showInfoWithStatus:@"请输入商品序号后3位"];
            return;
        }
        NSInteger count = [text integerValue];
        if (count == 0) {
            [SVProgressHUD showInfoWithStatus:@"请输入正确的序号"];
            return;
        }
        
        ProductModel *product = [ProductsManager getForwardProduct:count];
        if (!product) {
            [SVProgressHUD showInfoWithStatus:@"请输入正确的序号"];
            return;
        }
        
        [self updateLayout:product];
        [self.gotoButton setTitle:FORMAT(@"跳到第 %03ld 号", (long)product.xuhao) forState:UIControlStateNormal];
        [ProductsManager updateForwardIndex:(product.xuhao)];
//        self.index = product.xuhao + 1;
        
//        [self show];
    }];
    
//    [self hide];
    [alertView show];
}

- (void) actionPinpai
{
    NSInteger index = [ProductsManager instance].forwardPinpai;
    PopupLivesView *optionsView = [[PopupLivesView alloc] initWithTitle:@"选择品牌" lives:[LiveManager instance].liveDatas selected:index];
//    @weakify(self)
    optionsView.completeBolck = ^(int index, id content) {
//        @strongify(self)
        LiveInfo *liveInfo = [LiveManager liveInfoAtIndex:index];
        if (liveInfo.begintimestamp > [NSDate timeIntervalValue]) {
            // 品牌活动未开始
            [SVProgressHUD showInfoWithStatus:@"该品牌活动暂未开始"];
            return;
        }
        
        [ProductsManager instance].forwardPinpai = index;
        [self.pinpaiButton setTitle:FORMAT(@"选择品牌：%@", liveInfo.pinpaiming) forState:UIControlStateNormal];
        
        if ([LiveManager periodTime] != 0) {
            [SVProgressHUD showWithStatus:nil];
            [ProductsManager syncProductsWith:liveInfo.liveid
                                     finished:^(id content)
             {
                 ProductModel *product = [ProductsManager getForwardProduct:0];
                 [self updateLayout:product];
                 [self.gotoButton setTitle:FORMAT(@"跳到第 %03ld 号", (long)(product.xuhao)) forState:UIControlStateNormal];
                 [SVProgressHUD dismiss];
//                 [self show];
             } failed:nil];
        }
        else {
            ProductModel *product = [ProductsManager getForwardProduct:0];
            [self updateLayout:product];
            [self.gotoButton setTitle:FORMAT(@"跳到第 %03ld 号", (long)(product.xuhao)) forState:UIControlStateNormal];
//            [self show];
        }
    };
    
//    [self hide];
    [optionsView show];
}

- (LWLayout *) setupLayout
{
    LWLayout *layout = [[LWLayout alloc] init];
    // 发布的图片模型 imgsStorage
    CGFloat imageWidth = 40.0f;
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
    contentTextStorage.maxNumberOfLines = 5;//设置最大行数，超过则折叠
    contentTextStorage.lineBreakMode = NSLineBreakByCharWrapping;
    contentTextStorage.text = self.product.desc;
    contentTextStorage.font = SYSTEMFONT(14); //[FontUtils smallFont];
    contentTextStorage.textColor = COLOR_TEXT_DARK;
    CGFloat left = kOFFSET_SIZE*1.5f + 85;
    contentTextStorage.frame = CGRectMake(left,
                                          kOFFSET_SIZE,
                                          SCREEN_WIDTH - left - kOFFSET_SIZE ,
                                          CGFLOAT_MAX);
    
    LWImageStorage* lastImageStorage = (LWImageStorage *)[imageStorageArray lastObject];
    CGFloat infoTop = lastImageStorage.bottom + kOFFSET_SIZE*0.6;
    if (infoTop < contentTextStorage.bottom + kOFFSET_SIZE*0.6) {
        infoTop = contentTextStorage.bottom + kOFFSET_SIZE*0.6;
    }
    
    LWTextStorage* infoTextStorage = [[LWTextStorage alloc] init];
    infoTextStorage.text = @"商品描述已复制 可以长按“粘贴”";
    infoTextStorage.textColor = COLOR_TEXT_LIGHT;
//    if ([self.product isQuehuo]) {
//        infoTextStorage.text = @"商品缺货 按跳过继续转发";
//        infoTextStorage.textColor = RED_COLOR;
//    }
    infoTextStorage.font = SYSTEMFONT(13);
    infoTextStorage.frame = CGRectMake(kOFFSET_SIZE,
                                       infoTop,
                                       SCREEN_WIDTH - kOFFSET_SIZE*2,
                                       CGFLOAT_MAX);

    [layout addStorage:contentTextStorage];
    [layout addStorages:imageStorageArray];
    [layout addStorage:infoTextStorage];
    
    return layout;
}

- (void) showCoverLayer
{
    if (self.product.isQuehuo) {
        self.coverLayer.hidden = NO;
    }
    else {
        self.coverLayer.hidden = YES;
    }
}

- (void) requestGetSKU:(ProductModel *)product finished:(idBlock)finished
{
    RequestGetSKU *request = [RequestGetSKU new];
    request.productId = product.Id;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         ResponseSKUList *response = content;
         if (finished) {
             finished(response.product);
         }
     }
                                 onFailed:nil];
}

#pragma mark - Getter

- (LWAsyncDisplayView *) asyncDisplayView
{
    if (!_asyncDisplayView) {
        _asyncDisplayView = [[LWAsyncDisplayView alloc] initWithFrame:CGRectMake(0, 1.0f, self.width, 0)];
        _asyncDisplayView.displaysAsynchronously = NO;
        
        LWLayout *layout = [self setupLayout];
        _asyncDisplayView.layout = layout;
    }
    return _asyncDisplayView;
}

- (void) updateLayout:(ProductModel *)product
{
    self.product = product;

    LWLayout *layout = [self setupLayout];
    self.asyncDisplayView.layout = layout;
    
    CGFloat height = [layout suggestHeightWithBottomMargin:0];
    [self.asyncDisplayView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(@(height));
    }];
    
    if (product.xuhao <= 1) {
        self.prevButton.enabled = NO;
        self.nextButton.enabled = YES;
    }
    else {
        self.prevButton.enabled = YES;
        self.nextButton.enabled = YES;
    }
    
    if ([self.product isQuehuo]) {
//        self.okButton.enabled = NO;
        self.coverLayer.hidden = NO;
    }
    else {
//        self.okButton.enabled = YES;
        self.coverLayer.hidden = YES;
    }
}

- (CoverLayerView *) coverLayer
{
    if (!_coverLayer) {
        _coverLayer = [[CoverLayerView alloc] initWithFrame:CGRectMake(kOFFSET_SIZE, kOFFSET_SIZE, 85, 85)];
        _coverLayer.font = SYSTEMFONT(30);
        _coverLayer.hidden = !self.product.isQuehuo;
    }
    return _coverLayer;
}

@end
