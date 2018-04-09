//
//  SubUser.h
//  akucun
//
//  Created by Jarry Zhu on 2018/1/3.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "JTModel.h"

@interface SubUser : JTModel

@property (nonatomic, copy) NSString *subUserId;
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *tmptoken;
@property (nonatomic, copy) NSString *subusername;
@property (nonatomic, copy) NSString *shoujihao;
@property (nonatomic, copy) NSString *avatar;

// 第三方登录时 判断账号是否已成功注册（是否已绑定手机号）
@property (nonatomic, assign) BOOL validflag;
// 子账号当前是否已登录
@property (nonatomic, assign) BOOL islogin;
// 当前登录的设备平台
@property (nonatomic, copy) NSString *platform;
// 当前登录的设备名称
@property (nonatomic, copy) NSString *devicename;
// 当前登录的APP版本
@property (nonatomic, copy) NSString *appversion;
// 当前登录类型
@property (nonatomic, assign) NSInteger thirdtype;

@property (nonatomic, assign) BOOL istabaccount;    // 是否为主账号


// 是否为手机号主账号
- (BOOL) isPrimaryAccount;

@end
