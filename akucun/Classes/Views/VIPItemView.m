//
//  VIPItemView.m
//  akucun
//
//  Created by Jarry on 2017/8/20.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "VIPItemView.h"

@implementation VIPItemView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.backgroundColor = RGBCOLOR(0xF9, 0xF9, 0xF9);
    
    self.layer.borderColor = COLOR_SELECTED.CGColor;
    self.layer.borderWidth = 2.0f;
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.despLabel];
    [self addSubview:self.priceLabel];
    [self addSubview:self.checkedLabel];

    //    _lineView = [[UIView alloc] initWithFrame:CGRectMake(kOFFSET_SIZE, 0.0f, SCREEN_WIDTH-kOFFSET_SIZE, 0.5f)];
    //    _lineView.backgroundColor = COLOR_SEPERATOR_LIGHT;
    //    [self addSubview:_lineView];
    
    return self;
}

- (void) setTitle:(NSString *)title desp:(NSString *)desp price:(NSString *)price
{
    if (title) {
        self.titleLabel.text = title;
        [self.titleLabel sizeToFit];
    }
    if (price) {
        self.priceLabel.text = price;
        [self.priceLabel sizeToFit];
    }
    
    [self setNeedsLayout];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.left = kOFFSET_SIZE;
    self.titleLabel.top = kOFFSET_SIZE * 1.2;
    
    self.despLabel.left = kOFFSET_SIZE;
    self.despLabel.bottom = self.height - kOFFSET_SIZE * 1.2;
    
    self.checkedLabel.right = self.width;
    
    self.priceLabel.right = self.width - kOFFSET_SIZE;
    self.priceLabel.centerY = self.height * 0.5;
}

- (void) drawRect:(CGRect)rect
{
    CGFloat width = kOFFSET_SIZE * 2;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, self.bounds.size.width, 0);
    CGContextAddLineToPoint(context, self.bounds.size.width, width);
    CGContextAddLineToPoint(context, self.bounds.size.width - width, 0);
    CGContextSetFillColorWithColor(context, COLOR_SELECTED.CGColor);
    CGContextFillPath(context);
}

- (UILabel *) titleLabel
{
    if (!_titleLabel) {
        _titleLabel  = [[UILabel alloc] init];
        _titleLabel.backgroundColor = CLEAR_COLOR;
        _titleLabel.textColor = COLOR_TEXT_DARK;
        _titleLabel.font = BOLDSYSTEMFONT(17);
        _titleLabel.text = @"一年期会员";
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UILabel *) despLabel
{
    if (!_despLabel) {
        _despLabel  = [[UILabel alloc] init];
        _despLabel.backgroundColor = CLEAR_COLOR;
        _despLabel.textColor = COLOR_TEXT_NORMAL;
        _despLabel.font = [FontUtils smallFont];
        _despLabel.text = @"有效期一年，购买立即生效";
        [_despLabel sizeToFit];
    }
    return _despLabel;
}

- (UILabel *) priceLabel
{
    if (!_priceLabel) {
        _priceLabel  = [[UILabel alloc] init];
        _priceLabel.backgroundColor = CLEAR_COLOR;
        _priceLabel.textColor = COLOR_SELECTED;
        _priceLabel.font = BOLDSYSTEMFONT(20);
        _priceLabel.text = @"¥ --";
    }
    return _priceLabel;
}

- (UILabel *) checkedLabel
{
    if (!_checkedLabel) {
        CGFloat width = kOFFSET_SIZE * 1.1f;
        _checkedLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        _checkedLabel.backgroundColor = CLEAR_COLOR;
        _checkedLabel.textColor = WHITE_COLOR;
        _checkedLabel.font = ICON_FONT(16); //FA_ICONFONTSIZE(16);
        _checkedLabel.text = @"\ue5ca"; //kIconChecked;
    }
    return _checkedLabel;
}

@end
