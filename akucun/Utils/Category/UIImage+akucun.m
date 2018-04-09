//
//  UIImage+akucun.m
//  akucun
//
//  Created by Jarry on 2017/5/10.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "UIImage+akucun.h"

@implementation UIImage (akucun)

- (UIImage *) imageAddText:(NSString *)content font:(UIFont *)font
{
    //画布大小
    CGSize size = self.size;
    //创建一个基于位图的上下文
    UIGraphicsBeginImageContextWithOptions(size,NO,0.0);//opaque:NO  scale:0.0
    
    [self drawAtPoint:CGPointMake(0, 0)];
    
    CGRect rect = CGRectMake(20.0f, 20.0f, size.width-20.0f, size.height-20.0f);
    
    //绘制文字
    [content drawInRect:rect
         withAttributes:@{ NSFontAttributeName:font,NSForegroundColorAttributeName:WHITE_COLOR}];
    
    UIImage *newImage= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
