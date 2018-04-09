//
//  RequestReportScan.h
//  akucun
//
//  Created by Jarry on 2017/9/3.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"

@interface RequestReportScan : HttpRequestPOST

@property (nonatomic, copy)   NSString  *cartproduct;
@property (nonatomic, copy)   NSString  *adorderid;
@property (nonatomic, copy)   NSString  *barcode;
@property (nonatomic, assign) NSInteger statu;

@end
