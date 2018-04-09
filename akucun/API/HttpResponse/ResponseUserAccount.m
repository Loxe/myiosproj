//
//  ResponseUserAccount.m
//  akucun
//
//  Created by Jarry on 2017/6/21.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ResponseUserAccount.h"

@implementation ResponseUserAccount

- (void) parseData:(NSDictionary *)jsonData
{
    [super parseData:jsonData];
    
    NSDictionary *accountData = [jsonData objectForKey:@"account"];
    UserAccount *account = [UserAccount yy_modelWithDictionary:accountData];
    [UserManager instance].userInfo.account = account;
}

@end
