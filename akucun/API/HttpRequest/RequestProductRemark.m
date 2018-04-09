//
//  RequestProductRemark.m
//  akucun
//
//  Created by Jarry on 2017/4/11.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestProductRemark.h"

@implementation RequestProductRemark


- (NSString *) uriPath
{
    return API_URI_PRODUCT;
}

- (NSString *) actionId
{
    return ACTION_PRODUCT_REMARK;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamValue:self.productId forKey:@"productid"];
    [self.dataParams setParamValue:self.remark forKey:@"remark"];
}

@end
