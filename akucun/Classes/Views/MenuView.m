//
//  MenuView.m
//  akucun
//
//  Created by Jarry on 2017/3/31.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "MenuView.h"

@interface MenuView ()


@end

@implementation MenuView

#pragma mark - LifeCycle

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.show = NO;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.forwardButton];
        [self addSubview:self.commentButton];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    [self setNeedsDisplay];
    self.commentButton.frame = CGRectMake(0, 0, 80, self.bounds.size.height);
    self.forwardButton.frame = CGRectMake(80, 0, 80, self.bounds.size.height);
}

- (void) drawRect:(CGRect)rect
{
    [super drawRect:rect];
    UIBezierPath* beizerPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5.0f];
    [RGBACOLOR(76, 81, 84, 0.95) setFill];
    [beizerPath fill];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, rect.size.width/2, 5.0f);
    CGContextAddLineToPoint(context, rect.size.width/2, rect.size.height - 5.0f);
    CGContextSetLineWidth(context, 1.0f);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextStrokePath(context);
}

#pragma mark - Actions

- (void) clickedMenu
{
    if (self.show) {
        [self menuHide:YES];
    } else {
        [self menuShow];
    }
}

- (void) menuShow
{
    [UIView animateWithDuration:0.2f
                          delay:0.0f
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.0f
                        options:0
                     animations:^{
                         self.frame = CGRectMake(self.frame.origin.x - 160,
                                                 self.frame.origin.y,
                                                 160,
                                                 34.0f);
                     } completion:^(BOOL finished) {
                         self.show = YES;
                     }];
}

- (void) menuHide:(BOOL)animated
{
    if (!self.show) {
        return;
    }
    
    if (!animated) {
        self.frame = CGRectMake(self.frame.origin.x + 160,
                                self.frame.origin.y,
                                0.0f,
                                34.0f);
        self.show = NO;
        [self removeFromSuperview];
        return;
    }
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
         usingSpringWithDamping:0.7f
          initialSpringVelocity:0.0f
                        options:0
                     animations:^{
                         self.frame = CGRectMake(self.frame.origin.x + 160,
                                                 self.frame.origin.y,
                                                 0.0f,
                                                 34.0f);
                     } completion:^(BOOL finished) {
                         self.frame = CGRectMake(self.frame.origin.x,
                                                 self.frame.origin.y,
                                                 0.0f,
                                                 34.0f);
                         self.show = NO;
                         [self removeFromSuperview];
                     }];
}

#pragma mark - 

- (UIButton *) forwardButton
{
    if (_forwardButton) {
        return _forwardButton;
    }
    
    _forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_forwardButton setNormalColor:WHITE_COLOR highlighted:COLOR_SELECTED selected:nil];
    [_forwardButton setTitle:@" 转发" forState:UIControlStateNormal];
    //    [_commentButton setImage:[UIImage imageNamed:@"c.png"] forState:UIControlStateNormal];
    [_forwardButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    return _forwardButton;
}

- (UIButton *) commentButton
{
    if (_commentButton) {
        return _commentButton;
    }
    
    _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commentButton setNormalColor:WHITE_COLOR highlighted:COLOR_SELECTED selected:nil];
    [_commentButton setTitle:@" 评论" forState:UIControlStateNormal];
//    [_commentButton setImage:[UIImage imageNamed:@"c.png"] forState:UIControlStateNormal];
    [_commentButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    return _commentButton;
}

@end
