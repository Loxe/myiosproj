//
//  ECTabBar.m
//  EachingMobile
//
//  Created by Jarry on 15/5/8.
//  Copyright (c) 2015年 Sucang. All rights reserved.
//

#import "ECTabBar.h"

@interface ECTabBar ()

@property (nonatomic) CGFloat itemWidth;
@property (nonatomic) UIView *backgroundView;
@property UIEdgeInsets contentEdgeInsets;

@end

@implementation ECTabBar

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

- (id) init
{
    return [self initWithFrame:CGRectZero];
}

- (void) commonInitialization
{
    self.contentEdgeInsets = UIEdgeInsetsMake(0.5f, 0, kSafeAreaBottomHeight, 0);
    
    _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:_backgroundView];
    
    [self setTranslucent:NO];
}

//- (ECTabButton *) centerButton
//{
//    if (!_centerButton) {
//        CGFloat width = CGRectGetHeight(self.frame) - 10;
//        CGRect frame = CGRectMake((SCREEN_WIDTH-width)/2, 5, width, width);
//        _centerButton = [[ECTabButton alloc] initWithFrame:frame];
//    }
//    return _centerButton;
//}

- (void) setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:CLEAR_COLOR];
    
    self.backgroundView.backgroundColor = backgroundColor;
}

- (void) layoutSubviews
{
    CGSize frameSize = self.frame.size;
    CGFloat minimumContentHeight = CGRectGetHeight(self.frame);
    
    [self.backgroundView setFrame:CGRectMake(0, self.contentEdgeInsets.top + frameSize.height - minimumContentHeight,
                                               frameSize.width, frameSize.height - self.contentEdgeInsets.top)];
    
    //
//    if (!self.centerButton.superview && self.centerButtonEnabled) {
//        [self addSubview:self.centerButton];
//    }
    
    NSInteger count = self.centerButtonEnabled ? (self.items.count + 1) : self.items.count;
    [self setItemWidth:roundf((frameSize.width - [self contentEdgeInsets].left -
                               [self contentEdgeInsets].right) / count)];
    
    NSInteger index = 0;
    
    // Layout items
    for (ECTabBarItem *item in [self items]) {
        CGFloat itemHeight = frameSize.height;
        
        NSInteger offset = index;
        if (self.centerButtonEnabled) {
            offset = index > (self.items.count/2-1) ? (index+1) : index;
        }
        [item setFrame:CGRectMake(self.contentEdgeInsets.left + (offset * self.itemWidth),
                                  roundf(frameSize.height - itemHeight) - self.contentEdgeInsets.top,
                                  self.itemWidth, itemHeight - self.contentEdgeInsets.bottom)];
        item.badgeCenterOffset = CGPointMake(-self.itemWidth*0.5f+15, 10);
//        [item setNeedsLayout];
//        [item setNeedsDisplay];
        
        index++;
    }
}

- (void) drawRect:(CGRect)rect
{
    [super drawRect:rect];
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    [COLOR_SEPERATOR_LINE set];
    CGContextFillRect(context, CGRectMake(0.0f, 0.0f, rect.size.width, self.contentEdgeInsets.top));
}

#pragma mark - Configuration

- (void) setItemWidth:(CGFloat)itemWidth
{
    if (itemWidth > 0) {
        _itemWidth = itemWidth;
    }
}

- (void) setItems:(NSArray *)items
{
    for (ECTabBarItem *item in items) {
        [item removeFromSuperview];
    }
    
    _items = [items copy];
    for (ECTabBarItem *item in items) {
        [item addTarget:self action:@selector(tabBarItemWasSelected:) forControlEvents:UIControlEventTouchUpInside];
        [item addTarget:self action:@selector(tabBarItemWasHighlighted:) forControlEvents:UIControlEventTouchDown];
//        [item addTarget:self action:@selector(tabBarItemWasHighlighted:) forControlEvents:UIControlEventTouchDragOutside];
        [self addSubview:item];
    }
}

- (void) setHeight:(CGFloat)height
{
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame),
                              CGRectGetWidth(self.frame), height)];
}

/*- (CGFloat) minimumContentHeight
{
    CGFloat minimumTabBarContentHeight = CGRectGetHeight([self frame]);
    
    for (ECTabBarItem *item in [self items]) {
        CGFloat itemHeight = [item itemHeight];
        if (itemHeight && (itemHeight < minimumTabBarContentHeight)) {
            minimumTabBarContentHeight = itemHeight;
        }
    }
    
    return minimumTabBarContentHeight;
}*/

#pragma mark - Translucency

- (void) setTranslucent:(BOOL)translucent
{
    _translucent = translucent;
    
    CGFloat alpha = (translucent ? 0.9 : 1.0);
    [_backgroundView setAlpha:alpha];
}

#pragma mark - Item selection

- (void) tabBarItemWasHighlighted:(id)sender
{
    ECTabBarItem *selectItem = sender;
    if (selectItem == _selectedItem) {
        return;
    }
    [selectItem setNeedsDisplay];
}

- (void) tabBarItemWasSelected:(id)sender
{
    if ([[self delegate] respondsToSelector:@selector(tabBar:shouldSelectItemAtIndex:)]) {
        NSInteger index = [self.items indexOfObject:sender];
        if (![[self delegate] tabBar:self shouldSelectItemAtIndex:index]) {
            return;
        }
    }
    
    [self setSelectedItem:sender];
    
    if ([[self delegate] respondsToSelector:@selector(tabBar:didSelectItemAtIndex:)]) {
        NSInteger index = [self.items indexOfObject:self.selectedItem];
        [[self delegate] tabBar:self didSelectItemAtIndex:index];
    }
}

- (void) setSelectedItem:(ECTabBarItem *)selectedItem
{
    if (selectedItem == _selectedItem) {
        return;
    }
    [_selectedItem setSelected:NO];
    [_selectedItem showBadgeView];
    
    _selectedItem = selectedItem;
    [_selectedItem setSelected:YES];
    [_selectedItem hideBadgeView];
}


@end
