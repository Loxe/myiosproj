//
//  BuyViewController.h
//  akucun
//
//  Created by Jarry Zhu on 2017/11/5.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "BaseViewController.h"
#import "ProductModel.h"

@interface BuyViewController : BaseViewController

@property (nonatomic, strong) ProductModel *product;
@property (nonatomic, strong) ProductSKU *sku;

@property (nonatomic, copy) idBlock finishBlock;

@end
