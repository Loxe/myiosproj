//
//  RequestOrderList.m
//  akucun
//
//  Created by Jarry on 2017/4/7.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestOrderList.h"

@implementation RequestOrderList

- (void) initData
{
    [super initData];
    
    self.pageno = 1;
    self.pagesize = 20;
    self.dingdanstatu = -1;
}

- (SCHttpResponse *) response
{
    return [ResponseOrderList new];
}

- (NSString *) uriPath
{
    return API_URI_ORDER;
}

- (NSString *) actionId
{
    return ACTION_ORDER_PAGE;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamIntegerValue:self.pageno forKey:@"pageno"];
    [self.dataParams setParamIntegerValue:self.pagesize forKey:@"pagesize"];
    
//    if (self.dingdanstatu >= 0) {
        if (self.dingdanstatu == 3) {
            self.dingdanstatu = 4;
        }
        [self.dataParams setParamIntegerValue:self.dingdanstatu forKey:@"dingdanstatu"];
//    }
}

@end
