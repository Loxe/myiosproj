//
//  RelatedSMSAlert.h
//  akucun
//
//  Created by Jarry Z on 2018/4/5.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "MMAlertView.h"

/**
 申请关联主账号 验证码输入提示框
 */
@interface RelatedSMSAlert : MMPopupView

@property (nonatomic,copy) idRangeBlock confirmBlock;

@end
