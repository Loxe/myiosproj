//
//  PinpaiCart.h
//  akucun
//
//  Created by Jarry on 2017/5/7.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "JTModel.h"
#import "CartProduct.h"

@interface PinpaiCart : JTModel

@property (nonatomic, copy) NSString *pinpai;

@property (nonatomic, assign) NSInteger yunfeijine;
@property (nonatomic, assign) NSInteger dikoujine;

@property (nonatomic, strong) NSArray *cartproducts;


@end
