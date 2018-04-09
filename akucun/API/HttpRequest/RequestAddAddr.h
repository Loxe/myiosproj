//
//  RequestAddAddr.h
//  akucun
//
//  Created by Jarry on 2017/4/4.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"

/**
 *  用户添加地址信息接口
 */
@interface RequestAddAddr2 : HttpRequestPOST

@property (nonatomic, copy)   NSString  *name;

@property (nonatomic, copy)   NSString  *mobile;

@property (nonatomic, copy)   NSString  *province;

@property (nonatomic, copy)   NSString  *city;

@property (nonatomic, copy)   NSString  *area;

@property (nonatomic, copy)   NSString  *address;

// 0： 默认地址  其它： 非默认地址
@property (nonatomic, assign)   NSInteger  defaultflag;

@end
