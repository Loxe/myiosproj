//
//  WXApiManager.h
//  akucun
//
//  Created by Jarry on 16/9/2.
//  Copyright © 2016年 Sucang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

//
#define kWXAppID        @"wxb140ca2d12d4425a"
//@"wxe70358a259804642"
#define kWXAppSecret    @"88eacde204275bd006b24913e98a2c09"
//@"ee068f44b2c41c43d82d539c49741b39"


#define kWXApiURL       @"https://api.weixin.qq.com/sns"

@protocol WXApiManagerDelegate <NSObject>

@optional

- (void) managerDidAuthSuccess:(NSString *)openId unionId:(NSString *)unionId userInfo:(NSDictionary *)userInfo;

- (void) managerDidAuthCanceled:(SendAuthResp *)authResp msg:(NSString*)message;

- (void) managerDidRecvGetMessageReq:(GetMessageFromWXReq *)request;

- (void) managerDidRecvShowMessageReq:(ShowMessageFromWXReq *)request;

- (void) managerDidRecvLaunchFromWXReq:(LaunchFromWXReq *)request;

- (void) managerDidRecvMessageResponse:(SendMessageToWXResp *)response;

- (void) managerDidRecvAuthResponse:(SendAuthResp *)response;

- (void) managerDidRecvAddCardResponse:(AddCardToWXCardPackageResp *)response;


- (void) managerDidRecvPayResponse:(PayResp *)payResp;

@end

@interface WXApiManager : NSObject <WXApiDelegate>

@property (nonatomic, assign) id<WXApiManagerDelegate> delegate;

+ (instancetype) sharedManager;

+ (void) sendAuthRequestWithState:(NSString *)state
                           openId:(NSString *)openId
                   viewController:(UIViewController *)viewController;

+ (void) payRequest:(NSDictionary *)payInfo;


- (void) requestAccessTokenWithCode:(NSString *)code;

- (void) requestRefreshToken:(NSString *)refreshToken;

- (void) requestUserInfoWithOpenId:(NSString *)openId
                       accessToken:(NSString *)token;

@end
