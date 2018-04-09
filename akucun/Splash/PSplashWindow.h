//
//  PSplashWindow.h
//  akucun
//
//  Created by Jarry on 16/6/14.
//  Copyright © 2016年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSplashWindow : UIWindow

@property (nonatomic, copy) voidBlock block;

+ (PSplashWindow *) instance;

+ (void) splashFinished:(voidBlock)block;

- (void) show;

- (void) dismiss;


@end
