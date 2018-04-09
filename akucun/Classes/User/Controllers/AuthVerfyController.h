//
//  AuthVerfyController.h
//  akucun
//
//  Created by deepin do on 2017/12/21.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface AuthVerfyController : BaseViewController

@property (nonatomic, copy)  NSString  *realname;       // 真实姓名
@property (nonatomic, copy)  NSString  *idcard;         // 身份证号
@property (nonatomic, copy)  NSString  *bankcard;       // 银行卡号
@property (nonatomic, copy)  NSString  *mobile;         // 手机号
@property (nonatomic, copy)  UIImage   *frontImg;       // 身份证正面（可为空）
@property (nonatomic, copy)  UIImage   *backImg;        // 身份证背面（可为空）

@end
