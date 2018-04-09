//
//  RequestCartClear.h
//  akucun
//
//  Created by Jarry on 2017/5/13.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"

@interface RequestCartClear : HttpRequestPOST

@property (nonatomic, strong)   NSArray  *cpids;

@end
