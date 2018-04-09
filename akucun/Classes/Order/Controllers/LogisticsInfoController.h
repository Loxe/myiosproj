//
//  LogisticsInfoController.h
//  akucun
//
//  Created by deepin do on 2017/12/7.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "AdOrder.h"
#import "OrderModel.h"

@interface LogisticsInfoController : BaseViewController

@property (nonatomic, copy) NSString *deliverId;
@property (nonatomic, copy) NSString *wuliugongsi;

@property (nonatomic, strong) AdOrder *adOrder;
@property (nonatomic, strong) OrderModel *order;

@end
