//
//  UserManager.m
//  akucun
//
//  Created by Jarry Zhu on 2017/3/19.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "UserManager.h"
#import "RequestUserInfo.h"

@implementation UserManager

+ (UserManager *) instance
{
    static dispatch_once_t  onceToken;
    static UserManager * instance;
    dispatch_once(&onceToken, ^{
        instance = [[UserManager alloc] init];
    });
    return instance;
}

+ (BOOL) isValidToken
{
    return [UserManager token] && [UserManager token].length > 0;
}

+ (BOOL) isVIP
{
    UserInfo *userInfo = [UserManager instance].userInfo;
    return (userInfo.viplevel > 0);
}

+ (BOOL) isPrimaryAccount
{
    NSString *userId = [UserManager userId];
    NSString *subuserId = [UserManager subuserId];
    return [userId isEqualToString:subuserId];
}

+ (NSString *) token
{
    return [UserManager instance].token;
}

+ (NSString *) userId
{
    return [UserManager instance].userId;
}

+ (NSString *) subuserId
{
    return [UserManager instance].subuserId;
}

+ (void) saveToken:(NSString *)token userId:(NSString *)userId sub:(NSString *)subuserId
{
    [UserManager instance].token = token;
    [UserManager instance].userId = userId;
    [UserManager instance].subuserId = subuserId;

    [USER_DEFAULT setObject:token forKey:UDK_USER_TOKEN];
    [USER_DEFAULT setObject:userId forKey:UDK_USER_USERID];
    [USER_DEFAULT setObject:subuserId forKey:UDK_USER_SUBUSER];
    [USER_DEFAULT synchronize];
}

+ (void) clearToken
{
    [UserManager instance].token = nil;
    [UserManager instance].userId = nil;
    [UserManager instance].subuserId = nil;

    [USER_DEFAULT removeObjectForKey:UDK_USER_TOKEN];
    [USER_DEFAULT removeObjectForKey:UDK_USER_USERID];
    [USER_DEFAULT removeObjectForKey:UDK_USER_SUBUSER];
    [USER_DEFAULT synchronize];
}

+ (void) clearUserInfo
{
    [UserManager instance].userInfo = nil;
    [USER_DEFAULT removeObjectForKey:UDK_USER_INFO];
    [USER_DEFAULT synchronize];
}

+ (CGFloat) getSalesPercent:(NSInteger)vipLevel sales:(NSInteger)sales
{
    CGFloat percent = 0.0f;
    VIPMemberTarget *currentTarget = [UserManager targetByLevel:vipLevel];
    if (!currentTarget) {
        return percent;
    }
    if (sales < currentTarget.minsale) { // 保级
        percent = 1.0f * sales / currentTarget.minsale;
    }
    else {
        VIPMemberTarget *target5 = [UserManager targetByLevel:5];
        VIPMemberTarget *target4 = [UserManager targetByLevel:4];
        VIPMemberTarget *target3 = [UserManager targetByLevel:3];
        VIPMemberTarget *target2 = [UserManager targetByLevel:2];
//        VIPMemberTarget *target1 = [UserManager targetByLevel:1];
        if (sales >= target5.minsale) {
            percent = 1.0f;
        }
        else if (sales >= target4.minsale) {
//            percent = 0.5f + 0.5f * (sales-target4.minsale) / (target5.minsale-target4.minsale);
            percent = 0.5f + 0.5f * sales / target5.minsale;
        }
        else if (sales >= target3.minsale) {
//            percent = 0.5f + 0.5f * (sales-target3.minsale) / (target4.minsale-target3.minsale);
            percent = 0.5f + 0.5f * sales / target4.minsale;
        }
        else if (sales >= target2.minsale) {
//            percent = 0.5f + 0.5f * (sales-target2.minsale) / (target3.minsale-target2.minsale);
            percent = 0.5f + 0.5f * sales / target3.minsale;
        }
        else {
//            percent = 0.5f + 0.5f * (sales-target1.minsale) / (target2.minsale-target1.minsale);
            percent = 0.5f + 0.5f * sales / target2.minsale;
        }
    }
    return percent;
}

+ (VIPMemberTarget *) targetByLevel:(NSInteger)vipLevel
{
    NSDictionary *vipTargets = [UserManager instance].vipTargets;
    return [vipTargets objectForKey:kIntergerToString(vipLevel)];
}

+ (NSInteger) nextLevel:(NSInteger)vipLevel sales:(NSInteger)sales
{
    if (vipLevel >= 5) {
        return 0;
    }
    for (NSInteger i = vipLevel+1; i <= 5; i++) {
        VIPMemberTarget *target = [UserManager targetByLevel:i];
        if (sales < target.minsale) {
            return i;
        }
    }
    return 0;
}

+ (BOOL) isUpgradeLevel
{
    UserInfo *userInfo = [UserManager instance].userInfo;
    VIPMemberTarget *target = [UserManager targetByLevel:userInfo.viplevel];
    return (userInfo.monthsale >= target.minsale);
}

#pragma mark -

- (id) init
{
    self = [super init];
    if (self) {
        self.vipTargets = [NSDictionary dictionary];
        [self readUserInfo];
    }
    return self;
}

- (void) setUserInfo:(UserInfo *)userInfo
{
    _userInfo = userInfo;
    
    // Save
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
    [USER_DEFAULT setObject:data forKey:UDK_USER_INFO];
    [USER_DEFAULT synchronize];
}

- (void) readUserInfo
{
    NSString *token = [USER_DEFAULT objectForKey:UDK_USER_TOKEN];
    if (token && token.length > 0) {
        self.token = token;
    }
    
    NSString *userId = [USER_DEFAULT objectForKey:UDK_USER_USERID];
    if (userId && userId.length > 0) {
        self.userId = userId;
    }
    NSString *subuserId = [USER_DEFAULT objectForKey:UDK_USER_SUBUSER];
    if (subuserId && subuserId.length > 0) {
        self.subuserId = subuserId;
    }
    
    NSData *data = [USER_DEFAULT objectForKey:UDK_USER_INFO];
    if (data) {
        _userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    //
    NSData *configData = [USER_DEFAULT objectForKey:UDK_USER_CONFIGS];
    if (configData) {
        _userConfig = [NSKeyedUnarchiver unarchiveObjectWithData:configData];
    }
    else {
        _userConfig = [[UserConfig alloc] init];
    }
    
    //
    NSNumber *remark = [USER_DEFAULT objectForKey:UDK_REMARK_SWITCH];
    if (remark) {
        _userConfig.remarkSwitch = [remark boolValue];
    }
    
    NSNumber *time = [USER_DEFAULT objectForKey:UDK_DISCOVER_TIME];
    if (time) {
        _discoverTime = [time doubleValue];
    }
    NSData *discoverData = [USER_DEFAULT objectForKey:UDK_DISCOVER_TIMES];
    if (discoverData) {
        _discoverTimeData = [NSKeyedUnarchiver unarchiveObjectWithData:discoverData];
    }
    else {
        _discoverTimeData = [NSMutableDictionary dictionary];
    }
    NSData *liveTimeData = [USER_DEFAULT objectForKey:UDK_LIVE_TIMES];
    if (liveTimeData) {
        _liveTimeData = [NSKeyedUnarchiver unarchiveObjectWithData:liveTimeData];
    }
    else {
        _liveTimeData = [NSMutableDictionary dictionary];
    }
}

- (void) saveRemarkSwitch:(BOOL)remarkSwitch
{
    UserConfig *config = [self.userConfig yy_modelCopy];
    config.remarkSwitch = remarkSwitch;
    
    self.userConfig = config;
}

- (void) saveImageOption:(NSInteger)option
{
    UserConfig *config = [self.userConfig yy_modelCopy];
    config.imageOption = option;
    
    self.userConfig = config;
}

- (void) setUserConfig:(UserConfig *)userConfig
{
    _userConfig = userConfig;
    
    // Save
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userConfig];
    [USER_DEFAULT setObject:data forKey:UDK_USER_CONFIGS];
    [USER_DEFAULT synchronize];
}

- (void) setDiscoverTime:(NSTimeInterval)discoverTime
{
    _discoverTime = discoverTime;
    
    [USER_DEFAULT setObject:@(discoverTime) forKey:UDK_DISCOVER_TIME];
    [USER_DEFAULT synchronize];
}

- (void) updateDiscoverTime:(NSTimeInterval)time with:(NSInteger)type
{
    [self.discoverTimeData setParamDoubleValue:time forKey:kIntergerToString(type)];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.discoverTimeData];
    [USER_DEFAULT setObject:data forKey:UDK_DISCOVER_TIMES];
    [USER_DEFAULT synchronize];
}

- (NSTimeInterval) discoverTimeWith:(NSInteger)type
{
    return [self.discoverTimeData getDoubleValueForKey:kIntergerToString(type)];
}

- (void) updateLiveTime:(NSTimeInterval)time with:(NSInteger)type
{
    [self.liveTimeData setParamDoubleValue:time forKey:kIntergerToString(type)];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.liveTimeData];
    [USER_DEFAULT setObject:data forKey:UDK_LIVE_TIMES];
    [USER_DEFAULT synchronize];
}

- (NSTimeInterval) liveTimeWith:(NSInteger)type
{
    return [self.liveTimeData getDoubleValueForKey:kIntergerToString(type)];
}

#pragma mark -

- (void) requestUserInfo:(voidBlock)finished
{
    RequestUserInfo *request = [RequestUserInfo new];
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         if (finished) {
             finished();
         }
     } onFailed:nil];
}

@end
