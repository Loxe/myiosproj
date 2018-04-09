//
//  PayViewController.h
//  akucun
//
//  Created by Jarry on 2017/5/3.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderModel.h"
#import "Address.h"
#import "Logistics.h"

@interface PayViewController : BaseViewController

@property (nonatomic, strong) NSArray *orderIds;

@property (nonatomic, strong) OrderModel *order;

@property (nonatomic, strong) Address *address;
@property (nonatomic, strong) Logistics *logistics;

@property (nonatomic, copy) voidBlock finishBlock;
@property (nonatomic, copy) voidBlock cancelBlock;

@property (nonatomic, assign) BOOL showForward;

@end
