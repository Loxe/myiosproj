//
//  RequestCancelBuy.h
//  akucun
//
//  Created by Jarry on 2017/4/12.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"

@interface RequestCancelBuy : HttpRequestBase

@property (nonatomic, copy)   NSString  *productId;

@end
