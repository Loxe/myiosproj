//
//  HomeViewController.m
//  akucun
//
//  Created by Jarry Zhu on 2017/12/21.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HomeViewController.h"
#import "MainViewController.h"
#import "ECTabBarController.h"
#import "HomeTopbarView.h"
#import "LiveListViewController.h"
#import "TrailerViewController.h"
#import "SDWebImageDownloader.h"
#import "ProductsManager.h"

#define kHomeTopbarHeight   38.0f

@interface HomeViewController ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) HomeTopbarView *topBarView;

@property (nonatomic, strong) NSMutableArray *controllers;
@property (nonatomic, strong) BaseViewController *currentController;
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation HomeViewController

- (void) setupContent
{
    [super setupContent];
    self.title = @"爱库存";

    [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];

    _controllers = [NSMutableArray array];
    self.currentIndex = -1;
    
    [self.view addSubview:self.topBarView];
    
    [self.view insertSubview:self.contentView atIndex:0];
    
    //
    LiveListViewController *liveController = [LiveListViewController new];
    liveController.liveType = 0;
    [self.controllers addObject:liveController];
    
    LiveListViewController *pkgController = [LiveListViewController new];
    pkgController.liveType = 1;
    [self.controllers addObject:pkgController];
    
    //
    LiveListViewController *dxListController = [LiveListViewController new];
    dxListController.liveType = 3;
    [self.controllers addObject:dxListController];
    
    TrailerViewController *trailerController = [TrailerViewController new];
    [self.controllers addObject:trailerController];
    
    @weakify(self)
    self.topBarView.titleButtonClicked = ^(NSUInteger index) {
        @strongify(self)
        [self switchToControllerAt:index];
    };
}

- (void) updateNewFlag:(NSDictionary *)flagDic
{
    NSInteger index = 0;
    for (NSInteger i = 0; i < 4; i++) {
        NSString *key = kIntergerToString(i);
        BOOL flag = [flagDic getBoolValueForKey:key];
        index = i;
        // 专场和爆款活动 顺序调整
        if (i == 1) {
            index = 2;
        }
        else if (i == 2) {
            index = 1;
        }
        if (flag && self.currentIndex != index) {
            [self.topBarView showBadgeAt:index];
        }
    }
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.currentController = nil;
    self.currentIndex = -1;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [((MainViewController *)self.ec_tabBarController) updateLeftButton:nil];
    [((MainViewController *)self.ec_tabBarController) setLiveId:nil];

    self.navigationController.title = @"爱库存";
    [self ec_setTitle:@"爱库存"];
    self.ec_tabBarController.navigationItem.titleView = nil;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    if (!self.currentController) {
        [self.topBarView selectIndex:0];
        [self switchToControllerAt:0];
    }
    
//    [self requestLiveState];
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.contentView.height = self.view.height - kHomeTopbarHeight;
}

- (void) switchToControllerAt:(NSInteger)index
{
    if (index >= self.controllers.count) {
        return;
    }
    if (index == self.currentIndex) {
        return;
    }
    
    BaseViewController *controller = self.controllers[index];
    controller.view.frame = self.contentView.bounds;
    
    CGFloat left = 0.0f;
    if (index > self.currentIndex) {
        left = -SCREEN_WIDTH;
    }
    else {
        left = SCREEN_WIDTH;
    }
    
    NSTimeInterval animationDuration = .2f;
    NSTimeInterval duration = 0.0f;
    @weakify(self)
    if (self.currentController) {
        duration = animationDuration;
        [UIView animateWithDuration:animationDuration
                         animations:^
         {
             @strongify(self)
             self.contentView.left = left;
             
         } completion:^(BOOL finished) {
             @strongify(self)
             [self.currentController.view removeFromSuperview];
             [self.currentController removeFromParentViewController];
             self.currentController = nil;
             
             [self.contentView addSubview:controller.view];
             [self addChildViewController:controller];
             self.currentController = controller;
             
             self.contentView.left = 0.0f;
             self.contentView.alpha = 0.0f;
             
             [UIView animateWithDuration:.1f
                                   delay:duration
                                 options:UIViewAnimationOptionCurveLinear
                              animations:^
              {
                  self.contentView.alpha = 1.0f;
              } completion:nil];
         }];
    }
    else {
        [self.contentView addSubview:controller.view];
        [self addChildViewController:controller];
        self.currentController = controller;
    }
    
    self.currentIndex = index;
    [self.topBarView clearBadgeAt:index];
}

#pragma mark - Request


#pragma mark -

- (UIView *) contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kHomeTopbarHeight, self.view.width, self.view.height-kHomeTopbarHeight)];
    }
    return _contentView;
}

- (HomeTopbarView *) topBarView
{
    if (!_topBarView) {
        CGFloat titleBarHeight = kHomeTopbarHeight;
        _topBarView = [[HomeTopbarView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, titleBarHeight)];
        [_topBarView initTitles:@[@"直 播", @"爆 款", @"DX利丰", @"预 告"]];
    }
    return _topBarView;
}

@end
