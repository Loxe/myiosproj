//
//  ECTabBarController.h
//  EachingMobile
//
//  Created by Jarry on 15/5/15.
//  Copyright (c) 2015年 Sucang. All rights reserved.
//

#import "ECTabBar.h"

@protocol ECTabBarControllerDelegate;

@interface ECTabBarController : UIViewController <ECTabBarDelegate>

- (void) initTabBarController;

/**
 * The tab bar controller’s delegate object.
 */
@property (nonatomic, weak) id<ECTabBarControllerDelegate> delegate;

/**
 * An array of the root view controllers displayed by the tab bar interface.
 */
@property (nonatomic, strong) NSArray *viewControllers;

/**
 * The tab bar view associated with this controller.
 */
@property (nonatomic, strong) ECTabBar *tabBar;

/**
 * The view controller associated with the currently selected tab item.
 */
@property (nonatomic, weak) UIViewController *selectedViewController;

/**
 * The index of the view controller associated with the currently selected tab item.
 */
@property (nonatomic) NSUInteger selectedIndex;

/**
 * A Boolean value that determines whether the tab bar is hidden.
 */
@property (nonatomic, getter=isTabBarHidden) BOOL tabBarHidden;

/**
 * Changes the visibility of the tab bar.
 */
- (void) setTabBarHidden:(BOOL)hidden animated:(BOOL)animated;

- (void) updateBadge:(NSInteger)number atIndex:(NSInteger)index withStyle:(WBadgeStyle)style animationType:(WBadgeAnimType)aniType;

@end

@protocol ECTabBarControllerDelegate <NSObject>
@optional
/**
 * Asks the delegate whether the specified view controller should be made active.
 */
- (BOOL) tabBarController:(ECTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;

/**
 * Tells the delegate that the user selected an item in the tab bar.
 */
- (void) tabBarController:(ECTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;

@end

@interface UIViewController (ECTabBarControllerItem)

@property (nonatomic, readonly) ECTabBarController *ec_tabBarController;

@property (nonatomic, readonly) NSString *ec_tabTitle, *ec_tabImageName, *ec_tabIconName;

- (void) ec_setTabBarController:(ECTabBarController *)tabBarController;

- (void) ec_setTabTitle:(NSString *)title;

- (void) ec_setTabImage:(NSString *)imageName;

- (void) ec_setTitle:(NSString *)title;

- (void) ec_setTabIcon:(NSString *)iconName;

- (void) ec_setLeftBarItem:(UIBarButtonItem *)item;

@end
