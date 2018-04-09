//
//  IconButton.m
//  akucun
//
//  Created by Jarry on 2017/3/29.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "IconButton.h"

@interface IconButton ()

@property (nonatomic, strong) UILabel *iconLabel;

@end

@implementation IconButton

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = CLEAR_COLOR;
        
        self.textColor = COLOR_TEXT_NORMAL;
        self.iconColor = COLOR_TEXT_NORMAL;
        
        self.leftPadding = 0.0f;
        self.spacing = 6.0f;
        
        self.imageSize = 18.0f;
        
        self.titleLabel.font = [FontUtils normalFont];
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self setNormalColor:self.textColor highlighted:COLOR_SELECTED selected:nil];
        [self setTitleColor:COLOR_TEXT_LIGHT forState:UIControlStateDisabled];
        
        [self addSubview:self.iconLabel];
    }
    return self;
}

- (void) setImage:(NSString *)image
{
    _image = image;
    
    [self setNormalImage:image selectedImage:nil];
}

- (void) setTitle:(NSString *)title icon:(NSString *)icon
{
    [self setNormalTitle:title];
    
    if (icon) {
        [self setIcon:icon];
    }
}

- (void) setIcon:(NSString *)icon
{
    self.iconLabel.text = icon;
    [self.iconLabel sizeToFit];
    self.iconLabel.hidden = NO;
}

- (void) layoutSubviews
{
    [super layoutSubviews];

    self.iconLabel.left = self.leftPadding;
    self.iconLabel.centerY = (self.height)/2.0f;
}

- (void) setIconColor:(UIColor *)iconColor
{
    _iconColor = iconColor;
    self.iconLabel.textColor = iconColor;
}

- (void) setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    [self setNormalColor:textColor];
}

- (void) setTitleFont:(UIFont *)font
{
    [self.titleLabel setFont:font];
}

- (void) setIconFont:(UIFont *)font
{
    self.iconLabel.font = font;
}

//- (void) setTitleAlignment:(NSTextAlignment)textAlignment
//{
//    [self.titleLabel setTextAlignment:textAlignment];
//}

- (CGRect) imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(self.leftPadding, contentRect.origin.y, self.imageSize, contentRect.size.height);
}

- (CGRect) titleRectForContentRect:(CGRect)contentRect
{
    CGFloat left = 0.0f;
    if (!self.iconLabel.hidden) {
        left = 15 + self.spacing;
    }
    else if (self.image) {
        left = 18 + self.spacing;
    }
    
    return CGRectMake(contentRect.origin.x+left, contentRect.origin.y, contentRect.size.width-left, contentRect.size.height);
}

- (void) setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
   
    self.iconLabel.textColor = highlighted ? COLOR_SELECTED : self.iconColor;
}

- (void) setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    self.iconLabel.textColor = enabled ? self.iconColor : COLOR_TEXT_LIGHT;
}

- (UILabel *) iconLabel
{
    if (!_iconLabel) {
        _iconLabel = [[UILabel alloc] init];
        
        _iconLabel.textColor = self.iconColor;
        _iconLabel.font = FA_ICONFONTSIZE(15);
        
        _iconLabel.hidden = YES;
    }
    return _iconLabel;
}

@end
