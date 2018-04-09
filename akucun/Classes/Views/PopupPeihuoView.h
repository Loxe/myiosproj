//
//  PopupPeihuoView.h
//  akucun
//
//  Created by Jarry on 2017/7/24.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "MMPopupView.h"
#import "CartProduct.h"

@interface PopupPeihuoView : MMPopupView

@property (nonatomic, strong) CartProduct *product;

@property (nonatomic, copy) voidBlock finishBlock;

@property (nonatomic, copy) voidBlock skipBlock;

- (instancetype) initWithProduct:(CartProduct *)product;

@end
