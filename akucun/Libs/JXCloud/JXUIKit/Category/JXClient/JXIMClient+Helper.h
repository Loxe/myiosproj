//
//  JXIMClient+Helper.h
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

#import "JXClientDelegate.h"
#import "JXIMClient.h"
#import "JXMacros.h"

@interface JXIMClient (Helper)

+ (NSString *)appkey;

+ (NSDictionary *)clientConfig;

- (void)initializeSDKWithAppKey:(NSString *)key
               andLaunchOptions:(NSDictionary *)launchOptions
                      andConfig:(NSDictionary *)config;

@end
