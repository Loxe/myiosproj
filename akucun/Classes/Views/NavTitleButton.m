//
//  NavTitleButton.m
//  akucun
//
//  Created by Jarry Zhu on 2017/12/10.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "NavTitleButton.h"
#import "NSString+akucun.h"

@implementation NavTitleButton

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = CLEAR_COLOR;
        
        self.titleLabel.font = SYSTEMFONT(18);
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self setNormalColor:COLOR_TITLE highlighted:COLOR_SELECTED selected:nil];
        
        self.imageView.contentMode = UIViewContentModeCenter;
        [self setNormalImage:@"icon_down_arrow" hilighted:nil selectedImage:nil];
    }
    return self;
}

- (void) setTitle:(NSString *)title
{
    _title = title;
    [self setNormalTitle:title];
}

- (CGRect) imageRectForContentRect:(CGRect)contentRect
{
    CGSize size = [self.title sizeWithFont:self.titleLabel.font maxWidth:SCREEN_WIDTH];
    CGFloat x = (contentRect.size.width + size.width)/2.0f;
    if (x > contentRect.size.width-20) {
        x = contentRect.size.width-20;
    }
    return CGRectMake(x, contentRect.origin.y , 20, contentRect.size.height);
}

- (CGRect) titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.origin.x, contentRect.origin.y, contentRect.size.width-20, contentRect.size.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
