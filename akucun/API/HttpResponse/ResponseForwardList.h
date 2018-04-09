//
//  ResponseForwardList.h
//  akucun
//
//  Created by Jarry on 2017/4/7.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpResponseList.h"
#import "ProductModel.h"

@interface ResponseForwardList : HttpResponseList

@property (nonatomic, strong) NSMutableArray  *products;

@end
