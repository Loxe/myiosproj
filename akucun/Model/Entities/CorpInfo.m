//
//  CorpInfo.m
//  akucun
//
//  Created by Jarry Z on 2018/3/15.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "CorpInfo.h"

@implementation CorpInfo

- (NSArray *) imagesUrl
{
    if (!self.corpattach || self.corpattach.length == 0) {
        return nil;
    }
    NSString *urls = [self.corpattach stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return [urls componentsSeparatedByString:@","];
}

@end
