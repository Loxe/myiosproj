//
//  ProductSKU.h
//  akucun
//
//  Created by Jarry on 2017/4/8.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "JTModel.h"

@interface ProductSKU : JTModel

@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *productid;

@property (nonatomic, copy) NSString *barcode;
@property (nonatomic, copy) NSString *chima;
@property (nonatomic, copy) NSString *yanse;
@property (nonatomic, copy) NSString *cunfangdi;

@property (nonatomic, assign) NSInteger shuliang;

@property (nonatomic, assign) BOOL isChecked;

@end
