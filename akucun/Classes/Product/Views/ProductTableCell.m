//
//  ProductTableCell.m
//  akucun
//
//  Created by Jarry on 2017/3/30.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ProductTableCell.h"
#import "LWAsyncDisplayView.h"
#import "LWImageBrowser.h"
#import "SCImageView.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "MenuView.h"
#import "CoverLayerView.h"
#import "UserManager.h"
#import "LiveManager.h"

@interface ProductTableCell ()

@property (nonatomic, strong) SCImageView *logoImage;

@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, strong) NSMutableArray* imagePostions;
@property (nonatomic, strong) NSMutableArray *imageUrls;

@property (nonatomic, copy) NSString *logoUrl;

@property (nonatomic, strong) UIButton* tapButton;

@property (nonatomic, strong) UIButton *buyButton;
@property (nonatomic, strong) UIButton *forwardButton, *kefuButton;
//@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIButton *followButton;

@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIImageView* salesImage;

@property (nonatomic, strong) CoverLayerView* coverLayer;

@property (nonatomic, strong) LWTextStorage* skuStorage;
@property (nonatomic, strong) ProductSKU* selectSKU;

@property (nonatomic, strong) Comment* comment;

@end

@implementation ProductTableCell

- (void) updateData
{
    [self enabledBuyButton:NO];
    
    ProductCellLayout *cellLayout = (ProductCellLayout *)self.cellLayout;
    
    LiveInfo *liveInfo = [LiveManager getLiveInfo:cellLayout.productModel.liveid];
    if (liveInfo && liveInfo.buymodel > 0) {
        [self.buyButton setNormalTitle:@"立即购买"];
    }
    else {
        [self.buyButton setNormalTitle:@"加购物车"];
    }

    NSString *logoUrl = cellLayout.productModel.pinpaiurl;
    if (logoUrl && logoUrl.length > 0) {
        if (![self.logoUrl isEqualToString:logoUrl]) {
            [self.logoImage setImage:nil];
        }
        [self.logoImage sd_setImageWithURL:[NSURL URLWithString:logoUrl] placeholderImage:nil options:SDWebImageDelayPlaceholder];
        self.logoUrl = logoUrl;
    }
    
    NSArray *images = [cellLayout.productModel imagesUrl];
    NSInteger index = 0;
    for (NSString *imageUrl in images) {
        UIButton *imageView = self.imageViews[index];
        if (![imageUrl isEqualToString:self.imageUrls[index]]) {
            [imageView setImage:nil forState:UIControlStateNormal];
        }
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                             forState:UIControlStateNormal
                     placeholderImage:nil
                              options:SDWebImageDelayPlaceholder];
        [self.imageUrls replaceObjectAtIndex:index withObject:imageUrl];
        index ++;
    }
    
    NSArray *skus = cellLayout.productModel.skus;
    if (!skus || skus.count == 0) {
        [self enabledForwardButton:YES];
        self.coverLayer.hidden = YES;
        return;
    }

    BOOL enabled = NO;
    for (ProductSKU *sku in cellLayout.productModel.skus) {
        if (sku.shuliang > 0) {
            enabled = YES;
            break;
        }
    }
    [self enabledForwardButton:enabled];
    self.coverLayer.hidden = enabled;

    if (!enabled) {
        if ([cellLayout.productModel canbeForward]) {
            [self enabledForwardButton:YES];
        }
    }
    
    //
    if (cellLayout.productModel.follow > 0) {
        [self.followButton setImage:IMAGENAMED(@"icon_heart_selected") forState:UIControlStateNormal];
    }
    else {
        [self.followButton setImage:IMAGENAMED(@"icon_heart") forState:UIControlStateNormal];
    }
    
    //
    if (cellLayout.productModel.bohuojia > 0 && [UserManager isVIP]) { // 非VIP不显示
        NSString *jiesuanjia = FORMAT(@"¥ %.2f", cellLayout.productModel.jiesuanjia/100.0f);
        NSString *diaopaijia = @"";
        if (cellLayout.productModel.diaopaijia > 0) {
            // 吊牌价为0时 不显示
            diaopaijia = FORMAT(@"¥%.2f ", cellLayout.productModel.diaopaijia/100.0f);
        }
        NSString *priceStr = FORMAT(@"%@ %@",jiesuanjia,diaopaijia);
        NSMutableAttributedString *priceAttrText = [[NSMutableAttributedString alloc] initWithString:priceStr];
        // 结算价显示格式
        [priceAttrText addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(22) range:NSMakeRange(2, jiesuanjia.length-5)];
        // 吊牌价显示格式
        if (cellLayout.productModel.diaopaijia > 0) {
            [priceAttrText addAttributes:@{ NSForegroundColorAttributeName : LIGHTGRAY_COLOR, NSFontAttributeName : [FontUtils smallFont],  NSStrikethroughStyleAttributeName : @(NSUnderlinePatternSolid|NSUnderlineStyleSingle), NSBaselineOffsetAttributeName :  @(NSUnderlineStyleSingle), NSStrikethroughColorAttributeName : LIGHTGRAY_COLOR } range:NSMakeRange(jiesuanjia.length+1, diaopaijia.length)];
        }
        self.priceLabel.attributedText = priceAttrText;
        [self.priceLabel sizeToFit];
    }
}

- (void) initContent
{
    [self.contentView addSubview:self.logoImage];

    self.imageViews = [NSMutableArray array];
    self.imageUrls = [NSMutableArray array];
    self.imagePostions = [NSMutableArray array];
    for (int i = 0; i < 4; i ++) {
        UIButton *imageView = [self imageViewAt:i];
        [self.contentView addSubview:imageView];
        [self.imageViews addObject:imageView];
        [self.imageUrls addObject:@""];
    }
    
    [self.contentView addSubview:self.kefuButton];
//    [self.contentView addSubview:self.commentButton];
    [self.contentView addSubview:self.forwardButton];
    [self.contentView addSubview:self.buyButton];
    [self.contentView addSubview:self.followButton];
    [self.contentView addSubview:self.coverLayer];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.salesImage];
}

- (void) customLayoutViews
{
    [self.imagePostions removeAllObjects];
    ProductCellLayout *cellLayout = (ProductCellLayout *)self.cellLayout;
    CGFloat imageWidth = cellLayout.imageWidth;
    CGFloat left = cellLayout.imagesRect.origin.x;
    CGFloat top = cellLayout.imagesRect.origin.y;
    NSInteger row = 0;
    NSInteger column = 0;
    for (int i = 0; i < 4; i ++) {
        UIButton *imageView = self.imageViews[i];
        CGRect imageRect = CGRectMake(left + (column * (imageWidth + 5.0f)), top + (row * (imageWidth + 5.0f)), imageWidth, imageWidth);
        imageView.frame = imageRect;
        NSString* imagePositionString = NSStringFromCGRect(imageRect);
        [self.imagePostions addObject:imagePositionString];
        column ++;
        if (column > 1) {
            column = 0;
            row ++;
        }
    }
    
    if (self.hideForward) {
        self.kefuButton.right = SCREEN_WIDTH - kOFFSET_SIZE;
        self.kefuButton.top = cellLayout.menuPosition;
        
        self.forwardButton.hidden = YES;
    }
    else {
        self.forwardButton.right = SCREEN_WIDTH - kOFFSET_SIZE;
        self.forwardButton.top = cellLayout.menuPosition;
        
//        self.commentButton.right = self.forwardButton.left - kOFFSET_SIZE*0.5;
//        self.commentButton.top = self.forwardButton.top;
        
        self.forwardButton.hidden = NO;
    }
    
    self.kefuButton.top = self.forwardButton.top;
    self.kefuButton.right = self.forwardButton.left - kOFFSET_SIZE*0.5;
    self.kefuButton.hidden = NO;
    
    self.buyButton.right = SCREEN_WIDTH - kOFFSET_SIZE - 0.5f;
    self.buyButton.bottom = cellLayout.skuBgBottom - 0.5f;
    
//    self.cancelButton.right = self.buyButton.right;
//    self.commentButton.hidden = NO;
    
    NSArray *skus = cellLayout.productModel.skus;
    if (!skus || skus.count == 0) {
        self.buyButton.hidden = YES;
        self.followButton.hidden = YES;
        self.priceLabel.hidden = YES;
        self.salesImage.hidden = YES;
    }
    else {
        self.buyButton.hidden = NO;
        self.followButton.hidden = NO;
        self.priceLabel.hidden = NO;
        self.salesImage.hidden = (cellLayout.productModel.salestype != SalesTypeDouble);
    }
    
    self.followButton.right = SCREEN_WIDTH;
    self.followButton.centerY = cellLayout.nameCenterY;
    
    //
    self.coverLayer.frame = cellLayout.imagesRect;
    
    self.priceLabel.left = cellLayout.contentLeft;
    self.priceLabel.top = cellLayout.contentBottom;
    self.salesImage.right = SCREEN_WIDTH - kOFFSET_SIZE;
    self.salesImage.bottom = cellLayout.contentBottom;
}

- (void) updateCellLayout
{
//    self.menu.statusModel = self.cellLayout.statusModel;
}

#pragma mark - Actions

- (void) tapAction
{
//    [self hideCancel];
}
/*
- (void) showCancel
{
    if (!_tapButton) {
        _tapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _tapButton.frame = self.bounds;
        _tapButton.backgroundColor = CLEAR_COLOR;
        [_tapButton addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.contentView addSubview:_tapButton];
    
    [self.contentView addSubview:self.cancelButton];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.cancelButton.width = 45;
        self.cancelButton.right = SCREEN_WIDTH-kOFFSET_SIZE;
        self.cancelButton.alpha = 1.0f;
    }];
}

- (void) hideCancel
{
    if (self.cancelButton.alpha == 0.0f) {
        return;
    }
    
    [self.tapButton removeFromSuperview];
    self.tapButton = nil;

    [UIView animateWithDuration:0.3f animations:^{
        self.cancelButton.width = 0;
        self.cancelButton.left = SCREEN_WIDTH-kOFFSET_SIZE;
        self.cancelButton.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.cancelButton removeFromSuperview];
    }];
}*/

- (IBAction) kefuAction:(id)sender
{
    ProductCellLayout *cellLayout = (ProductCellLayout *)self.cellLayout;
    if (self.clickedKefuCallback) {
        self.clickedKefuCallback(self, cellLayout.productModel);
    }
}
/*
- (IBAction) commentAction:(id)sender
{
//    [self hideMenu];
    
    ProductCellLayout *cellLayout = (ProductCellLayout *)self.cellLayout;
    if (self.clickedCommentCallback) {
        self.clickedCommentCallback(self, cellLayout.productModel);
    }
}*/

- (IBAction) forwardAction:(id)sender
{
//    [self hideMenu];
    
    ProductCellLayout *cellLayout = (ProductCellLayout *)self.cellLayout;
    if (self.clickedForwardCallback) {
        self.clickedForwardCallback(self, cellLayout.productModel);
    }
}

- (IBAction) buyAction:(id)sender
{
    [self enabledBuyButton:NO];
    self.selectSKU.isChecked = NO;
//    self.selectSKU.shuliang -= 1;
    
    ProductCellLayout *cellLayout = (ProductCellLayout *)self.cellLayout;
    if (self.clickedBuyCallback) {
        self.clickedBuyCallback(self, cellLayout.productModel, self.selectSKU);
    }
}
/*
- (IBAction) cancelAction:(id)sender
{
    [self hideCancel];
    
    ProductCellLayout *cellLayout = (ProductCellLayout *)self.cellLayout;
    if (self.clickedCancelCallback) {
        self.clickedCancelCallback(self, cellLayout.productModel, self.comment);
    }
}*/

- (IBAction) followAction:(id)sender
{
    ProductCellLayout *cellLayout = (ProductCellLayout *)self.cellLayout;
    if (self.clickedFollowCallback) {
        self.clickedFollowCallback(self, cellLayout.productModel);
    }
}

- (void) enabledBuyButton:(BOOL)enabled
{
    self.buyButton.enabled = enabled;
    self.buyButton.backgroundColor = enabled ? COLOR_SELECTED : COLOR_BG_DISABLED;
}

- (void) enabledForwardButton:(BOOL)enabled
{
    self.forwardButton.enabled = enabled;
    self.forwardButton.backgroundColor = enabled ? COLOR_BG_BUTTON : COLOR_BG_DISABLED;
}

- (IBAction) imageAction:(id)sender
{
    UIButton *imageView = sender;
    [self showImageBrowserWithIndex:imageView.tag];
}

//点击查看大图
- (void) showImageBrowserWithIndex:(NSInteger)imageIndex
{
    ProductCellLayout *layout = (ProductCellLayout *)self.cellLayout;
    NSArray *imagesUrl = [layout.productModel imagesUrl];
    
    NSMutableArray* tmps = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.imagePostions.count; i ++) {
        LWImageBrowserModel* model = [[LWImageBrowserModel alloc]
                                      initWithplaceholder:nil
                                      thumbnailURL:[NSURL URLWithString:imagesUrl[i]]
                                      HDURL:[NSURL URLWithString:imagesUrl[i]]
                                      containerView:self.contentView
                                      positionInContainer:CGRectFromString(self.imagePostions[i])
                                      index:i];
        [tmps addObject:model];
    }
    LWImageBrowser* browser = [[LWImageBrowser alloc] initWithImageBrowserModels:tmps currentIndex:imageIndex];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FORWARD_HIDE object:nil];
    browser.finishedBlock = ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FORWARD_SHOW object:nil];
    };
    [browser show];
    
    if (self.clickedImageCallback) {
        self.clickedImageCallback(self, imageIndex);
    }
}

#pragma mark - LWAsyncDisplayViewDelegate

// 额外的绘制
- (void) extraAsyncDisplayIncontext:(CGContextRef)context
                              size:(CGSize)size
                       isCancelled:(LWAsyncDisplayIsCanclledBlock)isCancelled
{
    if (!isCancelled()) {
        ProductCellLayout *cellLayout = (ProductCellLayout *)self.cellLayout;

        CGContextSetLineWidth(context, kPIXEL_WIDTH);
        CGContextSetStrokeColorWithColor(context,RGB(220.0f, 220.0f, 220.0f, 1).CGColor);
        CGFloat offset = isPad ? kOFFSET_SIZE : 0.0f;
        CGContextMoveToPoint(context, offset, self.bounds.size.height);
        CGContextAddLineToPoint(context, self.bounds.size.width - offset, self.bounds.size.height);
        CGContextStrokePath(context);
        
        NSArray *skus = cellLayout.productModel.skus;
        if (skus && skus.count > 0) {
            CGContextSetFillColorWithColor(context, RGBCOLOR(0xF9, 0xF9, 0xF9).CGColor);
            CGContextFillRect(context, cellLayout.skuBgPosition);
            CGContextStrokeRect(context, cellLayout.skuBgPosition);
        }
    }
}

//点击LWImageStorage
- (void) lwAsyncDisplayView:(LWAsyncDisplayView *)asyncDisplayView
    didCilickedImageStorage:(LWImageStorage *)imageStorage
                      touch:(UITouch *)touch
{
    NSInteger tag = imageStorage.tag;
    //tag 0~8 是图片，9是头像
    switch (tag) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:{
//            if (self.clickedImageCallback) {
//                self.clickedImageCallback(self,tag);
//            }
        }
            break;
        case 9: {
            ProductCellLayout *cellLayout = (ProductCellLayout *)self.cellLayout;
            if (self.clickedAvatarCallback) {
                self.clickedAvatarCallback(self, cellLayout.productModel);
            }
        }
            break;
    }
}

//点击LWTextStorage
- (void) lwAsyncDisplayView:(LWAsyncDisplayView *)asyncDisplayView
     didCilickedTextStorage:(LWTextStorage *)textStorage
                   linkdata:(id)data
{
    if ([data isKindOfClass:[ProductModel class]]) {
        ProductCellLayout *cellLayout = (ProductCellLayout *)self.cellLayout;
        if (self.clickedAvatarCallback) {
            self.clickedAvatarCallback(self, cellLayout.productModel);
        }
    }
    else if ([data isKindOfClass:[ProductSKU class]]) {
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
            [self enabledBuyButton:YES];
            //
            self.skuStorage = textStorage;
            self.selectSKU = sku;
        }
        else {
            textStorage.textBackgroundColor = COLOR_BG_TEXT;
            textStorage.textColor = COLOR_TEXT_LINK;
            [self enabledBuyButton:NO];
            //
            self.skuStorage = nil;
            self.selectSKU = nil;
        }
        sku.isChecked = !checked;
    }
    /*
    else if ([data isKindOfClass:[Comment class]]) {
        
        Comment *comment = data;
        if ([comment.pinglunzheID isEqualToString:[UserManager userId]]) {
            self.comment = data;
            self.cancelButton.top = textStorage.top-3.0f;
            self.cancelButton.width = 0;
            [self showCancel];
        }
    }*/
}

- (BOOL) canPerformAction:(SEL)action withSender:(id)sender
{
//    if(action == @selector(cancelAction:)){
//        return YES;
//    }
    return [super canPerformAction:action withSender:sender];
}

- (BOOL) canBecomeFirstResponder
{
    return YES;
}

#pragma mark - Getter

- (SCImageView *) logoImage
{
    if (!_logoImage) {
        CGFloat top = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
        _logoImage = [[SCImageView alloc] initWithFrame:CGRectMake(kOFFSET_SIZE, top, 40, 40)];
        _logoImage.backgroundColor = WHITE_COLOR;
        _logoImage.contentMode = UIViewContentModeScaleAspectFit;
        _logoImage.clipsToBounds = YES;
        _logoImage.userInteractionEnabled = YES;
        
        _logoImage.layer.cornerRadius = 6.0f;
        _logoImage.layer.borderColor = [COLOR_TITLE colorWithAlphaComponent:0.5f].CGColor;
        _logoImage.layer.borderWidth = 0.2f;
        
        @weakify(self)
        _logoImage.clickedBlock = ^{
            @strongify(self)
            ProductCellLayout *cellLayout = (ProductCellLayout *)self.cellLayout;
            if (self.clickedAvatarCallback) {
                self.clickedAvatarCallback(self, cellLayout.productModel);
            }
        };
    }
    return _logoImage;
}

- (UIButton *) imageViewAt:(NSInteger)index
{
    UIButton *imageView = [UIButton buttonWithType:UIButtonTypeCustom];
    imageView.backgroundColor = COLOR_BG_IMAGE;

    imageView.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    imageView.tag = index;
    
    [imageView addTarget:self action:@selector(imageAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return imageView;
}

- (UIButton *) buyButton
{
    if (_buyButton) {
        return _buyButton;
    }
    _buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _buyButton.frame = CGRectMake(0, 0, 70, 24);
    _buyButton.backgroundColor = COLOR_BG_DISABLED;
    _buyButton.layer.masksToBounds = NO;
    _buyButton.layer.cornerRadius = 3.0f;
    _buyButton.titleLabel.font = [FontUtils smallFont];
    [_buyButton setNormalTitle:@"加购物车"];
    [_buyButton setNormalColor:WHITE_COLOR highlighted:COLOR_TEXT_LIGHT selected:nil];
    
    [_buyButton addTarget:self action:@selector(buyAction:)
         forControlEvents:UIControlEventTouchUpInside];
    _buyButton.enabled = NO;
    _buyButton.hidden = YES;
    return _buyButton;
}

- (UIButton *) kefuButton
{
    if (_kefuButton) {
        return _kefuButton;
    }
    _kefuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _kefuButton.frame = CGRectMake(0, 0, 45, 24);
    _kefuButton.backgroundColor = COLOR_BG_BUTTON;
    _kefuButton.layer.masksToBounds = NO;
    _kefuButton.layer.cornerRadius = 3.0f;
    _kefuButton.titleLabel.font = [FontUtils smallFont];
    [_kefuButton setNormalTitle:@"咨询"];
    [_kefuButton setNormalColor:WHITE_COLOR highlighted:COLOR_SELECTED selected:nil];
    
    [_kefuButton addTarget:self action:@selector(kefuAction:)
             forControlEvents:UIControlEventTouchUpInside];
    
    _kefuButton.hidden = YES;
    
    return _kefuButton;
}
/*
- (UIButton *) commentButton
{
    if (_commentButton) {
        return _commentButton;
    }
    _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _commentButton.frame = CGRectMake(0, 0, 45, 24);
    _commentButton.backgroundColor = COLOR_BG_BUTTON;
    _commentButton.clipsToBounds = YES;
    _commentButton.layer.cornerRadius = 3.0f;
    _commentButton.titleLabel.font = [FontUtils smallFont];
    [_commentButton setNormalTitle:@"评论"];
    [_commentButton setNormalColor:WHITE_COLOR highlighted:COLOR_SELECTED selected:nil];
    
    [_commentButton addTarget:self action:@selector(commentAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
    _commentButton.hidden = YES;

    return _commentButton;
}
*/
- (UIButton *) forwardButton
{
    if (_forwardButton) {
        return _forwardButton;
    }
    _forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _forwardButton.frame = CGRectMake(0, 0, 45, 24);
    _forwardButton.backgroundColor = COLOR_BG_BUTTON;
    _forwardButton.layer.masksToBounds = NO;
    _forwardButton.layer.cornerRadius = 3.0f;
    _forwardButton.titleLabel.font = [FontUtils smallFont];
    [_forwardButton setNormalTitle:@"转发"];
    [_forwardButton setNormalColor:WHITE_COLOR highlighted:COLOR_SELECTED selected:nil];
    
    [_forwardButton addTarget:self action:@selector(forwardAction:)
             forControlEvents:UIControlEventTouchUpInside];
    
    _forwardButton.hidden = YES;
    
    return _forwardButton;
}
/*
- (UIButton *) cancelButton
{
    if (_cancelButton) {
        return _cancelButton;
    }
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.frame = CGRectMake(SCREEN_WIDTH-kOFFSET_SIZE, 0, 0, 22);
    _cancelButton.backgroundColor = RED_COLOR;
    _cancelButton.clipsToBounds = YES;
    _cancelButton.layer.cornerRadius = 3.0f;
    _cancelButton.titleLabel.font = [FontUtils smallFont];
    [_cancelButton setNormalTitle:@"取消"];
    [_cancelButton setNormalColor:WHITE_COLOR highlighted:COLOR_TEXT_LIGHT selected:nil];
    
    [_cancelButton addTarget:self action:@selector(cancelAction:)
         forControlEvents:UIControlEventTouchUpInside];
    
    _cancelButton.alpha = 0.0f;
    
    return _cancelButton;
}*/

- (UIButton *) followButton
{
    if (_followButton) {
        return _followButton;
    }
    _followButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _followButton.frame = CGRectMake(0, 0, 20+kOFFSET_SIZE*2, 44);

    [_followButton setNormalImage:@"icon_heart" hilighted:@"icon_heart_hl" selectedImage:nil];
    
    [_followButton addTarget:self action:@selector(followAction:)
         forControlEvents:UIControlEventTouchUpInside];
    _followButton.hidden = YES;
    return _followButton;
}

- (UILabel *) priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [FontUtils normalFont];
        _priceLabel.textColor = COLOR_SELECTED;
        _priceLabel.hidden = YES;
    }
    return _priceLabel;
}

- (UIImageView *) salesImage
{
    if (!_salesImage) {
        _salesImage = [[UIImageView alloc] initWithImage:IMAGENAMED(@"image_dgf_double")];
//        _salesImage.frame = CGRectMake(0, 0, 61, 33);
        _salesImage.contentMode = UIViewContentModeScaleAspectFit;
        _salesImage.hidden = YES;
    }
    return _salesImage;
}

- (CoverLayerView *) coverLayer
{
    if (!_coverLayer) {
        _coverLayer = [[CoverLayerView alloc] initWithFrame:CGRectZero];
        _coverLayer.hidden = YES;
    }
    return _coverLayer;
}

/*
- (UIButton *) menuButton
{
    if (_menuButton) {
        return _menuButton;
    }
    _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_menuButton setImage:[UIImage imageNamed:@"icon_menu"] forState:UIControlStateNormal];
    _menuButton.imageEdgeInsets = UIEdgeInsetsMake(14.5f, 24.0f, 14.5f, kOFFSET_SIZE);
    [_menuButton addTarget:self action:@selector(didClickedMenuButton)
          forControlEvents:UIControlEventTouchUpInside];
    return _menuButton;
}

- (MenuView *) menuView
{
    if (_menuView) {
        return _menuView;
    }
    _menuView = [[MenuView alloc] initWithFrame:CGRectZero];
    _menuView.backgroundColor = [UIColor whiteColor];
    _menuView.opaque = YES;
    [_menuView.commentButton addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    [_menuView.forwardButton addTarget:self action:@selector(forwardAction:) forControlEvents:UIControlEventTouchUpInside];
    return _menuView;
}*/

@end
