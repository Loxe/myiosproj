//
//  ServerManager.m
//  J1ST-System
//
//  Created by Jarry on 14/12/25.
//  Copyright (c) 2014年 Zeninfor. All rights reserved.
//

#import "ServerManager.h"
#import "HttpDefines.h"
#import "DeviceIDManager.h"

@implementation ServerManager

+ (void) initHTTPServer
{
    NSString *host = [[ServerManager instance] httpServer];
    NSString *server = FORMAT(@"%@/api/%@", host, kAPIVersion);
    [SCHttpServiceFace instance].serverHost = server;
    INFOLOG(@"Http Server : %@", server);
    
    //
    [ServerManager instance].deviceId = [DeviceIDManager IDFVString];
    INFOLOG(@"Device ID : %@", [ServerManager instance].deviceId);
    
    // 网络连接超时
    [SCHttpServiceFace instance].timeoutInterval = 30;
    
    // 自定义 Header
    NSString *model = [[UIDevice currentDevice].deviceString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *os = @"iOS";
    NSString *osVer = SYSTEM_VERSION;
    NSString *appVer = APP_VERSION;
    NSString *apiVer = kClientAPIVersion;
    
    NSMutableDictionary *headerParams = [NSMutableDictionary dictionary];
    [headerParams setParamValue:model forKey:@"AKC-MODEL"];
    [headerParams setParamValue:os forKey:@"AKC-OS"];
    [headerParams setParamValue:osVer forKey:@"AKC-OS-VERSION"];
    [headerParams setParamValue:appVer forKey:@"AKC-APP-VERSION"];
    [headerParams setParamValue:apiVer forKey:@"AKC-APP-API-VERSION"];
    [headerParams setParamValue:BUILD_VERSION forKey:@"AKC-APP-BUILD-VERSION"];
    
#ifdef APPSTORE
    [headerParams setParamValue:@"1001" forKey:@"AKC-APP-CHANNEL"];
#else
    [headerParams setParamValue:@"1000" forKey:@"AKC-APP-CHANNEL"];
#endif
    
    [SCHttpServiceFace instance].headerParams = headerParams;
    
    // User Agent
    NSString *userAgent = FORMAT(@"%@ %@ %@ %@ %@", model, os, osVer, appVer, apiVer);
    [SCHttpServiceFace instance].userAgent = userAgent;

    [SCHttpServiceFace instance].logEnabled = YES;
}

+ (ServerManager *) instance
{
    static dispatch_once_t  onceToken;
    static ServerManager * instance;
    dispatch_once(&onceToken, ^{
        instance = [[ServerManager alloc] init];
    });
    return instance;
}

- (id) init
{
    self = [super init];
    if (self) {
        //
#if kPRODUCTION_ENABLED
        self.httpServer = kHTTPServer;
#else
        self.httpServer = [self readHttpServer];
#endif
    }
    return self;
}

- (NSString *) readHttpServer
{
    NSString *httpServer = [USER_DEFAULT objectForKey:@"UDK_HttpServer"];
    if (!httpServer || httpServer.length == 0) {
        return kHTTPServer;
    }
    return httpServer;
}

- (void) saveHttpServer:(NSString *)httpServer
{
    _httpServer = httpServer;
    // Save
    [USER_DEFAULT setObject:httpServer forKey:@"UDK_HttpServer"];
    [USER_DEFAULT synchronize];
}

@end
