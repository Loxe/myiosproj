//
//  VIPLevelAlertView.h
//  akucun
//
//  Created by deepin do on 2018/2/28.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 弹框类型 */
typedef NS_ENUM(NSInteger, VIPLevelAlertType) {
    VIPLevelAlertTypeUpgrade = 0, // 升级
    VIPLevelAlertTypeGrading,     // 保级
    VIPLevelAlertTypeDemotion,    // 降级
};

typedef void(^ActionBlock)(id nsobject);

@interface VIPLevelAlertView : UIView

@property (nonatomic, assign) VIPLevelAlertType alertType;

@property (nonatomic, strong) NSString *vipLevelText;
@property (nonatomic, strong) NSString *descriptionText; // 普通显示内容
@property (nonatomic, copy  ) NSAttributedString *descriptionAttributedText;// 富文本显示内容

@property (nonatomic, assign) BOOL isShowCloseBtn;  // default is YES;
//@property (nonatomic, assign) BOOL isShowActionBtn; // default is NO;

@property (nonatomic, copy  ) ActionBlock  actionHandle;
@property (nonatomic, strong) NSString    *actionBtnTitle;


- (VIPLevelAlertView *)initWithType:(VIPLevelAlertType)type title:(NSString *)title subTitle:(NSString *)subTitle actionBtnTitle:(NSString *)actionBtnTitle;

- (VIPLevelAlertView *)initWithType:(VIPLevelAlertType)type title:(NSString *)title subTitleAttribute:(NSAttributedString *)subTitleAttribute actionBtnTitle:(NSString *)actionBtnTitle;

- (void)showWithBGTapDismiss:(BOOL)isEnable;

@end
