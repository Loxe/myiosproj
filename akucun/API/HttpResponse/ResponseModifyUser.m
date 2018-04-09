//
//  ResponseModifyUser.m
//  akucun
//
//  Created by deepin do on 2018/1/10.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "ResponseModifyUser.h"
#import "UserManager.h"
#import "SDImageCache.h"

@implementation ResponseModifyUser

// 此处的jsonDat，已经是用data字段取出来的Dictionary了
- (void) parseData:(NSDictionary *)jsonData
{
    [super parseData:jsonData];

    NSString *nicheng = [jsonData getStringForKey:@"nicheng"];
    NSString *avatar  = [jsonData getStringForKey:@"avatar"];
    if (![NSString isEmpty:nicheng]) {
        [UserManager instance].userInfo.name = nicheng;
    }
    if (![NSString isEmpty:avatar]) {
        [[SDImageCache sharedImageCache] removeImageForKey:avatar withCompletion:nil];
        [UserManager instance].userInfo.avatar = avatar;
    }
}

@end
