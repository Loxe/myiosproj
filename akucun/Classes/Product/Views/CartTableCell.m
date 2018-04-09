//
//  CartTableCell.m
//  akucun
//
//  Created by Jarry on 2017/4/2.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "CartTableCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CoverLayerView.h"
#import "TextButton.h"
#import "SCImageView.h"
#import "LWImageBrowser.h"

@interface CartTableCell ()

@property (nonatomic, strong) UIImageView *checkImage;
@property (nonatomic, strong) SCImageView *productImage;

@property (nonatomic, strong) UIButton *remarkButton;

@property (nonatomic, strong) TextButton *deleteButton;

@property (nonatomic, strong) CoverLayerView* coverLayer;

@end

@implementation CartTableCell

- (void) updateData
{
    CartCellLayout *cellLayout = (CartCellLayout *)self.cellLayout;
    
    if (self.invalid || [cellLayout.cartProduct quehuo]) {
        UIImage *image = [IMAGENAMED(@"icon_uncheck") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.checkImage.image = image;
        self.checkImage.tintColor = COLOR_TEXT_LIGHT;
        
        self.coverLayer.hidden = NO;
    }
    else {
        NSString *image = cellLayout.checked ? @"icon_check" : @"icon_uncheck";
        self.checkImage.image = IMAGENAMED(image);
        
        self.coverLayer.hidden = YES;
    }
    
    self.remarkButton.alpha = self.invalid ? 0.0f : 1.0f;
    self.deleteButton.alpha = self.invalid ? 0.0f : 1.0f;
    
    [self.productImage sd_setImageWithURL:[NSURL URLWithString:[cellLayout.cartProduct imageUrl]]];
}

- (void) initContent
{
    [self.contentView addSubview:self.checkImage];
    [self.contentView addSubview:self.productImage];
    [self.contentView addSubview:self.remarkButton];
    [self.contentView addSubview:self.deleteButton];
//    [self.contentView addSubview:self.coverLayer];
}

- (void) customLayoutViews
{
    CartCellLayout *cellLayout = (CartCellLayout *)self.cellLayout;
    
    self.productImage.frame = cellLayout.imagePosition;
    self.checkImage.centerY = CGRectGetMidY(cellLayout.imagePosition);
    self.remarkButton.right = SCREEN_WIDTH - kOFFSET_SIZE;
    self.remarkButton.top = cellLayout.buttonPosition;
    
    self.deleteButton.right = SCREEN_WIDTH;
    self.deleteButton.centerY = self.productImage.centerY;
    
    self.checkImage.alpha = 1.0f;
    self.productImage.alpha = 1.0f;
    
    if (!self.invalid) {
        self.remarkButton.alpha = 1.0f;
        self.deleteButton.alpha = 1.0f;
    }

    //
    self.coverLayer.frame = cellLayout.imagePosition;
}

#pragma mark - Actions

- (IBAction) remarkAction:(id)sender
{
    CartCellLayout *cellLayout = (CartCellLayout *)self.cellLayout;
    if (self.clickedRemarkCallback) {
        self.clickedRemarkCallback(self, cellLayout.cartProduct);
    }

}

- (IBAction) deleteAction:(id)sender
{
    CartCellLayout *cellLayout = (CartCellLayout *)self.cellLayout;
    if (self.clickedDeleteCallback) {
        self.clickedDeleteCallback(self, cellLayout.cartProduct);
    }
}

- (void) showImageBrowser
{
    CartCellLayout *cellLayout = (CartCellLayout *)self.cellLayout;
    NSArray *imagesUrl = [cellLayout.cartProduct imagesUrl];
    
    NSMutableArray* tmps = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < imagesUrl.count; i ++) {
        LWImageBrowserModel* model = [[LWImageBrowserModel alloc]
                                      initWithplaceholder:nil
                                      thumbnailURL:[NSURL URLWithString:imagesUrl[i]]
                                      HDURL:[NSURL URLWithString:imagesUrl[i]]
                                      containerView:self.contentView
                                      positionInContainer:cellLayout.imagePosition
                                      index:i];
        [tmps addObject:model];
    }
    LWImageBrowser* browser = [[LWImageBrowser alloc] initWithImageBrowserModels:tmps currentIndex:0];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FORWARD_HIDE object:nil];
    browser.finishedBlock = ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FORWARD_SHOW object:nil];
    };
    [browser show];
}

#pragma mark - LWAsyncDisplayViewDelegate

// 额外的绘制
- (void) extraAsyncDisplayIncontext:(CGContextRef)context
                               size:(CGSize)size
                        isCancelled:(LWAsyncDisplayIsCanclledBlock)isCancelled
{
    if (!isCancelled()) {
        CGFloat offset = isPad ? kOFFSET_SIZE : 0.0f;
        CGContextMoveToPoint(context, offset, self.bounds.size.height);
        CGContextAddLineToPoint(context, self.bounds.size.width-offset, self.bounds.size.height);
        CGContextSetLineWidth(context, 0.5f);
        CGContextSetStrokeColorWithColor(context,RGB(220.0f, 220.0f, 220.0f, 1).CGColor);
        CGContextStrokePath(context);
    }
}

#pragma mark - Views

- (UIImageView *) checkImage
{
    if (!_checkImage) {
        _checkImage = [[UIImageView alloc] init];
        _checkImage.frame = CGRectMake(kOFFSET_SIZE, 0, 18, self.height);
        _checkImage.contentMode = UIViewContentModeScaleAspectFit;
        _checkImage.image = IMAGENAMED(@"icon_uncheck");
        
        _checkImage.alpha = 0.0f;
    }
    return _checkImage;
}

- (SCImageView *) productImage
{
    if (!_productImage) {
        _productImage = [[SCImageView alloc] init];
        _productImage.backgroundColor = RGB(240, 240, 240, 1);
        _productImage.contentMode = UIViewContentModeScaleAspectFill;
        _productImage.clipsToBounds = YES;
        _productImage.userInteractionEnabled = YES;
        _productImage.alpha = 0.0f;
        
        @weakify(self)
        _productImage.clickedBlock = ^{
            @strongify(self)
            [self showImageBrowser];
        };
    }
    return _productImage;
}

- (UIButton *) remarkButton
{
    if (_remarkButton) {
        return _remarkButton;
    }
    _remarkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _remarkButton.frame = CGRectMake(0, 0, 40, 20);
    _remarkButton.backgroundColor = COLOR_BG_BUTTON;
    _remarkButton.layer.masksToBounds = NO;
    _remarkButton.layer.cornerRadius = 3.0f;
    _remarkButton.titleLabel.font = [FontUtils smallFont];
    [_remarkButton setNormalTitle:@"备注"];
    [_remarkButton setNormalColor:WHITE_COLOR highlighted:COLOR_SELECTED selected:nil];
    
    [_remarkButton addTarget:self action:@selector(remarkAction:)
         forControlEvents:UIControlEventTouchUpInside];
    
    _remarkButton.alpha = 0.0f;
    
    return _remarkButton;
}

- (TextButton *) deleteButton
{
    if (_deleteButton) {
        return _deleteButton;
    }
    _deleteButton = [TextButton buttonWithType:UIButtonTypeCustom];
    _deleteButton.frame = CGRectMake(0, 0, 44+kOFFSET_SIZE, 44);
    _deleteButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kOFFSET_SIZE);

    [_deleteButton setTitleFont:FA_ICONFONTSIZE(18)];
    [_deleteButton setTitleAlignment:NSTextAlignmentRight];
    [_deleteButton setNormalTitle:FA_ICONFONT_DELETE];
    [_deleteButton setNormalColor:RED_COLOR highlighted:LIGHTGRAY_COLOR selected:nil];
    
    [_deleteButton addTarget:self action:@selector(deleteAction:)
            forControlEvents:UIControlEventTouchUpInside];
    
    _deleteButton.alpha = 0.0f;
    
    return _deleteButton;
}

- (CoverLayerView *) coverLayer
{
    if (!_coverLayer) {
        _coverLayer = [[CoverLayerView alloc] initWithFrame:CGRectZero];
        _coverLayer.text = @"缺货";
        _coverLayer.font = SYSTEMFONT(15);
        _coverLayer.hidden = YES;
    }
    return _coverLayer;
}

@end
