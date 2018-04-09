//
//  UserInfo.h
//  akucun
//
//  Created by Jarry on 16/3/15.
//  Copyright © 2016年 Sucang. All rights reserved.
//

#import "JTModel.h"
#import "Address.h"
#import "SubUser.h"

@class UserAccount;

/**
 *  用户详细资料
 */
@interface UserInfo : JTModel

@property (nonatomic, copy) NSString *userid;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *shoujihao;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *yonghubianhao;

@property (nonatomic, assign) BOOL identityflag; //0未认证，1已认证

@property (nonatomic, assign) NSInteger unreadnum;      // 未读消息数
@property (nonatomic, assign) BOOL      allowUpload;    // 发现 是否有上传权限

@property (nonatomic, assign) NSInteger viplevel;
@property (nonatomic, copy) NSString *vipendtime;

@property (nonatomic, assign) BOOL      prcstatu;       // 邀请码标记位
@property (nonatomic,   copy) NSString  *preferralcode; // 邀请码
@property (nonatomic, assign) NSInteger inviteCount;    // 待批准邀请数
@property (nonatomic, assign) NSInteger memberCount;    // 团队成员数


// 子账号列表
@property (nonatomic, strong) NSArray *subUserinfos;

// 购物车商品数
@property (nonatomic, assign) NSInteger normalproduct;

// 销售统计数据
@property (nonatomic, assign) NSInteger todaystat;  // 今日销售额
//@property (nonatomic, assign) NSInteger monthstat;  // 本月统计
@property (nonatomic, assign) NSInteger lastmonthstat;   // 上月销售额
@property (nonatomic, assign) NSInteger todayfee;  // 今日代购费
@property (nonatomic, assign) NSInteger monthfee;  // 本月代购费
@property (nonatomic, assign) NSInteger lastmonthfee;  // 上月代购费

@property (nonatomic, assign) NSInteger forwardcount;
@property (nonatomic, assign) NSInteger keyongdikou;
@property (nonatomic, assign) NSInteger yiyongdikou;

@property (nonatomic, strong, getter=defaultAddr) Address *addr;
@property (nonatomic, strong) NSArray *addrList;

@property (nonatomic, strong) UserAccount *account;

@property (nonatomic, assign) BOOL shoujihaovalid;

@property (nonatomic, assign) NSInteger memberType; // 会员类型 0：正常用户 1：递推
@property (nonatomic, assign) BOOL isDowngrade;     // 是否被降级
@property (nonatomic, assign) NSInteger monthsale;  // 当月销售额
@property (nonatomic, assign) BOOL isBalancePay;    // 是否开启余额支付
@property (nonatomic, assign) BOOL isCartMerge;     // 是否合并购物车

@property (nonatomic, assign) BOOL istabaccount;    // 是否为主账号
@property (nonatomic, assign) BOOL isrelevance;     // 是否为关联账号

@end

@interface VIPMemberTarget : JTModel

@property (nonatomic, assign) NSInteger viplevel;
@property (nonatomic, assign) NSInteger minsale;

@property (nonatomic, assign) NSInteger cartTimeout;

@end

@interface UserAccount : JTModel

@property (nonatomic, copy) NSString *userid;

// 可用余额，单位（分）
@property (nonatomic, assign) NSInteger keyongyue;
// 锁定余额，单位（分）
@property (nonatomic, assign) NSInteger suodingyue;
// 总余额
@property (nonatomic, assign) NSInteger yue;
// 帐户状态，0正常，1异常，2是帐户锁定，只有在正常的情况下才可以支付使用余额
@property (nonatomic, assign) NSInteger statu;

@end
