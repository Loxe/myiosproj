//
//  OrderBaseController.m
//  akucun
//
//  Created by Jarry on 2017/9/11.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "OrderBaseController.h"
#import "RequestOrderCancel.h"
#import "RequestCancelProduct.h"
#import "RequestOrderIsCancel.h"
#import "RequestChangeProduct.h"
#import "RequestProductBuy.h"
#import "RequestProductRemark.h"
#import "RequestGetSKU.h"
#import "RequestReportLack.h"
#import "RequestReportScan.h"
#import "RequestBarcodeSearch.h"
#import "AdOrderManager.h"
#import "ProductsManager.h"
#import "PopupProductView.h"
#import "ASaleApplyController.h"
#import "ASaleTuihuoController.h"
#import "ASaleDetailController.h"
#import "MMAlertView.h"
#import "SCLAlertView.h"

@interface OrderBaseController ()

@end

@implementation OrderBaseController

- (void) refreshData
{
    
}

- (void) updateRowAtIndex:(NSIndexPath *)indexPath product:(CartProduct *)product
{
    CartCellLayout *newLayout = [[CartCellLayout alloc] initWithModel:product checkable:NO remark:NO];
    
    AKTableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell coverScreenshotAndDelayRemoved:self.tableView cellHeight:newLayout.cellHeight];
    
    [self.dataSource replaceObjectAtIndex:indexPath.row withObject:newLayout];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
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
                [self showTuihuoConfirm:cartProduct];
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

- (void) showTuihuoConfirm:(CartProduct *)cartProduct
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
    /*
    [self confirmWithTitle:@"售后申请已提交"
                    detail:@"您需要将问题货品寄回爱库存，现在填写退货快递单号吗 ？"
                   btnText:@"确定"
                cancelText:@"暂不填写"
                     block:^
     {
         @strongify(self)
         ASaleTuihuoController *controller = [[ASaleTuihuoController alloc] initWithProduct:cartProduct.cartproductid];
         controller.finishedBlock = ^ {
             [self showAftersaleDetail:cartProduct];
         };
         UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
         [self presentViewController:nav animated:YES completion:nil];

     } canceled:^{
         @strongify(self)
         [self alertWithTitle:@"提示信息"
                       detail:@"您可以稍后在售后进度详情中填写退货快递单号"
                        block:^
         {
            [self refreshData];
         }];
     }];*/
}

- (void) showAftersaleDetail:(CartProduct *)cartProduct
{
    ASaleDetailController *controller = [[ASaleDetailController alloc] initWithProduct:cartProduct.cartproductid];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) tuikuan:(CartProduct *)cartProduct
{
    NSString *msg = @"\n订单未发货，确定取消该商品吗 ？ 确定取消商品金额将退回原支付渠道\n\n";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:msg];
    NSMutableAttributedString *msgAttrStr = [[NSMutableAttributedString alloc] initWithString:@"(单场活动最多可取消 5 件商品 ！)"];
    [msgAttrStr addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(15) range:NSMakeRange(0, msgAttrStr.length)];
    [msgAttrStr addAttribute:NSForegroundColorAttributeName value:COLOR_MAIN range:NSMakeRange(0, msgAttrStr.length)];
    [attrStr appendAttributedString:msgAttrStr];
    
    @weakify(self)
    MMPopupItemHandler handler = ^(NSInteger index) {
        @strongify(self)
        if (index == 1) {
            [self requestOrderIsCancel:cartProduct];
        }
    };
    NSArray *items =
    @[MMItemMake(@"取消", MMItemTypeNormal, handler),
      MMItemMake(@"确定", MMItemTypeHighlight, handler)];
    MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"申请退款不发货" attrDetail:attrStr items:items];
    [alertView show];
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

#pragma mark - Requests

- (void) requestOrderIsCancel:(CartProduct *)product
{
    [SVProgressHUD showWithStatus:nil];
    RequestOrderIsCancel *request = [RequestOrderIsCancel new];
    request.orderid = product.orderid;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         HttpResponseBase *response = content;
         NSDictionary *jsonData = response.responseData;
         NSInteger cancelnum = [jsonData getIntegerValueForKey:@"cancelnum"];
         NSInteger procount = [jsonData getIntegerValueForKey:@"procount"];
         if (procount >= cancelnum) {
             [SVProgressHUD dismiss];
//             [self alertWithTitle:@"无法取消商品"
//                           detail:detail
//                            block:nil];
             NSString *detail = FORMAT(@"该活动最多可取消 %ld 件商品 ！\n您已达到取消上限！",(long)cancelnum);
             SCLAlertView *alert = [[SCLAlertView alloc] init];
             alert.labelTitle.font = BOLDSYSTEMFONT(18);
             alert.viewText.font = SYSTEMFONT(15);
             alert.hideAnimationType = SCLAlertViewHideAnimationFadeOut;
             alert.showAnimationType = SCLAlertViewShowAnimationSlideInToCenter;
             alert.customViewColor = COLOR_MAIN;
             [alert showError:self.navigationController title:@"无法取消商品" subTitle:detail closeButtonTitle:@"确 定" duration:0.0f];
             
         }
         else {
             [self requestOrderCancelProduct:product];
         }
         
     } onFailed:nil];
}

- (void) requestOrderCancelProduct:(CartProduct *)product
{
//    [SVProgressHUD showWithStatus:nil];
    
    RequestCancelProduct *request = [RequestCancelProduct new];
    request.orderid = product.orderid;
    request.cartproductid = product.cartproductid;

    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [SVProgressHUD dismiss];
         HttpResponseBase *response = content;
         NSDictionary *jsonData = response.responseData;
         NSInteger cancelnum = [jsonData getIntegerValueForKey:@"cancelnum"];
         NSInteger procount = [jsonData getIntegerValueForKey:@"procount"];
         NSString *detail = FORMAT(@"该活动最多可取消 %ld 件商品 ！您已取消 %ld 件！",(long)cancelnum, (long)procount);
         [self alertWithTitle:@"商品已成功取消"
                       detail:detail
                        block:^
          {
              [self refreshData];
            }];
         /*
         SCLAlertView *alert = [[SCLAlertView alloc] init];
         alert.labelTitle.font = BOLDSYSTEMFONT(18);
         alert.viewText.font = SYSTEMFONT(15);
         alert.hideAnimationType = SCLAlertViewHideAnimationFadeOut;
         alert.showAnimationType = SCLAlertViewShowAnimationSlideInToCenter;
         [alert addButton:@"确 定" actionBlock:^{
             [self refreshData];
         }];
         [alert showSuccess:self.navigationController title:@"商品已成功取消" subTitle:detail closeButtonTitle:nil duration:0.0f];*/
     }
                                 onFailed:^(id content)
     {
         
     }];
}

- (void) requestCancelOrder
{
    [SVProgressHUD showWithStatus:nil];
    
    RequestOrderCancel *request = [RequestOrderCancel new];
    request.orderid = self.orderModel.orderid;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [SVProgressHUD showSuccessWithStatus:@"订单已取消"];
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
    request.orderId = self.orderModel.orderid;
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

- (void) requestBuyPorduct:(CartProduct *)product
                       sku:(ProductSKU *)sku
{
    [SVProgressHUD showWithStatus:nil];
    
    RequestProductBuy *request = [RequestProductBuy new];
    request.productId = product.productid;
    request.skuId = sku.Id;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [SVProgressHUD showSuccessWithStatus:@"已添加到购物车,请到购物车结算"];
         sku.shuliang -= 1;
         
         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ADD_TO_CART object:nil];
     }
                                 onFailed:^(id content)
     {
         
     }];
}

- (void) requestRemark:(NSString *)remark product:(CartProduct *)product index:(NSIndexPath *)indexPath
{
    [SVProgressHUD showWithStatus:nil];
    
    RequestProductRemark *request = [RequestProductRemark new];
    request.productId = product.cartproductid;
    request.remark = remark;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [SVProgressHUD showSuccessWithStatus:@"成功添加备注"];
         product.remark = remark;
         [self updateRowAtIndex:indexPath product:product];
         //
         [[AdOrderManager instance] updateProductRemark:remark product:product.cartproductid];
     }
                                 onFailed:nil];
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

- (void) reportProductLack:(CartProduct *)product
{
    [SVProgressHUD showWithStatus:nil];
    
    RequestReportLack *request = [RequestReportLack new];
    request.cartproduct = product.cartproductid;
    
    [SCHttpServiceFace serviceWithPostRequest:request
                                    onSuccess:^(id content)
     {
         [SVProgressHUD showSuccessWithStatus:@"已提交 ！"];
         
         GCD_DELAY(^{
             [self refreshData];
         }, 1.0f);
         
     } onFailed:nil];
}

- (void) reportProductScan:(NSString *)productId barcode:(NSString *)barcode status:(NSInteger)status
{
    [SVProgressHUD showWithStatus:nil];
    
    RequestReportScan *request = [RequestReportScan new];
    request.cartproduct = productId;
    request.adorderid = self.adOrder.adorderid;
    request.barcode = barcode;
    request.statu = status;
    
    [SCHttpServiceFace serviceWithPostRequest:request
                                    onSuccess:^(id content)
     {
         if (productId.length > 0) {
             [SVProgressHUD showSuccessWithStatus:@"操作成功 ！"];
             // 刷新界面
             
//             [[AdOrderManager instance] updateProductStatusBy:productId];
         }
         else {
             [SVProgressHUD dismiss];
         }
     } onFailed:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
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
        
    }
    return _tableView;
}

@end
