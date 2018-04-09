//
//  ResponseCartProducts.h
//  akucun
//
//  Created by Jarry on 2017/4/8.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpResponseList.h"
#import "PinpaiCart.h"

@interface ResponseCartProducts : HttpResponseList

@property (nonatomic, strong) NSMutableArray *outofstock;

@end
