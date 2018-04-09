//
//  ASaleTuihuoController.h
//  akucun
//
//  Created by Jarry on 2017/9/12.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "BaseViewController.h"
#import "CartProduct.h"

@interface ASaleTuihuoController : BaseViewController

@property (nonatomic, copy) NSString  *productId;

@property (nonatomic, copy) voidBlock finishedBlock;


- (instancetype) initWithProduct:(NSString *)cartProductId;

@end
