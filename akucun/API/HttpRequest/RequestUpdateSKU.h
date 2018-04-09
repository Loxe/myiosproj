//
//  RequestUpdateSKU.h
//  akucun
//
//  Created by Jarry on 2017/8/18.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"
#import "ResponseSKUList.h"

@interface RequestUpdateSKU : HttpRequestPOST

@property (nonatomic, strong)   NSArray  *products;

@end
