//
//  WXApiManager.m
//  akucun
//
//  Created by Jarry on 16/9/2.
//  Copyright © 2016年 Sucang. All rights reserved.
//

#import "WXApiManager.h"

@implementation WXApiManager

#pragma mark - LifeCycle

+ (instancetype) sharedManager
{
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}

+ (void) sendAuthRequestWithState:(NSString *)state
                           openId:(NSString *)openId
                   viewController:(UIViewController *)viewController
{
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_message,snsapi_userinfo";
    req.state = state;
    req.openID = openId;
    
    [WXApi sendAuthReq:req viewController:viewController delegate:[WXApiManager sharedManager]];
}

+ (void) payRequest:(NSDictionary *)payInfo
{
    // 调起微信支付
    PayReq* req = [[PayReq alloc] init];
    req.partnerId = [payInfo objectForKey:@"partnerid"];
    req.prepayId = [payInfo objectForKey:@"prepayid"];
    req.nonceStr = [payInfo objectForKey:@"noncestr"];
    req.package = [payInfo objectForKey:@"package"];
    req.sign = [payInfo objectForKey:@"sign"];
    
    NSString *timeStamp = [payInfo objectForKey:@"timestamp"];
    req.timeStamp = [timeStamp intValue];

    [WXApi sendReq:req];
}

#pragma mark - WX API Request

- (void) requestAccessTokenWithCode:(NSString *)code
{
    NSString *url = FORMAT(@"%@/oauth2/access_token", kWXApiURL);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:kWXAppID forKey:@"appid"];
    [params setObject:kWXAppSecret forKey:@"secret"];
    [params setObject:code forKey:@"code"];
    [params setObject:@"authorization_code" forKey:@"grant_type"];
 
    [SCHttpServiceFace serviceWithURL:url
                               method:SC_HTTP_GET
                               params:params
                                onSuc:^(id content)
    {
        NSDictionary *resp = content;
        NSString *openId = [resp getStringForKey:@"openid"];
        NSString *token = [resp getStringForKey:@"access_token"];
        if (openId.length > 0) {
            [self requestUserInfoWithOpenId:openId accessToken:token];
        }
    }
                              onError:^(id content)
    {
        [SVProgressHUD showErrorWithStatus:@"网络连接失败！"];
    }];
}

- (void) requestRefreshToken:(NSString *)refreshToken
{
    NSString *url = FORMAT(@"%@/oauth2/refresh_token", kWXApiURL);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:kWXAppID forKey:@"appid"];
    [params setObject:refreshToken forKey:@"refresh_token"];
    [params setObject:@"refresh_token" forKey:@"grant_type"];
    
    [SCHttpServiceFace serviceWithURL:url
                               method:SC_HTTP_GET
                               params:params
                                onSuc:^(id content)
     {
//         DEBUGLOG(@"%@",content);
     }
                              onError:^(id content)
     {
         [SVProgressHUD showErrorWithStatus:@"网络连接失败！"];
     }];
}

- (void) requestUserInfoWithOpenId:(NSString *)openId
                       accessToken:(NSString *)token
{
    NSString *url = FORMAT(@"%@/userinfo", kWXApiURL);

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"access_token"];
    [params setObject:openId forKey:@"openid"];
    
    [SCHttpServiceFace serviceWithURL:url
                               method:SC_HTTP_GET
                               params:params
                                onSuc:^(id content)
     {
         NSDictionary *resp = content;
         NSString *openId = [resp getStringForKey:@"openid"];
         NSString *unionId = [resp getStringForKey:@"unionid"];
         //
//         NSString *nickname = [resp getStringForKey:@"nickname"];
//         [UserManager saveWeixinName:nickname];
         
         if (_delegate
             && [_delegate respondsToSelector:@selector(managerDidAuthSuccess:unionId:userInfo:)]) {
             [_delegate managerDidAuthSuccess:openId unionId:unionId userInfo:resp];
         }
     }
                              onError:^(id content)
     {
         [SVProgressHUD showErrorWithStatus:@"网络连接失败！"];
     }];
}

#pragma mark - WXApiDelegate

- (void) onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *authResp = (SendAuthResp *)resp;
        if (authResp.errCode == 0) {
            DEBUGLOG(@"-> WX Auth code : %@ ", authResp.code);
            if (authResp.code && authResp.code.length > 0) {
                // 请求 Access Token
                [self requestAccessTokenWithCode:authResp.code];
            }
        }
        else if (authResp.errCode == -2) {
            NSString *errMsg = @"用户取消授权！";
            ERRORLOG(errMsg);
            if (_delegate
                && [_delegate respondsToSelector:@selector(managerDidAuthCanceled:msg:)]) {
                [_delegate managerDidAuthCanceled:authResp msg:errMsg];
            }
        }
        else if (authResp.errCode == -4) {
            NSString *errMsg = @"用户拒绝授权！";
            ERRORLOG(errMsg);
            if (_delegate
                && [_delegate respondsToSelector:@selector(managerDidAuthCanceled:msg:)]) {
                [_delegate managerDidAuthCanceled:authResp msg:errMsg];
            }
        }
        else {
            if (_delegate
                && [_delegate respondsToSelector:@selector(managerDidAuthCanceled:msg:)]) {
                [_delegate managerDidAuthCanceled:authResp msg:nil];
            }
        }
    }
    else if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvMessageResponse:)]) {
            SendMessageToWXResp *messageResp = (SendMessageToWXResp *)resp;
            [_delegate managerDidRecvMessageResponse:messageResp];
        }
    }
    else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvAddCardResponse:)]) {
            AddCardToWXCardPackageResp *addCardResp = (AddCardToWXCardPackageResp *)resp;
            [_delegate managerDidRecvAddCardResponse:addCardResp];
        }
    }
    else if ([resp isKindOfClass:[PayResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvPayResponse:)]) {
            PayResp *response = (PayResp*)resp;
            [_delegate managerDidRecvPayResponse:response];
        }
    }
}

- (void) onReq:(BaseReq *)req
{
    if ([req isKindOfClass:[GetMessageFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvGetMessageReq:)]) {
            GetMessageFromWXReq *getMessageReq = (GetMessageFromWXReq *)req;
            [_delegate managerDidRecvGetMessageReq:getMessageReq];
        }
    } else if ([req isKindOfClass:[ShowMessageFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvShowMessageReq:)]) {
            ShowMessageFromWXReq *showMessageReq = (ShowMessageFromWXReq *)req;
            [_delegate managerDidRecvShowMessageReq:showMessageReq];
        }
    } else if ([req isKindOfClass:[LaunchFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvLaunchFromWXReq:)]) {
            LaunchFromWXReq *launchReq = (LaunchFromWXReq *)req;
            [_delegate managerDidRecvLaunchFromWXReq:launchReq];
        }
    }
}

@end
