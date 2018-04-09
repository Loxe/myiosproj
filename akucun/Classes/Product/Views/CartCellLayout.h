//
//  CartCellLayout.h
//  akucun
//
//  Created by Jarry on 2017/4/2.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "AKCellLayout.h"
#import "CartProduct.h"

@interface CartCellLayout : AKCellLayout

@property (nonatomic,strong) CartProduct* cartProduct;

@property (nonatomic,assign) CGRect imagePosition;

@property (nonatomic,assign) CGFloat buttonPosition;

@property (nonatomic,assign) BOOL showRemark;
@property (nonatomic,assign) BOOL isCheckable;
@property (nonatomic,assign) BOOL checked;


- (id) initWithModel:(CartProduct*)cartProduct checkable:(BOOL)checkable remark:(BOOL)showRemark;


@end
