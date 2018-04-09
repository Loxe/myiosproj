//
//  RequestReportScan.m
//  akucun
//
//  Created by Jarry on 2017/9/3.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestReportScan.h"

@implementation RequestReportScan

- (NSString *) uriPath
{
    return API_URI_PRODUCT;
}

- (NSString *) actionId
{
    return ACTION_PRODUCT_SCAN;
}

- (void) initJsonBody
{
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    [resultDic setParamValue:self.cartproduct forKey:@"cartproductid"];
    [resultDic setParamValue:self.barcode forKey:@"barcode"];
    [resultDic setParamValue:self.adorderid forKey:@"adorderid"];
    [resultDic setParamIntegerValue:self.statu forKey:@"statu"];
    
    [self.jsonBody setValue:resultDic forKey:@"result"];
}

@end
