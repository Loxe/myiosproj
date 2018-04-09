//
//  GlobalDefine.h
//  akucun
//
//  Created by Jarry on 15/10/20.
//  Copyright © 2015年 Sucang. All rights reserved.
//

#ifndef GlobalDefine_h
#define GlobalDefine_h

#import <UIKit/UIDevice.h>
#import "FontUtils.h"
#import "NSString+akucun.h"

#define     XCODE9VERSION     // Xcode9 标记， Xcode8打包记得注释
#define     isIPhoneX               ([UIScreen instancesRespondToSelector:@selector(currentMode)]?CGSizeEqualToSize(CGSizeMake(1125,2436),[[UIScreen mainScreen] currentMode].size):NO)
/**
 *  Constant width & height
 */
#define     kBOTTOM_BAR_HEIGHT      (isIPhoneX ? 84.0f : 50.0f)
#define     kBOTTOM_BUTTON_WIDTH    200.0f
#define     kEDIT_BAR_HEIGHT        44.0f
#define     kSafeAreaTopHeight      (isIPhoneX ? 88 : 64)
#define     kSafeAreaBottomHeight   (isIPhoneX ? 34 : 0)

#define     kFIELD_HEIGHT           (SCREEN_WIDTH/10.0f)
#define     kOFFSET_SIZE            (SCREEN_WIDTH/22.0f)
#define     kTableCellHeight        (SCREEN_WIDTH/8.0f + 2.0f)
//#define     kTableHeadHeight        (kTableCellHeight * 0.6)

#define     kPadCellHeight          (60.0f)
#define     kFIELD_HEIGHT_PAD       (50.0f)
#define     kOFFSET_SIZE_PAD        (20.0f)

#define     kDefaultLineSpace       (SCREEN_WIDTH/42.0f)

#define     kPIXEL_WIDTH            (1.0f/[UIScreen mainScreen].scale)

#define     kPageMenuHeight         (38.0f)
#define     kPageContentHeight      (SCREEN_HEIGHT-kSafeAreaTopHeight-kPageMenuHeight-kBOTTOM_BAR_HEIGHT)

#define     kPictureSelectItemWH    (SCREEN_WIDTH-40-24)*0.25

#define     POPUPINFO(infotxt)      [LPPopup popupCustomText:infotxt] // 弹出提示信息，并自动隐藏，单例

/**
 *  版本信息类
 **/
#define iOS7Later   ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later   ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later   ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)

/**
 *  Color
 **/
#define     HEX_COLOR_GREEN         @"#00B019"
#define     HEX_COLOR_ORANGE        @"#FD5B22"
#define     HEX_COLOR_GRAY          @"#727272"

// 主色
#define     COLOR_MAIN              RGBCOLOR(0xFF, 0x58, 0x5E)

#define     COLOR_APP_ORANGE        COLOR_HEX(HEX_COLOR_ORANGE)
#define     COLOR_APP_GREEN         COLOR_HEX(HEX_COLOR_GREEN)
#define     COLOR_APP_YELLOW        RGBCOLOR(0xF4, 0x9A, 0x13)
#define     COLOR_APP_RED           RGBCOLOR(0xFD, 0x64, 0x3C)
#define     COLOR_APP_BLACK         RGBCOLOR(0x33, 0x33, 0x33)
#define     COLOR_APP_BLUE          RGBCOLOR(0x4C, 0x9C, 0xFA)

#define     COLOR_BACKGROUND        WHITE_COLOR
#define     COLOR_BG_DARK           RGBCOLOR(0x4C, 0x43, 0x43)
#define     COLOR_BG_LIGHT          RGBCOLOR(0x59, 0x59, 0x59)
#define     COLOR_BG_LIST           RGBCOLOR(0x82, 0x7A, 0x75)
#define     COLOR_BG_LIST_SELECTED  RGBCOLOR(0x4C, 0x3D, 0x36)
#define     COLOR_BG_HEADER         RGBCOLOR(0xF2, 0xD3, 0xD2)
#define     COLOR_BG_BUTTON         COLOR_MAIN //RGBCOLOR(0x91, 0xA1, 0xCA)
#define     COLOR_BG_DISABLED       RGBCOLOR(0xCC, 0xCC, 0xCC)
#define     COLOR_BG_TEXT           RGBACOLOR(0, 0, 0, 0.15)
#define     COLOR_BG_TEXT_DISABLED  RGBACOLOR(0, 0, 0, 0.1)
#define     COLOR_BG_IMAGE          RGBCOLOR(0xF0, 0xF0, 0xF0)
#define     COLOR_BG_LIGHTGRAY      RGBCOLOR(0xF0, 0xF0, 0xF0)
#define     COLOR_BG_TRACK          RGBCOLOR(69, 151, 199)

#define     COLOR_TITLE             RGBCOLOR(0x34, 0x1B, 0x1C)
#define     COLOR_SELECTED          COLOR_MAIN //RGBCOLOR(0xF9, 0x52, 0x51)
#define     COLOR_TABBAR_BG         RGBCOLOR(0xF9, 0xF9, 0xF9)

#define     COLOR_CHECKED           COLOR_SELECTED
#define     COLOR_UNCHECK           RGBCOLOR(0xE9, 0xE9, 0xE9)
// 文字相关颜色
#define     COLOR_TEXT_LINK         RGBCOLOR(113, 129, 161)
#define     COLOR_TEXT_DISABLED     RGBCOLOR(0xCC, 0xCC, 0xCC)

#define     COLOR_TEXT_DARK         RGBCOLOR(0x4C, 0x43, 0x43)
#define     COLOR_TEXT_NORMAL       RGBCOLOR(0x72, 0x72, 0x72)
#define     COLOR_TEXT_LIGHT        RGBCOLOR(0xCC, 0xCC, 0xCC)

#define     COLOR_LAUNCH_BG         RGBCOLOR(0x4D, 0x4D, 0x4D)
#define     COLOR_LAUNCH_TEXT       RGBCOLOR(0xCC, 0xCC, 0xCC)

#define     COLOR_SEPERATOR_LINE    RGBCOLOR(0xD5, 0xD5, 0xD5)
#define     COLOR_SEPERATOR_LIGHT   RGBCOLOR(0xE9, 0xE9, 0xE9)


/**
 *  Animation Duration
 */
#define     kAnimationDuration      .35f
#define     kAnimationDurationLong  .6f
#define     kAnimationDurationShort .3f

/**
 *  View Signal / View之间事件传递Key
 */

#define NOTIFICATION_APP_FOREGROUND @"notificationAppForeground"
#define NOTIFICATION_APP_BACKGROUND @"notificationAppBackground"

#define NOTIFICATION_NOT_VIP        @"notificationNotVIP"
#define NOTIFICATION_TOKEN_EXPIRED  @"notificationTokenExpired"
#define NOTIFICATION_VERSION_UPDATE @"notificationVersionUpdate"

#define NOTIFICATION_FORWARD_SHOW   @"notificationForwardShow"
#define NOTIFICATION_FORWARD_HIDE   @"notificationForwardHide"

#define NOTIFICATION_RECIEVED_MSG   @"notificationReceivedMsg"

#define NOTIFICATION_SYNC_PRODUCTS  @"notificationSyncProducts"
#define NOTIFICATION_SYNC_COMPLETE  @"notificationSyncComplete"

#define NOTIFICATION_ADD_FOLLOW    @"notificationAddFollow"
#define NOTIFICATION_ADD_TO_CART    @"notificationAddToCart"
#define NOTIFICATION_ALIPAY_SUCCESS @"notificationAlipaySuccess"

#define NOTIFICATION_SYNC_LIVEDATA  @"notificationSyncLiveData" // 同步活动商品
#define NOTIFICATION_UPDATE_USERINFO @"notificationUpdateUserInfo"

#define NOTIFICATION_VIP0_UPGRADED  @"notificationVIP0Upgraded"
#define NOTIFICATION_REWARD_INFO    @"notificationRewardInfo"
#define NOTIFICATION_REWARD_RECEIVED @"notificationRewardRecieved"

/**
 *  NSUserDefaults Keys Define
 */
#define UDK_PROMOTION_IMAGE         @"UDK_PROMOTION_IMAGE"  // 首页活动弹窗图片
#define UDK_USER_VIP_STATUS         @"UDK_USER_VIP_STATUS"  // 当前会员等级弹窗提示


#endif /* GlobalDefine_h */
