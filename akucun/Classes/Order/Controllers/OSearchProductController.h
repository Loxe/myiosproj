//
//  OSearchProductController.h
//  akucun
//
//  Created by Jarry Z on 2018/2/1.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "OrderProductsController.h"

@interface OSearchProductController : OrderProductsController

@property (nonatomic, copy) NSString *liveId;

@property (nonatomic, copy) NSString *barcode;

@property (nonatomic, assign) BOOL showStatus;

@end
