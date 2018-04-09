//
//  CartRecycleCell.m
//  akucun
//
//  Created by Jarry on 2017/9/2.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "CartRecycleCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CoverLayerView.h"
#import "TextButton.h"
#import "SCImageView.h"
#import "LWImageBrowser.h"

@interface CartRecycleCell ()

@property (nonatomic, strong) SCImageView *productImage;

@property (nonatomic, strong) UIButton *buyButton;

@property (nonatomic, strong) CoverLayerView* coverLayer;

@end

@implementation CartRecycleCell

- (void) updateData
{
    CartCellLayout *cellLayout = (CartCellLayout *)self.cellLayout;
    
    [self.buyButton setNormalTitle:@"重新购买"];
    [self.buyButton setNormalColor:WHITE_COLOR];

    if ([cellLayout.cartProduct quehuo]) {
        self.buyButton.backgroundColor = COLOR_BG_DISABLED;
        self.buyButton.enabled = NO;
        self.coverLayer.hidden = NO;
    }
    else {
        if (cellLayout.cartProduct.buystatus == 3) {
            self.buyButton.backgroundColor = WHITE_COLOR;
            [self.buyButton setNormalTitle:@"已重新购买"];
            [self.buyButton setNormalColor:RED_COLOR];
            self.buyButton.enabled = NO;
        }
        else {
            self.buyButton.backgroundColor = COLOR_APP_ORANGE;
            self.buyButton.enabled = YES;
        }
        self.coverLayer.hidden = YES;
    }
        
    [self.productImage sd_setImageWithURL:[NSURL URLWithString:[cellLayout.cartProduct imageUrl]]];
}

- (void) initContent
{
    [self.contentView addSubview:self.productImage];
    [self.contentView addSubview:self.buyButton];
    [self.contentView addSubview:self.coverLayer];
}

- (void) customLayoutViews
{
    CartCellLayout *cellLayout = (CartCellLayout *)self.cellLayout;
    
    self.productImage.frame = cellLayout.imagePosition;
    self.buyButton.right = SCREEN_WIDTH - kOFFSET_SIZE;
    self.buyButton.top = cellLayout.buttonPosition;
    
    self.productImage.alpha = 1.0f;
    
    self.buyButton.alpha = 1.0f;
    
    //
    self.coverLayer.frame = cellLayout.imagePosition;
}

#pragma mark - Actions

- (IBAction) buyAction:(id)sender
{
    self.buyButton.enabled = NO;

    CartCellLayout *cellLayout = (CartCellLayout *)self.cellLayout;
    if (self.clickedBuyCallback) {
        self.clickedBuyCallback(self, cellLayout.cartProduct);
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

#pragma mark - Views

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

- (UIButton *) buyButton
{
    if (_buyButton) {
        return _buyButton;
    }
    _buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _buyButton.frame = CGRectMake(0, 0, 70, 24);
    _buyButton.backgroundColor = COLOR_APP_ORANGE;
    _buyButton.layer.masksToBounds = NO;
    _buyButton.layer.cornerRadius = 3.0f;
    _buyButton.titleLabel.font = [FontUtils smallFont];
    [_buyButton setNormalTitle:@"重新购买"];
    [_buyButton setNormalColor:WHITE_COLOR highlighted:COLOR_TEXT_LIGHT selected:nil];
    
    [_buyButton addTarget:self action:@selector(buyAction:)
            forControlEvents:UIControlEventTouchUpInside];
    
    _buyButton.enabled = NO;
    _buyButton.alpha = 0.0f;
    
    return _buyButton;
}

- (CoverLayerView *) coverLayer
{
    if (!_coverLayer) {
        _coverLayer = [[CoverLayerView alloc] initWithFrame:CGRectZero];
//        _coverLayer.text = @"缺货";
        _coverLayer.font = SYSTEMFONT(20);
        _coverLayer.hidden = YES;
    }
    return _coverLayer;
}

@end
