//
//  OrderRefundController.h
//  akucun
//
//  Created by Jarry on 2017/6/20.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderModel.h"
#import "CartProduct.h"

@interface OrderRefundController : BaseViewController

@property (nonatomic, strong) OrderModel *orderModel;

@property (nonatomic, strong) CartProduct  *cartProduct;
@property (nonatomic, copy) NSString  *productId;

@property (nonatomic, copy) voidBlock finishedBlock;

- (instancetype) initWithType:(NSInteger)type cartProduct:(CartProduct *)cartProduct;

@end
