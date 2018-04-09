//
//  RequestReportLack.m
//  akucun
//
//  Created by Jarry on 2017/9/3.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestReportLack.h"

@implementation RequestReportLack

- (NSString *) uriPath
{
    return API_URI_PRODUCT;
}

- (NSString *) actionId
{
    return ACTION_PRODUCT_LACK;
}

- (void) initJsonBody
{
    [self.jsonBody setValue:self.cartproduct forKey:@"cartproductid"];
    [self.jsonBody setValue:@"" forKey:@"userdesc"];
}

@end
