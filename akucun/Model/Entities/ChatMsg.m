//
//  ChatMsg.m
//  akucun
//
//  Created by Jarry on 2017/9/7.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ChatMsg.h"

@implementation ChatMsg

- (BOOL) isSender
{
    return (self.direction == 0);
}

@end
