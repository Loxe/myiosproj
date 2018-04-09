//
//  ResponseAddrList.m
//  akucun
//
//  Created by Jarry on 2017/7/15.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ResponseAddrList.h"
#import "UserManager.h"

@implementation ResponseAddrList

- (void) parseData:(NSDictionary *)jsonData
{
    [super parseData:jsonData];
    
    UserInfo *userInfo = [UserManager instance].userInfo;
    
    Address *defaultAddr = nil;
    for (Address *addr in self.result) {
        if (addr.defaultflag == 0) {
            defaultAddr = addr;
        }
    }
    
    userInfo.addr = nil;
    if (defaultAddr) {
        userInfo.addr = defaultAddr;
        [self.result removeObject:defaultAddr];
        [self.result insertObject:defaultAddr atIndex:0];
    }
    
    userInfo.addrList = self.result;
    [UserManager instance].userInfo = userInfo;
    
    //
    NSDictionary *countDic = [jsonData objectForKey:@"count"];
    if (countDic) {
        NSInteger allcount = [countDic getIntegerValueForKey:@"allcount"];
        NSInteger changecount = [countDic getIntegerValueForKey:@"changecount"];
        [UserManager instance].addrCount = allcount;
        [UserManager instance].addrChanged = changecount;
    }
}

- (NSString *) resultKey
{
    return @"addrs";
}

- (id) parseItemFrom:(NSDictionary *)dictionary
{
    Address *addr = [Address yy_modelWithDictionary:dictionary];
    return addr;
}

@end
