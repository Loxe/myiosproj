//
//  OrderTableCell.m
//  akucun
//
//  Created by Jarry on 2017/4/2.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "OrderTableCell.h"
#import "Gallop.h"
#import "TextButton.h"
#import "CountDownView.h"

@interface OrderTableCell ()

@property (nonatomic, strong) UIImageView *logoImage;

@property (nonatomic, strong) TextButton* accessoryButton;

@property (nonatomic, strong) UIButton *payButton;
@property (nonatomic, strong) UIButton *previewButton;
@property (nonatomic, strong) UIButton *scanButton;

@property (nonatomic, strong) CountDownView *timeView;

@property (nonatomic, copy) NSString *logoUrl;

@end

@implementation OrderTableCell

- (void) initContent
{
    [self.contentView addSubview:self.logoImage];
    [self.contentView addSubview:self.accessoryButton];
    [self.contentView addSubview:self.payButton];
    [self.contentView addSubview:self.previewButton];
    [self.contentView addSubview:self.scanButton];
    [self.contentView addSubview:self.timeView];
}

- (void) updateData
{
    OrderCellLayout *cellLayout = (OrderCellLayout *)self.cellLayout;
    
    NSString *logoUrl = nil;
    if (cellLayout.orderModel) {
        logoUrl = cellLayout.orderModel.pinpaiURL;
    }
    else if (cellLayout.adOrder) {
        logoUrl = cellLayout.adOrder.pinpaiURL;
    }
    if (logoUrl && logoUrl.length > 0) {
        if (![self.logoUrl isEqualToString:logoUrl]) {
            [self.logoImage setImage:nil];
        }
        [self.logoImage sd_setImageWithURL:[NSURL URLWithString:logoUrl] placeholderImage:nil options:SDWebImageDelayPlaceholder];
        self.logoUrl = logoUrl;
    }
}

- (void) customLayoutViews
{
    OrderCellLayout *layout = (OrderCellLayout *)self.cellLayout;
    self.accessoryButton.frame = CGRectMake(self.contentView.right-60, layout.dateHeight, 60, layout.nameHeight);
    
//    CGFloat offset = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
    self.logoImage.centerY = self.accessoryButton.centerY;
    self.payButton.right = SCREEN_WIDTH - kOFFSET_SIZE;
    self.payButton.top = (layout.cellHeight + layout.linePosition - self.payButton.height)/2.0f;
    
    self.timeView.liveTime = 0;
    self.timeView.alpha = 0.0f;
    
    if (layout.orderModel) {
        self.payButton.alpha = (layout.orderModel.status == 0) ? 1.0f : 0.0f;
        self.previewButton.alpha = 0.0f;
        [self.previewButton setNormalTitle:@"对账单"];
        self.previewButton.width = 60;
        self.scanButton.alpha = 0.0f;
        
        if (layout.orderModel.status == 0) {
            self.timeView.liveTime = layout.orderModel.overtimeshuzi;
            self.timeView.centerY = self.payButton.centerY;
            self.timeView.left = kOFFSET_SIZE*2 + 30;
            self.timeView.alpha = 1.0f;
        }
    }
    else if (layout.adOrder) {
        self.payButton.alpha = 0.0f;
        self.previewButton.alpha = 1.0f;
        self.scanButton.alpha = 0.0f;
        if (layout.adOrder.statu == 4) {
            [self.previewButton setNormalTitle:@"对账单"];
            self.previewButton.width = 60;
            // 已发货发货单 都要显示 扫码分拣
            self.scanButton.alpha = 1.0f;
        }
        else if (layout.adOrder.statu >= 1 && layout.adOrder.statu <= 3) {
            [self.previewButton setNormalTitle:@"对账单"];
            self.previewButton.width = 60;
            // 拣货中 支持 扫码分拣
            self.scanButton.alpha = 1.0f;
        }
        else {
            [self.previewButton setNormalTitle:@"对账单"];
            self.previewButton.width = 60;
        }
//        self.previewButton.alpha = (layout.adOrder.statu == 4) ? 1.0f : 0.0f;
    }
    
    self.previewButton.right = self.payButton.right;
    self.previewButton.top = self.payButton.top;
    self.scanButton.right = self.previewButton.left - kOFFSET_SIZE;
    self.scanButton.top = self.payButton.top;
}

#pragma mark - Actions

- (IBAction) payAction:(id)sender
{
    OrderCellLayout *cellLayout = (OrderCellLayout *)self.cellLayout;
    if (self.clickedPayCallback) {
        self.clickedPayCallback(self, cellLayout.orderModel);
    }
}

- (IBAction) previewAction:(id)sender
{
    OrderCellLayout *cellLayout = (OrderCellLayout *)self.cellLayout;
    NSString *url = nil;
    id model = nil;
    if (cellLayout.orderModel) {
        model = cellLayout.orderModel;
        url = cellLayout.orderModel.downloadurl;
    }
    else if (cellLayout.adOrder) {
        model = cellLayout.adOrder;
        url = cellLayout.adOrder.downloadurl;
//        if (cellLayout.adOrder.statu == 4) {
//            url = cellLayout.adOrder.downloadurl;
//        }
//        else if (cellLayout.adOrder.statu == 0) {
//            url = nil;
//        }
//        else {
//            url = cellLayout.adOrder.downloadurl ? : @"";
//        }
    }
    if (self.clickedPreviewCallback) {
        self.clickedPreviewCallback(self, model, url);
    }
}

- (IBAction) scanAction:(id)sender
{
    OrderCellLayout *cellLayout = (OrderCellLayout *)self.cellLayout;
    if (self.clickedScanCallback) {
        self.clickedScanCallback(self, cellLayout.adOrder);
    }
}

#pragma mark - LWAsyncDisplayViewDelegate

// 额外的绘制
- (void) extraAsyncDisplayIncontext:(CGContextRef)context
                               size:(CGSize)size
                        isCancelled:(LWAsyncDisplayIsCanclledBlock)isCancelled
{
    if (!isCancelled()) {
        OrderCellLayout *layout = (OrderCellLayout *)self.cellLayout;
        CGContextMoveToPoint(context, kOFFSET_SIZE, layout.linePosition);
        CGContextAddLineToPoint(context, self.bounds.size.width, layout.linePosition);
        CGContextSetStrokeColorWithColor(context,RGB(220.0f, 220.0f, 220.0f, 1).CGColor);
        CGContextSetLineWidth(context, 0.2f);
        CGContextStrokePath(context);

        CGContextMoveToPoint(context, 0.0f, self.bounds.size.height);
        CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
        CGContextSetLineWidth(context, 0.5f);
        CGContextStrokePath(context);
        
        if (layout.showDate) {
            [COLOR_BG_HEADER set];
            CGContextFillRect(context, CGRectMake(0, 0, SCREEN_WIDTH, layout.dateHeight));
        }
    }
}

#pragma mark - Views

- (UIImageView *) logoImage
{
    if (!_logoImage) {
        CGFloat top = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
        _logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(kOFFSET_SIZE, top, 18, 18)];
        _logoImage.backgroundColor = COLOR_BG_LIGHTGRAY;
        _logoImage.contentMode = UIViewContentModeScaleAspectFill;
        _logoImage.clipsToBounds = YES;
        
        _logoImage.layer.cornerRadius = 3.0f;
        _logoImage.layer.borderColor = COLOR_SEPERATOR_LIGHT.CGColor;
        _logoImage.layer.borderWidth = 0.2f;
    }
    return _logoImage;
}

- (TextButton *) accessoryButton
{
    if (!_accessoryButton) {
        _accessoryButton = [TextButton buttonWithType:UIButtonTypeCustom];
        _accessoryButton.frame = CGRectMake(0, 0, kOFFSET_SIZE, 60);
        _accessoryButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kOFFSET_SIZE);
        
        [_accessoryButton setTitleFont:FA_ICONFONTSIZE(20)];
        [_accessoryButton setTitleAlignment:NSTextAlignmentRight];
        
        [_accessoryButton setTitle:FA_ICONFONT_RIGHT forState:UIControlStateNormal];
        [_accessoryButton setTitleColor:COLOR_TEXT_LIGHT forState:UIControlStateNormal];
        
        _accessoryButton.enabled = NO;
    }
    return _accessoryButton;
}

- (UIButton *) payButton
{
    if (_payButton) {
        return _payButton;
    }
    _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _payButton.frame = CGRectMake(0, 0, 60, 24);
    _payButton.backgroundColor = COLOR_SELECTED;
    _payButton.layer.masksToBounds = NO;
    _payButton.layer.cornerRadius = 3.0f;
//    _payButton.layer.borderColor = RED_COLOR.CGColor;
//    _payButton.layer.borderWidth = 1.0f;
    _payButton.titleLabel.font = [FontUtils smallFont];
    [_payButton setNormalTitle:@"去支付"];
    [_payButton setNormalColor:WHITE_COLOR highlighted:GRAY_COLOR selected:nil];
    
    [_payButton addTarget:self action:@selector(payAction:)
            forControlEvents:UIControlEventTouchUpInside];
    
    _payButton.alpha = 0.0f;

    return _payButton;
}

- (UIButton *) previewButton
{
    if (_previewButton) {
        return _previewButton;
    }
    _previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _previewButton.frame = CGRectMake(0, 0, 60, 24);
    _previewButton.backgroundColor = COLOR_BG_BUTTON;
    _previewButton.layer.masksToBounds = NO;
    _previewButton.layer.cornerRadius = 3.0f;
    _previewButton.titleLabel.font = [FontUtils smallFont];
    [_previewButton setNormalTitle:@"对账单"];
    [_previewButton setNormalColor:WHITE_COLOR highlighted:GRAY_COLOR selected:nil];
    
    [_previewButton addTarget:self action:@selector(previewAction:)
         forControlEvents:UIControlEventTouchUpInside];
    
    _previewButton.alpha = 0.0f;
    
    return _previewButton;
}

- (UIButton *) scanButton
{
    if (_scanButton) {
        return _scanButton;
    }
    _scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _scanButton.frame = CGRectMake(0, 0, 60, 24);
    _scanButton.backgroundColor = WHITE_COLOR;
    _scanButton.layer.masksToBounds = NO;
    _scanButton.layer.cornerRadius = 3.0f;
    _scanButton.layer.borderWidth = 0.5f;
    _scanButton.layer.borderColor = COLOR_SELECTED.CGColor;

    _scanButton.titleLabel.font = [FontUtils smallFont];
    [_scanButton setNormalTitle:@"扫码分拣"];
    [_scanButton setNormalColor:COLOR_SELECTED highlighted:COLOR_TEXT_NORMAL selected:nil];
    
    [_scanButton addTarget:self action:@selector(scanAction:)
             forControlEvents:UIControlEventTouchUpInside];
    
    _scanButton.alpha = 0.0f;
    
    return _scanButton;
}

- (CountDownView *) timeView
{
    if (!_timeView) {
        _timeView = [[CountDownView alloc] initWithFrame:CGRectZero];
        @weakify(self)
        _timeView.timeoutBlock = ^{
            @strongify(self)
            self.payButton.alpha = 0.0f;
            self.timeView.alpha = 0.0f;
            OrderCellLayout *cellLayout = (OrderCellLayout *)self.cellLayout;
            cellLayout.orderModel.status = 5;
            [cellLayout updateData];
            [self updateDisplay];
        };
        _timeView.alpha = 0.0f;
    }
    return _timeView;
}

@end
