//
//  MyOrderController.m
//  akucun
//
//  Created by Jarry on 2017/6/18.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "MyOrderController.h"
#import "AppDelegate.h"
#import "CameraUtils.h"
#import "MJRefresh.h"
#import "UIScrollView+EmptyDataSet.h"
#import "TopBarView.h"
#import "OrderTableCell.h"
#import "RequestOrderList.h"
#import "RequestDeliverList.h"
#import "RequestOrderDetail.h"
#import "RequestDeliverDetail.h"
#import "RequestDeliverApply.h"
#import "RequestReportScan.h"
#import "RequestBarcodeSearch.h"
#import "PayViewController.h"
#import "OrderDetailController.h"
#import <QuickLook/QuickLook.h>
#import "MMAlertView.h"
#import "AdOrderManager.h"
#import "BarcodeScanController.h"
#import "PopupPeihuoView.h"
#import "MMSheetView.h"


@interface MyOrderController () <UITableViewDataSource,UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, QLPreviewControllerDataSource, QLPreviewControllerDelegate>

//@property (nonatomic, strong) TopBarView* topBarView;

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataSource;

@property (nonatomic, assign) NSInteger pageNo;

@property (strong, nonatomic) AdOrder *adOrder;

@end

@implementation MyOrderController

- (void) setupContent
{
    [super setupContent];
    self.view.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    
    self.title = @"我的订单";
    
//    [self.view addSubview:self.topBarView];
    [self.view addSubview:self.tableView];

    //
    @weakify(self)
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self refreshOrderList];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.textColor = LIGHTGRAY_COLOR;
    self.tableView.mj_header = refreshHeader;

    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        self.pageNo ++;
        NSInteger type = self.orderType - 1;
        if (type == 3) {// 已发货，取发货单列表
            [self requestDeliverList:self.pageNo status:2];
        }
        else if (type == 2) {// 拣货中
            [self requestDeliverList:self.pageNo status:3];
        }
        else if (type == 1) {// 待发货，取发货单列表
            [self requestDeliverList:self.pageNo status:1];
        }
        else {
            [self requestOrderList:self.pageNo type:type];
        }
    }];
    refreshFooter.stateLabel.textColor = COLOR_TEXT_LIGHT;
    [refreshFooter setTitle:@"正在加载数据中..." forState:MJRefreshStateRefreshing];
    [refreshFooter setTitle:@"已加载完毕" forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = refreshFooter;
    self.tableView.mj_footer.hidden = YES;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [SVProgressHUD setContainerView:nil];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
/*
    if (self.topBarView.selectedIndex != self.orderType) {
        self.topBarView.selectedIndex = self.orderType;
    }
    else if (self.orderType <= 1) {
        self.pageNo = 1;
        [self.tableView.mj_footer resetNoMoreData];
        self.tableView.mj_footer.hidden = YES;
        [self requestOrderList:self.pageNo type:(self.orderType - 1)];
    }
 */
}

- (void) updateData
{
    if (!self.dataSource || self.dataSource.count == 0) {
        [self refreshOrderList];
    }
    else if (self.orderType <= 1) {
        self.pageNo = 1;
        [self.tableView.mj_footer resetNoMoreData];
        self.tableView.mj_footer.hidden = YES;
        [self requestOrderList:self.pageNo type:(self.orderType - 1)];
    }
}

- (void) refreshOrderList
{
    [SVProgressHUD showWithStatus:nil];
    self.dataSource = nil;
    [self.tableView.mj_footer resetNoMoreData];
    self.tableView.mj_footer.hidden = YES;
    [self.tableView reloadData];
    
    NSInteger type = self.orderType - 1;
    GCD_DELAY(^{
        self.pageNo = 1;
        if (type == 3) {// 已发货，取发货单列表
            [self requestDeliverList:self.pageNo status:2];
        }
        else if (type == 2) {// 拣货中
            [self requestDeliverList:self.pageNo status:3];
        }
        else if (type == 1) {// 待发货，取发货单列表
            [self requestDeliverList:self.pageNo status:1];
        }
        else {
            [self requestOrderList:self.pageNo type:type];
        }
    }, 0.3f);
}

- (void) updateDataSource:(NSArray *)orders
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    
    if (!self.dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    else if (self.pageNo == 1) {
        [self.dataSource removeAllObjects];
    }
    
    if (orders.count == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView reloadData];
        return;
    }
    
    NSInteger index = 0;
    NSString *date = @"";
    if (self.orderType == 2 || self.orderType == 3 || self.orderType == 4) {
        for (id item in orders) {
            if (![item isKindOfClass:[AdOrder class]]) {
                continue;
            }
            AdOrder *order = item;
            NSString *orderDate = [order dateString];
            BOOL showDate = ![orderDate isEqualToString:date];
            OrderCellLayout *layout = [[OrderCellLayout alloc] initWithAdOrder:order showDate:showDate];
            date = orderDate;
            [self.dataSource addObject:layout];
            index ++;
        }
    }
    else {
        for (id item in orders) {
            if (![item isKindOfClass:[OrderModel class]]) {
                continue;
            }
            OrderModel *order = item;
            NSString *orderDate = [order dateString];
            BOOL showDate = ![orderDate isEqualToString:date];
            OrderCellLayout *layout = [[OrderCellLayout alloc] initWithModel:order showDate:showDate];
            date = orderDate;
            [self.dataSource addObject:layout];
            index ++;
        }
    }
    
    [self.tableView reloadData];
    self.tableView.mj_footer.hidden = (self.dataSource.count < 20);
    if (self.dataSource.count >= 20) {
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark - 

- (void) requestOrderList:(NSInteger)pageNo type:(NSInteger)type
{
    RequestOrderList *request = [RequestOrderList new];
    request.pageno = pageNo;
    request.dingdanstatu = type;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         ResponseOrderList *response = content;
         [self updateDataSource:response.result];
     }
                                 onFailed:^(id content)
     {
         [self.tableView.mj_header endRefreshing];
     }
                                  onError:^(id content)
     {
         [self.tableView.mj_header endRefreshing];
     }];
}

- (void) requestDeliverList:(NSInteger)pageNo status:(NSInteger)status
{
    RequestDeliverList *request = [RequestDeliverList new];
    request.pageno = pageNo;
    request.statu = status;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [self.tableView.mj_header endRefreshing];
         ResponseDeliverList *response = content;
         [self updateDataSource:response.result];
     }
                                 onFailed:^(id content)
     {
         [self.tableView.mj_header endRefreshing];
     }
                                  onError:^(id content)
     {
         [self.tableView.mj_header endRefreshing];
     }];
}

- (void) requestOrderDetail:(OrderModel *)order
{
    [SVProgressHUD showWithStatus:nil];
    RequestOrderDetail *request = [RequestOrderDetail new];
    request.orderid = order.orderid;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [SVProgressHUD dismiss];
         ResponseOrderDetail *response = content;
         [self payAction:order logistics:response.logistics];
     }
                                 onFailed:^(id content)
     {
         [self.tableView.mj_header endRefreshing];
     }
                                  onError:^(id content)
     {
         [self.tableView.mj_header endRefreshing];
     }];
}

- (void) requestDeliverDetail:(AdOrder *)order index:(NSIndexPath *)indexPath
{
    [SVProgressHUD showWithStatus:nil];
    RequestDeliverDetail *request = [RequestDeliverDetail new];
    request.adorderid = order.adorderid;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [SVProgressHUD dismiss];

         ResponseDeliverDetail *response = content;
         
         OrderCellLayout* layout = self.dataSource[indexPath.row];
         layout.adOrder = response.order;
         
         [self scanAction:response.order index:indexPath];
     }
                                 onFailed:nil];
}

- (void) requestApplyDoc:(AdOrder *)order
{
    [SVProgressHUD showWithStatus:nil];
    RequestDeliverApply *request = [RequestDeliverApply new];
    request.adorderid = order.adorderid;
 
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [SVProgressHUD dismiss];
         
         NSArray *items =
         @[MMItemMake(@"确定", MMItemTypeHighlight, nil)];
         
         NSString *detailText = @"\n对账单申请已提交，生成对账单过程可能需要几分钟时间，请稍候在发货单详情中查看";
         MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"申请已提交" detail:detailText items:items];
         [alertView show];
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
//             [[AdOrderManager instance] updateProductStatusBy:productId];
         }
         else {
             [SVProgressHUD dismiss];
         }

     } onFailed:nil];
}

- (void) requestBarcodeSearch:(NSString *)barcode
{
    [SVProgressHUD showWithStatus:nil];
    
    RequestBarcodeSearch *request = [RequestBarcodeSearch new];
    request.barcode = barcode;
    if (self.adOrder) {
        request.liveid = self.adOrder.liveid;
    }
    
    [SCHttpServiceFace serviceWithRequest:request onSuccess:^(id content)
     {
         //
         [SVProgressHUD dismiss];
         
         ResponseBarcodeSearch *response = content;
         [self showBarcodeResult:response.result barcode:barcode];
         
     } onFailed:nil];
}

- (void) showBarcodeResult:(NSArray *)products barcode:(NSString *)barcode
{
    if (!products || products.count == 0) {
        NSArray *items =
        @[MMItemMake(@"确定", MMItemTypeHighlight, nil)];
        NSString *detailText = @"\n请确认商品条码是否正确 ! \n您可以尝试扫一下另一个条码 !\n";
        MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:barcode detail:detailText items:items];
        [alertView show];
        //
        [self reportProductScan:@"" barcode:barcode status:0];
        return;
    }
    
    CartProduct *product = nil;
    for (CartProduct *p in products) {
        if (p.scanstatu == 0) {
            product = p;
            break;
        }
    }
    if (product) {
        PopupPeihuoView *popupView = [[PopupPeihuoView alloc] initWithProduct:product];
        @weakify(self)
        popupView.finishBlock = ^{
            @strongify(self)
            [self reportProductScan:product.cartproductid barcode:barcode status:1];
        };
        [popupView show];
    }
    else {
        NSArray *items =
        @[MMItemMake(@"确定", MMItemTypeHighlight, nil)];
        NSString *detailText = @"\n该商品已拣货，请勿重复操作";
        MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"商品已拣货" detail:detailText items:items];
        [alertView show];
    }
}

#pragma mark - Action

- (void) payAction:(OrderModel *)order logistics:(Logistics *)logistics
{
    PayViewController *payController = [PayViewController new];
    payController.order = order;
    payController.orderIds = @[order.orderid];
    payController.logistics = logistics;
    @weakify(self)
    payController.finishBlock = ^{
        @strongify(self)
        [self refreshOrderList];
        //
        OrderDetailController *controller = [OrderDetailController new];
        controller.orderModel = order;
        [self.navigationController pushViewController:controller animated:YES];
    };
    
    [self.navigationController pushViewController:payController animated:YES];
//    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:payController];
//    [self presentViewController:payController animated:YES completion:nil];
}

- (void) previewDocAction:(NSString *)url model:(id)model
{
//    if (url == nil) {
//        // 申请对账单
//        AdOrder *order = model;
//        [self requestApplyDoc:order];
//        return;
//    }
    
//    if ([model isKindOfClass:[OrderModel class]]) {
//        [self downloadFile:url];
//        return;
//    }
    
    MMPopupItemHandler block = ^(NSInteger index) {
        if (index == 0) {
            [self requestApplyDoc:model];
        }
        else {
            [self downloadFile:url];
        }
    };
    
    NSString *title = @"";
    NSArray *items =
    @[MMItemMake(@"更新对账单", MMItemTypeNormal, block),
      MMItemMake(@"下载对账单", MMItemTypeNormal, block)];
    
    if ([NSString isEmpty:url]) {
        items = @[MMItemMake(@"申请对账单", MMItemTypeNormal, block)];
    }

    MMSheetView *sheetView = [[MMSheetView alloc] initWithTitle:title items:items];
    [sheetView show];
}

- (void) downloadFile:(NSString *)url
{
    if (url.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"对账单还未生成，请稍候再试"];
        return;
    }
    
    [SVProgressHUD showWithStatus:nil];
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/对账单.xls"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    [SCHttpServiceFace serviceWithDownloadURL:[url urlEncodedString]
                                         path:path
                                        onSuc:^(id content)
     {
         [SVProgressHUD dismiss];
         //
         QLPreviewController *previewController = [[QLPreviewController alloc] init];
         previewController.delegate =self;
         previewController.dataSource =self;
         [self presentViewController:previewController animated:YES completion:nil];
     }
                                      onError:^(id content)
     {
         [SVProgressHUD showErrorWithStatus:@"下载对账单出错了, 请更新对账单"];
     }];
}

- (void) scanAction:(AdOrder *)order index:(NSIndexPath *)indexPath
{
    self.adOrder = order;
    
    /*
    if (order.products.count == 0) {
        [self requestDeliverDetail:order index:indexPath];
        return;
    }*/

    if ([CameraUtils isCameraNotDetermined]) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    // 用户授权
//                    [self presentViewController:self.scanReader animated:YES completion:nil];
                    [self showSGQScanVC];
                }
                else {
                    // 用户拒绝授权
                    [self showCameraDenied];
                }
            });
        }];
    }
    else if ([CameraUtils isCameraDenied]) {
        // 摄像头已被禁用
        [self showCameraDenied];
    }
    else {
        // 用户允许访问摄像头
//        [self presentViewController:self.scanReader animated:YES completion:nil];
        [self showSGQScanVC];
    }
}

- (void) showCameraDenied
{
    [self confirmWithTitle:@"摄像头未授权" detail:@"摄像头访问未授权，您可以在设置中打开" btnText:@"去设置" block:^{
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    } canceled:nil];
}

- (void) showSGQScanVC
{
    BarcodeScanController *scanController = [[BarcodeScanController alloc] init];
    scanController.liveId = self.adOrder.liveid;
    [self.navigationController presentViewController:scanController animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderCellLayout* layout = self.dataSource[indexPath.row];
    return layout.cellHeight;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"cellIdentifier";
    OrderTableCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[OrderTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.row < self.dataSource.count) {
        OrderCellLayout* layout = self.dataSource[indexPath.row];
        cell.cellLayout = layout;
        cell.indexPath = indexPath;
        
        [self callbackWithCell:cell];
    }
    
    return cell;
}

- (void) callbackWithCell:(OrderTableCell *)cell
{
    @weakify(self)
    cell.clickedPayCallback = ^(OrderTableCell* cell, OrderModel *model) {
        @strongify(self)
        [self requestOrderDetail:model];
    };
    
    cell.clickedPreviewCallback = ^(OrderTableCell* cell, id model, NSString *pathUrl) {
        @strongify(self)
        [self previewDocAction:pathUrl model:model];
    };
    
    cell.clickedScanCallback = ^(OrderTableCell* cell, AdOrder *model) {
        @strongify(self)
        [self scanAction:model index:cell.indexPath];
    };
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < self.dataSource.count) {
        OrderCellLayout* layout = self.dataSource[indexPath.row];
        OrderDetailController *controller = [OrderDetailController new];
        if (layout.orderModel) {
            controller.orderModel = layout.orderModel;
        }
        else if (layout.adOrder) {
            controller.adOrder = layout.adOrder;
        }
        @weakify(self)
        controller.finishedBlock = ^{
            @strongify(self)
            [self refreshOrderList];
        };
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate

- (NSAttributedString *) titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无相关订单";
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

- (CGFloat) verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -kTableCellHeight;
}

#pragma mark - QLPreviewControllerDataSource, QLPreviewControllerDelegate

- (NSInteger) numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}

- (id<QLPreviewItem>) previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/对账单.xls"];
    return [NSURL fileURLWithPath:path];
}

#pragma mark - Lazy Load

- (UITableView *) tableView
{
    if (!_tableView) {
        CGRect frame = CGRectMake(0, 0, self.view.width, self.view.height);
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
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
/*
- (TopBarView *) topBarView
{
    if (!_topBarView) {
         NSArray *titles = @[@"全 部", @"待支付", @"待发货", @"拣货中", @"已发货", @"已取消"];
        _topBarView = [[TopBarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44) titles:titles];
        
        @weakify(self)
        _topBarView.selectBlock = ^(int index) {
            @strongify(self)
            self.orderType = index;
            [self refreshOrderList];
        };
    }
    return _topBarView;
}
*/
@end
