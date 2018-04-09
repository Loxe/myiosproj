//
//  RequestOrderCreate.h
//  akucun
//
//  Created by Jarry on 2017/4/8.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"
#import "ResponseOrderCreate.h"

@interface RequestOrderCreate : HttpRequestPOST

@property (nonatomic, strong)   NSArray  *products;

@property (nonatomic, copy) NSString *addrid;

@end
