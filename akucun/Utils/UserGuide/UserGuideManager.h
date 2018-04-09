//
//  UserGuideManager.h
//  akucun
//
//  Created by Jarry Z on 2018/1/21.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 新手引导 功能定义
 */
#define kUserGuideNewOrderToPay     @"UserGuideNewOrderToPay"

#define kUserGuideFuncInvite        @"UserGuideFuncInvite"
#define kUserGuideNewInvitation     @"UserGuideNewInvitation"
#define kUserGuideNewApproval       @"UserGuideNewApproval"
#define kUserGuideNewTeam           @"UserGuideNewTeam"


@interface UserGuideManager : NSObject


/**
 显示新手功能引导

 @param function    功能定义
 @param title       引导说明文字
 @param view        需要高亮显示的View
 @param offset      高亮显示区域需要扩大的偏移量
 */
+ (void) createUserGuide:(NSString *)function title:(NSString *)title focusedView:(UIView *)view offset:(CGFloat)offset;


/**
 显示新手功能引导

 @param function    功能定义
 @param title       引导说明文字
 @param frame       高亮显示的区域
 */
+ (void) createCircleUserGuide:(NSString *)function title:(NSString *)title focusedFrame:(CGRect)rect;


+ (void) createFrameUserGuide:(NSString *)function title:(NSString *)title focusedFrame:(CGRect)rect;

/**
 判断新功能引导是否需要显示

 @param function    功能定义
 @return YES/NO
 */
+ (BOOL) shouldShowGuide:(NSString *)function;

@end
