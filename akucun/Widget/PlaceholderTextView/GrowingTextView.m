//
//  GrowingTextView.m
//  iosapp
//
//  Created by Jarry on 11/17/14.
//  Copyright (c) 2014 Sucang. All rights reserved.
//

#import "GrowingTextView.h"

@implementation GrowingTextView

- (instancetype) initWithPlaceholder:(NSString *)placeholder
{
    self = [super initWithPlaceholder:placeholder];
    if (self) {
        self.font = [UIFont systemFontOfSize:15];
        self.scrollEnabled = NO;
        self.scrollsToTop = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.enablesReturnKeyAutomatically = YES;
        self.textContainerInset = UIEdgeInsetsMake(7.5, 4, 7.5, 0);
        _maxNumberOfLines = 4;
        _maxHeight = ceilf(self.font.lineHeight * _maxNumberOfLines + 15 + 4 * (_maxNumberOfLines - 1));
        self.placeholderFont = self.font;
    }
    
    return self;
}

// Code from apple developer forum - @Steve Krulewitz, @Mark Marszal, @Eric Silverberg
- (CGFloat) measureHeight
{
    return ceilf([self sizeThatFits:self.frame.size].height + 10);
}


@end
