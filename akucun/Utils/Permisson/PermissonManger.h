//
//  PermissonManger.h
//  akucun
//
//  Created by deepin do on 2017/12/8.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PermissonType) {
    PermissonTypePhoto = 0,   // 相册
    PermissonTypeCapture,     // 相册
    PermissonTypeMicroPhone,  // 麦克风
    PermissonTypeLocation,    // 定位
    PermissonTypeAddressBook, // 通讯录
    PermissonTypePush,        // 推送
};

@interface PermissonManger : NSObject

/** 各权限 */
- (BOOL)isHavePhotoPermisson;
- (BOOL)isHaveCapturePermisson;
- (BOOL)isHaveMicroPhonePermisson;
- (BOOL)isHaveLocationPermisson;
- (BOOL)isHaveAddressBookPermisson;
- (BOOL)isHavePushPermisson;

/** 设置某种权限 */
- (void)toSettingPermissionFor:(PermissonType)type;

/** 设置权限界面 */
- (void)toSettingPage;

/** 对于未对权限请求做处理 */
- (void)requestAuthorizationWhenNotDeterminedWithHandel: (void (^)(void))compleHandel;

@end
