//
//  RequestAftersaleApply.h
//  akucun
//
//  Created by Jarry on 2017/9/11.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"

@interface RequestAftersaleApply : HttpRequestPOST

@property (nonatomic, copy) NSString *cartproductid;
@property (nonatomic, copy) NSString *problemdesc;

/**
 1: 漏发申请 2: 质量问题 3: 款号错 4: 颜色错 5: 尺码错
 */
@property (nonatomic, assign) NSInteger problemtype;

/**
 1: 漏发补发 2: 漏发退款 3: 退货补发 4: 退货退款
 */
@property (nonatomic, assign) NSInteger expecttype;


/**
 图片数据数组
 */
@property (nonatomic, strong) NSArray *pingzheng;


@end
