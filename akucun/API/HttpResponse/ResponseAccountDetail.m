//
//  ResponseAccountDetail.m
//  akucun
//
//  Created by Jarry on 2017/6/18.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ResponseAccountDetail.h"
#import "UserManager.h"

@implementation ResponseAccountDetail

- (void) parseData:(NSDictionary *)jsonData
{
    [super parseData:jsonData];
    
    NSDictionary *accountData = [jsonData objectForKey:@"account"];
    UserAccount *account = [UserAccount yy_modelWithDictionary:accountData];
    [UserManager instance].userInfo.account = account;
}

- (NSString *) resultKey
{
    return @"records";
}

- (id) parseItemFrom:(NSDictionary *)dictionary
{
    AccountRecord *record = [AccountRecord yy_modelWithDictionary:dictionary];
    return record;
}

@end
