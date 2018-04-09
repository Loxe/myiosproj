//
//  UserManager.h
//  akucun
//
//  Created by Jarry Zhu on 2017/3/19.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "UserInfo.h"
#import "UserConfig.h"

/**
 *  NSUserDefaults Keys Define
 *  用户信息
 */
#define UDK_USER_TOKEN      @"UDK_USER_TOKEN"       //
#define UDK_USER_USERID     @"UDK_USER_USERID"      //
#define UDK_USER_SUBUSER    @"UDK_USER_SUBUSER"     //
#define UDK_USER_INFO       @"UDK_USER_INFO"        //

#define UDK_USER_CONFIGS    @"UDK_USER_CONFIGS"     //
#define UDK_REMARK_SWITCH   @"UDK_REMARK_SWITCH"    // 下单备注开关

#define UDK_DISCOVER_TIME   @"UDK_DISCOVER_TIME"    // 发现更新时间
#define UDK_DISCOVER_TIMES  @"UDK_DISCOVER_TIMES"   // 发现更新时间
#define UDK_LIVE_TIMES      @"UDK_LIVE_TIMES"       // 活动更新时间

/**
 *  用户信息管理
 */
@interface UserManager : NSObject

@property (nonatomic, strong)   UserInfo    *userInfo;

@property (nonatomic, copy)     NSString    *token;

@property (nonatomic, copy)     NSString    *userId;

@property (nonatomic, copy)     NSString    *subuserId;

//@property (nonatomic, assign)   BOOL remarkSwitch;

@property (nonatomic, strong)   UserConfig  *userConfig;

//@property (nonatomic, assign)   BOOL isDiscoverUpdated;
@property (nonatomic, assign)   NSTimeInterval discoverTime;
@property (nonatomic, strong)   NSMutableDictionary *discoverTimeData;
//
@property (nonatomic, strong)   NSMutableDictionary *liveTimeData;

// 会员销售额指标
@property (nonatomic, strong)   NSDictionary  *vipTargets;

@property (nonatomic, assign)   NSInteger addrCount;        // 地址最多修改次数
@property (nonatomic, assign)   NSInteger addrChanged;      // 地址已修改次数

@property (nonatomic, strong)   NSArray *relatedUserList;

/**
 *  UserManager 单例
 *  @return UserManager
 */
+ (UserManager *) instance;


+ (BOOL) isValidToken;

+ (BOOL) isVIP; // VIP 等级大于0

+ (BOOL) isPrimaryAccount;

/**
 *  获取当前Token
 *  @return NSString
 */
+ (NSString *) token;

/**
 *  获取当前UserID
 *  @return NSString
 */
+ (NSString *) userId;

+ (NSString *) subuserId;

/**
 *  保存 Token 和 UserId
 *  @param token    User Token
 *  @param userId   User Id
 */
+ (void) saveToken:(NSString *)token userId:(NSString *)userId sub:(NSString *)subuserId;

+ (CGFloat) getSalesPercent:(NSInteger)vipLevel sales:(NSInteger)sales;

+ (VIPMemberTarget *) targetByLevel:(NSInteger)vipLevel;

// 下一等级
+ (NSInteger) nextLevel:(NSInteger)vipLevel sales:(NSInteger)sales;

+ (BOOL) isUpgradeLevel;

/**
 *  清除Token
 */
+ (void) clearToken;

+ (void) clearUserInfo;

- (void) saveRemarkSwitch:(BOOL)remarkSwitch;

- (void) saveImageOption:(NSInteger)option;

- (void) requestUserInfo:(voidBlock)finished;

//
- (void) updateDiscoverTime:(NSTimeInterval)time with:(NSInteger)type;

- (NSTimeInterval) discoverTimeWith:(NSInteger)type;

- (void) updateLiveTime:(NSTimeInterval)time with:(NSInteger)type;

- (NSTimeInterval) liveTimeWith:(NSInteger)type;

@end
