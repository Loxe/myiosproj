//
//  CountDownView.h
//  akucun
//
//  Created by Jarry on 2017/7/27.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
  倒计时View
 */
@interface CountDownView : UIView

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) UIColor *titleColor;

@property (nonatomic, assign) NSTimeInterval liveTime;

@property (nonatomic, copy) voidBlock timeoutBlock;

- (void) cancelTimer;

@end
