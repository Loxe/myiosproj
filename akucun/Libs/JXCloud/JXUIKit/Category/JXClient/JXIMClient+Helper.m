//
//  JXIMClient+Helper.m
//

#import "JXIMClient+Helper.h"

#import "JXError+LocalDescription.h"
#import "JXHUD.h"

#import "JXMCSUserManager.h"
#import "JXLocalPushManager.h"

static NSDictionary *LAUNCH_OPTIONS = nil;
static NSDictionary *CLIENT_CONFIG = nil;

@implementation JXIMClient (Helper)

#pragma mark - loadConfig

+ (NSString *)appkey {
    return JX_APPKEY;
}

+ (NSDictionary *)clientConfig {
    return CLIENT_CONFIG;
}

- (void)initializeSDKWithAppKey:(NSString *)key
               andLaunchOptions:(NSDictionary *)launchOptions
                      andConfig:(NSDictionary *)config {
    JX_APPKEY = key;
    if (launchOptions) {
        LAUNCH_OPTIONS = launchOptions;
    }
    if (config) {
        CLIENT_CONFIG = config;
    }
    UIApplication *app = [UIApplication sharedApplication];
    [self setupAppDelegateToClient];
    [self registerAPNS:app];

    [[JXLocalPushManager sharedInstance] registerLocalNotification];
    if (key.length) {
        JXError *error = [self registerSDKWithAppKey:key];
        if (error) {
            [sJXHUD showMessage:[error getLocalDescription] duration:1.4];
        }
    }
}

#pragma mark - register apns

- (void)registerAPNS:(UIApplication *)application {
#if !TARGET_IPHONE_SIMULATOR
    if (IOSVersion >= 10.0) {    // iOS10
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = (id<UNUserNotificationCenterDelegate>)[JXLocalPushManager sharedInstance];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge |
                                                 UNAuthorizationOptionSound |
                                                 UNAuthorizationOptionAlert)
                              completionHandler:^(BOOL granted, NSError *_Nullable error) {
                                  if (!error) {
                                  }
                              }];
        [application registerForRemoteNotifications];
    } else if (IOSVersion >= 8.0) {    // iOS8
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge |
                                 UIUserNotificationTypeSound
                      categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    } else {    // iOS7
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge |
                                                        UIRemoteNotificationTypeSound |
                                                        UIRemoteNotificationTypeAlert];
    }
#endif
}

#pragma mark - app delegate notifications

- (void)setupAppDelegateToClient {
    [kDefaultNotificationCenter addObserver:self
                                   selector:@selector(appDidEnterBackground:)
                                       name:UIApplicationDidEnterBackgroundNotification
                                     object:nil];
    [kDefaultNotificationCenter addObserver:self
                                   selector:@selector(appWillEnterForeground:)
                                       name:UIApplicationWillEnterForegroundNotification
                                     object:nil];
    [kDefaultNotificationCenter addObserver:self
                                   selector:@selector(appDidFinishLaunching:)
                                       name:UIApplicationDidFinishLaunchingNotification
                                     object:nil];
    [kDefaultNotificationCenter addObserver:self
                                   selector:@selector(appDidBecomeActive:)
                                       name:UIApplicationDidBecomeActiveNotification
                                     object:nil];
    [kDefaultNotificationCenter addObserver:self
                                   selector:@selector(appWillResignActive:)
                                       name:UIApplicationWillResignActiveNotification
                                     object:nil];
    [kDefaultNotificationCenter addObserver:self
                                   selector:@selector(appDidReceiveMemoryWarning:)
                                       name:UIApplicationDidReceiveMemoryWarningNotification
                                     object:nil];
    [kDefaultNotificationCenter addObserver:self
                                   selector:@selector(appWillTerminate:)
                                       name:UIApplicationWillTerminateNotification
                                     object:nil];
    [kDefaultNotificationCenter addObserver:self
                                   selector:@selector(appProtectedDataWillBecomeUnavailable:)
                                       name:UIApplicationProtectedDataWillBecomeUnavailable
                                     object:nil];
    [kDefaultNotificationCenter addObserver:self
                                   selector:@selector(appProtectedDataDidBecomeAvailable:)
                                       name:UIApplicationProtectedDataDidBecomeAvailable
                                     object:nil];
}

@end
