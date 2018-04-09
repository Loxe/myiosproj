//
//  UserInfo.m
//  Power-IO
//
//  Created by Jarry on 16/3/15.
//  Copyright © 2016年 Zenin-tech. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

+ (NSDictionary *) modelCustomPropertyMapper
{
    return @{ @"avatar": @[@"avatar", @"avator"],
              @"memberCount": @"members",
              @"inviteCount": @"waitApproveMembers"
              };
}

+ (NSDictionary *) modelContainerPropertyGenericClass
{
    return @{ @"addr" : [Address class],
              @"subUserinfos" : [SubUser class]
              };
}

@end

@implementation VIPMemberTarget

@end

@implementation UserAccount

@end
