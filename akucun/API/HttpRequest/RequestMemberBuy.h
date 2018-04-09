//
//  RequestMemberBuy.h
//  akucun
//
//  Created by Jarry on 2017/8/12.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"

@interface RequestMemberBuy : HttpRequestBase

@property (nonatomic, copy)   NSString  *productid;
@property (nonatomic, copy)   NSString  *transactionid;

@end
