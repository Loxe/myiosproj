//
//  ProductCellLayout.h
//  akucun
//
//  Created by Jarry on 2017/3/30.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "AKCellLayout.h"
#import "ProductModel.h"


@interface ProductCellLayout : AKCellLayout

//@property (nonatomic,copy)  NSString *productId;
@property (nonatomic,strong) ProductModel* productModel;

@property (nonatomic,assign) CGFloat contentLeft;
@property (nonatomic,assign) CGFloat contentBottom;

@property (nonatomic,assign) CGFloat menuPosition;
@property (nonatomic,assign) CGRect skuBgPosition;
@property (nonatomic,assign) CGFloat skuBgBottom;

@property (nonatomic,assign) CGFloat imageWidth;
@property (nonatomic,assign) CGRect imagesRect;
//@property (nonatomic,copy) NSArray* imagePostions;

@property (nonatomic,assign) CGFloat nameCenterY;


- (id) initWithModel:(ProductModel *)product;

@end
