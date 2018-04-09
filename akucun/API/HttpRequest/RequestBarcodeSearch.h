//
//  RequestBarcodeSearch.h
//  akucun
//
//  Created by Jarry Zhu on 2017/12/12.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"
#import "ResponseBarcodeSearch.h"

@interface RequestBarcodeSearch : HttpRequestBase

@property (nonatomic, copy)   NSString  *barcode;
@property (nonatomic, copy)   NSString  *liveid;

@end
