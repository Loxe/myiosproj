//
//  RequestSendComment.m
//  akucun
//
//  Created by Jarry on 2017/4/9.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestSendComment.h"

@implementation RequestSendComment

- (NSString *) uriPath
{
    return API_URI_PRODUCT;
}

- (NSString *) actionId
{
    return ACTION_PRODUCT_COMMENT;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamValue:self.productId forKey:@"productid"];
    [self.dataParams setParamValue:self.content forKey:@"comment"];
}

@end
