//
//  DiscoverPageController.m
//  akucun
//
//  Created by Jarry Z on 2018/3/20.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "DiscoverPageController.h"
#import "ECTabBarController.h"
#import "MainViewController.h"
#import "SPPageMenu.h"
#import "DiscoverViewController.h"

@interface DiscoverPageController () <SPPageMenuDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) SPPageMenu *pageMenu;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *viewControllers;

@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation DiscoverPageController

- (void) setupContent
{
    [super setupContent];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = @"发现";
    
    [self ec_setTabTitle:@"发现"];
    [self ec_setTabImage:@"icon_discover"];
    
    SPPageMenu *pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kPageMenuHeight) trackerStyle:SPPageMenuTrackerStyleTextZoom];
    [pageMenu setItems:@[@"推 荐",@"公 告",@"直播问答",@"发货现场",@"培 训"] selectedItemIndex:0];
    pageMenu.permutationWay = SPPageMenuPermutationWayNotScrollAdaptContent;
    pageMenu.itemTitleFont = BOLDSYSTEMFONT(14);
    pageMenu.unSelectedItemTitleColor = COLOR_TEXT_NORMAL;
    pageMenu.selectedItemTitleColor = COLOR_SELECTED;
    pageMenu.needTextColorGradients = YES;
    pageMenu.delegate = self;
    [self.view addSubview:pageMenu];
    _pageMenu = pageMenu;
    
    _viewControllers = [NSMutableArray array];
    DiscoverViewController *controller1 = [DiscoverViewController new];
    controller1.type = 1;
    [self addChildViewController:controller1];
    [self.viewControllers addObject:controller1];
    DiscoverViewController *controller2 = [DiscoverViewController new];
    controller2.type = 2;
    [self addChildViewController:controller2];
    [self.viewControllers addObject:controller2];
    DiscoverViewController *controller3 = [DiscoverViewController new];
    controller3.type = 3;
    [self addChildViewController:controller3];
    [self.viewControllers addObject:controller3];
    DiscoverViewController *controller4 = [DiscoverViewController new];
    controller4.type = 4;
    [self addChildViewController:controller4];
    [self.viewControllers addObject:controller4];
    DiscoverViewController *controller5 = [DiscoverViewController new];
    controller5.type = 5;
    [self addChildViewController:controller5];
    [self.viewControllers addObject:controller5];

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kPageMenuHeight, SCREEN_WIDTH, kPageContentHeight)];
    scrollView.contentSize = CGSizeMake(5*SCREEN_WIDTH, 0);
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    _scrollView = scrollView;

    // 这一行赋值，可实现pageMenu的跟踪器时刻跟随scrollView滑动的效果
    self.pageMenu.bridgeScrollView = self.scrollView;
    
    for (NSInteger i = 0; i<self.viewControllers.count; i++) {
        BaseViewController *vc = self.viewControllers[i];
        vc.view.frame = CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, kPageContentHeight);
        [scrollView addSubview:vc.view];
    }
    
    self.selectedIndex = -1;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [((MainViewController *)self.ec_tabBarController) updateLeftButton:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FORWARD_HIDE object:nil]; //临时修改，发通知让“转发按钮隐藏”
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    if (self.selectedIndex < 0) {
        self.pageMenu.selectedItemIndex = 0;
    }
    else {
        [self.pageMenu clearBadgeAt:self.selectedIndex];
        DiscoverViewController *targetViewController = self.viewControllers[self.selectedIndex];
        [targetViewController updateData:nil];
    }
    
//    NSInteger index = self.selectedIndex>=0 ? self.selectedIndex : 0;
//    self.pageMenu.selectedItemIndex = index;
    
}

- (void) updateNewFlag:(NSDictionary *)flagDic
{
    for (NSInteger i = 0; i < 5; i++) {
        BOOL flag = [flagDic getBoolValueForKey:kIntergerToString(i+1)];
        DiscoverViewController *viewController = self.viewControllers[i];
        viewController.shouldUpdate = flag;
        if (flag && self.selectedIndex != i) {
            [self.pageMenu showBadgeAt:i];
        }
    }
}

#pragma mark - SPPageMenuDelegate
- (void) pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index
{
//    NSLog(@"itemSelectedAtIndex------->%zd",index);
}

- (void) pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    [self.pageMenu clearBadgeAt:toIndex];

//    NSLog(@"%zd------->%zd",fromIndex,toIndex);
    // 如果fromIndex与toIndex之差大于等于2,说明跨界面移动了,此时不动画.
    if (labs(toIndex - fromIndex) >= 2) {
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * toIndex, 0) animated:NO];
    } else {
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * toIndex, 0) animated:YES];
    }
    if (self.viewControllers.count <= toIndex) {return;}
    
    if (self.selectedIndex == toIndex) {
        return;
    }
    
    DiscoverViewController *targetViewController = self.viewControllers[toIndex];
    [targetViewController updateData:nil];

    self.selectedIndex = toIndex;
}

@end
