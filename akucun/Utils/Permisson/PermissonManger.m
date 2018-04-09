//
//  PermissonManger.m
//  akucun
//
//  Created by deepin do on 2017/12/8.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "PermissonManger.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>

@implementation PermissonManger







/**
权限状态检查
*/
- (BOOL)isHavePhotoPermisson {
    NSInteger authorizationStatus;
    if (iOS8Later) {
        authorizationStatus = [PHPhotoLibrary authorizationStatus];
    } else {
        authorizationStatus = [ALAssetsLibrary authorizationStatus];
    }
    
    if (authorizationStatus == 3) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isHaveCapturePermisson {
    return YES;
}


- (BOOL)isHaveMicroPhonePermisson {
    return YES;
}



- (BOOL)isHaveLocationPermisson {
    return YES;
}



- (BOOL)isHaveAddressBookPermisson {
    return YES;
}


- (BOOL)isHavePushPermisson {
    return YES;
}


/**
 根据不同的权限去设置
 */
- (void)toSettingPermissionFor:(PermissonType)type {
    switch (type) {
        case PermissonTypePhoto:
            NSLog(@"");
            break;
            
        default:
            break;
    }
}


/** 设置权限界面 */
- (void)toSettingPage {
    if (iOS8Later) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:General&path=Reset"]];
    }
}

/** 对于权限未处理的设置 */
- (void)requestAuthorizationWhenNotDeterminedWithHandel: (void (^)(void))compleHandel {
    if (iOS8Later) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (compleHandel) {
                        compleHandel();
                    }
                });
            }];
        });
    } else {
        [[ALAssetsLibrary new] enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        } failureBlock:nil];
    }
}

//检测相册权限
//func isPhotosPermission() -> Bool {
//    if #available(iOS 8.0, *) {
//        let status = PHPhotoLibrary .authorizationStatus()
//        if status == .restricted || status == .denied {
//            return false
//        } else {
//            return true
//        }
//
//    }else {
//        let author = ALAssetsLibrary.authorizationStatus()
//        if author == .restricted || author == .denied {
//            return false
//
//        } else {
//            return true
//        }
//
//    }
//}

////检测相机权限
//func isCapturePermission() -> Bool {
//    let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
//    if status == .restricted || status == .denied {
//
//        return false
//
//    } else {
//        return true
//    }
//
//
//
//}
////检测麦克风权限
//func isMicroPhonePermission() -> Bool {
//    let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeAudio)
//    if status == .restricted || status == .denied {
//
//        return false
//
//    } else {
//        return true
//    }
//
//
//}
//
////检测推送权限
//func isPushPermission() -> Bool {
//    if #available(iOS 8.0, *) {
//        if UIApplication.shared.currentUserNotificationSettings?.types == .none {
//            return false
//        } else {
//            return true
//        }
//
//
//    } else {
//        if UIApplication.shared.enabledRemoteNotificationTypes() == .none {
//            return false
//        } else {
//            return true
//        }
//    }
//
//
//}
//// 位置权限
//func isLocationPermission() -> Bool {
//    if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() == .denied {
//        return false
//    } else {
//        return true
//    }
//
//
//}
////通讯录权限
//func isAddressBookPermission() -> Bool {
//    if #available(iOS 9.0, *) {
//        let status = CNContactStore.authorizationStatus(for: .contacts)
//        if status == .restricted || status == .denied  {
//            return false
//        } else {
//            return true
//        }
//    } else {
//        let status = ABAddressBookGetAuthorizationStatus()
//        if status == .restricted || status == .denied  {
//            return false
//        } else {
//            return true
//        }
//    }
//}
//
////设置权限界面
//func tosetPermission() {
//    if #available(iOS 8.0, *) {
//        UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
//    }else {
//        UIApplication.shared.openURL(URL(string:"prefs:General&path=Reset")!)
//    }
//}


////检测权限跳转界面
//func noPermissTosetting(status:PermissionStatus){
//    switch status {
//    case .photo:
//        if !MKPermissionSetting.sharedInstance.isPhotosPermission() {
//            showAlert(title: "相册权限未开启", messsage: "点击立即开启去设置权限")
//        }
//        break
//    case .capture:
//        if !MKPermissionSetting.sharedInstance.isCapturePermission() {
//            showAlert(title: "相机权限未开启", messsage: "点击立即开启去设置权限")
//        }
//        break
//    case .microPhone:
//        if !MKPermissionSetting.sharedInstance.isMicroPhonePermission() {
//            showAlert(title: "麦克风权限未开启", messsage: "点击立即开启去设置权限")
//        }
//        break
//    case .push:
//        if !MKPermissionSetting.sharedInstance.isPushPermission() {
//            showAlert(title: "推送权限未开启", messsage: "点击立即开启去设置权限")
//        }
//        break
//    case .location:
//        if !MKPermissionSetting.sharedInstance.isLocationPermission() {
//            showAlert(title: "位置权限未开启", messsage: "点击立即开启去设置权限")
//        }
//        break
//    case .addressBook:
//        if !MKPermissionSetting.sharedInstance.isAddressBookPermission() {
//
//            let cacheAlertView = alertView("权限设置", "该服务需要使用定位服务，请前往设置>隐私>通讯录服务，允许迈迈管家使用通讯录服务", 163)
//
//            cacheAlertView.confirmClosure = {
//                self.tosetPermission()
//            }
//            _ = MKAlertController().show(showView: cacheAlertView, location: .center, animation: .defaultShow)
//        }
//
//        break
//
//    }
//
//}



@end
