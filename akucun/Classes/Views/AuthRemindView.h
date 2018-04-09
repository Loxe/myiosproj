//
//  AuthRemindView.h
//  akucun
//
//  Created by deepin do on 2017/12/21.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthRemindView : UIView

// 提醒图标
@property(nonatomic, strong) NSString *imgString;

// 提醒文字
@property(nonatomic, strong) NSString *remindString;

- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)setRemindViewWithTitle:(NSString *)title image:(NSString *)img;

@end
