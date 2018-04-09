//
//  RequestProductForward.h
//  akucun
//
//  Created by Jarry on 2017/4/7.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"

@interface RequestProductForward : HttpRequestBase

@property (nonatomic, copy)   NSString  *productId;

@property (nonatomic, assign) NSInteger dest;

@end
