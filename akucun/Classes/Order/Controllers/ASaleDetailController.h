//
//  ASaleDetailController.h
//  akucun
//
//  Created by Jarry on 2017/9/12.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "BaseViewController.h"
#import "CartProduct.h"
#import "ASaleService.h"

@interface ASaleDetailController : BaseViewController

@property (nonatomic, copy) NSString  *productId;

@property (nonatomic, strong) ASaleService *asaleService;

@property (nonatomic, copy) voidBlock finishedBlock;

- (instancetype) initWithProduct:(NSString *)productId;

- (instancetype) initWithService:(ASaleService *)service;

@end
