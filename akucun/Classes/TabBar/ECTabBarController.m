//
//  ECTabBarController.m
//  EachingMobile
//
//  Created by Jarry on 15/5/15.
//  Copyright (c) 2015年 Sucang. All rights reserved.
//

#import <objc/runtime.h>
#import "ECTabBarController.h"

@interface ECTabBarController ()

@property (nonatomic, strong) UIView *contentView;

@end


@implementation ECTabBarController

#pragma mark - View lifecycle

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = COLOR_BACKGROUND;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        [self initTabBarController];
    }
    return self;
}

- (void) initTabBarController
{
    
}

- (void) viewDidLoad
{
    [super viewDidLoad];
            
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.tabBar];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setSelectedIndex:self.selectedIndex];
    
    [self setTabBarHidden:self.isTabBarHidden animated:NO];
}

#pragma mark - Methods

- (UIViewController *) selectedViewController
{
    return [[self viewControllers] objectAtIndex:self.selectedIndex];
}

- (void) setSelectedIndex:(NSUInteger)selectedIndex
{
    if (selectedIndex >= self.viewControllers.count) {
        return;
    }
    
    if ([self selectedViewController]) {
        [[self selectedViewController] willMoveToParentViewController:nil];
        [[[self selectedViewController] view] removeFromSuperview];
        [[self selectedViewController] removeFromParentViewController];
    }
    
    _selectedIndex = selectedIndex;
    [[self tabBar] setSelectedItem:[[self tabBar] items][selectedIndex]];
    
    [self setSelectedViewController:[[self viewControllers] objectAtIndex:selectedIndex]];
    [self addChildViewController:[self selectedViewController]];
    [[[self selectedViewController] view] setFrame:[[self contentView] bounds]];
    [[self contentView] addSubview:[[self selectedViewController] view]];
    [[self selectedViewController] didMoveToParentViewController:self];
    
    self.navigationItem.title = self.selectedViewController.title;
}

- (void) setViewControllers:(NSArray *)viewControllers
{
    if (viewControllers && [viewControllers isKindOfClass:[NSArray class]]) {
        _viewControllers = [viewControllers copy];
        
        NSMutableArray *tabBarItems = [[NSMutableArray alloc] init];
        
        for (UIViewController *viewController in viewControllers) {
            ECTabBarItem *tabBarItem = [[ECTabBarItem alloc] init];
            [tabBarItem setTitle:[viewController ec_tabTitle]];
            NSString *normalImage = [viewController ec_tabImageName];
            if (normalImage) {
                NSString *selectImage = [normalImage stringByAppendingString:@"_selected"];
                [tabBarItem setSelectedImage:selectImage withUnselectedImage:normalImage];
            }
            NSString *normalIcon = [viewController ec_tabIconName];
            [tabBarItem setIconText:normalIcon];
            
            [tabBarItems addObject:tabBarItem];
            
            [viewController ec_setTabBarController:self];
        }
        
        [[self tabBar] setItems:tabBarItems];
    } else {
//        for (UIViewController *viewController in _viewControllers) {
//            [viewController rdv_setTabBarController:nil];
//        }
        
        _viewControllers = nil;
    }
}

- (NSInteger) indexForViewController:(UIViewController *)viewController
{
    UIViewController *searchedController = viewController;
    if ([searchedController navigationController]) {
        searchedController = [searchedController navigationController];
    }
    return [[self viewControllers] indexOfObject:searchedController];
}

- (ECTabBar *) tabBar
{
    if (!_tabBar) {
        _tabBar = [[ECTabBar alloc] init];
        [_tabBar setBackgroundColor:COLOR_TABBAR_BG];
        [_tabBar setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|
                                      UIViewAutoresizingFlexibleTopMargin|
                                      UIViewAutoresizingFlexibleLeftMargin|
                                      UIViewAutoresizingFlexibleRightMargin|
                                      UIViewAutoresizingFlexibleBottomMargin)];
        [_tabBar setDelegate:self];
    }
    return _tabBar;
}

- (UIView *) contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        [_contentView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|
                                           UIViewAutoresizingFlexibleHeight)];
    }
    return _contentView;
}

- (void) setTabBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    _tabBarHidden = hidden;
    
    __weak ECTabBarController *weakSelf = self;
    
    void (^block)(void) = ^{
        CGSize viewSize = weakSelf.view.bounds.size;
        CGFloat tabBarStartingY = viewSize.height;
        CGFloat contentViewHeight = viewSize.height;
        CGFloat tabBarHeight = CGRectGetHeight([[weakSelf tabBar] frame]);
        
        if (!tabBarHeight) {
            tabBarHeight = kBOTTOM_BAR_HEIGHT;
        }
        
        if (!hidden) {
            tabBarStartingY = viewSize.height - tabBarHeight;
            if (![[weakSelf tabBar] isTranslucent]) {
                contentViewHeight -=  tabBarHeight;
            }
            [[weakSelf tabBar] setHidden:NO];
        }
        
        [[weakSelf tabBar] setFrame:CGRectMake(0, tabBarStartingY, viewSize.width, tabBarHeight)];
        [[weakSelf contentView] setFrame:CGRectMake(0, 0, viewSize.width, contentViewHeight)];
    };
    
    void (^completion)(BOOL) = ^(BOOL finished){
        if (hidden) {
            [[weakSelf tabBar] setHidden:YES];
        }
    };
    
    if (animated) {
        [UIView animateWithDuration:0.24 animations:block completion:completion];
    } else {
        block();
        completion(YES);
    }
}

- (void) setTabBarHidden:(BOOL)hidden
{
    [self setTabBarHidden:hidden animated:NO];
}

- (void) updateBadge:(NSInteger)number atIndex:(NSInteger)index withStyle:(WBadgeStyle)style animationType:(WBadgeAnimType)aniType
{
    if (index != self.selectedIndex) {
        ECTabBarItem *tabBarItem = self.tabBar.items[index];
        [tabBarItem setBadgeNumber:number];
        // 以下判断是为了ipad上初始运行时购物车有订单时，badge显示位置的修复
//        if (index == 3 && isPad) { // 此处若是需要其他tabBarItem数字显示有一样的问题，同样的方式处理
//            tabBarItem.badgeCenterOffset = CGPointMake(100, 10);
//        }
        [tabBarItem showBadgeWithStyle:style value:number animationType:aniType];
    }
    else {
        [self.tabBar.selectedItem setBadgeNumber:number];
        [self.tabBar.selectedItem showBadgeWithStyle:style value:number animationType:WBadgeAnimTypeNone];
        [self.tabBar.selectedItem clearBadge];
    }
}

#pragma mark - ECTabBarDelegate

- (BOOL) tabBar:(ECTabBar *)tabBar shouldSelectItemAtIndex:(NSInteger)index
{    
    if ([[self delegate] respondsToSelector:@selector(tabBarController:shouldSelectViewController:)]) {
        if (![[self delegate] tabBarController:self shouldSelectViewController:[self viewControllers][index]]) {
            return NO;
        }
    }
    
    if ([self selectedViewController] == [self viewControllers][index]) {
        if ([[self selectedViewController] isKindOfClass:[UINavigationController class]]) {
            UINavigationController *selectedController = (UINavigationController *)[self selectedViewController];
            
            if ([selectedController topViewController] != [selectedController viewControllers][0]) {
                [selectedController popToRootViewControllerAnimated:YES];
            }
        }
        
        return NO;
    }
    
    return YES;
}

- (void) tabBar:(ECTabBar *)tabBar didSelectItemAtIndex:(NSInteger)index
{
    if (index < 0 || index >= [[self viewControllers] count]) {
        return;
    }
    
    [self setSelectedIndex:index];
    
    if ([[self delegate] respondsToSelector:@selector(tabBarController:didSelectViewController:)]) {
        [[self delegate] tabBarController:self didSelectViewController:[self viewControllers][index]];
    }
}

@end

#pragma mark - UIViewController + ECTabBarControllerItem

@implementation UIViewController (ECTabBarControllerItem)

- (void) ec_setTabBarController:(ECTabBarController *)tabBarController
{
    objc_setAssociatedObject(self, @selector(ec_tabBarController), tabBarController, OBJC_ASSOCIATION_ASSIGN);
}

- (ECTabBarController *) ec_tabBarController
{
    ECTabBarController *tabBarController = objc_getAssociatedObject(self, @selector(ec_tabBarController));
    
    if (!tabBarController && self.parentViewController) {
        tabBarController = [self.parentViewController ec_tabBarController];
    }
    
    return tabBarController;
}

- (void) ec_setTabTitle:(NSString *)title
{
    objc_setAssociatedObject(self, @selector(ec_tabTitle), title, OBJC_ASSOCIATION_COPY);
}

- (void) ec_setTabImage:(NSString *)imageName
{
    objc_setAssociatedObject(self, @selector(ec_tabImageName), imageName, OBJC_ASSOCIATION_COPY);
}

- (void) ec_setTabIcon:(NSString *)iconName
{
    objc_setAssociatedObject(self, @selector(ec_tabIconName), iconName, OBJC_ASSOCIATION_COPY);
}

- (NSString *) ec_tabTitle
{
    return objc_getAssociatedObject(self, @selector(ec_tabTitle));
}

- (NSString *) ec_tabImageName
{
    return objc_getAssociatedObject(self, @selector(ec_tabImageName));
}

- (NSString *) ec_tabIconName
{
    return objc_getAssociatedObject(self, @selector(ec_tabIconName));
}

- (void) ec_setTitle:(NSString *)title
{
    self.title = title;
    if (self.ec_tabBarController) {
        self.ec_tabBarController.navigationItem.title = title;
    }
}

- (void) ec_setLeftBarItem:(UIBarButtonItem *)item
{
    self.ec_tabBarController.navigationItem.leftBarButtonItem = item;
}

@end


