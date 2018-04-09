//
//  ResponseFollowList.h
//  akucun
//
//  Created by Jarry on 2017/9/17.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpResponseList.h"
#import "ProductModel.h"

@interface ResponseFollowList : HttpResponseList

@property (nonatomic, strong) NSMutableArray  *products;

@end
