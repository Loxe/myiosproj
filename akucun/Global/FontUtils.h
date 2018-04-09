//
//  FontUtils.h
//  akucun
//
//  Created by Jarry on 16/1/12.
//  Copyright © 2016年 Sucang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define     FONT_PP_TITLE   BOLDTNRFONTSIZE(15)

/**
 *  自定义字体
 */
#define     ICON_FONT(s)    [UIFont fontWithName:@"Material Icons" size:s]
#define     kIconAdd        @"\ue145"
#define     kIconMenu       @"\ue5d2"
#define     kIconBack       @"\ue5cb"
#define     kIconCalendar   @"\ue8df"
#define     kIconDelete     @"\ue872"
#define     kIconClose      @"\ue14c"
#define     kIconSetting    @"\ue8b8"
#define     kIconChecked    @"\ue876"
#define     kIconDownload   @"\ue258"
#define     kIconSearch     @"\ue8b6"

/**
 *  FontAwesome图标字体名称
 */
#define FA_ICONFONTNAME         @"FontAwesome"

/**
 *  FontAwesome图标字体大小
 */
#define FA_ICONFONTSIZE(s)      [UIFont fontWithName:FA_ICONFONTNAME size:s]

#define FA_ICONFONT_SETTING     @"\uF013"
#define FA_ICONFONT_USER        @"\uF007"
#define FA_ICONFONT_MENU        @"\uF0C9"
#define FA_ICONFONT_SEARCH      @"\uF002"
#define FA_ICONFONT_ADD         @"\uF067"
#define FA_ICONFONT_BACK        @"\uF104"
#define FA_ICONFONT_CLOSE       @"\uF00D"
#define FA_ICONFONT_DELETE      @"\uF014"
#define FA_ICONFONT_MESSAGE     @"\uF003"
#define FA_ICONFONT_MSG2        @"\uF0E0"
#define FA_ICONFONT_MORE        @"\uF142"
#define FA_ICONFONT_RIGHT       @"\uF105"
#define FA_ICONFONT_EDIT        @"\uF044"
#define FA_ICONFONT_CHECKED     @"\uF058"
#define FA_ICONFONT_UNCHECK     @"\uF05D"
#define FA_ICONFONT_CAMERA      @"\uF030"
#define FA_ICONFONT_KEFU        @"\uF27B"
#define FA_ICONFONT_SHARE       @"\uF045"

#define FA_ICONFONT_UNCHECK1    @"\uF096"
#define FA_ICONFONT_CHECKED1    @"\uF14A"
#define FA_ICONFONT_SELECT      @"\uF00C"

#define FA_ICONFONT_TIP         @"\uF111"
#define FA_ICONFONT_ALERT       @"\uF12A"
#define FA_ICONFONT_QUESTION    @"\uF128"

/**
 *  字体管理工具类
 */
@interface FontUtils : NSObject

/**
 *  标准字体
 *  @return UIFont *
 */
+ (UIFont *) normalFont;
/**
 *  小号字体
 *  @return UIFont *
 */
+ (UIFont *) smallFont;
/**
 *  大号字体
 *  @return UIFont *
 */
+ (UIFont *) bigFont;

+ (UIFont *) buttonFont;

+ (UIFont *) FA_iconFont;

@end
