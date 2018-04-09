//
//  SCImageView.m
//  akucun
//
//  Created by Jarry on 2017/8/11.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "SCImageView.h"

@implementation SCImageView

#pragma mark - 点击高亮处理

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.highlighted = YES;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.highlighted = NO;
    
    if (self.clickedBlock) {
        self.clickedBlock();
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.highlighted = NO;
}

#pragma mark - 高亮后产生的效果

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.alpha = 0.6f;
    }
    else {
        self.alpha = 1.f;
    }
}

@end
