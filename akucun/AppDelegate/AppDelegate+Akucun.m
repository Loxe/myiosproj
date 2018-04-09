//
//  AppDelegate+Akucun.m
//  akucun
//
//  Created by Jarry Z on 2018/4/3.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "AppDelegate+Akucun.h"
#import "OnboardingViewController.h"
#import "OnboardingContentViewController.h"
#import "MainViewController.h"
#import <GTSDK/GeTuiSdk.h>
#import "EBBannerView.h"
#import "ProductsManager.h"
#import "AKAlertView.h"

@implementation AppDelegate (Akucun)

#pragma mark - Guide
- (void) showGuidePages
{
    CGFloat topOffset = 0;// isIPhoneX ? 44 : 0;
    CGFloat heightOffset = isIPhoneX ? 104 : 0;
    OnboardingContentViewController *page1 = [OnboardingContentViewController contentWithTitle:@""
                                                                                          body:@""
                                                                                         image:[UIImage imageNamed:@"guide01.jpg"]
                                                                                    buttonText:@""
                                                                                        action:nil];
    page1.movesToNextViewController = YES;
    page1.iconWidth = SCREEN_WIDTH;
    page1.iconHeight = SCREEN_HEIGHT- heightOffset;
    page1.topPadding = topOffset;
    OnboardingContentViewController *page2 = [OnboardingContentViewController contentWithTitle:@""
                                                                                          body:@""
                                                                                         image:[UIImage imageNamed:@"guide02.jpg"]
                                                                                    buttonText:@""
                                                                                        action:nil];
    page2.movesToNextViewController = YES;
    page2.iconWidth = SCREEN_WIDTH;
    page2.iconHeight = SCREEN_HEIGHT- heightOffset;
    page2.topPadding = topOffset;
    OnboardingContentViewController *page3 = [OnboardingContentViewController contentWithTitle:@""
                                                                                          body:@""
                                                                                         image:[UIImage imageNamed:@"guide03.jpg"]
                                                                                    buttonText:@""
                                                                                        action:nil];
    page3.movesToNextViewController = YES;
    page3.iconWidth = SCREEN_WIDTH;
    page3.iconHeight = SCREEN_HEIGHT- heightOffset;
    page3.topPadding = topOffset;
    
    OnboardingContentViewController *page4 = [OnboardingContentViewController contentWithTitle:@""
                                                                                          body:@""
                                                                                         image:[UIImage imageNamed:@"guide04.jpg"]
                                                                                    buttonText:@""
                                                                                        action:nil];
    page4.movesToNextViewController = YES;
    page4.iconWidth = SCREEN_WIDTH;
    page4.iconHeight = SCREEN_HEIGHT- heightOffset;
    page4.topPadding = topOffset;
    
    OnboardingContentViewController *page5 = [OnboardingContentViewController contentWithTitle:@""
                                                                                          body:@""
                                                                                         image:[UIImage imageNamed:@"guide05.jpg"]
                                                                                    buttonText:@""
                                                                                        action:^
                                              {
                                                  [self showNormalVC];
                                              }];
    page5.iconWidth = SCREEN_WIDTH;
    page5.iconHeight = SCREEN_HEIGHT- heightOffset;
    page5.topPadding = topOffset;
    //    page5.actionButton.backgroundColor = COLOR_MAIN;
    page5.actionButton.titleLabel.font = BOLDSYSTEMFONT(16);
    //    page5.actionButton.layer.cornerRadius = 5;
    //    page5.actionButton.layer.masksToBounds = YES;
    
    // 容器
    OnboardingViewController *contentVC = [OnboardingViewController onboardWithBackgroundImage:nil contents:@[page1,page2,page3,page4,page5]];
    contentVC.shouldMaskBackground = NO;
    contentVC.shouldBlurBackground = NO;
    contentVC.pageControl.hidden = NO;
    contentVC.pageControl.pageIndicatorTintColor = COLOR_TEXT_LIGHT;
    contentVC.pageControl.currentPageIndicatorTintColor = COLOR_SELECTED;
    contentVC.allowSkipping = YES;
    contentVC.underPageControlPadding = isIPhoneX ? 30 : 20;
    contentVC.view.backgroundColor = RGBCOLOR(0xFD, 0x96, 0x9B);// [UIColor colorWithPatternImage:[UIImage imageNamed:@"guide_bg.jpg"]];
    contentVC.skipButton.backgroundColor = [BLACK_COLOR colorWithAlphaComponent:.4f];
    contentVC.skipButton.titleLabel.font = BOLDSYSTEMFONT(14);
    [contentVC.skipButton setNormalTitle:@"跳过"];
    [contentVC.skipButton setNormalColor:WHITE_COLOR highlighted:COLOR_SELECTED selected:nil];
    contentVC.skipButton.layer.cornerRadius = 15.0f;
    contentVC.skipButton.layer.masksToBounds = YES;
    contentVC.skipHandler = ^{
        [self showNormalVC];
    };
    
    self.window.rootViewController = contentVC;
}

- (void) showNormalVC
{
    self.window.rootViewController = self.viewController;
    if ([UserManager isValidToken]) {
        self.viewController.view.alpha = 1.0f;
        [self.viewController pushViewController:[MainViewController new] animated:NO];
    }
    else {
        self.viewController.view.alpha = 1.0f;
    }
    //
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:APP_VERSION];
}

#pragma mark - Getui

/** 远程通知注册成功委托 */
- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
    
    // 向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:token];
    
    // 向佳信客服注册deviceToken
    [[JXIMClient sharedInstance] bindDeviceToken:deviceToken];
}

- (void) application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    // Background Fetch 恢复SDK 运行
    [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);
}

/** iOS 10 以前，为处理 APNs 通知点击事件 */
- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    // 处理APNs代码，通过userInfo可以取到推送的信息（包括内容，角标，自定义参数等）。如果需要弹窗等其他操作，则需要自行编码。
    NSLog(@"\n>>>[Receive RemoteNotification - Background Fetch]:%@\n\n",userInfo);
    
    // 将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

/** iOS 10 及以后版本 */
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// App在前台获取到通知
- (void) userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    
    NSLog(@"willPresentNotification：%@", notification.request.content.userInfo);
    
    // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

// 点击通知进入App时触发，在该方法内统计有效用户点击数
- (void) userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
{
    NSLog(@"didReceiveNotification：%@", response.notification.request.content.userInfo);
    
    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
    
    completionHandler();
}
#endif

/** SDK启动成功返回cid */
- (void) GeTuiSdkDidRegisterClient:(NSString *)clientId
{
    //个推SDK已注册，返回clientId
    NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
    //
    if (self.pushReport == 0) {
        [self requestReportPush:clientId];
    }
}

/** SDK遇到错误回调 */
- (void) GeTuiSdkDidOccurError:(NSError *)error
{
    //个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@"\n>>>[GexinSdk error]:%@\n\n", [error localizedDescription]);
}

/** SDK收到透传消息回调 */
- (void) GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId
{
    //收到个推消息
    if (!payloadData) {
        return;
    }
    
    NSString *payloadMsg = nil;
    payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
    NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@",taskId,msgId, payloadMsg,offLine ? @"<离线消息>" : @""];
    NSLog(@"\n>>>[GexinSdk ReceivePayload]:%@\n\n", msg);
    
    NSDictionary *jsonData = [payloadData objectFromJSONData];
    if (jsonData) {
        [self handlePushMessage:jsonData offline:offLine];
    }
    else {
        if (!offLine) {
            /** EBBannerView */
            EBBannerView *banner = [EBBannerView bannerWithBlock:^(EBBannerViewMaker *make) {
                make.style   = EBBannerViewStyleiOS9;
                make.content = payloadMsg;
                make.object  = self;
            }];
            [banner show];
        }
    }
}

- (void) handlePushMessage:(NSDictionary *)jsonData offline:(BOOL)offline
{
    if (![UserManager isValidToken]) {
        return;
    }
    
    NSInteger action = [jsonData getIntegerValueForKey:@"action"];
    NSDictionary *payload = [jsonData objectForKey:@"payload"];
    
    switch (action) {
        case MSG_ACTION_SYNC_LIVE:   // 同步活动数据 指令
        {
            if (payload) {
                NSString *liveId = [payload getStringForKey:@"liveid"];
                if ([NSString isEmpty:liveId]) {
                    break;
                }
                [[ProductsManager instance] deleteDataByLive:liveId];
                //
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SYNC_LIVEDATA object:nil userInfo:@{@"liveId" : liveId}];
            }
        }
            break;
            
        case MSG_ACTION_PRODUCT_OFF:   // 活动商品下架 指令
        {
            if (payload) {
                NSString *liveId = [payload getStringForKey:@"liveid"];
                NSArray *products = [payload objectForKey:@"products"];
                if (!products) {
                    break;
                }
                for (NSString *pId in products) {
                    [[ProductsManager instance] deleteDataById:pId];
                }
                
                //
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SYNC_LIVEDATA object:nil userInfo:@{@"liveId" : liveId}];
            }
        }
            break;
            
        case MSG_ACTION_UPDATE_LIVE:   // 刷新活动信息
        {
            if (payload) {
                NSString *liveId = [payload getStringForKey:@"liveid"];
                if ([NSString isEmpty:liveId]) {
                    break;
                }
                //
                [[LiveManager instance] requestUpdateLive:liveId];
            }
        }
            break;
            
        case MSG_ACTION_UPDATE_USERINFO:    // 刷新用户信息
        {
            [[UserManager instance] requestUserInfo:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_USERINFO object:nil];
            }];
        }
            break;
            
        case MSG_ACTION_APP_UPGRADE:        // 版本更新
        {
            if (payload) {
                NSString *desc = [payload getStringForKey:@"desc"];
                NSString *url = [payload getStringForKey:@"url"];
                if (![NSString isEmpty:url]) {
                    [self updateVersionWith:desc url:url];
                }
            }
        }
            break;
            
        case MSG_ACTION_REWARD_INFO:        // 奖励弹窗
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REWARD_INFO object:nil userInfo:jsonData];
        }
            break;
            
        case MSG_ACTION_ALERT_MSG:          // 弹框提示
        {
//            NSString *title = [jsonData getStringForKey:@"title"];
            NSString *message = [jsonData getStringForKey:@"message"];
            if ([NSString isEmpty:message]) {
                break;
            }
            
            MMPopupItemHandler handler = ^(NSInteger index) {
            };
            NSArray *items =
            @[MMItemMake(@"确定", MMItemTypeHighlight, handler)];
            
            AKAlertView *alertView = [[AKAlertView alloc] initWithConfirmTitle:FA_ICONFONT_ALERT titleFont:FA_ICONFONTSIZE(35) titleColor:RED_COLOR detail:message items:items];
            [alertView show];
        }
            break;
            
        default:
        {
            if (offline) {
                break;
            }
            NSString *title = [jsonData getStringForKey:@"title"];
            NSString *message = [jsonData getStringForKey:@"message"];
            if ([NSString isEmpty:message]) {
                break;
            }
            /** EBBannerView */
            EBBannerView *banner = [EBBannerView bannerWithBlock:^(EBBannerViewMaker *make) {
                make.style   = EBBannerViewStyleiOS9;
                if (![NSString isEmpty:title]) {
                    make.title = title;
                }
                make.stayDuration = 5.0f;
                make.content = message;
            }];
            [banner show];
        }
            break;
    }
}

- (void) updateVersionWith:(NSString *)desc url:(NSString *)url
{
    [MMAlertView hideAll];
    
    MMPopupItemHandler handler = ^(NSInteger index) {
        if (index == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    };
    NSArray *items =
    @[MMItemMake(@"取消", MMItemTypeNormal, handler),
      MMItemMake(@"更新", MMItemTypeHighlight, handler)];
    
    MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"版本更新" detail:FORMAT(@"\n%@", desc) items:items];
    [alertView show];
}

@end
