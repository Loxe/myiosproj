//
//  ResponseTeamList.m
//  akucun
//
//  Created by deepin do on 2018/1/19.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "ResponseTeamList.h"
#import "Member.h"

@implementation ResponseTeamList

- (void) parseData:(NSDictionary *)jsonData
{
    [super parseData:jsonData];
    
    NSDictionary *countMember = [jsonData objectForKey:@"countMember"];
    self.totalCount = [countMember getIntegerValueForKey:@"count"];
    self.activeCount = [countMember getIntegerValueForKey:@"activeCount"];
    self.lostCount = [countMember getIntegerValueForKey:@"liushicount"];

    NSDictionary *pagesData = [jsonData objectForKey:@"pages"];
    if (pagesData) {
        self.pages = [pagesData getIntegerValueForKey:@"pages"];
        self.page = [pagesData getIntegerValueForKey:@"page"];
    }
}

- (NSString *) resultKey
{
    return @"items";
}

- (id) parseItemFrom:(NSDictionary *)dictionary
{
    Member *item = [Member yy_modelWithDictionary:dictionary];
    return item;
}


@end
