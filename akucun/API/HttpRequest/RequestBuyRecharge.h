//
//  RequestBuyRecharge.h
//  akucun
//
//  Created by Jarry on 2017/9/17.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"
#import "ResponseBuyRecharge.h"

@interface RequestBuyRecharge : HttpRequestBase

@property (nonatomic, assign)   NSInteger paytype;
@property (nonatomic, assign)   NSInteger payjine;

@property (nonatomic, copy)   NSString  *deltaid;

@end
