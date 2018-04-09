//
//  AppDelegate.m
//  akucun
//
//  Created by Jarry Zhu on 2017/3/6.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Akucun.h"
#import "WXApiManager.h"
#import "LoginViewController.h"
#import "MainViewController.h"
#import "PSplashWindow.h"
#import "ProductsManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AFNetworking.h"
#import "SDImageCache.h"
#import "MMAlertView.h"
#import "DeviceIDManager.h"
#import "RequestUserActive.h"
#import "RequestReportInfo.h"
#import "RequestReportPush.h"
#import "IQKeyboardManager.h"
#import <GTSDK/GeTuiSdk.h>
#import "EBBannerView.h"
#import "RewardAlertView.h"
// iOS10 及以上需导入 UserNotifications.framework
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

#import <AlipaySDK/AlipaySDK.h>
#import "umfPaySdkIphone.h"
#import <Bugly/Bugly.h>

// 微信
#define kWeixinAppID        @"wxb140ca2d12d4425a"

#if APPSTORE        // APP STORE 版

// 个推
#define kGtAppId            @"1EbD6HaMeAAzDtRe26M4M8"
#define kGtAppKey           @"XBiGO1w4fz8kfg6SleObp7"
#define kGtAppSecret        @"NIdWw96hziAN3nLZaOmU54"

// Bugly APP ID
#define kBuglyAppID         @"30087b8660"

#elif   AKTEST      // 测试版

// 开启PGY
#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>

#define kPGYAppId           @"2232a4f417bfe1bd209626d2d8866735"

// 个推 测试
#define kGtAppId            @"nVFJp4zLUm9Qoo7AavsR9A"
#define kGtAppKey           @"vI1gqsa6MA7TLEquvc78B1"
#define kGtAppSecret        @"XUOsNCwbfgAypmPR14i1Q3"

// Bugly APP ID
#define kBuglyAppID         @"e81f79c815"

#else               // 企业版

// 企业版开启PGY
#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>

#define kPGYAppId           @"caa2a696733b8285aadb6e3e0ffd3125"

// 个推
#define kGtAppId            @"oTVLMyYO1k6eRte02gL6P"
#define kGtAppKey           @"b1m5LbSIUn7TAFTKolyA53"
#define kGtAppSecret        @"Ma3txz1mLC8d1DKSChv8O3"

// Bugly APP ID
#define kBuglyAppID         @"eecfa3b10e"   //@"18444962f5"

#endif

// Bugtags
//#define kBugtagsAppKey      @"34d1e4156f41071028cab384437ace94"

@interface AppDelegate () <GeTuiSdkDelegate, UNUserNotificationCenterDelegate>

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation AppDelegate

+ (AppDelegate *) sharedDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#if !DEBUG
    // Bugly
    [Bugly startWithAppId:kBuglyAppID];
#endif
    
//    INFOLOG(@"============= > %@", kGtAppId);
    
    // 佳信
    [self initJXSDKWithOptions:launchOptions];
    
    // 联动支付
    [self umfPaySdkRegister];
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
//    NSLog(@"(%f, %f)", SCREEN_WIDTH, SCREEN_HEIGHT);
    
    //
//    [SCLog initLog];
    
    //
    [ServerManager initHTTPServer];
    
    //
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[BLACK_COLOR colorWithAlphaComponent:0.6f]];
    [SVProgressHUD setForegroundColor:WHITE_COLOR];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD setMinimumDismissTimeInterval:3.0f];
    [SVProgressHUD setMaxSupportedWindowLevel:(UIWindowLevelStatusBar+100)];
    
    //
//    [IQKeyboardManager sharedManager].canAdjustAdditionalSafeAreaInsets = YES;
    
    // WX API
    [WXApi registerApp:kWXAppID];
    
    // 通过个推平台分配的appId、 appKey 、appSecret 启动SDK，注：该方法需要在主线程中调用
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    // 注册 APNs
    [self registerRemoteNotification];

    [[UINavigationBar appearance] setTintColor:COLOR_TITLE];
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes: @{NSForegroundColorAttributeName: COLOR_TITLE,
          NSFontAttributeName: SYSTEMFONT(18)}];
    
//    [DeviceIDManager deleteIDFV];
    // 上报设备信息
    [self requestReportInfo];
    
#ifndef APPSTORE    // 企业版
    //
    #if !TARGET_IPHONE_SIMULATOR
    //启动基本SDK
    [[PgyManager sharedPgyManager] startManagerWithAppId:kPGYAppId];
    //关闭用户反馈功能(默认开启)
    [[PgyManager sharedPgyManager] setEnableFeedback:NO];
    
    //启动更新检查SDK
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:kPGYAppId];
//    [[PgyUpdateManager sharedPgyManager] checkUpdate];
    #endif
    
#else               // APP STORE 版
    
#if !DEBUG
    // 判断akucun企业版是否已安装
    BOOL installedAkucun = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"akvip://"]];
    NSLog(@"== installedAkucun = %d", installedAkucun);
    if (installedAkucun) {
        [self showExitApp];
    }
#endif

#endif
    
    //
    [ProductsManager init];
    
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserGuideNewOrderToPay];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kUserGuideNewInvitation"];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kUserGuideNewTeam"];

    self.viewController = [[UINavigationController alloc] initWithRootViewController:[LoginViewController new]];
    self.viewController.view.alpha = 0.0f;

    BOOL hideGuide = [[NSUserDefaults standardUserDefaults] boolForKey:APP_VERSION];
    if (hideGuide || isPad) {
        self.window.rootViewController = self.viewController;
    }
    else {
        [self showGuidePages];
    }
    [self.window makeKeyAndVisible];

    // 启动画面加载
    [PSplashWindow splashFinished:^{
        if (hideGuide || isPad) {
            if ([UserManager isValidToken]) {
                self.viewController.view.alpha = 1.0f;
                [self.viewController pushViewController:[MainViewController new] animated:NO];
            }
            else {
                self.viewController.view.alpha = 1.0f;
            }
        }
    }];
        
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldUpdateVersion:) name:NOTIFICATION_VERSION_UPDATE object:nil];
    
    return YES;
}

#pragma mark - 佳信客服SDK初始化
/** 佳信客服SDK初始化 */
- (void)initJXSDKWithOptions:(NSDictionary *)launchOptions  {
    
    LocalizationSetLanguage(@"zh-Hans");
    [sClient initializeSDKWithAppKey:JX_APPKEY andLaunchOptions:launchOptions andConfig:nil];
}

#pragma mark - 联动支付SDK注册
- (void)umfPaySdkRegister {

    // 注册微信AppID
    [[umfPaySdkIphone sharedUmfManager] umfRegisterApp:kWeixinAppID];

    // 注册Apple Pay的merchantID
//    [[umfPaySdkIphone sharedUmfManager] umfRegisterMerchant:@"com.aikucun.akvip"];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_APP_BACKGROUND object:nil];
    
    // 图片缓存大于500M时自动清理
    NSInteger size = [[SDImageCache sharedImageCache] getSize];
    if (size > 500 * 1024 * 1024) {
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    }
    
    // 活动结束 下架
    NSString *overLives = [LiveManager instance].overLiveIds;
    if (overLives && overLives.length > 0) {
        NSArray *array = [overLives componentsSeparatedByString:@","];
        for (NSString *liveId in array) {
            [[ProductsManager instance] deleteDataByLive:liveId];
        }
        [LiveManager instance].overLiveIds = nil;
    }
    
    //
    [self.manager.reachabilityManager stopMonitoring];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    // 支付宝回调处理
    [[umfPaySdkIphone sharedUmfManager] alipaymentEnd];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_APP_FOREGROUND object:nil];
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
#ifndef APPSTORE    // AppStore版本禁用PGY
    #if !TARGET_IPHONE_SIMULATOR && !DEBUG && !AKTEST
    // PGY 检查更新
    [[PgyUpdateManager sharedPgyManager] checkUpdate];
    #endif
#endif
    
    GCD_DELAY(^{
        [self monitorNetworking];
    }, .5f);

    //
    if ([UserManager isValidToken]) {
        [self requestActivate];
    }
    
    // 取消显示 Icon Badge
    [application setApplicationIconBadgeNumber:0];
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - 

- (void) requestActivate
{
    /*
    // 用户激活 每天上报一次
    NSString *today = [[NSDate date] formattedDateWithFormatString:@"yyyyMMdd"];
    NSString *date = [[NSUserDefaults standardUserDefaults] stringForKey:@"AIKUCUN_USER_ACTIVATE"];
    if (date && [date isEqualToString:today]) {
        return;
    }*/
    RequestUserActive *request = [RequestUserActive new];
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
    {
//        [[NSUserDefaults standardUserDefaults] setValue:today forKey:@"AIKUCUN_USER_ACTIVATE"];
    } onFailed:nil];
}

- (void) requestReportInfo
{
    self.isReport = 1;
    RequestReportInfo *request = [RequestReportInfo new];
    [SCHttpServiceFace serviceWithPostRequest:request onSuccess:^(id content) {
        self.isReport = 2;
    } onFailed:^(id content) {
        self.isReport = 0;
    } onError:^(id content) {
        self.isReport = 0;
    }];
}

- (void) requestReportPush:(NSString *)pushId
{
    self.pushReport = 1;
    RequestReportPush *request = [RequestReportPush new];
    request.pushId = pushId;
    
    [SCHttpServiceFace serviceWithRequest:request onSuccess:^(id content) {
        self.pushReport = 2;
    } onFailed:^(id content) {
        self.pushReport = 0;
    } onError:^(id content) {
        self.pushReport = 0;
    }];
}

#pragma mark - WX API / Alipay

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (BOOL) application:(UIApplication *)application
             openURL:(NSURL *)url
   sourceApplication:(NSString *)sourceApplication
          annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            //
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ALIPAY_SUCCESS object:resultDic];
        }];
        return YES;
    }

    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result : %@",resultDic);
            //
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ALIPAY_SUCCESS object:nil userInfo:resultDic];
        }];
        return YES;
    }
    
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    
    // 联动支付处理
//    return  [[umfPaySdkIphone sharedUmfManager]umfHandleOpenUrl:url];
}

/** 注册 APNs */
- (void) registerRemoteNotification
{
    /*
     警告：Xcode8 需要手动开启"TARGETS -> Capabilities -> Push Notifications"
     */
    /*
     警告：该方法需要开发者自定义，以下代码根据 APP 支持的 iOS 系统不同，代码可以对应修改。
     以下为演示代码，注意根据实际需要修改，注意测试支持的 iOS 系统都能获取到 DeviceToken
     */
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#else // Xcode 7编译会调用
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#endif
    }
    else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
    /** 前台弹框控件的EBBannerView点击通知事件 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bannerViewDidClick:) name:EBBannerViewDidClickNotification object:nil];
}

/** 前台推送弹框点击事件 */
-(void) bannerViewDidClick:(NSNotification*)noti
{
    NSLog(@"点击前台弹框了 %@",noti.object);
}

#pragma mark-监听网络
- (void) monitorNetworking
{
    // 开启网络指示器
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    NSURL *url = [NSURL URLWithString:kHTTPServer];
    
    if (!_manager) {
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
        @weakify(self)
        [_manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            @strongify(self)
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWWAN:
                {
                    INFOLOG(@"===== 3G/4G =====");
                    self.networkAvailable = YES;
                }
                    break;
                    
                case AFNetworkReachabilityStatusReachableViaWiFi:
                {
                    INFOLOG(@"===== WiFi =====");
                    self.networkAvailable = YES;
                }
                    break;
                    
                case AFNetworkReachabilityStatusNotReachable:
                default:
                {
                    INFOLOG(@"网络不可达");
                    self.networkAvailable = NO;
                    GCD_MAIN(^{
                        [self showNetworkAlert];
                    });
                }
                    break;
            }
            
            if (self.networkAvailable && self.isReport == 0) {
                [self requestReportInfo];
            }
        }];
    }
    
    // 开始监听
    [_manager.reachabilityManager startMonitoring];
}

- (void) showNetworkAlert
{
    [MMAlertView hideAll];
    
    MMPopupItemHandler handler = ^(NSInteger index) {
        if (index == 1) {
            // 系统网络设置
            NSURL *url = [NSURL URLWithString:@"App-Prefs:root=WIFI"];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            } else {
                DEBUGLOG(@"不能跳转至WIFI设置界面");
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        }
    };
    NSArray *items =
    @[MMItemMake(@"取消", MMItemTypeNormal, handler),
      MMItemMake(@"去设置", MMItemTypeHighlight, handler)];
    
    MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"网络不可用" detail:@"\n当前网络连接不可用，请检查网络设置 ！" items:items];
    [alertView show];
}

- (void) showExitApp
{
    MMPopupItemHandler handler = ^(NSInteger index) {
        exit(0);
    };
    NSArray *items =
    @[MMItemMake(@"退出", MMItemTypeHighlight, handler)];
    
    MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"检测到您已安装 爱库存VIP，请先卸载 爱库存VIP ！" detail:@"" items:items];
    [alertView show];
}

- (void) shouldUpdateVersion:(NSNotification *)info
{
    [SVProgressHUD dismiss];
    [MMAlertView hideAll];
    
    MMPopupItemHandler handler = ^(NSInteger index) {
        if (index == 1) {
            [self updateVersion];
        }
    };
    NSArray *items =
    @[MMItemMake(@"取消", MMItemTypeNormal, handler),
      MMItemMake(@"更新", MMItemTypeHighlight, handler)];
    
    NSDictionary *msgData = info.userInfo;
    NSString *msg = [msgData objectForKey:HTTP_KEY_MSG];
    
    MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"版本更新" detail:FORMAT(@"\n%@", msg) items:items];
    [alertView show];
}

- (void) updateVersion
{
#ifdef APPSTORE
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1336929842"]];
#else
    [SVProgressHUD showWithStatus:nil];
    [[PgyUpdateManager sharedPgyManager] checkUpdateWithDelegete:self selector:@selector(updateMethod:)];
#endif
}

#ifndef APPSTORE
- (void) updateMethod:(NSDictionary *)info
{
    INFOLOG(@"%@", info);
    [SVProgressHUD dismiss];
    if (info) {
        NSString *url = info[@"downloadURL"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
    else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-services://?action=download-manifest&url=https%3A%2F%2Fwww.pgyer.com%2Fapiv2%2Fapp%2Fplist%3FappKey%3Dcaa2a696733b8285aadb6e3e0ffd3125%26_api_key%3D7270a48e25dedefde81a403e78d6725d"]];
    }
    [[PgyUpdateManager sharedPgyManager] updateLocalBuildNumber];
}
#endif

@end
