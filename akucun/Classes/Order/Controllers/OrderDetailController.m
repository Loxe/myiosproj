//
//  OrderDetailController.m
//  akucun
//
//  Created by Jarry on 2017/4/8.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "OrderDetailController.h"
#import "AppDelegate.h"
#import "CameraUtils.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YYText.h"
#import "MJRefresh.h"
#import "TableCellBase.h"
#import "RequestOrderDetail.h"
#import "RequestDeliverDetail.h"
#import "RequestAddrList.h"
#import "RequestDeliverApply.h"
#import "RequestBarcodeSearch.h"
#import "ProductsManager.h"
#import "Logistics.h"
#import "OptionsPickerView.h"
#import "PayViewController.h"
#import "OrderSearchController.h"
#import "DocPreviewController.h"
#import <QuickLook/QuickLook.h>
#import "SCActionSheet.h"
#import "TipMessageView.h"
#import "MMAlertView.h"
#import "AdOrderManager.h"
#import "BarcodeScanController.h"
#import "PopupPeihuoView.h"
#import "CountDownView.h"
#import "LogisticsInfoController.h"
#import "AddressViewController.h"
#import "IconButton.h"
#import "MMSheetView.h"
//#define kHeaderHeight   36.0f

@interface OrderHeader : UIView

@property (nonatomic, strong) UILabel *nameLabel, *mobileLabel, *addressLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIButton *copyaButton;

//@property (nonatomic, strong) OrderModel *order;
@property (nonatomic, copy) NSString *wuliuInfo;
//@property (nonatomic, copy) NSString *danhao;
@property (nonatomic, strong) Logistics *logistics;

- (void) setAddress:(NSString *)addr name:(NSString *)name mobile:(NSString *)mobile;

- (void) updateLayout;

@end

@interface OrderDetailController () <QLPreviewControllerDataSource, QLPreviewControllerDelegate>
{
    CGFloat _headerHeight;
}

@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UILabel *pinpaiLabel, *dateLabel;

//@property (nonatomic,strong) TipMessageView *messageView;

@property (nonatomic, strong) NSArray *products;

@property (nonatomic, strong) OrderHeader *headerView;

@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UILabel *totalLabel, *amountLabel;
@property (nonatomic, strong) UILabel *typeLabel;

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *payButton;
@property (nonatomic, strong) TextButton *searchButton;
@property (nonatomic, strong) IconButton *scanButton;
//@property (nonatomic, strong) UIButton *previewButton;

@property (strong, nonatomic) BarcodeScanController *scanController;

@property (nonatomic, strong) CountDownView *timeView;

@end

@implementation OrderDetailController

- (void) setupContent
{
    [super setupContent];
    self.view.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _headerHeight = isPad ? 45 : 38;
    
    self.rightButton.width = 60.0f;
    [self.rightButton setNormalTitle:@"对账单"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    
//    [self.messageView hide];
//    [self.view addSubview:self.messageView];

    [self.headerView updateLayout];
    [self.view addSubview:self.tableView];

    //
    @weakify(self)
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self refreshOrderDetail];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.textColor = LIGHTGRAY_COLOR;
    self.tableView.mj_header = refreshHeader;
    
    _footerView = [[UIView alloc] init];
    _footerView.backgroundColor = [COLOR_MAIN colorWithAlphaComponent:0.2f];
    _footerView.alpha = 0.0f;
    [self.view addSubview:_footerView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kPIXEL_WIDTH)];
    line.backgroundColor = COLOR_SEPERATOR_LINE;
    [_footerView addSubview:line];
    [_footerView addSubview:self.totalLabel];
    [_footerView addSubview:self.amountLabel];
    [_footerView addSubview:self.typeLabel];
    [_footerView addSubview:self.payButton];

    [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.mas_equalTo(@(SCREEN_WIDTH));
        make.height.mas_equalTo(@(50+kSafeAreaBottomHeight*0.5f));
    }];
    
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.footerView.mas_left).offset(kOFFSET_SIZE);
        make.centerY.equalTo(self.footerView.mas_centerY).offset(-kSafeAreaBottomHeight*0.25f);
    }];
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.footerView.mas_right).offset(-kOFFSET_SIZE);
        make.centerY.equalTo(self.totalLabel);
    }];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.amountLabel.mas_left).offset(-10);
        make.centerY.equalTo(self.totalLabel);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.footerView.mas_top);
    }];
}

- (void) initViewData
{
    [super initViewData];
    
    self.dataSource = [NSMutableArray array];
//    [SVProgressHUD showWithStatus:nil];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.dataSource.count == 0) {
        [SVProgressHUD showWithStatus:nil];
        [self refreshOrderDetail];
        /*
        if (self.adOrder && self.adOrder.statu == 4) {
            [SVProgressHUD showWithStatus:nil];
            
            AdOrder *adOrder = [[AdOrderManager instance] adOrderById:self.adOrder.adorderid];
            if (adOrder) {
                self.adOrder = adOrder;
            }
            if (self.adOrder.products.count == 0) {
                [self requestDeliverDetail];
            }
            else {
                [self updateDataSource:self.adOrder.products];
                [SVProgressHUD dismiss];
            }
        }
        else {
            [SVProgressHUD showWithStatus:nil];
            [self refreshOrderDetail];
        }*/
    }
}

- (IBAction) leftButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
//    if (self.orderModel && self.orderModel.status <= 1) {
//        if (self.finishedBlock) {
//            self.finishedBlock();
//        }
//    }
}

- (void) setOrderModel:(OrderModel *)orderModel
{
    [super setOrderModel:orderModel];
    
    self.title = @"订单详情";

//    self.headerView.order = orderModel;
    
    [self updateFooter];
}

- (void) setAdOrder:(AdOrder *)adOrder
{
    [super setAdOrder:adOrder];
    
    self.title = @"发货单详情";

    [self updateFooter];

    [self.headerView setAddress:adOrder.shouhuodizhi name:adOrder.shouhuoren mobile:adOrder.lianxidianhua];
    
    if (adOrder.statu == 4) {
        self.rightButton.hidden = NO;

        if (![NSString isEmpty:adOrder.wuliuhao]) {
            self.headerView.wuliuInfo = [adOrder displayWuliuInfo];
        }
    }
    else {
        if (adOrder.downloadurl && adOrder.downloadurl.length > 0) {
            self.rightButton.hidden = NO;
        }
        else {
            self.rightButton.hidden = YES;
        }
        // 待发货
        if (adOrder.statu == 0) {
            [self.headerView.copyaButton setNormalTitle:@"修改地址"];
            self.headerView.copyaButton.hidden = NO;
        }
    }
}

- (void) refreshData
{
    [self refreshOrderDetail];
}

- (void) refreshOrderDetail
{
//    [SVProgressHUD showWithStatus:nil];
    if (self.orderModel) {
        [self requestOrderDetail];
    }
    else if (self.adOrder) {
        [self requestDeliverDetail];
    }
}

- (void) updateDataSource:(NSArray *)products
{
    [self.dataSource removeAllObjects];    
    self.products = products;
    
    for (CartProduct *product in products) {
        if (self.adOrder && self.adOrder.outaftersale > 0) {
            product.outaftersale = YES;
        }
        product.showBarcode = YES;
        CartCellLayout *layout = [[CartCellLayout alloc] initWithModel:product checkable:NO remark:NO];
        [self.dataSource addObject:layout];
    }
    
    [self.tableView reloadData];
    
    [UIView animateWithDuration:.2f animations:^{
        self.footerView.alpha = 1.0f;
    }];
    
    /*
    if (self.orderModel && self.orderModel.status == 0) {
        [UIView animateWithDuration:.3f animations:^{
            [self.messageView show];
            self.tableView.top = self.messageView.bottom;
        }];
    }
     */
}

- (void) updateFooter
{
    if (self.orderModel) {
        self.amountLabel.text = FORMAT(@"结算金额：%@", [self.orderModel totalAmount]);
        [self.amountLabel sizeToFit];
        self.amountLabel.centerY = self.totalLabel.centerY;
        
        self.totalLabel.text = FORMAT(@"合计： %ld 件", (unsigned long)self.orderModel.shangpinjianshu);
        if (self.orderModel.jiesuanfangshishuzi > 0) {
            self.typeLabel.text = FORMAT(@"(%@)", self.orderModel.jiesuanfangshi);
        }
        if (self.orderModel.status == 0) {   // 未支付
            self.payButton.enabled = YES;
            self.payButton.alpha = 1.0f;
            self.amountLabel.right = self.payButton.left - kOFFSET_SIZE;
            self.rightButton.hidden = YES;
        }
        else {
            self.payButton.alpha = 0.0f;
            self.amountLabel.right = SCREEN_WIDTH - kOFFSET_SIZE;
            self.rightButton.hidden = YES;
        }
    }
    else if (self.adOrder) {
        if (self.adOrder.tuikuanjine > 0) {
            self.totalLabel.textColor = RED_COLOR;
            self.totalLabel.text = FORMAT(@"缺货：- %ld 件", (unsigned long)(self.adOrder.lacknum));
        }
        else {
            self.totalLabel.textColor = COLOR_TEXT_DARK;
            self.totalLabel.text = @"缺货：0 件";
        }
        if (self.adOrder.statu < 4) {
            self.amountLabel.text = FORMAT(@"待发件数： %ld 件", (unsigned long)[self.adOrder daifahuoNum]);
        }
        else {
            if (self.adOrder.substatu > 1 && self.adOrder.pnum > 0) {
                self.amountLabel.text = FORMAT(@"实发件数： %ld 件", (unsigned long)self.adOrder.pnum);
            }
            else {
                self.amountLabel.text = FORMAT(@"总件数： %ld 件", (unsigned long)self.adOrder.num);
            }
        }
        
        self.totalLabel.hidden = (self.adOrder.substatu <= 1);
    }
}

#pragma mark - Actions

- (IBAction) wuliuAction:(id)sender
{
    if (self.adOrder && self.adOrder.statu == 0) {
        // 修改地址
        AddressViewController *controller = [AddressViewController new];
        controller.adOrder = self.adOrder;
        @weakify(self)
        controller.finishBlock = ^{
            @strongify(self)
            [self requestUserAddress];
            [self refreshOrderDetail];
        };
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
    /*
    WuliuInfoController *controller = [WuliuInfoController new];
    if (self.orderModel) {
        controller.wuliugongsi = self.orderModel.wuliugongsi;
        controller.wuliuhao = self.orderModel.wuliuhao;
    }
    else if (self.adOrder) {
        controller.wuliugongsi = self.adOrder.wuliugongsi;
        controller.wuliuhao = self.adOrder.wuliuhao;
//        controller.wuliuhao = @"666363636336,3334768014593";
    }
     */
    LogisticsInfoController *controller = [LogisticsInfoController new];
    if (self.orderModel) {
        controller.deliverId = self.orderModel.wuliuhao;
        controller.wuliugongsi = self.orderModel.wuliugongsi;
        controller.order = self.orderModel;
    }
    else if (self.adOrder) {
        controller.deliverId = self.adOrder.wuliuhao;
        controller.wuliugongsi = self.adOrder.wuliugongsi;
        controller.adOrder = self.adOrder;
    }
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction) scanAction:(id)sender
{
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

- (IBAction) searchAction:(id)sender
{
    OrderSearchController *controller = [OrderSearchController new];
    if (self.orderModel) {
        controller.orderModel = self.orderModel;
    }
    if (self.adOrder) {
        controller.adOrder = self.adOrder;
    }
    controller.products = self.products;
    controller.finishedBlock = ^{
        [self refreshOrderDetail];
    };
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
//    [self presentViewController:navController animated:YES completion:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction) payAction:(id)sender
{
    PayViewController *payController = [PayViewController new];
    payController.order = self.orderModel;
    payController.orderIds = @[self.orderModel.orderid];
    payController.logistics = self.headerView.logistics;
    payController.finishBlock = ^{
        [self refreshOrderDetail];
    };
    [self.navigationController pushViewController:payController animated:YES];
//    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:payController];
//    [self.navigationController presentViewController:controller animated:YES completion:nil];
}

- (IBAction) rightButtonAction:(id)sender
{
    if (self.orderModel) {
        [self downloadFile];
        return;
    }
    
    MMPopupItemHandler block = ^(NSInteger index) {
        if (index == 0) {
            [self requestApplyDoc:self.adOrder];
        }
        else {
            [self downloadFile];
        }
    };
    
    NSArray *items =
    @[MMItemMake(@"更新对账单", MMItemTypeNormal, block),
      MMItemMake(@"下载对账单", MMItemTypeNormal, block)];
    
    MMSheetView *sheetView = [[MMSheetView alloc] initWithTitle:@"" items:items];
    [sheetView show];
}

- (void) downloadFile
{
    [SVProgressHUD showWithStatus:nil];
    NSString *url = nil;
    if (self.orderModel) {
        url = [self.orderModel.downloadurl urlEncodedString];
    }
    else if (self.adOrder) {
        url = [self.adOrder.downloadurl urlEncodedString];
    }
    
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/对账单.xls"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    [SCHttpServiceFace serviceWithDownloadURL:url
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

- (IBAction) cancelAction:(id)sender
{
    [self confirmWithTitle:@"确定取消订单 ?"
                     block:^{
        // 取消订单
        [self requestCancelOrder];
                         
    } canceled:nil];
}

#pragma mark - Request

- (void) requestOrderDetail
{
    RequestOrderDetail *request = [RequestOrderDetail new];
    request.orderid = self.orderModel.orderid;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [SVProgressHUD dismiss];
         [self.tableView.mj_header endRefreshing];
         
         ResponseOrderDetail *response = content;
         self.orderModel = response.order;
         self.headerView.logistics = response.logistics;
         if (response.order.status == 2) {
             if (![NSString isEmpty:response.logistics.wuliuhao]) {
                 self.headerView.wuliuInfo = FORMAT(@"%@\n单号：%@", response.logistics.wuliugongsi, response.logistics.wuliuhao);
             }
             [self.headerView updateLayout];
             self.orderModel.wuliugongsi = response.logistics.wuliugongsi;
             self.orderModel.wuliuhao = response.logistics.wuliuhao;
         }
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

- (void) requestDeliverDetail
{
    RequestDeliverDetail *request = [RequestDeliverDetail new];
    request.adorderid = self.adOrder.adorderid;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [SVProgressHUD dismiss];
         [self.tableView.mj_header endRefreshing];
         
         ResponseDeliverDetail *response = content;
         AdOrder *order = response.order;
         self.adOrder = order;
         [self updateDataSource:order.products];
         
     }
                                 onFailed:^(id content)
     {
         [self.tableView.mj_header endRefreshing];
         
         NSDictionary *msgData = content;
         NSNumber *codeObj = [msgData objectForKey:HTTP_KEY_CODE];
         NSInteger code = codeObj ? codeObj.integerValue : 0;
         if (code == ERR_DELIVER_INVALID) {
             [self.navigationController popViewControllerAnimated:YES];
             if (self.finishedBlock) {
                 self.finishedBlock();
             }
         }
     }
                                  onError:^(id content)
     {
         [self.tableView.mj_header endRefreshing];
     }];
}

- (void) requestUserAddress
{
    RequestAddrList *request = [RequestAddrList new];
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
     } onFailed:nil];
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
        popupView.finishBlock = ^{
            //
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

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        if (self.orderModel && self.orderModel.isvirtual) {
            return 0;
        }
        else if (self.adOrder && self.adOrder.isvirtual) {
            return 0;
        }
        return self.dataSource.count > 0 ? self.headerView.height : 0;
    }
    else if (section == 3 && self.dataSource.count > 0) {
        return _headerHeight;
    }
    return 0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return self.headerView;
    }
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _headerHeight)];
    header.backgroundColor = COLOR_BG_HEADER;
    
    if (self.orderModel) {
        self.pinpaiLabel.text = self.orderModel.pinpai;
        [self.logoView sd_setImageWithURL:[NSURL URLWithString:self.orderModel.pinpaiURL]];
    }
    else if (self.adOrder) {
        self.pinpaiLabel.text = self.adOrder.pinpai;
        [self.logoView sd_setImageWithURL:[NSURL URLWithString:self.adOrder.pinpaiURL]];
    }

    self.logoView.centerY = _headerHeight/2.0f;
    [header addSubview:self.logoView];
    
    [self.pinpaiLabel sizeToFit];
    self.pinpaiLabel.left = self.logoView.right + kOFFSET_SIZE*0.5;
    self.pinpaiLabel.centerY = self.logoView.centerY;
    [header addSubview:self.pinpaiLabel];
    
    [header addSubview:self.searchButton];
    
    if (self.adOrder && (self.adOrder.statu>=1 && self.adOrder.statu<=4)) {
        self.scanButton.right = self.searchButton.left;
        [header addSubview:self.scanButton];
    }

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _headerHeight-0.5f, SCREEN_WIDTH, 0.5f)];
    line.backgroundColor = COLOR_SEPERATOR_LINE;
    [header addSubview:line];
    return header;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        if (self.orderModel && self.orderModel.isvirtual) {
            return 0;
        }
        else if (self.adOrder && self.adOrder.isvirtual) {
            return 0;
        }
    }
    if (section == 3) {
        return 0;
    }
    CGFloat height = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
    return self.dataSource.count > 0 ? height : 0;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CGFloat height = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    footer.backgroundColor = CLEAR_COLOR;
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5f, SCREEN_WIDTH, 0.2f)];
//    line.backgroundColor = COLOR_SEPERATOR_LINE;
//    [footer addSubview:line];
    return footer;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.orderModel && self.orderModel.status == 0) {
            return 3;
        }
        else if (self.adOrder && self.adOrder.statu == 4) {
            return 3;
        }
        else if (self.adOrder && self.adOrder.expectdelivertime.length > 0) {
            return 3;
        }
        return 2;
    }
    else if (section == 1) {
        return 0;
    }
    else if (section == 2) {
        if (self.adOrder && self.dataSource.count > 0) {
            if (self.adOrder.tuikuanjine <= 0) {
                return 4;
            }
            return 5;
        }
        else if (self.orderModel && self.dataSource.count > 0) {
            return 3;
        }
        else {
            return 0;
        }
    }
    return self.dataSource.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        if (indexPath.row >= self.dataSource.count) {
            return 0;
        }
        CartCellLayout* layout = self.dataSource[indexPath.row];
        return layout.cellHeight;
    }
    return isPad ? kPadCellHeight : kTableCellHeight;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        TableCellBase *cell = [[TableCellBase alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.selectionDisabled = YES;
        cell.seperatorLine.backgroundColor = COLOR_SEPERATOR_LIGHT;
//        cell.seperatorLine.height = 0.2f;
        
        NSInteger timeIndex = 0;
        if (self.orderModel && self.orderModel.status == 0) {
            timeIndex = 1;
        }
        else if (self.adOrder && self.adOrder.statu == 4) {
            timeIndex = 1;
        }
        else if (self.adOrder && self.adOrder.expectdelivertime.length > 0) {
            timeIndex = 1;
        }
        
        if (indexPath.row == 0 && timeIndex > 0) {
            cell.textLabel.textColor = RED_COLOR;
            cell.detailTextLabel.textColor = RED_COLOR;
            
            if (self.orderModel && self.orderModel.status == 0) {
                cell.textLabel.text = @"订单支付剩余时间： ";
                self.timeView.liveTime = self.orderModel.overtimeshuzi;
                CGFloat height = isPad ? kPadCellHeight : kTableCellHeight;
                self.timeView.top = height * 0.5 - 10;
                self.timeView.left = SCREEN_WIDTH - kOFFSET_SIZE - 80;
                [cell.contentView addSubview:self.timeView];
            }
            else if (self.adOrder && self.adOrder.statu == 4) {
                
                NSTimeInterval delta = self.adOrder.aftersaletimenum - [NSDate timeIntervalValue];
                if (delta > 24*3600) {
                    cell.textLabel.text = @"售后截止时间： ";
                    cell.detailTextLabel.text = self.adOrder.aftersaletime;
                    self.timeView.hidden = YES;
                }
                else if (delta > 0) {
                    cell.textLabel.text = @"售后剩余时间： ";
                    cell.detailTextLabel.text = @"";
                
                    self.timeView.liveTime = self.adOrder.aftersaletimenum;
                    CGFloat height = isPad ? kPadCellHeight : kTableCellHeight;
                    self.timeView.top = height * 0.5 - 10;
                    self.timeView.left = SCREEN_WIDTH - kOFFSET_SIZE - 80;
                    [cell.contentView addSubview:self.timeView];
                }
                else {
                    cell.textLabel.text = @"售后已结束";
                    cell.detailTextLabel.text = @"";
                    self.timeView.hidden = YES;
                }
            }
            else if (self.adOrder && self.adOrder.expectdelivertime.length > 0) {
                cell.textLabel.text = @"预计发货时间： ";
                cell.detailTextLabel.text = self.adOrder.expectdelivertime;
                self.timeView.hidden = YES;
            }
        }
        else if (indexPath.row == timeIndex) {
            cell.detailTextLabel.width = SCREEN_WIDTH - cell.textLabel.width - kOFFSET_SIZE * 4;
            if (self.orderModel) {
                cell.textLabel.text = FORMAT(@"订单编号： %@", [self.orderModel displayOrderId]);
                cell.detailTextLabel.textColor = [self.orderModel statusColor];
                cell.detailTextLabel.text = [self.orderModel statusText];
            }
            else if (self.adOrder) {
                cell.textLabel.text = FORMAT(@"发货单号： %@", [self.adOrder odorderstr]);
                if (self.adOrder.statu == 0) {
                    cell.detailTextLabel.textColor = RED_COLOR;
                    cell.detailTextLabel.text = @"待发货";
                }
                else if (self.adOrder.statu < 4) {
                    cell.detailTextLabel.textColor = RED_COLOR;
                    cell.detailTextLabel.text = @"拣货中";
                }
                else if (self.adOrder.statu == 4) {
                    cell.detailTextLabel.textColor = [self.adOrder subTextColor];
                    cell.detailTextLabel.text = [self.adOrder subStatusText];
                }
            }
        }
        else if (indexPath.row == timeIndex + 1) {
            cell.showSeperator = NO;
            cell.textLabel.textColor = COLOR_TEXT_NORMAL;
            if (self.orderModel) {
                cell.textLabel.text = FORMAT(@"下单时间： %@", self.orderModel.dingdanshijian);
                if (self.orderModel.status == 0) {
                    CGFloat height = isPad ? kPadCellHeight : kTableCellHeight;
                    self.cancelButton.top = (height - self.cancelButton.height)/2.0f;
                    self.cancelButton.alpha = 1.0f;
                    [cell.contentView addSubview:self.cancelButton];
                }
            }
            else if (self.adOrder) {
                cell.textLabel.text = FORMAT(@"发货时间： %@", self.adOrder.optime);
                if (self.adOrder.statu < 4) {
                    cell.textLabel.text = FORMAT(@"下单时间： %@", self.adOrder.createtime);
                }
            }
        }
        return cell;
    }
    else if (indexPath.section == 2) {
        TableCellBase *cell = [[TableCellBase alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.selectionDisabled = YES;
        cell.seperatorLine.backgroundColor = COLOR_SEPERATOR_LIGHT;
//        cell.seperatorLine.height = 0.2f;
        if (indexPath.row == 0) {
            if (self.orderModel) {
                cell.textLabel.text = FORMAT(@"商品金额（ %ld件 ）", (long)self.orderModel.shangpinjianshu);
                cell.detailTextLabel.text = [NSString priceString:self.orderModel.shangpinjine];
            }
            else if (self.adOrder) {
                cell.textLabel.text = FORMAT(@"商品金额（ %ld件 ）", (long)self.adOrder.num);
                cell.detailTextLabel.text = [NSString priceString:self.adOrder.shangpinjine];
            }
        }
        else if (indexPath.row == 1) {
            cell.textLabel.text = @"优惠金额";
            if (self.orderModel) {
                cell.detailTextLabel.text = FORMAT(@"- %@", [NSString priceString:self.orderModel.dikoujine]);
            }
            else if (self.adOrder) {
                cell.detailTextLabel.text = FORMAT(@"- %@", [NSString priceString:self.adOrder.dikoujine]);
            }
        }
        else if (indexPath.row == 2) {
            cell.textLabel.text = @"运 费";
            if (self.orderModel) {
                cell.detailTextLabel.text = FORMAT(@"+ %@", [NSString priceString:self.orderModel.yunfei]);
                cell.showSeperator = NO;
            }
            else if (self.adOrder) {
                cell.detailTextLabel.text = FORMAT(@"+ %@", [NSString priceString:self.adOrder.yunfeijine]);
            }
        }
        else if (indexPath.row == 3) {
            cell.textLabel.text = @"订单金额（ 实付 ）";
            cell.detailTextLabel.text = [NSString priceString:self.adOrder.zongjine];
        }
        else if (indexPath.row == 4) {
            NSMutableString *text = [NSMutableString stringWithString:@"退款金额（ "];
            if (self.adOrder.lacknum > 0) {
                [text appendString:FORMAT(@"缺货-%ld件 ", (long)self.adOrder.lacknum)];
            }
            if (self.adOrder.cancelnum > 0) {
                [text appendString:FORMAT(@"取消-%ld件 ", (long)self.adOrder.cancelnum)];
            }
            [text appendString:@"）"];
            cell.textLabel.text = text;
            cell.textLabel.textColor = RED_COLOR;
            cell.detailTextLabel.text = FORMAT(@"- %@", [NSString priceString:self.adOrder.tuikuanjine]);
            cell.detailTextLabel.textColor = RED_COLOR;
        }
        return cell;
    }
    
    static NSString* cellIdentifier = @"cellIdentifier";
    OrderDetailTableCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[OrderDetailTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.row < self.dataSource.count) {
        CartCellLayout* layout = self.dataSource[indexPath.row];
        cell.cellLayout = layout;
    }
    
    cell.indexPath = indexPath;
    [self callbackWithCell:cell];

    return cell;
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

#pragma mark - Views
/*
- (TipMessageView *) messageView
{
    if (!_messageView) {
        NSString *msg = @"注意：请您在 24 小时内支付，超时系统会自动取消";
        _messageView = [[TipMessageView alloc] initWithFrame:CGRectZero message:msg];
        @weakify(self)
        _messageView.closeBlock = ^{
            @strongify(self)
            [UIView animateWithDuration:.3f animations:^{
                [self.messageView hide];
                [self.view layoutIfNeeded];
            }];
        };
    }
    return _messageView;
}
*/

- (OrderHeader *) headerView
{
    if (!_headerView) {
        _headerView = [[OrderHeader alloc] initWithFrame:CGRectZero];
        
        [_headerView.copyaButton addTarget:self action:@selector(wuliuAction:)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}

- (UIImageView *) logoView
{
    if (!_logoView) {
        UIImage *image = IMAGENAMED(@"logo");
        _logoView = [[UIImageView alloc] initWithImage:image];
        _logoView.frame = CGRectMake(kOFFSET_SIZE, 10, 16, 16);
        _logoView.contentMode = UIViewContentModeScaleAspectFit;
        
        _logoView.clipsToBounds = YES;
        _logoView.layer.cornerRadius = 3.0f;
    }
    return _logoView;
}

- (UILabel *) pinpaiLabel
{
    if (!_pinpaiLabel) {
        _pinpaiLabel  = [[UILabel alloc] init];
        _pinpaiLabel.backgroundColor = CLEAR_COLOR;
        _pinpaiLabel.left = kOFFSET_SIZE;
        _pinpaiLabel.textColor = COLOR_TEXT_DARK;
        _pinpaiLabel.font = FONT_PP_TITLE;
        _pinpaiLabel.text = @"Name";
        [_pinpaiLabel sizeToFit];
    }
    return _pinpaiLabel;
}

- (UILabel *) dateLabel
{
    if (!_dateLabel) {
        _dateLabel  = [[UILabel alloc] init];
        _dateLabel.backgroundColor = CLEAR_COLOR;
        _dateLabel.left = kOFFSET_SIZE;
        _dateLabel.textColor = COLOR_TEXT_NORMAL;
        _dateLabel.font = [FontUtils smallFont];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        _dateLabel.text = @"";
        [_dateLabel sizeToFit];
    }
    return _dateLabel;
}

- (UILabel *) totalLabel
{
    if (!_totalLabel) {
        _totalLabel  = [[UILabel alloc] init];
        _totalLabel.backgroundColor = CLEAR_COLOR;
        _totalLabel.textColor = COLOR_TEXT_DARK;
        _totalLabel.font = [FontUtils buttonFont];
        _totalLabel.text = @"合计： 0 件";
    }
    return _totalLabel;
}

- (UILabel *) typeLabel
{
    if (!_typeLabel) {
        _typeLabel  = [[UILabel alloc] init];
        _typeLabel.backgroundColor = CLEAR_COLOR;
        _typeLabel.textColor = RED_COLOR;
        _typeLabel.font = [FontUtils buttonFont];
        _typeLabel.text = @"";
    }
    return _typeLabel;
}

- (UILabel *) amountLabel
{
    if (!_amountLabel) {
        _amountLabel  = [[UILabel alloc] init];
        _amountLabel.backgroundColor = CLEAR_COLOR;
        _amountLabel.textColor = COLOR_TEXT_DARK;
        _amountLabel.font = [FontUtils buttonFont];
    }
    return _amountLabel;
}

- (UIButton *) payButton
{
    if (_payButton) {
        return _payButton;
    }
    _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _payButton.frame = CGRectMake(0, 11, 60, 28);
    _payButton.right = SCREEN_WIDTH - kOFFSET_SIZE;
    _payButton.backgroundColor = COLOR_SELECTED;
    _payButton.clipsToBounds = YES;
    _payButton.layer.cornerRadius = 3.0f;
    _payButton.titleLabel.font = [FontUtils smallFont];
    [_payButton setNormalTitle:@"去支付"];
    [_payButton setNormalColor:WHITE_COLOR highlighted:GRAY_COLOR selected:nil];
    
    [_payButton addTarget:self action:@selector(payAction:)
         forControlEvents:UIControlEventTouchUpInside];
    
    _payButton.alpha = 0.0f;
    
    return _payButton;
}

- (UIButton *) cancelButton
{
    if (_cancelButton) {
        return _cancelButton;
    }
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.frame = CGRectMake(0, 11, 70, 28);
    _cancelButton.right = SCREEN_WIDTH - kOFFSET_SIZE;
    _cancelButton.backgroundColor = CLEAR_COLOR;
    _cancelButton.clipsToBounds = YES;
    _cancelButton.layer.cornerRadius = 3.0f;
    _cancelButton.layer.borderWidth = 1.0f;
    _cancelButton.layer.borderColor = RED_COLOR.CGColor;
    _cancelButton.titleLabel.font = [FontUtils smallFont];
    [_cancelButton setNormalTitle:@"取消订单"];
    [_cancelButton setNormalColor:RED_COLOR highlighted:GRAY_COLOR selected:nil];
    
    [_cancelButton addTarget:self action:@selector(cancelAction:)
         forControlEvents:UIControlEventTouchUpInside];
    
    _cancelButton.alpha = 0.0f;
    
    return _cancelButton;
}

- (TextButton *) searchButton
{
    if (!_searchButton) {
        _searchButton = [TextButton buttonWithType:UIButtonTypeCustom];
        _searchButton.frame = CGRectMake(0, 0, kOFFSET_SIZE+30, _headerHeight);
        _searchButton.right = SCREEN_WIDTH;
        _searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kOFFSET_SIZE);
        
        [_searchButton setTitleFont:ICON_FONT(22)];
        [_searchButton setTitleAlignment:NSTextAlignmentRight];
        
        [_searchButton setTitle:kIconSearch forState:UIControlStateNormal];
        [_searchButton setNormalColor:COLOR_TEXT_DARK highlighted:COLOR_SELECTED selected:nil];
        
        [_searchButton addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchButton;
}

- (IconButton *) scanButton
{
    if (_scanButton) {
        return _scanButton;
    }
    
    _scanButton = [[IconButton alloc] initWithFrame:CGRectMake(0, 0, 80, _headerHeight)];
//    _scanButton.backgroundColor = RED_COLOR;
    _scanButton.spacing = 3.0f;
    [_scanButton setTextColor:COLOR_TEXT_DARK];
    [_scanButton setTitleFont:[FontUtils normalFont]];
    [_scanButton setTitle:@"扫码分拣" icon:nil];
    [_scanButton setImage:@"icon_scan"];
/*
    UIImage *image = [IMAGENAMED(@"icon_scan") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _scanButton.imageView.tintColor = COLOR_TEXT_DARK;
    [_scanButton setImage:image forState:UIControlStateNormal];
    */
    [_scanButton addTarget:self action:@selector(scanAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return _scanButton;
}

- (CountDownView *) timeView
{
    if (!_timeView) {
        _timeView = [[CountDownView alloc] initWithFrame:CGRectZero];
        @weakify(self)
        _timeView.timeoutBlock = ^{
            @strongify(self)
            self.orderModel.status = 5;
            self.payButton.enabled = NO;
            [self.tableView reloadData];
            [self updateFooter];
        };
    }
    return _timeView;
}

@end

@implementation OrderHeader

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.backgroundColor = WHITE_COLOR;
    
    self.width = SCREEN_WIDTH;
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.nameLabel];
    [self addSubview:self.mobileLabel];
    [self addSubview:self.addressLabel];
    [self addSubview:self.copyaButton];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(kOFFSET_SIZE, 0.0f, SCREEN_WIDTH-kOFFSET_SIZE, 0.5f)];
    _lineView.backgroundColor = COLOR_SEPERATOR_LIGHT;
    _lineView.hidden = YES;
    [self addSubview:_lineView];
    
    return self;
}

- (void) setWuliuInfo:(NSString *)wuliuInfo
{
    _wuliuInfo = wuliuInfo;
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:wuliuInfo];
    attributedText.yy_lineSpacing = 5.0f;
    attributedText.yy_font = [FontUtils normalFont];
    self.titleLabel.attributedText = attributedText;
    [self.titleLabel sizeToFit];
    
    self.copyaButton.hidden = NO;
    self.lineView.hidden = NO;
}

- (void) setLogistics:(Logistics *)logistics
{
    _logistics = logistics;
    
    self.nameLabel.text = logistics.shouhuoren;
    [self.nameLabel sizeToFit];
    
    self.mobileLabel.text = [logistics displayMobile];
    [self.mobileLabel sizeToFit];

    self.addressLabel.text = logistics.shouhuodizhi;
    [self.addressLabel sizeToFit];
    
    [self updateLayout];
}

- (void) setAddress:(NSString *)addr name:(NSString *)name mobile:(NSString *)mobile
{
    self.nameLabel.text = name;
    [self.nameLabel sizeToFit];
    
    self.mobileLabel.text = mobile;
    [self.mobileLabel sizeToFit];
    
    self.addressLabel.text = addr;
    [self.addressLabel sizeToFit];
    
    [self updateLayout];
}

- (IBAction) copyAction:(id)sender
{
/*
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.danhao;
    [SVProgressHUD showSuccessWithStatus:@"快递单号已复制"];
 */
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    [self updateLayout];
}

- (void) updateLayout
{
    CGFloat offset = isPad ? kOFFSET_SIZE_PAD*0.8 : kOFFSET_SIZE*0.8;
    CGFloat top = offset;
    
    self.copyaButton.right = SCREEN_WIDTH - kOFFSET_SIZE;
    self.copyaButton.top = top;
    
    if (self.wuliuInfo) {
        self.titleLabel.top = top;
        self.lineView.top = self.titleLabel.bottom + kOFFSET_SIZE*0.5;
        top = self.lineView.bottom + kOFFSET_SIZE*0.5;
        
        self.titleLabel.width = self.width - kOFFSET_SIZE*2 - 80;
    }
    
    self.nameLabel.top = top;
    self.mobileLabel.top = self.nameLabel.top;
    self.mobileLabel.left = self.nameLabel.right + kOFFSET_SIZE;
    
    self.addressLabel.top = self.nameLabel.bottom + kOFFSET_SIZE*0.5;
    self.addressLabel.width = SCREEN_WIDTH - kOFFSET_SIZE*2;
    
    self.height = self.addressLabel.bottom + offset;
}

- (UILabel *) nameLabel
{
    if (!_nameLabel) {
        _nameLabel  = [[UILabel alloc] init];
        _nameLabel.backgroundColor = CLEAR_COLOR;
        _nameLabel.left = kOFFSET_SIZE;
        _nameLabel.textColor = COLOR_TEXT_DARK;
        _nameLabel.font = [FontUtils normalFont];
        _nameLabel.text = @"";
    }
    return _nameLabel;
}

- (UILabel *) mobileLabel
{
    if (!_mobileLabel) {
        _mobileLabel  = [[UILabel alloc] init];
        _mobileLabel.backgroundColor = CLEAR_COLOR;
        _mobileLabel.textColor = COLOR_TEXT_DARK;
        _mobileLabel.font = [FontUtils normalFont];
    }
    return _mobileLabel;
}

- (UILabel *) addressLabel
{
    if (!_addressLabel) {
        _addressLabel  = [[UILabel alloc] init];
        _addressLabel.backgroundColor = CLEAR_COLOR;
        _addressLabel.left = kOFFSET_SIZE;
        _addressLabel.textColor = COLOR_TEXT_NORMAL;
        _addressLabel.font = [FontUtils smallFont];
        _addressLabel.text = @"";
        _addressLabel.numberOfLines = 0;
        [_addressLabel sizeToFit];
    }
    return _addressLabel;
}

- (UILabel *) titleLabel
{
    if (!_titleLabel) {
        _titleLabel  = [[UILabel alloc] init];
        _titleLabel.backgroundColor = CLEAR_COLOR;
        _titleLabel.left = kOFFSET_SIZE;
        _titleLabel.textColor = COLOR_TEXT_NORMAL;
        _titleLabel.font = [FontUtils normalFont];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UIButton *) copyaButton
{
    if (_copyaButton) {
        return _copyaButton;
    }
    _copyaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _copyaButton.frame = CGRectMake(0, 0, 70, 24);
    _copyaButton.right = SCREEN_WIDTH - kOFFSET_SIZE;
    _copyaButton.backgroundColor = CLEAR_COLOR;
    _copyaButton.clipsToBounds = YES;
    _copyaButton.layer.cornerRadius = 3.0f;
    _copyaButton.layer.borderWidth = 0.5f;
    _copyaButton.layer.borderColor = COLOR_TEXT_NORMAL.CGColor;
    _copyaButton.titleLabel.font = [FontUtils smallFont];
    [_copyaButton setNormalTitle:@"查看物流"];
    [_copyaButton setNormalColor:COLOR_TEXT_NORMAL highlighted:RED_COLOR selected:nil];
    
//    [_copyaButton addTarget:self action:@selector(copyAction:)
//           forControlEvents:UIControlEventTouchUpInside];
    
    _copyaButton.hidden = YES;
    
    return _copyaButton;
}

@end
