//
//  OrderBaseController.h
//  akucun
//
//  Created by Jarry on 2017/9/11.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderDetailTableCell.h"
#import "OrderModel.h"
#import "AdOrder.h"
#import "CartProduct.h"

@interface OrderBaseController : BaseViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataSource;

@property (nonatomic, strong) OrderModel* orderModel;
@property (nonatomic, strong) AdOrder* adOrder;

@property (nonatomic, copy) voidBlock finishedBlock;

- (void) refreshData;

- (void) productAction:(NSInteger)action product:(CartProduct *)cartProduct index:(NSIndexPath *)indexPath;

- (void) requestOrderCancelProduct:(CartProduct *)product;
- (void) requestCancelOrder;
- (void) requestChangeProduct:(CartProduct *)product
                          sku:(ProductSKU *)sku;
- (void) requestBuyPorduct:(CartProduct *)product
                       sku:(ProductSKU *)sku;
- (void) requestRemark:(NSString *)remark product:(CartProduct *)product index:(NSIndexPath *)indexPath;
- (void) requestGetSKU:(CartProduct *)product;
- (void) reportProductLack:(CartProduct *)product;
- (void) reportProductScan:(NSString *)productId barcode:(NSString *)barcode status:(NSInteger)status;


@end
