//
//  TipMessageView.h
//  akucun
//
//  Created by Jarry on 2017/7/1.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TipMessageView : UIView

@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, copy) voidBlock closeBlock;

- (instancetype) initWithFrame:(CGRect)frame message:(NSString *)message;

- (void) show;

- (void) hide;

@end
