//
//  OrderDetailTableCell.m
//  akucun
//
//  Created by Jarry on 2017/4/18.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "OrderDetailTableCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TextButton.h"
#import "SCImageView.h"
#import "LWImageBrowser.h"
#import "LWAsyncDisplayView.h"

@interface OrderDetailTableCell ()

@property (nonatomic, strong) SCImageView *productImage;
@property (nonatomic, strong) TextButton *statusButton;

@property (nonatomic, strong) UIButton *actionButton;

@property (nonatomic, strong) TextButton *remarkButton;

@end

@implementation OrderDetailTableCell

- (NSString *) statusText
{
    NSString *statusText = @"";
    switch (self.status) {
        case ProductStatusInit:
        {
            statusText = @"换尺码";
        }
            break;
        case ProductStatusWeifahuo:
        {
            statusText = @"换尺码";
        }
            break;
        case ProductStatusYifahuo:
        {
            statusText = @"申请售后";
        }
            break;
        case ProductStatusFahuo:
        {
            statusText = @"";
        }
            break;
        case ProductStatusCancel:
        {
            statusText = @"已取消";
        }
            break;
        case ProductStatusQuehuo:
        {
            statusText = @"平台缺货 退款中";
        }
            break;
        case ProductStatusTuihuo:
        {
            statusText = @"退货 已退款";
        }
            break;
        case ProductStatusTuikuan:
        {
            statusText = @"用户取消 退款中";
        }
            break;
        case ProductStatusPending:
        {
            statusText = @"退货中";
        }
            break;
            
        case ProductStatusTuikuanDone:
        {
            statusText = @"用户取消 已退款";
        }
            break;
        case ProductStatusQuehuoDone:
        {
            statusText = @"平台缺货 已退款";
        }
            break;

        case ProductASaleSubmit:
        case ProductASaleRejected:
        case ProductASalePending:
        case ProductASaleLoufaBufa:
        case ProductASaleLoufaTuikuan:
        case ProductASaleTuihuoBufa:
        case ProductASaleTuihuoTuikuan:
        case ProductASaleTuihuoPending:
        {
            statusText = @"售后进度";
        }
            break;
            
        default:
            break;
    }
    return statusText;
}

- (void) updateData
{
    CartCellLayout *cellLayout = (CartCellLayout *)self.cellLayout;
    
    [self.productImage sd_setImageWithURL:[NSURL URLWithString:[cellLayout.cartProduct imageUrl]]];
    
    NSString *remark = cellLayout.cartProduct.remark;
    if (remark && remark.length > 0) {
        UIColor *color = COLOR_TEXT_NORMAL;
        if (cellLayout.cartProduct.scanstatu > 0) {
            color = COLOR_APP_GREEN;
        }
        self.remarkButton.width = SCREEN_WIDTH*0.5;
        [self.remarkButton setNormalTitle:FORMAT(@"备注：%@", remark)];
        [self.remarkButton setTitleAlignment:NSTextAlignmentLeft];
        [self.remarkButton setNormalColor:color highlighted:COLOR_SELECTED selected:nil];
        self.remarkButton.layer.borderWidth = 0.0f;
    }
    else {
        self.remarkButton.width = 45;
        [self.remarkButton setNormalTitle:@"备注"];
        [self.remarkButton setTitleAlignment:NSTextAlignmentCenter];
        [_remarkButton setNormalColor:COLOR_SELECTED highlighted:COLOR_TEXT_NORMAL selected:nil];
        self.remarkButton.layer.borderWidth = 1.0f;
    }

    self.status = cellLayout.cartProduct.status;
//    self.actionButton.hidden = YES;
    
    if (self.showStatus) {
        self.statusButton.backgroundColor = CLEAR_COLOR;
        self.statusButton.enabled = NO;
        self.statusButton.width = 100;
        [self.statusButton setNormalTitle:[cellLayout.cartProduct statusText]];
        [self.statusButton setTitleAlignment:NSTextAlignmentRight];
        if (cellLayout.cartProduct.scanstatu > 0) {
            [self.statusButton setNormalTitle:@"已扫码分拣"];
        }
        return;
    }

    if (self.status == ProductStatusInit ||
        self.status == ProductStatusWeifahuo ||
        self.status == ProductStatusYifahuo ||
        (self.status >= ProductASaleSubmit && self.status <= ProductASaleTuihuoPending))
    {
        // 申请售后 按钮
        if (cellLayout.cartProduct.isvirtual && self.status == ProductStatusYifahuo) {
            // 虚拟商品不支持售后
            self.statusButton.backgroundColor = CLEAR_COLOR;
            self.statusButton.enabled = NO;
            self.statusButton.width = 120;
            [self.statusButton setNormalTitle:[cellLayout.cartProduct statusText]];
            [self.statusButton setTitleAlignment:NSTextAlignmentRight];
            [self.statusButton setNormalTitle:@"虚拟商品不退不换"];
            return;
        }
        
        self.statusButton.backgroundColor = COLOR_BG_BUTTON;
        self.statusButton.enabled = YES;
        self.statusButton.width = 70;
        [self.statusButton setNormalTitle:[self statusText]];
        [self.statusButton setTitleAlignment:NSTextAlignmentCenter];

        if (self.status == ProductStatusInit ||
            self.status == ProductStatusWeifahuo) {
            [self.actionButton setNormalTitle:@"取 消"];
        }
        else if (self.status >= ProductASaleSubmit && self.status <= ProductASaleTuihuoPending) {
            self.statusButton.backgroundColor = RED_COLOR;
        }
        /*
        if (cellLayout.cartProduct.scanstatu > 0) {
            self.statusButton.backgroundColor = CLEAR_COLOR;
            self.statusButton.enabled = NO;
            [self.statusButton setNormalTitle:@"已扫码分拣"];
        }*/
    }
    else
    {
        //其他状态按钮不可按
        self.statusButton.backgroundColor = CLEAR_COLOR;
        self.statusButton.enabled = NO;
        self.statusButton.width = 100;
//        [self.statusButton setNormalTitle:[self statusText]];
        [self.statusButton setNormalTitle:[cellLayout.cartProduct statusText]];
        [self.statusButton setTitleAlignment:NSTextAlignmentRight];
        
        /*
        if (cellLayout.cartProduct.scanstatu > 0) {
            [self.statusButton setNormalTitle:@"已扫码分拣"];
        }*/
    }
}

- (void) initContent
{
    [self.contentView addSubview:self.productImage];
    [self.contentView addSubview:self.statusButton];
    [self.contentView addSubview:self.actionButton];
    [self.contentView addSubview:self.remarkButton];
}

- (void) customLayoutViews
{
    CartCellLayout *cellLayout = (CartCellLayout *)self.cellLayout;
    
    self.productImage.frame = cellLayout.imagePosition;
    self.productImage.alpha = 1.0f;

    self.statusButton.right = SCREEN_WIDTH - kOFFSET_SIZE;
    self.statusButton.top = cellLayout.buttonPosition;
    
    self.actionButton.right = self.statusButton.left - kOFFSET_SIZE*0.5f;
    self.actionButton.top = cellLayout.buttonPosition;
    
    self.remarkButton.left = kOFFSET_SIZE;
    self.remarkButton.top = cellLayout.buttonPosition;
    self.remarkButton.alpha = 1.0f;
//    BOOL showCancel = YES;
    
    self.actionButton.hidden = YES;
    
    if (self.showStatus) {
        self.statusButton.hidden = NO;
        return;
    }
    
    if (self.status == ProductStatusInit) {
        self.statusButton.hidden = cellLayout.cartProduct.outaftersale;
    }
    else if (self.status == ProductStatusWeifahuo)
    {
        self.statusButton.hidden = cellLayout.cartProduct.outaftersale;
        self.actionButton.hidden = cellLayout.cartProduct.outaftersale;
    }
    else if (self.status == ProductStatusYifahuo)
    {
        self.statusButton.hidden = cellLayout.cartProduct.outaftersale;
    }
//    else if (self.status >= ProductStatusAppeal &&
//             self.status <= ProudctStatusRefund)
//    {
//        self.statusButton.hidden = cellLayout.cartProduct.outaftersale;
//        self.actionButton.hidden = cellLayout.cartProduct.outaftersale;
//    }
    else {
        self.statusButton.hidden = NO;
    }
}

#pragma mark - Actions

- (IBAction) statusAction:(id)sender
{
    NSInteger action = 0;
    if (self.status == ProductStatusInit) {
        action = ProductActionChange;
    }
    else if (self.status == ProductStatusWeifahuo) {
        action = ProductActionChange;
    }
    else if (self.status == ProductStatusYifahuo) {
        action = ProductActionApply;
    }
    else if (self.status >= ProductASaleSubmit && self.status <= ProductASaleTuihuoPending) {
        action = ProductActionAfterSale;
    }
    
    CartCellLayout *cellLayout = (CartCellLayout *)self.cellLayout;
    if (self.clickedActionCallback) {
        self.clickedActionCallback(self, action, cellLayout.cartProduct);
    }
}

- (IBAction) buttonAction:(id)sender
{
    NSInteger action = ProductActionNone;
    if (self.status == ProductStatusWeifahuo) {
        action = ProductActionTuikuan;
    }
    else if (self.status == ProductStatusYifahuo ||
             self.status == ProductStatusFahuo)
    {
        action = ProductActionTuihuo;
    }
    
    CartCellLayout *cellLayout = (CartCellLayout *)self.cellLayout;
    if (self.clickedActionCallback) {
        self.clickedActionCallback(self, action, cellLayout.cartProduct);
    }
}

- (IBAction) remarkAction:(id)sender
{
    CartCellLayout *cellLayout = (CartCellLayout *)self.cellLayout;
    if (self.clickedRemarkCallback) {
        self.clickedRemarkCallback(self, cellLayout.cartProduct);
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
    [browser show];
}

#pragma mark - LWAsyncDisplayViewDelegate

// 额外的绘制
- (void) extraAsyncDisplayIncontext:(CGContextRef)context
                               size:(CGSize)size
                        isCancelled:(LWAsyncDisplayIsCanclledBlock)isCancelled
{
    if (!isCancelled()) {
        CGContextMoveToPoint(context, 0, self.bounds.size.height);
        CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
        CGContextSetLineWidth(context, 0.5f);
        CGContextSetStrokeColorWithColor(context,RGB(220.0f, 220.0f, 220.0f, 1).CGColor);
        CGContextStrokePath(context);
    }
}

//点击LWTextStorage
- (void) lwAsyncDisplayView:(LWAsyncDisplayView *)asyncDisplayView
     didCilickedTextStorage:(LWTextStorage *)textStorage
                   linkdata:(id)data
{
    if ([data isKindOfClass:[NSString class]]) {
        //
        [self becomeFirstResponder];
        UIMenuItem* copyLink = [[UIMenuItem alloc] initWithTitle:@"复制"
                                                          action:@selector(copyText)];
        [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:copyLink, nil]];
        
        CGRect rect = CGRectMake(textStorage.center.x - 50.0f, textStorage.top, 100.0f, 50.0f);
        [UIMenuController sharedMenuController].arrowDirection = UIMenuControllerArrowDown;
        [[UIMenuController sharedMenuController] setTargetRect:rect inView:self];
        [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
    }
}

- (void) copyText
{
    CartCellLayout *cellLayout = (CartCellLayout *)self.cellLayout;
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = cellLayout.cartProduct.extrainfo;
    
    [SVProgressHUD showInfoWithStatus:@"内容已复制"];
    
    [self resignFirstResponder];
    [self.asyncDisplayView removeHighlightIfNeed];
}

- (BOOL) canPerformAction:(SEL)action withSender:(id)sender
{
    if(action == @selector(copyText)){
        return YES;
    }
    return [super canPerformAction:action withSender:sender];
}

- (BOOL) canBecomeFirstResponder
{
    return YES;
}

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

- (TextButton *) statusButton
{
    if (_statusButton) {
        return _statusButton;
    }
    _statusButton = [TextButton buttonWithType:UIButtonTypeCustom];
    _statusButton.frame = CGRectMake(0, 0, 70, 24);
    _statusButton.backgroundColor = COLOR_BG_BUTTON;
    _statusButton.layer.masksToBounds = NO;
    _statusButton.layer.cornerRadius = 3.0f;
    _statusButton.titleLabel.font = [FontUtils smallFont];

    [_statusButton setNormalColor:WHITE_COLOR highlighted:COLOR_SELECTED selected:nil];
    
    [_statusButton setNormalTitleColor:nil disableColor:RED_COLOR];
    
    [_statusButton addTarget:self action:@selector(statusAction:)
            forControlEvents:UIControlEventTouchUpInside];
    
    _statusButton.hidden = YES;
    
    return _statusButton;
}

- (UIButton *) actionButton
{
    if (_actionButton) {
        return _actionButton;
    }
    _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _actionButton.frame = CGRectMake(0, 0, 60, 24);
    _actionButton.backgroundColor = CLEAR_COLOR;
    _actionButton.layer.masksToBounds = NO;
    _actionButton.layer.cornerRadius = 3.0f;
    _actionButton.layer.borderWidth = 0.5f;
    _actionButton.layer.borderColor = COLOR_SELECTED.CGColor;

    _actionButton.titleLabel.font = [FontUtils smallFont];
    [_actionButton setNormalColor:COLOR_SELECTED highlighted:COLOR_TEXT_NORMAL selected:nil];
    
    [_actionButton addTarget:self action:@selector(buttonAction:)
            forControlEvents:UIControlEventTouchUpInside];
    
    _actionButton.hidden = YES;
    
    return _actionButton;
}

- (TextButton *) remarkButton
{
    if (_remarkButton) {
        return _remarkButton;
    }
    _remarkButton = [TextButton buttonWithType:UIButtonTypeCustom];
    _remarkButton.frame = CGRectMake(0, 0, 45, 24);
    _remarkButton.backgroundColor = CLEAR_COLOR;
    _remarkButton.layer.masksToBounds = NO;
    _remarkButton.layer.cornerRadius = 3.0f;
    _remarkButton.layer.borderWidth = .5f;
    _remarkButton.layer.borderColor = RED_COLOR.CGColor;
    
    [_remarkButton setTitleAlignment:NSTextAlignmentCenter];
    _remarkButton.titleLabel.font = [FontUtils smallFont];
    [_remarkButton setNormalTitle:@"备注"];
    [_remarkButton setNormalColor:COLOR_SELECTED highlighted:COLOR_TEXT_NORMAL selected:nil];
    
    [_remarkButton addTarget:self action:@selector(remarkAction:)
            forControlEvents:UIControlEventTouchUpInside];
    
    _remarkButton.alpha = 0.0f;
    
    return _remarkButton;
}

@end
