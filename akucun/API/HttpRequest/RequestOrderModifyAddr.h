//
//  RequestOrderModifyAddr.h
//  akucun
//
//  Created by Jarry on 2017/8/27.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"

@interface RequestOrderModifyAddr : HttpRequestPOST

@property (nonatomic, copy)   NSString  *adorderid;

@property (nonatomic, copy)   NSString  *name;

@property (nonatomic, copy)   NSString  *mobile;

@property (nonatomic, copy)   NSString  *province;

@property (nonatomic, copy)   NSString  *city;

@property (nonatomic, copy)   NSString  *area;

@property (nonatomic, copy)   NSString  *address;

@end
