//
//  PopupProductView.h
//  akucun
//
//  Created by Jarry on 2017/6/16.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "MMPopupView.h"
#import "ProductModel.h"

@interface PopupProductView : MMPopupView

@property (nonatomic, strong) ProductModel *product;

@property (nonatomic, assign) BOOL isChange;

@property (nonatomic, copy) idBlock finishBlock;

- (instancetype) initWithProduct:(ProductModel *)product title:(NSString *)title isChange:(BOOL)change;

@end
