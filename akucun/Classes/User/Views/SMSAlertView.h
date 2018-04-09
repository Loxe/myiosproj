//
//  SMSAlertView.h
//  akucun
//
//  Created by Jarry Z on 2018/4/4.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "MMAlertView.h"

/**
 修改地址 校验手机号 验证码输入框
 */
@interface SMSAlertView : MMPopupView

@property (nonatomic,copy) NSString *mobile;

@property (nonatomic,copy) idBlock confirmBlock;

- (instancetype) initWithTitle:(NSString *)title mobile:(NSString *)mobile;

@end
