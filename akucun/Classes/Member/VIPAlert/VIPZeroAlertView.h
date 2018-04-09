//
//  VIPZeroAlertView.h
//  akucun
//
//  Created by deepin do on 2018/3/5.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 弹框类型 */
typedef NS_ENUM(NSInteger, VIPZeroAlertType) {
    VIPZeroAlertTypeNormal = 0, // 普通
    VIPZeroAlertTypeAction,     // 有交互事件
};

typedef void(^ActionBlock)(id nsobject);

@interface VIPZeroAlertView : UIView

@property (nonatomic, assign) VIPZeroAlertType alertType;

@property (nonatomic, strong) NSString *vipTitleText;
@property (nonatomic, strong) NSString *descriptionText; // 普通显示内容
@property (nonatomic, copy  ) NSAttributedString *descriptionAttributedText;// 富文本显示内容

@property (nonatomic, assign) BOOL isShowCloseBtn;  // default is NO;
@property (nonatomic, assign) BOOL isShowActionBtn; // default is YES;

@property (nonatomic, copy  ) ActionBlock  actionHandle;
@property (nonatomic, strong) NSString    *actionBtnTitle;

- (void)showWithBGTapDismiss:(BOOL)isEnable;

@end
