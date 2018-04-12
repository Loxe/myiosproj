//
//  Prefix.h
//  akucun
//
//  Created by Jarry on 16/9/18.
//  Copyright (c) 2016年 Sucang. All rights reserved.
//

#ifdef __OBJC__
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
//#import "AFNetworking.h"
#import "SCUtility.h"
#import "UIScrollView+akucun.h"
#import "UIView+YYAdd.h"
#import "Masonry.h"
#import "SVProgressHUD.h"
#import "GlobalDefine.h"
#import "ServerManager.h"
#import "UserManager.h"

#import "UIView+TZLayout.h"
#import "LPPopup.h"
//#import "YXPhotoCaptureViewController.h"
//#import "YXVideoCaptureViewController.h"
//#import "WYCaptureController.h"
//#import "WYVideoCaptureController.h"
//#import "ABMediaView.h"
//#import "ProgressHUD.h"

#import "AliVideoUpload.h"
#import <VODUpload/VODUploadSVideoClient.h>
#import <AliyunOSSiOS/AliyunOSSiOS.h>
#import <AliyunVideoCore/AliyunVideoCore.h>
#import <AliyunVodPlayerSDK/AliyunVodPlayerSDK.h>

#import "WZLBadgeImport.h"
#import "UserGuideManager.h"

#import "JXSDKHelper.h"
#if DEBUG
static NSString *JX_APPKEY     = @"zjeyn280awfjcg#im604#10003";//或者@"zjeyn280awfjcg#im604#10004"
static NSString *JX_SALEAPPKEY = @"zjeyn280awfjcg#im604#10003";
static NSString *JX_FEEDAPPKEY = @"zjeyn280awfjcg#im604#10004";
#else
static NSString *JX_APPKEY     = @"oxa0z2flnzjudw#akc685#10002";//或者@"oxa0z2flnzjudw#akc685#10003"
static NSString *JX_SALEAPPKEY = @"oxa0z2flnzjudw#akc685#10002";
static NSString *JX_FEEDAPPKEY = @"oxa0z2flnzjudw#akc685#10003";
#endif


#endif
