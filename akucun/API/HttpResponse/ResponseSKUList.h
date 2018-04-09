//
//  ResponseSKUList.h
//  akucun
//
//  Created by Jarry on 2017/8/18.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpResponseList.h"
#import "ProductSKU.h"
#import "ProductModel.h"

@interface ResponseSKUList : HttpResponseList

@property (nonatomic, copy)   NSString  *productId;
@property (nonatomic, strong) ProductModel *product;

@property (nonatomic, strong) NSArray *productIds;
@property (nonatomic, strong) NSArray *products;

@end
