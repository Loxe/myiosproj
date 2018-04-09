//
//  IconButton.h
//  akucun
//
//  Created by Jarry on 2017/3/29.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IconButton : UIButton

@property (nonatomic, copy) UIColor *iconColor, *textColor;

@property (nonatomic, copy) NSString *image;
@property (nonatomic, assign) CGFloat imageSize;

@property (nonatomic, assign) CGFloat leftPadding;
@property (nonatomic, assign) CGFloat spacing;

- (void) setTitleFont:(UIFont *)font;

- (void) setIconFont:(UIFont *)font;

- (void) setIcon:(NSString *)icon;

- (void) setTitle:(NSString *)title icon:(NSString *)icon;

@end
