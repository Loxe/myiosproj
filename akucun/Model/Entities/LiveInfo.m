//
//  LiveInfo.m
//  akucun
//
//  Created by Jarry on 2017/4/24.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "LiveInfo.h"
#import "Comment.h"
#import "UserManager.h"

@implementation LiveInfo

+ (NSDictionary *) modelCustomPropertyMapper
{
    return @{ @"isTop": @[@"isTop", @"top"]
            };
}

+ (NSDictionary *) modelContainerPropertyGenericClass
{
    return @{ @"comments" : [Comment class]
              };
}

- (NSArray *) imagesUrl
{
    if (!self.yugaotupian || self.yugaotupian.length == 0) {
        return nil;
    }
    NSString *urls = [self.yugaotupian stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return [urls componentsSeparatedByString:@","];
}

- (BOOL) isNewLive
{
    NSTimeInterval delta = [NSDate timeIntervalValue] - self.begintimestamp;
    return (delta < 3600 * 2);
}

- (BOOL) isTodayLive
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.begintimestamp];
    return [date isToday];
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
