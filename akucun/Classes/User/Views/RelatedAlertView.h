//
//  RelatedAlertView.h
//  akucun
//
//  Created by Jarry Z on 2018/4/4.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "MMAlertView.h"

/**
 申请关联主账号 警告提示框
 */
@interface RelatedAlertView : MMPopupView

+ (void) showWithConfirmed:(voidBlock)confirmBlock;

@end
