//
//  HttpResponseBase.m
//  akucun
//
//  Created by Jarry on 17/3/15.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpResponseBase.h"
#import "HttpDefines.h"
#import "MMAlertView.h"

@implementation HttpResponseBase

- (void) parseDataObj:(id)Object
{
    [super parseDataObj:Object];
    //
    [self parseData:Object];
}

- (void) parseData:(NSDictionary *)jsonData
{
    // parse response data ...
}

- (BOOL) checkFailed:(NSDictionary *)response
{
    NSString *status = [response objectForKey:HTTP_KEY_STATUS];
    return [status isEqualToString:HTTP_STATUS_FAIL] || [status isEqualToString:HTTP_STATUS_ERROR];
}

- (void) showError:(id)error
{
    ERRORLOG(@"Response Error: \n%@", error);
    if ([error isKindOfClass:[NSDictionary class]]) {
        //
        NSDictionary *msgData = error;
        NSNumber *codeObj = [msgData objectForKey:HTTP_KEY_CODE];
        NSInteger code = codeObj ? codeObj.integerValue : 0;
        NSString *msg = [msgData objectForKey:HTTP_KEY_MSG];
        //
        if (code == ERR_VIP_DISABLED || code == ERR_NOT_FORWARD || code == ERR_NOT_PAYED) {
            // 非会员
//            [SVProgressHUD dismiss];
//            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NOT_VIP object:nil userInfo:msgData];
        }
        else if (code == 40005) {   // Token失效
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TOKEN_EXPIRED object:nil];
            [SVProgressHUD dismiss];
            [self showErrorDialog:msg code:code block:nil];
        }
        else if (code == 40006) {   // 强制同步更新
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SYNC_PRODUCTS object:nil];
        }
        else if (code == 40011) {   // 低版本升级
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_VERSION_UPDATE object:nil userInfo:msgData];
        }
        else if (code == ERR_DELIVER_INVALID) {   // 发货单已失效

        }
        else {
            [self showErrorMessage:msg code:code];
        }
    }
    else if ([error isKindOfClass:[NSError class]]) {
        //
        NSError *errorObj = error;
        if (errorObj.localizedDescription) {
            [self showErrorMessage:errorObj.localizedDescription];
        }
        else if (errorObj.code == -1001) {
            [self showErrorMessage:@"网络连接超时！"];
        }
        else if (errorObj.code == -1011 || errorObj.code == -1004) {
            [self showErrorMessage:@"服务器发生错误！"];
        }
        else {
            [self showErrorMessage:@"网络连接失败！"];
        }
    }
    else {
        //
        [self showErrorMessage:error];
    }
}

- (void) showErrorMessage:(NSString *)message
{
    [self showErrorMessage:message code:0];
}

- (void) showErrorMessage:(NSString *)message code:(NSInteger)code
{
    if (message && code > 0) {
        NSString *text = FORMAT(@"[E%ld]\n%@", (long)code, message);
        [SVProgressHUD showErrorWithStatus:text];
    }
    else if(message) {
        [SVProgressHUD showErrorWithStatus:FORMAT(@"[Error]\n%@", message)];
    }
    else if(code > 0) {
        [SVProgressHUD showErrorWithStatus:FORMAT(@"[E%ld]\n 未知错误 ！", (long)code)];
    }
    else {
        [SVProgressHUD showErrorWithStatus:InternationalString(@"msg_server_error")];
    }
}

- (void) showFailedMessage:(NSString *)message code:(NSInteger)code
{
    if (message && code > 0) {
        NSString *text = FORMAT(@"[F%ld]\n%@", (long)code, message);
        [SVProgressHUD showErrorWithStatus:text];
    }
    else if(message) {
        [SVProgressHUD showErrorWithStatus:FORMAT(@"[Failed]\n%@", message)];
    }
    else if(code > 0) {
        [SVProgressHUD showErrorWithStatus:FORMAT(@"[F%ld]\n 未知错误 ！", (long)code)];
    }
    else {
        [SVProgressHUD showErrorWithStatus:InternationalString(@"msg_server_error")];
    }
}

- (void) showErrorDialog:(NSString *)message code:(NSInteger)code block:(voidBlock)block
{
    NSString *title = InternationalString(@"msg_server_error");
    if (message && code > 0) {
        title = FORMAT(@"[E%ld]\n%@", (long)code, message);
    }
    else if(message) {
        title = FORMAT(@"[Error]\n%@", message);
    }
    else if(code > 0) {
        title = FORMAT(@"[E%ld]\n 未知错误 ！", (long)code);
    }
    
    MMPopupItemHandler handler = ^(NSInteger index) {
        if (block) {
            block();
        }
    };
    NSArray *items =
    @[MMItemMake(@"确定", MMItemTypeHighlight, handler)];
    
        MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:title detail:@"" items:items];
    [alertView show];
}

@end
