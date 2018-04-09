//
//  TopNumButton.m
//  akucun
//
//  Created by Jarry on 2017/6/29.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "TopNumButton.h"

@interface TopNumButton ()

//@property (nonatomic, assign) CGFloat titleHeight;

@end

@implementation TopNumButton

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = CLEAR_COLOR;
        
        self.titleLabel.font = [FontUtils smallFont];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self setNormalColor:COLOR_TEXT_DARK highlighted:COLOR_SELECTED selected:nil];
        
        //
        [self addSubview:self.numLabel];
    }
    return self;
}

- (void) setNumber:(NSInteger)number
{
    _number = number;
    
    self.numLabel.text = kIntergerToString(number);
    self.numLabel.textColor = (number > 0) ? COLOR_SELECTED : COLOR_TEXT_NORMAL;
}

- (void) setTitle:(NSString *)title number:(NSInteger)number
{
    if (title) {
        [self setNormalTitle:title];
    }
    self.number = number;
}

- (CGRect) titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.origin.x, contentRect.size.height - 20, contentRect.size.width, 20);
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
//    self.numLabel.top = kOFFSET_SIZE;
}

- (UILabel *) numLabel
{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height-20)];
        _numLabel.font = SYSTEMFONT(35);
        _numLabel.textColor = COLOR_TEXT_NORMAL;
        _numLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numLabel;
}

@end
