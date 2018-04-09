//
//  AppDelegate.h
//  akucun
//
//  Created by Jarry Zhu on 2017/3/6.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UINavigationController *viewController;

@property (assign, nonatomic) BOOL networkAvailable;

@property (nonatomic, assign) NSInteger isReport, pushReport;   // 0,1,2


+ (AppDelegate *) sharedDelegate;

- (void) requestReportPush:(NSString *)pushId;

@end

