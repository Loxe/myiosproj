//
//  HomeTopbarView.h
//  akucun
//
//  Created by Jarry Zhu on 2017/12/28.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTopbarView : UIScrollView

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, copy) void (^titleButtonClicked)(NSUInteger index);


- (instancetype) initWithFrame:(CGRect)frame;

- (void) initTitles:(NSArray *)titles;

- (void) selectIndex:(NSInteger)index;

- (void) animationWithOffset:(CGFloat)offsetRatio from:(NSInteger)index to:(NSInteger)toIndex;

- (void)showBadgeAt:(NSInteger)index;
- (void)clearBadgeAt:(NSInteger)index;


@end
