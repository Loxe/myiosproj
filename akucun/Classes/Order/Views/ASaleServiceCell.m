//
//  ASaleServiceCell.m
//  akucun
//
//  Created by Jarry on 2017/9/12.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ASaleServiceCell.h"
#import "TextButton.h"
#import "SCImageView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ASaleServiceCell ()

@property (nonatomic, strong) SCImageView *productImage;

@property (nonatomic, strong) TextButton* accessoryButton;

@end

@implementation ASaleServiceCell

- (void) updateData
{
    ASaleCellLayout *cellLayout = (ASaleCellLayout *)self.cellLayout;
    [self.productImage sd_setImageWithURL:[NSURL URLWithString:[cellLayout.model imageUrl]] placeholderImage:nil options:SDWebImageDelayPlaceholder];
}

- (void) initContent
{
    [self.contentView addSubview:self.accessoryButton];
    [self.contentView addSubview:self.productImage];
}

- (void) customLayoutViews
{
    ASaleCellLayout *cellLayout = (ASaleCellLayout *)self.cellLayout;
    
    CGFloat offset = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
    CGFloat height = cellLayout.cellHeight - cellLayout.linePosition2 -  offset*0.2f;
    self.accessoryButton.frame = CGRectMake(self.contentView.right-60, cellLayout.linePosition2, 60, height);
    
    self.productImage.top = cellLayout.imageTop;
    self.productImage.hidden = NO;
}

#pragma mark - LWAsyncDisplayViewDelegate

// 额外的绘制
- (void) extraAsyncDisplayIncontext:(CGContextRef)context
                               size:(CGSize)size
                        isCancelled:(LWAsyncDisplayIsCanclledBlock)isCancelled
{
    if (!isCancelled()) {
        ASaleCellLayout *cellLayout = (ASaleCellLayout *)self.cellLayout;
        CGContextMoveToPoint(context, kOFFSET_SIZE, cellLayout.linePosition1);
        CGContextAddLineToPoint(context, self.bounds.size.width-kOFFSET_SIZE, cellLayout.linePosition1);
        CGContextMoveToPoint(context, kOFFSET_SIZE, cellLayout.linePosition2);
        CGContextAddLineToPoint(context, self.bounds.size.width-kOFFSET_SIZE, cellLayout.linePosition2);
        CGContextSetLineWidth(context, kPIXEL_WIDTH);
        CGContextSetStrokeColorWithColor(context,COLOR_SEPERATOR_LIGHT.CGColor);
        CGContextStrokePath(context);

        CGContextMoveToPoint(context, 0.0f, self.bounds.size.height);
        CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
        CGContextSetLineWidth(context, kPIXEL_WIDTH);
        CGContextSetStrokeColorWithColor(context,COLOR_SEPERATOR_LINE.CGColor);
        CGContextStrokePath(context);
    }
}

#pragma mark - Views

- (SCImageView *) productImage
{
    if (!_productImage) {
        CGFloat top = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
        _productImage = [[SCImageView alloc] initWithFrame:CGRectMake(kOFFSET_SIZE, top, 80, 80)];
        _productImage.backgroundColor = RGBCOLOR(240, 240, 240);
        _productImage.contentMode = UIViewContentModeScaleAspectFill;
        _productImage.clipsToBounds = YES;
//        _logoImage.userInteractionEnabled = YES;
        _productImage.hidden = YES;
    }
    return _productImage;
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

@end
