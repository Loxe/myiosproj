//
//  ResponseMsgList.m
//  akucun
//
//  Created by Jarry on 2017/6/29.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ResponseMsgList.h"
#import "UserManager.h"

@implementation ResponseMsgList

- (void) parseData:(NSDictionary *)jsonData
{
    [super parseData:jsonData];
/*
    NSInteger count = 0;
    for (Message *msg in self.result) {
        if (msg.readflag == 0) {
            count ++;
        }
    }
    [UserManager instance].userInfo.msgCount = count;
 */
}

- (NSString *) resultKey
{
    return @"msg";
}

- (id) parseItemFrom:(NSDictionary *)dictionary
{
    Message *msg = [Message yy_modelWithDictionary:dictionary];
    return msg;
}

@end
