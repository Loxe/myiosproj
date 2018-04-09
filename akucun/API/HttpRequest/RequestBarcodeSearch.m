//
//  RequestBarcodeSearch.m
//  akucun
//
//  Created by Jarry Zhu on 2017/12/12.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestBarcodeSearch.h"

@implementation RequestBarcodeSearch

- (HttpResponseBase *) response
{
    return [ResponseBarcodeSearch new];
}

- (NSString *) uriPath
{
    return API_URI_PRODUCT;
}

- (NSString *) actionId
{
    return ACTION_BARCODE_SEARCH;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamValue:self.barcode forKey:@"barcode"];
    [self.dataParams setParamValue:self.liveid forKey:@"liveid"];

}

@end
