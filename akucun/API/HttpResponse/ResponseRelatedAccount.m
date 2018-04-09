//
//  ResponseRelatedAccount.m
//  akucun
//
//  Created by Jarry Z on 2018/4/5.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "ResponseRelatedAccount.h"

@implementation ResponseRelatedAccount

- (void) parseData:(NSDictionary *)jsonData
{
    [super parseData:jsonData];
    
    NSDictionary *memberDic = [jsonData objectForKey:@"userinfo"];
    if (memberDic) {
        self.member = [Member yy_modelWithDictionary:memberDic];
    }

    self.checkStatus = [jsonData getIntegerValueForKey:@"checkstatus"];
}

@end
