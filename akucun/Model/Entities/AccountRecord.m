//
//  AccountRecord.m
//  akucun
//
//  Created by Jarry on 2017/6/18.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "AccountRecord.h"

@implementation AccountRecord

- (NSString *) yuanyinText
{
    NSString *text = @"";
    switch (self.biangengyuanyin) {
        case ARecordINLACK:
            text = @"缺货退款";
            break;
            
        case ARecordINRETURN:
            text = @"商品返仓退款";
            break;
            
        case ARecordINDEFECTIVE:
            text = @"次品协商退款";
            break;
            
        case ARecordINFREIGHT:
            text = @"运费返还";
            break;
            
        case ARecordINCANCEL:
            text = @"商品未发货退款";
            break;
            
        case ARecordOUTORDER:
            text = @"订单支付";
            break;
            
        case ARecordOUTUSER:
            text = @"用户提现";
            break;
            
        case ARecordOUTSYSTEM:
            text = @"系统默认提现";
            break;
            
        default:
            break;
    }
    return text;
}

@end
