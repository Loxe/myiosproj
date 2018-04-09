//
//  ASaleApplyController.h
//  akucun
//
//  Created by Jarry on 2017/9/11.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "BaseViewController.h"
#import "CartProduct.h"

@interface ASaleApplyController : BaseViewController

@property (nonatomic, strong) CartProduct  *cartProduct;

@property (nonatomic, copy) intBlock finishedBlock;


- (instancetype) initWithProduct:(CartProduct *)cartProduct;

@end
