//
//  OrderCellLayout.h
//  akucun
//
//  Created by Jarry on 2017/4/2.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "AKCellLayout.h"
#import "OrderModel.h"
#import "AdOrder.h"

@interface OrderCellLayout : AKCellLayout

@property (nonatomic, strong) OrderModel* orderModel;
@property (nonatomic, strong) AdOrder* adOrder;

@property (nonatomic, assign) BOOL showDate;
@property (nonatomic, assign) CGFloat dateHeight;

@property (nonatomic, assign) CGFloat nameHeight;
@property (nonatomic, assign) CGFloat linePosition;

- (id) initWithModel:(OrderModel*)orderModel showDate:(BOOL)flag;

- (id) initWithAdOrder:(AdOrder*)orderModel showDate:(BOOL)flag;

@end
