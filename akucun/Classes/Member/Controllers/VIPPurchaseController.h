//
//  VIPPurchaseController.h
//  akucun
//
//  Created by Jarry on 2017/8/12.
//  Copyright © 2017年 Sucang. All rights reserved.
//
#import "BaseViewController.h"

typedef void(^ActionBlock)(id nsobject);

@interface VIPPurchaseController : BaseViewController

@property (nonatomic, copy  ) ActionBlock  completionBlock;

@end
