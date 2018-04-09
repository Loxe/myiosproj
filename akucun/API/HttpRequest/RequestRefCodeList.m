//
//  RequestRefCodeList.m
//  akucun
//
//  Created by Jarry Z on 2018/3/17.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestRefCodeList.h"

@implementation RequestRefCodeList

- (HttpResponseBase *) response
{
    return [ResponseRefcodeList new];
}

- (NSString *) uriPath
{
    return API_URI_USER;
}

- (NSString *) actionId
{
    return ACTION_USER_REFCODELIST;
}

@end
