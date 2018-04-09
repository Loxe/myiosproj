//
//  ECTabBar.h
//  EachingMobile
//
//  Created by Jarry on 15/5/8.
//  Copyright (c) 2015年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECTabBarItem.h"
//#import "ECTabButton.h"

@protocol ECTabBarDelegate;

@interface ECTabBar : UIView

@property (nonatomic, assign) BOOL centerButtonEnabled;

//@property (nonatomic, strong) ECTabButton *centerButton;

/**
 * The tab bar’s delegate object.
 */
@property (nonatomic, weak) id <ECTabBarDelegate> delegate;

/**
 * The items displayed on the tab bar.
 */
@property (nonatomic, strong) NSArray *items;

/**
 * The currently selected item on the tab bar.
 */
@property (nonatomic, strong) ECTabBarItem *selectedItem;

/*
 * Enable or disable tabBar translucency. Default is NO.
 */
@property (nonatomic, getter=isTranslucent) BOOL translucent;

/**
 * Sets the height of tab bar.
 */
- (void) setHeight:(CGFloat)height;


@end


@protocol ECTabBarDelegate <NSObject>

@optional
/**
 * Asks the delegate if the specified tab bar item should be selected.
 */
- (BOOL)tabBar:(ECTabBar *)tabBar shouldSelectItemAtIndex:(NSInteger)index;

/**
 * Tells the delegate that the specified tab bar item is now selected.
 */
- (void)tabBar:(ECTabBar *)tabBar didSelectItemAtIndex:(NSInteger)index;

@end

