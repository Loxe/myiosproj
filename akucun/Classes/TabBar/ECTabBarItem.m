//
//  ECTabBarItem.m
//  EachingMobile
//
//  Created by Jarry on 15/5/15.
//  Copyright (c) 2015年 Sucang. All rights reserved.
//

#import "ECTabBarItem.h"

@interface ECTabBarItem ()

@property UIImage *unselectedImage, *selectedImage;

@property (copy) NSDictionary *iconAttributes, *selectedIconAttributes;

//@property (nonatomic, strong) UILabel *badgeLabel;

@end

@implementation ECTabBarItem

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
    // Setup defaults
    
    self.backgroundColor = CLEAR_COLOR;
    
    _titlePositionAdjustment = UIOffsetMake(1, 4);
    _imagePositionAdjustment = UIOffsetMake(0, 0);

    _unselectedTitleAttributes = @{
                                   NSFontAttributeName: SYSTEMFONT(11),
                                   NSForegroundColorAttributeName: COLOR_TITLE,
                                   };
    _selectedTitleAttributes = @{
                                 NSFontAttributeName: BOLDSYSTEMFONT(11),
                                 NSForegroundColorAttributeName: COLOR_SELECTED,
                                 };

    _iconAttributes = @{
                        NSFontAttributeName: FA_ICONFONTSIZE(25),
                        NSForegroundColorAttributeName: LIGHTGRAY_COLOR,
                        };
    _selectedIconAttributes = @{
                                NSFontAttributeName: FA_ICONFONTSIZE(25),
                                NSForegroundColorAttributeName: COLOR_SELECTED,
                                };

//    [self addSubview:self.badgeLabel];
    
    self.badgeBgColor = COLOR_SELECTED;
    self.badgeFont = BOLDSYSTEMFONT(10);
//    self.badgeCenterOffset = CGPointMake(SCREEN_WIDTH/5.0f-25, 10);
    CGFloat offsetX = (SCREEN_WIDTH/5.0f)*0.5f + 15;
    self.badgeCenterOffset = CGPointMake(offsetX, 10);
    [self clearBadge];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
//    CGFloat offsetX = self.width*0.35f;
//    self.badgeCenterOffset = CGPointMake(-offsetX, 10);
}

- (void) showBadgeView
{
    if (self.badgeNumber > 0) {
        [self resumeBadge];
    }
}

- (void) hideBadgeView
{
    [self clearBadge];
}

- (void) setSelectedImage:(NSString *)selectedImage withUnselectedImage:(NSString *)unselectedImage
{
    if (selectedImage) {
        self.selectedImage = IMAGENAMED(selectedImage);
    }
    
    if (unselectedImage) {
        self.unselectedImage = IMAGENAMED(unselectedImage);
    }
}

- (void) setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}

- (void) drawRect:(CGRect)rect
{
    CGSize frameSize = self.frame.size;
    CGSize titleSize = CGSizeZero;
    NSDictionary *titleAttributes = nil, *iconAttributes = nil;
//    UIImage *backgroundImage = nil;
    UIImage *image = nil;
    CGFloat imageStartingY = 0.0f;
    
    if ([self isSelected]) {
        image = [self selectedImage];
//        backgroundImage = [self selectedBackgroundImage];
        titleAttributes = [self selectedTitleAttributes];
        if (!titleAttributes) {
            titleAttributes = [self unselectedTitleAttributes];
        }
        
        iconAttributes = [self selectedIconAttributes];
    }
    else if ([self isHighlighted]) {
        image = [self selectedImage];
        titleAttributes = [self unselectedTitleAttributes];
        iconAttributes = [self selectedIconAttributes];
    }
    else {
        image = [self unselectedImage];
//        backgroundImage = [self unselectedBackgroundImage];
        titleAttributes = [self unselectedTitleAttributes];
        iconAttributes = [self iconAttributes];
    }
    
    CGSize imageSize = CGSizeMake(22, 22); //image.size;

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);

//    [backgroundImage drawInRect:self.bounds];
    // Draw image and title
    
    if (![_title length]) {
        if (image) {
            [image drawInRect:CGRectMake(roundf(frameSize.width / 2 - imageSize.width / 2) +
                                         _imagePositionAdjustment.horizontal,
                                         roundf(frameSize.height / 2 - imageSize.height / 2) +
                                         _imagePositionAdjustment.vertical,
                                         imageSize.width, imageSize.height)];
        }
        
    } else {
        
        titleSize = [_title boundingRectWithSize:CGSizeMake(frameSize.width, 20)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName: titleAttributes[NSFontAttributeName]}
                                         context:nil].size;
        
        if (image) {
            imageStartingY = roundf((frameSize.height - imageSize.height - titleSize.height) / 2);
            
            [image drawInRect:CGRectMake(roundf(frameSize.width / 2 - imageSize.width / 2) +
                                         _imagePositionAdjustment.horizontal,
                                         imageStartingY + _imagePositionAdjustment.vertical,
                                         imageSize.width, imageSize.height)];
        }
        
        if (_iconText) {
            imageSize = [_iconText boundingRectWithSize:CGSizeMake(frameSize.width, 30)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:iconAttributes[NSFontAttributeName]}
                                             context:nil].size;
            imageStartingY = roundf((frameSize.height - imageSize.height - titleSize.height) / 2);
            CGContextSetFillColorWithColor(context, [iconAttributes[NSForegroundColorAttributeName] CGColor]);
            [_iconText drawInRect:CGRectMake(roundf(frameSize.width / 2 - imageSize.width / 2) +
                                          _imagePositionAdjustment.horizontal,
                                          imageStartingY + _imagePositionAdjustment.vertical,
                                          imageSize.width, imageSize.height)
                   withAttributes:iconAttributes];
        }
        
        CGContextSetFillColorWithColor(context, [titleAttributes[NSForegroundColorAttributeName] CGColor]);
        [_title drawInRect:CGRectMake(roundf(frameSize.width / 2 - titleSize.width / 2) +
                                          _titlePositionAdjustment.horizontal,
                                          imageStartingY + imageSize.height + _titlePositionAdjustment.vertical,
                                          titleSize.width, titleSize.height)
            withAttributes:titleAttributes];
    }

    CGContextRestoreGState(context);
}

@end
