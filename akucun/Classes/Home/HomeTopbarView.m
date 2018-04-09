//
//  HomeTopbarView.m
//  akucun
//
//  Created by Jarry Zhu on 2017/12/28.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HomeTopbarView.h"

@interface HomeTopbarView ()

@property (nonatomic, weak) UIView *underLine;

@property (nonatomic, strong) NSMutableArray *titleButtons;

@property (nonatomic, strong) UIFont *font;

@end

@implementation HomeTopbarView

- (void) showBadgeAt:(NSInteger)index
{
    if (index >= self.titleButtons.count) {
        return;
    }
    UIButton *button = [self.titleButtons objectAtIndex:index];
    [button showBadgeWithStyle:WBadgeStyleRedDot value:1 animationType:WBadgeAnimTypeScale];
}

- (void) clearBadgeAt:(NSInteger)index
{
    if (index >= self.titleButtons.count) {
        return;
    }
    UIButton *button = [self.titleButtons objectAtIndex:index];
    [button clearBadge];
}

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = WHITE_COLOR;
        
        _currentIndex = -1;
        _titleButtons = [NSMutableArray new];
        
        self.font = BOLDSYSTEMFONT(14);
        
        self.contentSize = CGSizeMake(frame.size.width, 25);
        self.showsHorizontalScrollIndicator = NO;
    }
    
    return self;
}

- (void) initTitles:(NSArray *)titles
{
    CGFloat buttonWidth = self.frame.size.width / titles.count;
    CGFloat buttonHeight = self.frame.size.height;
    
    [titles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = CLEAR_COLOR;
        
        if ([title hasSuffix:@".png"]) {
            [button setImage:IMAGENAMED(title) forState:UIControlStateNormal];
        }
        else {
            button.titleLabel.font = self.font;
            [button setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
            [button setTitle:title forState:UIControlStateNormal];
        }
        
        button.frame = CGRectMake(buttonWidth * idx, 0, buttonWidth, buttonHeight);
        button.tag = idx;
        [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        
        CGSize size = [title boundingRectWithSize:CGSizeMake(320, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
        CGFloat offset = (buttonWidth-size.width)*0.5f;
        button.badgeBgColor = COLOR_SELECTED;
        [button clearBadge];
        button.badgeCenterOffset = CGPointMake(-offset, 12);
        
        [_titleButtons addObject:button];
        [self addSubview:button];
        [self sendSubviewToBack:button];
    }];
    
//    [firstTitle setTitleColor:COLOR_SELECTED forState:UIControlStateNormal];
//    firstTitle.transform = CGAffineTransformMakeScale(1.1, 1.1);
    
    UIView * underLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, buttonWidth, 3)];
    underLine.backgroundColor = COLOR_SELECTED;
    underLine.top = self.height - underLine.height;
    underLine.alpha = 0.0f;
    [self addSubview:underLine];
    _underLine = underLine;
    
    /*
    // 默认选中第一个
    UIButton *firstTitle = _titleButtons[0];
    NSString *title = firstTitle.titleLabel.text;
    CGSize size = [title boundingRectWithSize:CGSizeMake(320, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
    CGFloat left = buttonWidth * _currentIndex + (buttonWidth - size.width) / 2.0f - 2;
    [UIView animateWithDuration:.3f animations:^{
        [firstTitle setTitleColor:COLOR_SELECTED forState:UIControlStateNormal];
        firstTitle.transform = CGAffineTransformMakeScale(1.1, 1.1);
        self.underLine.alpha = 1.0f;
        self.underLine.left =  left;
        self.underLine.width = size.width*1.1;
    }];
     */
}

- (void) selectIndex:(NSInteger)index
{
    if (index >= _titleButtons.count) {
        return;
    }
    
    if (_currentIndex == index) {
        return;
    }
    
    if (_currentIndex >= 0) {
        UIButton *preTitle = _titleButtons[_currentIndex];
        [UIView animateWithDuration:.25f animations:^{
            [preTitle setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
            preTitle.transform = CGAffineTransformIdentity;
        }];
    }
    
    _currentIndex = index;
    UIButton *button = _titleButtons[_currentIndex];
    NSString *title = button.titleLabel.text;
    CGSize size = [title boundingRectWithSize:CGSizeMake(320, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
    CGFloat width = self.width / self.titleButtons.count;
    CGFloat btnWidth = size.width;
    if (btnWidth == 0) {
        btnWidth = 60;
    }
    CGFloat left = width * _currentIndex + (width - btnWidth) / 2.0f - 2;
    
    [UIView animateWithDuration:.25f animations:^{
        [button setTitleColor:COLOR_SELECTED forState:UIControlStateNormal];
        button.transform = CGAffineTransformMakeScale(1.1, 1.1);
        
        self.underLine.alpha = 1.0f;
        self.underLine.left =  left;
        self.underLine.width = btnWidth*1.1;
    }];
}

- (void) animationWithOffset:(CGFloat)offsetRatio from:(NSInteger)index to:(NSInteger)toIndex
{
    UIButton *titleFrom = self.titleButtons[index];
    UIButton *titleTo = self.titleButtons[toIndex];

    [UIView transitionWithView:titleFrom duration:0.1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
//        [titleFrom setTitleColor:[UIColor colorWithRed:1.0f green:colorValue1*(1-offsetRatio) blue:colorValue2*(1-offsetRatio) alpha:1.0]
//                        forState:UIControlStateNormal];
        titleFrom.transform = CGAffineTransformMakeScale(1 + 0.1 * offsetRatio, 1 + 0.1 * offsetRatio);
    } completion:nil];
    
    
    [UIView transitionWithView:titleTo duration:0.1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
//        [titleTo setTitleColor:[UIColor colorWithRed:1.0f green:colorValue1*offsetRatio blue:colorValue2*offsetRatio alpha:1.0]
//                      forState:UIControlStateNormal];
        titleTo.transform = CGAffineTransformMakeScale(1 + 0.1 * (1-offsetRatio), 1 + 0.1 * (1-offsetRatio));
    } completion:nil];
}

- (void) onClick:(UIButton *)button
{
    if (_currentIndex != button.tag) {
        /*
        UIButton *preTitle = _titleButtons[_currentIndex];
        
        _currentIndex = button.tag;

        NSString *title = button.titleLabel.text;
        CGSize size = [title boundingRectWithSize:CGSizeMake(320, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
        CGFloat width = self.width / self.titleButtons.count;
        CGFloat left = width * _currentIndex + (width - size.width) / 2.0f - 2;

        [UIView animateWithDuration:.3f animations:^{
            [preTitle setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
            preTitle.transform = CGAffineTransformIdentity;
            
            [button setTitleColor:COLOR_SELECTED forState:UIControlStateNormal];
            button.transform = CGAffineTransformMakeScale(1.1, 1.1);
            
            self.underLine.alpha = 1.0f;
            self.underLine.left =  left;
            self.underLine.width = size.width*1.1;
        }];*/
        
        [self selectIndex:button.tag];
        
        if (self.titleButtonClicked) {
            self.titleButtonClicked(_currentIndex);
        }
    }
}

- (void) drawRect:(CGRect)rect
{
    [super drawRect:rect];
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    [COLOR_SEPERATOR_LINE set];
    CGContextFillRect(context, CGRectMake(0.0f, rect.size.height-kPIXEL_WIDTH, rect.size.width, kPIXEL_WIDTH));
}

@end
