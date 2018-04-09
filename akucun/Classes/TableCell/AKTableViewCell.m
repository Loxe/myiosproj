//
//  AKTableViewCell.m
//  akucun
//
//  Created by Jarry on 2017/4/2.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "AKTableViewCell.h"
#import "Gallop.h"

@interface AKTableViewCell () <LWAsyncDisplayViewDelegate>

@property (nonatomic, strong) UIView *seperatorLine;

@end

@implementation AKTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = WHITE_COLOR;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.asyncDisplayView];
        
        [self initContent];
    }
    return self;
}

- (void) initContent
{
    _seperatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kPIXEL_WIDTH)];
    _seperatorLine.backgroundColor = COLOR_SEPERATOR_LINE;
    _seperatorLine.alpha = 0.0f;
    [self.contentView addSubview:_seperatorLine];
}

- (void) updateData
{
    
}

- (void) updateDisplay
{
    [self.asyncDisplayView.layer setNeedsDisplay];
}

- (void) setShowSeperator:(BOOL)showSeperator
{
    _showSeperator = showSeperator;
    self.seperatorLine.alpha = showSeperator ? 1.0f : 0.0f;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.asyncDisplayView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.cellLayout.cellHeight);
    
    self.seperatorLine.frame = CGRectMake(kOFFSET_SIZE, self.height-kPIXEL_WIDTH, self.width-kOFFSET_SIZE, kPIXEL_WIDTH);
    
    //主线程runloop空闲时执行
    LWTransaction* layerAsyncTransaction = self.layer.lw_asyncTransaction;
    [layerAsyncTransaction
     addAsyncOperationWithTarget:self
     selector:@selector(customLayoutViews)
     object:nil
     completion:^(BOOL canceled) {}];
}

- (void) customLayoutViews
{
    
}

- (void) setCellLayout:(AKCellLayout *)cellLayout
{
    if (_cellLayout != cellLayout) {
        _cellLayout = cellLayout;
        self.asyncDisplayView.layout = self.cellLayout;
        
        //主线程runloop空闲时执行
        LWTransaction* layerAsyncTransaction = self.layer.lw_asyncTransaction;
        [layerAsyncTransaction
         addAsyncOperationWithTarget:self
         selector:@selector(updateCellLayout)
         object:nil
         completion:^(BOOL canceled) {}];
    }
    else {
        [cellLayout updateData];
        [self.asyncDisplayView.layer setNeedsDisplay];
    }
    
    [self updateData];
}

- (void) updateCellLayout
{
    
}

- (void) coverScreenshotAndDelayRemoved:(UITableView *)tableView
                             cellHeight:(CGFloat)cellHeight
{
    UIImage* screenshot = [GallopUtils screenshotFromView:self];
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:[tableView convertRect:self.frame toView:tableView]];
    
    imgView.frame = CGRectMake(imgView.frame.origin.x,
                               imgView.frame.origin.y,
                               imgView.frame.size.width,
                               cellHeight);
    
    imgView.contentMode = UIViewContentModeTop;
    imgView.backgroundColor = [UIColor whiteColor];
    imgView.image = screenshot;
    [tableView addSubview:imgView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [imgView removeFromSuperview];
    });
}

#pragma mark - LWAsyncDisplayViewDelegate

// 额外的绘制
- (void) extraAsyncDisplayIncontext:(CGContextRef)context
                               size:(CGSize)size
                        isCancelled:(LWAsyncDisplayIsCanclledBlock)isCancelled
{
    if (!isCancelled() && !self.showSeperator) {
        CGContextMoveToPoint(context, 0.0f, self.bounds.size.height-kPIXEL_WIDTH);
        CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height-kPIXEL_WIDTH);
        CGContextSetLineWidth(context, kPIXEL_WIDTH);
        CGContextSetStrokeColorWithColor(context,RGB(220.0f, 220.0f, 220.0f, 1).CGColor);
        CGContextStrokePath(context);
    }
}

#pragma mark - Getter

- (LWAsyncDisplayView *) asyncDisplayView
{
    if (!_asyncDisplayView) {
        _asyncDisplayView = [[LWAsyncDisplayView alloc] initWithFrame:CGRectZero];
        _asyncDisplayView.displaysAsynchronously = NO;
        _asyncDisplayView.delegate = self;
    }
    return _asyncDisplayView;
}

@end
