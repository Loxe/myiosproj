//
//  BaseViewController.m
//  akucun
//
//  Created by Jarry on 17/3/13.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "BaseViewController.h"
#import "AKAlertView.h"
#import "SDImageCache.h"

@interface BaseViewController () 

@property (nonatomic, assign) BOOL shouldReload;

@property (nonatomic, strong) UIView *titleLine;

@end

@implementation BaseViewController

- (instancetype) init
{
    self = [super init];
    if (self) {
        [self setupContent];
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //    [self setNeedsStatusBarAppearanceUpdate];
    
    if (self.shouldReload) {
        [self setupContent];
    }
    
    [self initViewData];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.view.superview) {
        [SVProgressHUD setContainerView:self.view.superview];
        [SVProgressHUD resetOffsetFromCenter];
    }
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];

    if (self.navigationController.viewControllers.count > 1) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    } else {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 
    [SCHttpServiceFace cancelAllRequest];
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if (self.isViewLoaded && !self.view.window)// 是否是正在使用的视图
    {
        self.shouldReload = YES;
        self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
    }

    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    
//    [[SDWebImageManager sharedManager] cancelAll];
    
    ERRORLOG(@"--> !! didReceiveMemoryWarning ");
}

- (BOOL) isVisible
{
    return (self.isViewLoaded && self.view.window);
}

- (void) setupContent
{
    self.view.backgroundColor = WHITE_COLOR;
}

- (void) initViewData
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
}

- (void) updateData
{
}

- (void) setShowTitle:(BOOL)showTitle
{
    _showTitle = showTitle;
    
    if (self.showTitle) {
        [self.view addSubview:self.titleView];
    }
}

- (void) setHideStatusBar:(BOOL)hideStatusBar
{
    _hideStatusBar = hideStatusBar;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL) prefersStatusBarHidden
{
    return self.hideStatusBar;
}

- (BOOL) shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    /*
    if (self.titleView) {
        [UIView animateWithDuration:kAnimationDurationShort
                         animations:^
         {
             self.titleView.frame = CGRectMake(0, 0, self.view.width, 64);
             [self.titleLabel setCenter:CGPointMake(self.view.centerX, 42)];
         }];
    }*/
}

- (void) setTitle:(NSString *)title
{
    [super setTitle:title];
    
    if (self.titleLabel) {
        self.titleLabel.text = title;
        [self.titleLabel sizeToFit];
        [self.titleLabel setCenter:CGPointMake(self.view.centerX, isIPhoneX ? 66 : 42)];
    }
}

- (void) setShowTitleLine:(BOOL)showTitleLine
{
    _showTitleLine = showTitleLine;
    if (showTitleLine) {
        if (!_titleLine) {
            _titleLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.titleView.height-.5f, self.titleView.width, .5f)];
            _titleLine.backgroundColor = COLOR_SEPERATOR_LIGHT;
            [self.titleView addSubview:_titleLine];
        }
    }
}

- (UIView *) titleView
{
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kSafeAreaTopHeight)];
        _titleView.backgroundColor = WHITE_COLOR;
        [_titleView addSubview:self.titleLabel];
    }
    return _titleView;
}

- (UILabel *) titleLabel
{
    if (!_titleLabel) {
        _titleLabel  = [[UILabel alloc] init];
        _titleLabel.backgroundColor = CLEAR_COLOR;
        _titleLabel.textColor = COLOR_TEXT_DARK;
        _titleLabel.font = [FontUtils bigFont];
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.userInteractionEnabled = YES;
        _titleLabel.text = @"";
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        //        _titleLabel.shadowOffset = CGSizeMake(0.4f, 0.6f);
        //		_titleLabel.shadowColor = WHITE_COLOR;
    }
    return _titleLabel;
}

- (TextButton *) leftButton
{
    if (!_leftButton) {
        _leftButton = [TextButton buttonWithType:UIButtonTypeCustom];
        _leftButton.frame = CGRectMake(0, kIOS7Offset, 60, 44);
        _leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        
        [_leftButton setTitleFont:FA_ICONFONTSIZE(30)];
        [_leftButton setTitleAlignment:NSTextAlignmentLeft];
        
        [_leftButton setTitle:FA_ICONFONT_BACK forState:UIControlStateNormal];
        [_leftButton setTitleColor:COLOR_TEXT_DARK forState:UIControlStateNormal];
        [_leftButton setTitleColor:COLOR_SELECTED forState:UIControlStateHighlighted];
        
        [_leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (TextButton *) rightButton
{
    if (!_rightButton) {
        _rightButton = [TextButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(self.view.width-40, kIOS7Offset, 40, 44);
        
        [_rightButton setTitleFont:[FontUtils buttonFont]];
        [_rightButton setTitleAlignment:NSTextAlignmentRight];
        
        [_rightButton setTitle:@"取消" forState:UIControlStateNormal];
        [_rightButton setTitleColor:COLOR_TEXT_DARK forState:UIControlStateNormal];
        [_rightButton setTitleColor:COLOR_SELECTED forState:UIControlStateHighlighted];
        
        [_rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

- (IBAction) leftButtonAction:(id)sender
{
    if (self.isPresented) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction) rightButtonAction:(id)sender
{
}
/*
- (void) switchTitleText:(NSString *)title toRight:(BOOL)flag
{
    [UIView animateWithDuration:.2f animations:^{
        self.titleLabel.alpha = 0.0f;
        self.titleLabel.centerX = flag ? self.view.width*0.8 : self.view.width*0.2;
    } completion:^(BOOL finished) {
        [self setTitle:title];
        [UIView animateWithDuration:.2f animations:^{
            self.titleLabel.alpha = 1.0f;
        }];
    }];
}
*/
- (BOOL) gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count ==1)//关闭主界面的右滑返回
    {
        return NO;
    }

    return YES;
}

- (void) confirmWithIcon:(NSString *)icon title:(NSString *)title block:(voidBlock)block canceled:(voidBlock)canceled
{
    MMPopupItemHandler handler = ^(NSInteger index) {
        if (index == 1) {
            if (block) {
                block();
            }
        }
        else {
            if (canceled) {
                canceled();
            }
        }
    };
    NSArray *items =
    @[MMItemMake(@"取消", MMItemTypeNormal, handler),
      MMItemMake(@"确定", MMItemTypeHighlight, handler)];
    
    AKAlertView *alertView = [[AKAlertView alloc] initWithConfirmTitle:icon titleFont:FA_ICONFONTSIZE(35) titleColor:RED_COLOR detail:title items:items];
    [alertView show];
}

- (void) confirmWithTitle:(NSString *)title block:(voidBlock)block canceled:(voidBlock)canceled
{
    [self confirmWithTitle:title detail:nil block:block canceled:canceled];
}

- (void) confirmWithTitle:(NSString *)title detail:(NSString *)detail block:(voidBlock)block canceled:(voidBlock)canceled
{
    MMPopupItemHandler handler = ^(NSInteger index) {
        if (index == 1) {
            if (block) {
                block();
            }
        }
        else {
            if (canceled) {
                canceled();
            }
        }
    };
    NSArray *items =
    @[MMItemMake(@"取消", MMItemTypeNormal, handler),
      MMItemMake(@"确定", MMItemTypeHighlight, handler)];
    
    NSString *detailText = nil;
    if (detail) {
        detailText = FORMAT(@"\n%@", detail);
    }
    
    MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:title detail:detailText items:items];
    [alertView show];
}

- (void) confirmWithTitle:(NSString *)title detail:(NSString *)detail btnText:(NSString *)btnText block:(voidBlock)block canceled:(voidBlock)canceled
{
    MMPopupItemHandler handler = ^(NSInteger index) {
        if (index == 1) {
            if (block) {
                block();
            }
        }
        else {
            if (canceled) {
                canceled();
            }
        }
    };
    NSArray *items =
    @[MMItemMake(@"取消", MMItemTypeNormal, handler),
      MMItemMake(btnText, MMItemTypeHighlight, handler)];
    
    NSString *detailText = nil;
    if (detail) {
        detailText = FORMAT(@"\n%@", detail);
    }
    
    MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:title detail:detailText items:items];
    [alertView show];
}

- (void) confirmWithTitle:(NSString *)title detail:(NSString *)detail btnText:(NSString *)btnText cancelText:(NSString *)cancelText block:(voidBlock)block canceled:(voidBlock)canceled
{
    MMPopupItemHandler handler = ^(NSInteger index) {
        if (index == 1) {
            if (block) {
                block();
            }
        }
        else {
            if (canceled) {
                canceled();
            }
        }
    };
    NSArray *items =
    @[MMItemMake(cancelText, MMItemTypeNormal, handler),
      MMItemMake(btnText, MMItemTypeHighlight, handler)];
    
    NSString *detailText = nil;
    if (detail) {
        detailText = FORMAT(@"\n%@", detail);
    }
    
    MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:title detail:detailText items:items];
    [alertView show];
}

- (void) alertWithIcon:(NSString *)icon detail:(NSString *)detail block:(voidBlock)block
{
    MMPopupItemHandler handler = ^(NSInteger index) {
        if (block) {
            block();
        }
    };
    NSArray *items =
    @[MMItemMake(@"确定", MMItemTypeHighlight, handler)];
    
    AKAlertView *alertView = [[AKAlertView alloc] initWithConfirmTitle:icon titleFont:FA_ICONFONTSIZE(35) titleColor:RED_COLOR detail:detail items:items];
    [alertView show];
}

- (void) alertWithTitle:(NSString *)title detail:(NSString *)detail block:(voidBlock)block
{
    [self alertWithTitle:title btnText:@"确定" detail:detail block:block];
}

- (void) alertWithTitle:(NSString *)title btnText:(NSString *)btnText detail:(NSString *)detail block:(voidBlock)block
{
    MMPopupItemHandler handler = ^(NSInteger index) {
        if (block) {
            block();
        }
    };
    NSArray *items =
    @[MMItemMake(btnText, MMItemTypeHighlight, handler)];
    
    NSString *detailText = nil;
    if (detail) {
        detailText = FORMAT(@"\n%@", detail);
    }
    
    MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:title detail:detailText items:items];
    [alertView show];
}

@end

