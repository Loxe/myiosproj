//
//  ResponseUserInfo.m
//  akucun
//
//  Created by Jarry on 2017/3/22.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ResponseUserInfo.h"
#import "UserManager.h"

@implementation ResponseUserInfo

- (void) parseData:(NSDictionary *)jsonData
{
    [super parseData:jsonData];
    
    Address *defaultAddr = [UserManager instance].userInfo.defaultAddr;
    NSArray *addrList = [UserManager instance].userInfo.addrList;
    
    NSDictionary *userDic = [jsonData objectForKey:@"userinfo"];
    UserInfo *userInfo = [UserInfo yy_modelWithDictionary:userDic];
    userInfo.addr = defaultAddr;
    userInfo.addrList = addrList;
    
    NSMutableArray *array = [NSMutableArray array];
    for (SubUser *item in userInfo.subUserinfos) {
        if ([item isPrimaryAccount]) {
            continue;
        }
        else if (item.istabaccount) {
            [array insertObject:item atIndex:0];
        }
        else {
            [array addObject:item];
        }
    }
    userInfo.subUserinfos = array;
    
    NSDictionary *accountData = [jsonData objectForKey:@"account"];
    UserAccount *account = [UserAccount yy_modelWithDictionary:accountData];
    userInfo.account = account;
    
    NSDictionary *memberDic = [jsonData objectForKey:@"memberinfo"];
    if (memberDic) {
        userInfo.isDowngrade = [memberDic getBoolValueForKey:@"isDowngrade"];        
        userInfo.monthsale = [memberDic getIntegerValueForKey:@"monthsale"];
        userInfo.isBalancePay = [memberDic getBoolValueForKey:@"isBalancePay"];
        userInfo.isCartMerge = [memberDic getBoolValueForKey:@"isCartMerge"];
        userInfo.viplevel = [memberDic getIntegerValueForKey:@"memberLevel"];
        
        NSMutableDictionary *vipTargets = [NSMutableDictionary dictionary];
        NSArray *targetArray = [memberDic objectForKey:@"memberTarget"];
        for (NSDictionary *itemDic in targetArray) {
            VIPMemberTarget *item = [VIPMemberTarget yy_modelWithDictionary:itemDic];
            [vipTargets setObject:item forKey:kIntergerToString(item.viplevel)];
        }
        [UserManager instance].vipTargets = vipTargets;
    }
    
//#warning TEST
//    userInfo.isrelevance = YES;
//    userInfo.istabaccount = YES;
//    userInfo.viplevel = 0;
//    userInfo.isDowngrade = YES;
//    userInfo.monthsale = 15000000;
//    userInfo.isBalancePay = NO;
//    userInfo.identityflag = YES;
//    userInfo.monthstat = userInfo.monthsale;
//    userInfo.prcstatu = YES;
//    userInfo.memberCount = 1;
//    userInfo.inviteCount = 2;
    
    [UserManager instance].userInfo = userInfo;
}

@end
