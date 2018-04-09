//
//  CoverLayerView.m
//  akucun
//
//  Created by Jarry on 2017/4/28.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "CoverLayerView.h"

@interface CoverLayerView ()

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation CoverLayerView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.backgroundColor = [WHITE_COLOR colorWithAlphaComponent:0.5f];
    
    self.text = @"光";
    [self addSubview:self.textLabel];
    
    return self;
}

- (void) setText:(NSString *)text
{
    _text = text;
    
    self.textLabel.text = text;
}

- (void) setFont:(UIFont *)font
{
    _font = font;
    self.textLabel.font = font;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.width / 2.0f;
    self.textLabel.size = CGSizeMake(width, width);
    self.textLabel.centerX = self.width / 2.0f;
    self.textLabel.centerY = self.height / 2.0f;
    self.textLabel.layer.cornerRadius = width / 2.0f;;
}

- (UILabel *) textLabel
{
    if (!_textLabel) {
        _textLabel  = [[UILabel alloc] init];
        _textLabel.frame = CGRectMake(0, 0, 100, 100);
        _textLabel.textColor = RGBCOLOR(0xEE, 0xEE, 0xEE);
        _textLabel.font = SYSTEMFONT(40);
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.adjustsFontSizeToFitWidth = YES;
        _textLabel.text = self.text;
        
        _textLabel.layer.backgroundColor = [BLACK_COLOR colorWithAlphaComponent:0.4f].CGColor;
        _textLabel.layer.masksToBounds = NO;
        _textLabel.layer.cornerRadius = 50;
    }
    return _textLabel;
}

@end
