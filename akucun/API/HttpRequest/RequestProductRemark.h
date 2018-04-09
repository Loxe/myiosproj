//
//  RequestProductRemark.h
//  akucun
//
//  Created by Jarry on 2017/4/11.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"

@interface RequestProductRemark : HttpRequestBase

@property (nonatomic, copy)   NSString  *productId;

@property (nonatomic, copy)   NSString  *remark;

@end
