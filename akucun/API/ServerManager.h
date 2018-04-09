//
//  ServerManager.h
//  akucun
//
//  Created by Jarry on 16/12/25.
//  Copyright (c) 2016年 Sucang. All rights reserved.
//

#import "HttpDefines.h"
#import "SCHttpServiceFace.h"

/**
 *  平台服务器地址配置管理
 */
@interface ServerManager : NSObject

/**
 *  初始化 HTTP 服务器、参数 等
 */
+ (void) initHTTPServer;

/**
 *  HTTP 服务器地址
 */
@property (nonatomic, copy)   NSString    *httpServer;

/**
 *  设备唯一号ID
 */
@property (nonatomic, copy)   NSString    *deviceId;

/**
 *  ServerManager 单例管理
 *
 *  @return ServerManager
 */
+ (ServerManager *) instance;

- (void) saveHttpServer:(NSString *)httpServer;

@end
