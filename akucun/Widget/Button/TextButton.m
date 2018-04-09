//
//  TextButton.m
//  J1ST-System
//
//  Created by Jarry on 16/11/25.
//  Copyright © 2016年 Zenin-tech. All rights reserved.
//

#import "TextButton.h"

@implementation TextButton


- (void) setTitleFont:(UIFont *)font
{
    [self.titleLabel setFont:font];
}

- (void) setTitleAlignment:(NSTextAlignment)textAlignment
{
    [self.titleLabel setTextAlignment:textAlignment];
}

- (CGRect) titleRectForContentRect:(CGRect)contentRect
{
    if (self.showImage) {
        return CGRectMake(contentRect.origin.x+self.titleEdgeInsets.left*2+self.imageSize, contentRect.origin.y+self.titleEdgeInsets.top, contentRect.size.width-self.titleEdgeInsets.left*2-self.titleEdgeInsets.right-self.imageSize, contentRect.size.height-self.titleEdgeInsets.top-self.titleEdgeInsets.bottom);
    }
    return CGRectMake(contentRect.origin.x+self.titleEdgeInsets.left, contentRect.origin.y+self.titleEdgeInsets.top, contentRect.size.width-self.titleEdgeInsets.left-self.titleEdgeInsets.right, contentRect.size.height-self.titleEdgeInsets.top-self.titleEdgeInsets.bottom);
}

- (CGRect) imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.origin.x+self.titleEdgeInsets.left, (contentRect.size.height-self.imageSize)/2, self.imageSize, self.imageSize);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
