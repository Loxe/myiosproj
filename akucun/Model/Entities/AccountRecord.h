//
//  AccountRecord.h
//  akucun
//
//  Created by Jarry on 2017/6/18.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "JTModel.h"

// 订单商品状态
typedef NS_ENUM(NSInteger, eAccountRecordType)
{
    AccountRecordIN = 0 ,       // 0: 入帐
    AccountRecordOUT            // 1: 出帐
};

typedef NS_ENUM(NSInteger, eAccountRecordYuanyin)
{
    ARecordINLACK       = 2 ,   // 缺货退款
    ARecordINRETURN     = 3 ,   // 商品返仓退款
    ARecordINDEFECTIVE  = 4 ,   // 次品协商退款
    ARecordINFREIGHT    = 5 ,   // 运费返还
    ARecordINCANCEL     = 6 ,   // 商品未发货退款

    ARecordOUTORDER = 100 ,     // 订单支付
    ARecordOUTUSER  = 101 ,     // 用户提现
    ARecordOUTSYSTEM = 102 ,    // 系统默认提现
};

@interface AccountRecord : JTModel

@property (nonatomic, copy) NSString *userid;

@property (nonatomic, copy) NSString *miaoshu;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *title;

// 0: 入帐， 1: 出帐
@property (nonatomic, assign) NSInteger type;
// 此记录的金额变化大小
@property (nonatomic, assign) NSInteger jine;
// 此变更后，帐户中的可用余额
@property (nonatomic, assign) NSInteger zongyue;

@property (nonatomic, assign) NSInteger biangengyuanyin;


- (NSString *) yuanyinText;


@end
