//
//  TopIconButton.h
//  akucun
//
//  Created by Jarry on 2017/6/19.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopIconButton : UIButton

@property (nonatomic, copy) UIColor *iconColor, *textColor;

- (void) setTitle:(NSString *)title image:(NSString *)image;

- (void) setBadgeCount:(NSInteger)count;

@end
