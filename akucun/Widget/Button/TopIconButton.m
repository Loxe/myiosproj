//
//  TopIconButton.m
//  akucun
//
//  Created by Jarry on 2017/6/19.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "TopIconButton.h"

@interface TopIconButton ()

@property (nonatomic, strong) UILabel *badgeLabel;

@property (nonatomic, copy) NSString *badgeText;

@end

@implementation TopIconButton

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = CLEAR_COLOR;
        
        self.textColor = COLOR_TEXT_DARK;
        
        self.titleLabel.font = [FontUtils smallFont];
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self setNormalColor:self.textColor highlighted:COLOR_SELECTED selected:nil];
        
        [self addSubview:self.badgeLabel];
    }
    return self;
}

- (void) setTitle:(NSString *)title image:(NSString *)image
{
    [self setNormalTitle:title];
    [self setNormalImage:image selectedImage:nil];
}

- (void) setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    [self setNormalColor:textColor];
}

- (void) setBadgeCount:(NSInteger)count
{
    if (count > 0) {
        NSString *text = kIntergerToString(count);
        [self setBadgeText:text];
        
        self.badgeLabel.alpha = 1.0f;
//        [UIView animateWithDuration:.2f animations:^{
//            self.badgeLabel.alpha = 1.0f;
//        }];
    }
    else {
        self.badgeLabel.alpha = 0.0f;
//        [UIView animateWithDuration:.2f animations:^{
//            self.badgeLabel.alpha = 0.0f;
//        }];
    }
}

- (void) setBadgeText:(NSString *)text
{
    if ([_badgeText isEqualToString:text]) {
        return;
    }
    _badgeText = text;
    self.badgeLabel.text = text;

    CGSize size = [text boundingRectWithSize:CGSizeMake(320, 60) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.badgeLabel.font} context:nil].size;
    
    CGFloat width = MAX(20, (size.width + 10.0f));
    [UIView animateWithDuration:.2f animations:^{
        self.badgeLabel.width = width;
    }];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    self.badgeLabel.centerX = self.width/2.0f+18;
    self.badgeLabel.top = -5.0f;
}

- (CGRect) imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.origin.x, contentRect.origin.y , contentRect.size.width, contentRect.size.height-25);
}

- (CGRect) titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.origin.x, contentRect.size.height - 20, contentRect.size.width, 20);
}

- (UILabel *) badgeLabel
{
    if (!_badgeLabel) {
        _badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20.0f, 20.0f)];
        _badgeLabel.clipsToBounds = YES;
        _badgeLabel.userInteractionEnabled = NO;
        _badgeLabel.backgroundColor = COLOR_SELECTED;
        _badgeLabel.textColor = WHITE_COLOR;
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.adjustsFontSizeToFitWidth = YES;
        _badgeLabel.font = SYSTEMFONT(12);
        _badgeLabel.layer.cornerRadius = 10.0f;
        
        _badgeLabel.alpha = 0.0f;
    }
    return _badgeLabel;
}

@end
