//
//  Trailer.m
//  akucun
//
//  Created by Jarry on 2017/3/22.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "Trailer.h"
#import "UserManager.h"

@implementation Trailer

- (NSArray *) imagesUrl
{
    if (!self.yugaotupian || self.yugaotupian.length == 0) {
        return nil;
    }
    NSString *urls = [self.yugaotupian stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return [urls componentsSeparatedByString:@","];
}

- (NSInteger) levelFlag
{
    if (self.memberLevels < 1) {
        return 0;
    }
    UserInfo *userInfo = [UserManager instance].userInfo;
    if (userInfo.viplevel >= self.memberLevels) {
        return userInfo.viplevel;
    }
    return self.memberLevels;
}

@end
