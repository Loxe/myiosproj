//
//  OrderProductsController.m
//  akucun
//
//  Created by Jarry Z on 2018/1/22.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "OrderProductsController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "MMAlertView.h"
#import "RequestProductRemark.h"
#import "RequestCancelProduct.h"
#import "RequestChangeProduct.h"
#import "RequestGetSKU.h"
#import "ASaleApplyController.h"
#import "ASaleTuihuoController.h"
#import "ASaleDetailController.h"
#import "ProductsManager.h"
#import "PopupProductView.h"

@interface OrderProductsController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@implementation OrderProductsController

- (void) refreshData
{
    
}

- (void) productAction:(NSInteger)action product:(CartProduct *)cartProduct index:(NSIndexPath *)indexPath
{
    if (action == ProductActionChange) {
        // 未付款，换尺码
        [self changeProductSKU:cartProduct];
    }
    else if (action == ProductActionTuikuan) {
        // 已付款 未发货，退款不发货
        [self tuikuan:cartProduct];
    }
    else if (action == ProductActionApply) {
        // 申请售后
        ASaleApplyController *controller = [[ASaleApplyController alloc] initWithProduct:cartProduct];
        @weakify(self)
        controller.finishedBlock = ^(int type) {
            @strongify(self)
            cartProduct.status = ProductASaleSubmit;
            [self updateRowAtIndex:indexPath product:cartProduct];
            
            if (type > 1) {
                [self showAftersaleConfirm:cartProduct];
            }
            else {
                [self showAftersaleDetail:cartProduct];
            }
        };
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
        [self presentViewController:nav animated:YES completion:nil];
    }
    else if (action == ProductActionAfterSale) {
        // 售后进度
        ASaleDetailController *controller = [[ASaleDetailController alloc] initWithProduct:cartProduct.cartproductid];
        
        [self.navigationController pushViewController:controller animated:YES];
    }
}

// 换尺码
- (void) changeProductSKU:(CartProduct *)cartProduct
{
    ProductModel *product = [[ProductsManager instance] productById:cartProduct.productid];
    if (!product) {
        [SVProgressHUD showInfoWithStatus:@"该商品不支持换尺码"];
        return;
    }
    
    PopupProductView *popupView = [[PopupProductView alloc] initWithProduct:product title:@"换尺码" isChange:YES];
    @weakify(self)
    popupView.finishBlock = ^(id content) {
        @strongify(self)
        ProductSKU *sku = content;
        if ([sku.Id isEqualToString:cartProduct.sku.Id]) {
            [SVProgressHUD showInfoWithStatus:@"选择了相同的尺码"];
            return;
        }
        
        [self requestChangeProduct:cartProduct sku:sku];
    };
    [popupView show];
}

- (void) tuikuan:(CartProduct *)cartProduct
{
    NSString *msg = @"订单未发货，确定取消该商品吗 ？ 确定取消该商品金额将退回原支付渠道";
    @weakify(self)
    [self confirmWithTitle:@"申请退款不发货"
                    detail:msg
                     block:^
     {
         @strongify(self)
         [self requestOrderCancelProduct:cartProduct];
         
     } canceled:nil];
}

- (void) showAftersaleConfirm:(CartProduct *)cartProduct
{
    @weakify(self)
    [self alertWithTitle:@"售后申请已提交"
                 btnText:@"填写快递单号"
                  detail:@"您需要将问题货品寄回爱库存，请填写退货快递单号"
                   block:^
     {
         @strongify(self)
         ASaleTuihuoController *controller = [[ASaleTuihuoController alloc] initWithProduct:cartProduct.cartproductid];
         controller.finishedBlock = ^ {
             [self showAftersaleDetail:cartProduct];
         };
         UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
         [self presentViewController:nav animated:YES completion:nil];
     }];
}

- (void) showAftersaleDetail:(CartProduct *)cartProduct
{
    ASaleDetailController *controller = [[ASaleDetailController alloc] initWithProduct:cartProduct.cartproductid];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -

- (void) updateDataSource:(NSArray *)products
{
    if (!self.dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    else if (self.pageNo == 1) {
        [self.dataSource removeAllObjects];
    }
    
    if (products.count == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView reloadData];
        return;
    }
    
    for (CartProduct *product in products) {
//        if (self.adOrder && self.adOrder.outaftersale > 0) {
//            product.outaftersale = YES;
//        }
//        product.scanstatu = 0;
        product.showBarcode = YES;
        CartCellLayout *layout = [[CartCellLayout alloc] initWithModel:product checkable:NO remark:NO];
        [self.dataSource addObject:layout];
    }
    
    [self updateTableData];
}

- (void) updateTableData
{
    [self.tableView reloadData];
    self.tableView.mj_footer.hidden = (self.dataSource.count < kPAGE_SIZE);
    if (self.dataSource.count >= kPAGE_SIZE) {
        [self.tableView.mj_footer endRefreshing];
    }
}

- (void) updateRowAtIndex:(NSIndexPath *)indexPath product:(CartProduct *)product
{
    CartCellLayout *newLayout = [[CartCellLayout alloc] initWithModel:product checkable:NO remark:NO];
    
    AKTableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell coverScreenshotAndDelayRemoved:self.tableView cellHeight:newLayout.cellHeight];
    
    [self.dataSource replaceObjectAtIndex:indexPath.row withObject:newLayout];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - request

- (void) requestRemark:(NSString *)remark product:(CartProduct *)product index:(NSIndexPath *)indexPath
{
    [SVProgressHUD showWithStatus:nil];
    
    RequestProductRemark *request = [RequestProductRemark new];
    request.productId = product.cartproductid;
    request.remark = remark;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [SVProgressHUD showSuccessWithStatus:@"已成功添加备注"];
         product.remark = remark;
         [self updateRowAtIndex:indexPath product:product];
     }
                                 onFailed:nil];
}

- (void) requestOrderCancelProduct:(CartProduct *)product
{
    [SVProgressHUD showWithStatus:nil];
    
    RequestCancelProduct *request = [RequestCancelProduct new];
    request.orderid = product.orderid;
    request.cartproductid = product.cartproductid;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [SVProgressHUD showSuccessWithStatus:@"申请已提交"];
         //
         [self refreshData];
     }
                                 onFailed:^(id content)
     {
         
     }];
}

- (void) requestChangeProduct:(CartProduct *)product
                          sku:(ProductSKU *)sku
{
    [SVProgressHUD showWithStatus:nil];
    
    RequestChangeProduct *request = [RequestChangeProduct new];
    request.orderId = product.orderid;
    request.productId = product.cartproductid;
    request.skuId = sku.Id;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [SVProgressHUD showSuccessWithStatus:@"已提交"];
         //
         GCD_DELAY(^{
             [self refreshData];
             // 更新 SKU
             [self requestGetSKU:product];
         }, 1.0f);
     }
                                 onFailed:^(id content)
     {
         
     }];
}

- (void) requestGetSKU:(CartProduct *)product
{
    RequestGetSKU *request = [RequestGetSKU new];
    request.productId = product.productid;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
     }
                                 onFailed:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CartCellLayout* layout = self.dataSource[indexPath.row];
    return layout.cellHeight;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"cellIdentifier";
    OrderDetailTableCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[OrderDetailTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [self configureCell:cell];
    [self callbackWithCell:cell];
    
    if (indexPath.row < self.dataSource.count) {
        CartCellLayout* layout = self.dataSource[indexPath.row];
        cell.cellLayout = layout;
    }
    cell.indexPath = indexPath;

    return cell;
}

- (void) configureCell:(OrderDetailTableCell *)cell
{

}

- (void) callbackWithCell:(OrderDetailTableCell *)cell
{
    @weakify(self)
    cell.clickedActionCallback = ^(OrderDetailTableCell* cell, NSInteger action, CartProduct *model) {
        @strongify(self)
        [self productAction:action product:model index:cell.indexPath];
    };
    
    cell.clickedRemarkCallback = ^(OrderDetailTableCell *cell, CartProduct *model) {
        @strongify(self)
        MMAlertView *alertView =
        [[MMAlertView alloc] initWithInputTitle:@"商品备注"
                                         detail:@""
                                        content:model.remark
                                    placeholder:@"请输入备注信息"
                                        handler:^(NSString *text)
         {
             [self requestRemark:text product:model index:cell.indexPath];
         }];
        [alertView show];
    };
}

#pragma mark - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate

- (NSAttributedString *) titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无商品记录";
    NSDictionary *attributes = @{NSFontAttributeName : [FontUtils normalFont],
                                 NSForegroundColorAttributeName : COLOR_TEXT_LIGHT };
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *) imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return IMAGENAMED(@"image_order");
}

- (BOOL) emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return self.dataSource ? YES : NO;
}

- (BOOL) emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

#pragma mark -

- (UITableView *) tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = CLEAR_COLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
        //        _tableView.showsVerticalScrollIndicator = NO;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
    }
    return _tableView;
}

@end
