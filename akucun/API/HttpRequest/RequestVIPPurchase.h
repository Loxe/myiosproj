//
//  RequestVIPPurchase.h
//  akucun
//
//  Created by Jarry on 2017/9/3.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"
#import "ResponseVIPPurchase.h"

@interface RequestVIPPurchase : HttpRequestBase

@property (nonatomic, assign)   NSInteger paytype;

@property (nonatomic, copy)   NSString  *productid;

@end
