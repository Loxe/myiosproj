//
//  MyOrderPageController.m
//  akucun
//
//  Created by Jarry Z on 2018/4/12.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "MyOrderPageController.h"
#import "SPPageMenu.h"
#import "MyOrderController.h"
#import "DeliverLivesController.h"

@interface MyOrderPageController () <SPPageMenuDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) SPPageMenu *pageMenu;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *viewControllers;

@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation MyOrderPageController

- (void) setupContent
{
    [super setupContent];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = @"我的订单";
    
    SPPageMenu *pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kPageMenuHeight) trackerStyle:SPPageMenuTrackerStyleTextZoom];
    [pageMenu setItems:@[@"全 部",@"待支付",@"待发货",@"拣货中",@"已发货",@"已取消"] selectedItemIndex:0];
    pageMenu.permutationWay = SPPageMenuPermutationWayNotScrollAdaptContent;
    pageMenu.itemTitleFont = SYSTEMFONT(14);
    pageMenu.unSelectedItemTitleColor = COLOR_TEXT_NORMAL;
    pageMenu.selectedItemTitleColor = COLOR_SELECTED;
    pageMenu.needTextColorGradients = YES;
    pageMenu.delegate = self;
    [self.view addSubview:pageMenu];
    _pageMenu = pageMenu;
    
    _viewControllers = [NSMutableArray array];
    MyOrderController *controller1 = [MyOrderController new];
    controller1.orderType = 0;
    [self addChildViewController:controller1];
    [self.viewControllers addObject:controller1];
    MyOrderController *controller2 = [MyOrderController new];
    controller2.orderType = 1;
    [self addChildViewController:controller2];
    [self.viewControllers addObject:controller2];
    MyOrderController *controller3 = [MyOrderController new];
    controller3.orderType = 2;
    [self addChildViewController:controller3];
    [self.viewControllers addObject:controller3];
    
    DeliverLivesController *controller4 = [DeliverLivesController new];
    controller4.type = 1;
    [self addChildViewController:controller4];
    [self.viewControllers addObject:controller4];
    DeliverLivesController *controller5 = [DeliverLivesController new];
    controller5.type = 2;
    [self addChildViewController:controller5];
    [self.viewControllers addObject:controller5];
    
    MyOrderController *controller6 = [MyOrderController new];
    controller6.orderType = 5;
    [self addChildViewController:controller6];
    [self.viewControllers addObject:controller6];
    
    CGFloat height = SCREEN_HEIGHT-kSafeAreaTopHeight-kPageMenuHeight;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kPageMenuHeight, SCREEN_WIDTH, (height))];
    scrollView.contentSize = CGSizeMake(6*SCREEN_WIDTH, 0);
//    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    
    // 这一行赋值，可实现pageMenu的跟踪器时刻跟随scrollView滑动的效果
    self.pageMenu.bridgeScrollView = self.scrollView;
    
    for (NSInteger i = 0; i<self.viewControllers.count; i++) {
        BaseViewController *vc = self.viewControllers[i];
        vc.view.frame = CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, height);
        [scrollView addSubview:vc.view];
    }
    
    self.selectedIndex = -1;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    if (self.selectedIndex != self.initIndex) {
        self.pageMenu.selectedItemIndex = self.initIndex;
    }
    else {
        BaseViewController *targetViewController = self.viewControllers[self.selectedIndex];
        [targetViewController updateData];
    }
}

#pragma mark - SPPageMenuDelegate

- (void) pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index
{
    //    NSLog(@"itemSelectedAtIndex------->%zd",index);
}

- (void) pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    BOOL animated = YES;
    if (labs(toIndex - fromIndex) >= 2) {
        animated = NO;
    }
    
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * toIndex, 0) animated:animated];
    
    if (self.viewControllers.count <= toIndex) {return;}
    
    if (self.selectedIndex == toIndex) {
        return;
    }
    
    BaseViewController *targetViewController = self.viewControllers[toIndex];
    if (animated) {
        GCD_DELAY(^{
            [targetViewController updateData];
        }, .2f)
    }
    else {
        [targetViewController updateData];
    }
    
    self.selectedIndex = toIndex;
    self.initIndex = toIndex;
}

@end
