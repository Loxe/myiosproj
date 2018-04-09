//
//  ValidateManger.h
//  akucun
//
//  Created by deepin do on 2017/12/21.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ValidateManger : NSObject

/** 手机号较验 */
+ (BOOL)validateMobile:(NSString *)mobile;

/** 邮箱较验 */
+ (BOOL)validateEmail:(NSString *)email;

/** 密码较验 */
+ (BOOL)validatePassword:(NSString *)password;

/** 短信验证码较验 */
+ (BOOL)validateSMSCode:(NSString *)code;

/** 银行卡较验 */
+ (BOOL)validateBankCard:(NSString *)cardNumber;

/** 身份证较验 */
+ (BOOL)validateIDCardNumber: (NSString *)value;

@end
