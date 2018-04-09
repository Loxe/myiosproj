//
//  RewardAlertView.h
//  akucun
//
//  Created by Jarry Z on 2018/4/3.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 弹框类型 */
typedef NS_ENUM(NSInteger, RewardAlertType) {
    RewardAlertTypeMonth = 1,   // 月度奖
    RewardAlertTypeInvite,      // 邀请奖
    RewardAlertTypeTeam,        // 团队奖
};

@interface RewardAlertView : UIView

@property (nonatomic, assign) RewardAlertType alertType;
@property (nonatomic, assign) NSInteger amount;

@property (nonatomic, copy) voidBlock actionBlock;

- (instancetype) initWithType:(NSInteger)type
                        value:(NSInteger)amountValue;

- (void) showWithBGTapDismiss:(BOOL)isEnable;

@end
