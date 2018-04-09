//
//  CartViewController.m
//  akucun
//
//  Created by Jarry on 2017/3/21.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "CartViewController.h"
#import "ECTabBarController.h"
#import "MainViewController.h"
#import "AddressViewController.h"
#import "AddrManageController.h"
#import "MMAlertView.h"
#import "Gallop.h"
#import "CartTableCell.h"
#import "RequestCartProducts.h"
#import "RequestOrderCreate.h"
#import "RequestProductRemark.h"
#import "RequestCancelBuy.h"
#import "RequestCartClear.h"
#import "RequestAddrList.h"
#import "IconButton.h"
#import "CommentView.h"
#import "MJRefresh.h"
#import "UserManager.h"
#import "AddressView.h"
#import "WeixinPopupView.h"
#import "PayViewController.h"
#import "MyOrderController.h"
#import "OrderDetailController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "TipMessageView.h"
#import "CartRecycleController.h"

#define kHeaderHeight   36.0f

@interface CartViewController () <UITableViewDataSource,UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic,strong) TipMessageView *messageView;

@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) NSMutableArray* dataSource;

//@property (nonatomic,strong) NSMutableArray* outOfStocks;

@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) AddressView *addressView;

@property (nonatomic,strong) NSArray* pinpaiCarts;
@property (nonatomic,strong) NSMutableArray* pinpaiButtons;

@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UIButton *buyButton;
//@property (nonatomic, strong) UIButton *clearButton;
@property (nonatomic, strong) UIButton *recycleButton;

//@property (nonatomic, strong) CommentView* commentView;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) CartProduct *selectProduct;

@property (nonatomic, assign) double jiesuanAmount;
@property (nonatomic, assign) NSInteger jiesuanCount;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, strong) NSMutableArray* products;

@property (nonatomic, assign) BOOL shouldRefresh;

@property (nonatomic, assign) NSInteger selectedAddr;

@end

@implementation CartViewController

- (void) setupContent
{
    [super setupContent];
    self.view.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    
    self.title = @"购物车";
    
    self.shouldRefresh = YES;
    
    [self ec_setTabTitle:@"购物车"];
    [self ec_setTabImage:@"icon_cart"];

    [self.messageView hide];
    [self.view addSubview:self.messageView];
    [self.view addSubview:self.tableView];

    _footerView = [[UIView alloc] init];
    _footerView.backgroundColor = COLOR_BG_HEADER;
    _footerView.frame = CGRectMake(0, self.view.height, SCREEN_WIDTH, isPad ? kFIELD_HEIGHT_PAD : 44);
    [self.view addSubview:_footerView];
    
    [_footerView addSubview:self.totalLabel];
    [_footerView addSubview:self.buyButton];
    
//    [self.view addSubview:self.commentView];

//    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view.mas_centerX);
//        make.bottom.equalTo(self.view.mas_bottom);
//        make.width.mas_equalTo(@(SCREEN_WIDTH));
//        make.height.mas_equalTo(@(50));
//    }];
    
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.footerView.mas_left).offset(kOFFSET_SIZE);
        make.centerY.equalTo(self.footerView.mas_centerY);
    }];
    [self.buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.footerView.mas_right);
        make.centerY.equalTo(self.footerView.mas_centerY);
        make.height.equalTo(self.footerView.mas_height);
        make.width.equalTo(@(100));
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.messageView.mas_bottom);
        make.bottom.equalTo(self.footerView.mas_top);
    }];
    
    //
    @weakify(self)
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self clearData];
        [SVProgressHUD showWithStatus:nil];
        [self requestCartPorducts];
        [self requestUserAddress];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.textColor = LIGHTGRAY_COLOR;
    self.tableView.mj_header = refreshHeader;
    
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAddProductToCart) name:NOTIFICATION_ADD_TO_CART object:nil];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) didAddProductToCart
{
    self.shouldRefresh = YES;
    [self clearData];
}

- (void) initViewData
{
//    _dataSource = [NSMutableArray array];
    _pinpaiButtons = [NSMutableArray array];
    _products = [NSMutableArray array];
    
    //
    UserInfo *userInfo = [UserManager instance].userInfo;
    self.addressView.address = userInfo.defaultAddr;
    self.addressView.top = self.headerLabel.bottom;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [((MainViewController *)self.ec_tabBarController) updateLeftButton:nil];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    if (self.shouldRefresh) {
        [SVProgressHUD showWithStatus:nil];
        [self clearData];
        [self requestCartPorducts];
    }
    else {
        [self requestCartPorducts];
//        [self.tableView reloadData];
//        [self updateAmount];
    }
    
    //
    UserInfo *userInfo = [UserManager instance].userInfo;
    NSArray *addrList = userInfo.addrList;
    if (self.selectedAddr >= addrList.count) {
        self.selectedAddr = 0;
    }
    if (self.selectedAddr == 0) {
        self.addressView.address = userInfo.defaultAddr;
    }
//    [self updateLayout];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
//    [self ec_setBadge:self.totalCount];
    
//    [UIView animateWithDuration:0.2f animations:^{
//        self.footerView.top = self.view.height;
//    }];
//    [self.dataSource removeAllObjects];
//    [self.tableView reloadData];
//    [self updateAmount];
}

- (void) updateLayout
{
    [self.addressView updateLayout];
}

- (void) clearData
{
    [self.dataSource removeAllObjects];
    self.dataSource = nil;
    [self.pinpaiButtons removeAllObjects];
    [self.products removeAllObjects];
    [self.tableView reloadData];
}

- (void) updateDataSource:(NSArray *)products
{
    self.pinpaiCarts = products;
    
    if (!self.dataSource) {
        self.dataSource = [NSMutableArray array];
    }

    [SVProgressHUD dismiss];
    
    [self.dataSource removeAllObjects];
    self.totalCount = 0;
    NSInteger i = 0;
    for (PinpaiCart *pinpai in products) {
        NSMutableArray *datas = [NSMutableArray array];
        for (CartProduct *item in pinpai.cartproducts) {
            CartCellLayout *layout = [[CartCellLayout alloc] initWithModel:item checkable:YES remark:YES];
//            layout.checked = [layout.cartProduct quehuo] ? NO : YES;
            layout.checked = YES;
            [datas addObject:layout];
            if (layout.checked) {
                self.totalCount ++;
            }
        }
        [self.dataSource addObject:datas];
        
        IconButton *button = [self headerButtonWithTitle:pinpai.pinpai];
        button.tag = i;
        [self.pinpaiButtons addObject:button];
        i ++;
    }
    
    //
    UserInfo *userInfo = [UserManager instance].userInfo;
    userInfo.normalproduct = self.totalCount;
    [self.ec_tabBarController updateBadge:userInfo.normalproduct atIndex:3 withStyle:WBadgeStyleNumber animationType:WBadgeAnimTypeBounce];

    [self.tableView reloadData];
    [self updateAmount];
    
    if (self.dataSource.count > 0 && !self.messageView.hidden && self.messageView.alpha == 0.0f) {
        [UIView animateWithDuration:.3f
                         animations:^
         {
             [self.messageView show];
             [self.tableView layoutIfNeeded];
         }];
    }
}

- (void) updateAmount
{
    double amount = 0.0f;
    NSInteger count = 0;
    [self.products removeAllObjects];
    self.totalCount = 0;
    for (NSArray *products in self.dataSource) {
        for (CartCellLayout *layout in products) {
            if (layout.checked) {
                [self.products addObject:layout.cartProduct.cartproductid];
                amount += layout.cartProduct.jiesuanjia/100.0f;
                count ++;
            }
            self.totalCount ++;
        }
    }
    
    self.jiesuanCount = count;
    self.jiesuanAmount = amount;
    
    self.totalLabel.text = FORMAT(@"合计： ¥ %.2f　(%ld 件)", amount, (long)count);
    if (amount > 0) {
        self.buyButton.enabled = YES;
        self.buyButton.backgroundColor = COLOR_SELECTED;
        
        [UIView animateWithDuration:0.2f animations:^{
            self.footerView.bottom = self.view.height;
        }];
    }
    else {
        [UIView animateWithDuration:0.2f animations:^{
            self.footerView.top = self.view.height;
        }];
        
        self.buyButton.enabled = NO;
        self.buyButton.backgroundColor = GRAY_COLOR;
    }
}

- (void) updateRowAtIndex:(NSIndexPath *)indexPath model:(CartProduct *)model
{
    NSArray *array = self.dataSource[indexPath.section-1];
    if (indexPath.row >= array.count) {
        return;
    }
    
    CartCellLayout *newLayout = [[CartCellLayout alloc] initWithModel:model checkable:YES remark:YES];
    newLayout.checked = YES;
    
    AKTableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell coverScreenshotAndDelayRemoved:self.tableView cellHeight:newLayout.cellHeight];
    
    [self.dataSource[indexPath.section-1] replaceObjectAtIndex:indexPath.row withObject:newLayout];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void) updateRowAtIndex:(NSIndexPath *)indexPath
{
    CartCellLayout *layout = self.dataSource[indexPath.section-1][indexPath.row];
    AKTableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell coverScreenshotAndDelayRemoved:self.tableView cellHeight:layout.cellHeight];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

// 有未支付订单 提示先支付
- (void) showPayErrorDialog:(NSString *)msg
{
    [self confirmWithTitle:@"有未支付订单" detail:msg btnText:@"支付" block:^{
        //
        MyOrderController *controller = [MyOrderController new];
        controller.orderType = 0;
        [self.navigationController pushViewController:controller animated:YES];
    } canceled:nil];
}

#pragma mark - Actions

- (IBAction) headerButtonAction:(id)sender
{
    IconButton *button = sender;
    NSInteger index = button.tag;

    BOOL checked = !button.selected;
    button.selected = checked;
    [button setImage:checked ? @"icon_check" : @"icon_uncheck"];
    
    NSArray *array = self.dataSource[index];
    NSMutableArray *indexs = [NSMutableArray array];
    NSInteger i = 0;
    for (CartCellLayout *layout in array) {
        if ([layout.cartProduct quehuo]) {
            layout.checked = NO;
        }
        else {
            layout.checked = checked;
        }
        [indexs addObject:[NSIndexPath indexPathForRow:i inSection:(index+1)]];
        i ++;
    }
    
    [self.tableView reloadRowsAtIndexPaths:indexs withRowAnimation:UITableViewRowAnimationNone];
    
    [self updateAmount];
}

- (IBAction) buyAction:(id)sender
{
    UserInfo *userInfo = [UserManager instance].userInfo;
    if (!userInfo.defaultAddr) {
        [SVProgressHUD showInfoWithStatus:@"请添加收货地址！"];
        return;
    }
    
    //
    MMPopupItemHandler block = ^(NSInteger index) {
        if (index == 1) {
            // Request
            [self requestCreateOrder];
            self.buyButton.enabled = NO;
        }
    };
    
    NSArray *items =
    @[MMItemMake(@"取消", MMItemTypeNormal, block),
      MMItemMake(@"去支付", MMItemTypeHighlight, block)];
    
    NSString *detail = FORMAT(@"\n一共 %ld 件   结算金额 %.2f 元\n\n", (long)self.jiesuanCount, self.jiesuanAmount);
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:detail];
    NSMutableAttributedString *msgAttrStr = [[NSMutableAttributedString alloc] initWithString:@"(单场活动最多可取消 5 件商品 ！)"];
    [msgAttrStr addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(15) range:NSMakeRange(0, msgAttrStr.length)];
    [msgAttrStr addAttribute:NSForegroundColorAttributeName value:COLOR_MAIN range:NSMakeRange(0, msgAttrStr.length)];
    [attrStr appendAttributedString:msgAttrStr];

    MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"立即去支付 ?" attrDetail:attrStr items:items];
    [alertView show];
//    [WeixinPopupView showWithCompeted:nil];
    
}

- (void) remarkAction:(CartProduct *)product
{
    MMAlertView *alertView =
    [[MMAlertView alloc] initWithInputTitle:@"添加备注\n"
                                     detail:@""
                                    content:product.remark
                                placeholder:@"请输入备注信息"
                                    handler:^(NSString *text)
     {
         [self requestRemark:text];
     }];
    [alertView show];
//    self.commentView.placeHolder = @"添加备注";
//    self.commentView.hidden = NO;
//    [self.commentView show];
}

- (void) editAddressAction
{
    UserInfo *userInfo = [UserManager instance].userInfo;
    AddressViewController *controller = [AddressViewController new];
    if (userInfo.defaultAddr) {
        controller.addr = userInfo.defaultAddr;
    }
    @weakify(self)
    controller.finishBlock = ^{
        @strongify(self)
        [self requestUserAddress];
    };
    [self.navigationController pushViewController:controller animated:YES];
    
    /*
    if (!userInfo.defaultAddr) {
        AddressViewController *controller = [AddressViewController new];
        @weakify(self)
        controller.finishBlock = ^{
            @strongify(self)
            UserInfo *userInfo = [UserManager instance].userInfo;
            self.addressView.address = userInfo.defaultAddr;
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
    
    AddrManageController *controller = [AddrManageController new];
    controller.selectIndex = self.selectedAddr;
    @weakify(self)
    controller.finishBlock = ^(id content) {
        @strongify(self)
        UserInfo *userInfo = [UserManager instance].userInfo;
        self.selectedAddr = [userInfo.addrList indexOfObject:content];
        self.addressView.address = content;
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:controller animated:YES];*/
}

- (void) deleteAction:(NSIndexPath *)indexPath
{
    //
    MMPopupItemHandler block = ^(NSInteger index) {
        if (index == 1) {
            // Request
            [self requestCancelBuy:indexPath];
        }
    };
    
    NSArray *items =
    @[MMItemMake(@"取消", MMItemTypeNormal, block),
      MMItemMake(@"确定", MMItemTypeHighlight, block)];
    
    MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"确定从购物车中移除商品 ?" detail:@"" items:items];
//    alertView.attachedView = self.view;
    [alertView show];
}

- (IBAction) recycleAction:(id)sender
{
    self.shouldRefresh = YES;
    CartRecycleController *controller = [CartRecycleController new];
    [self.navigationController pushViewController:controller animated:YES];
}
/*
- (IBAction) clearAction:(id)sender
{
    MMPopupItemHandler block = ^(NSInteger index) {
        if (index == 1) {
            // Request
            [self requestClearOutofStock];
        }
    };
    
    NSArray *items =
    @[MMItemMake(@"取消", MMItemTypeNormal, block),
      MMItemMake(@"确定", MMItemTypeHighlight, block)];
    
    MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"确定清空已失效商品 ?" detail:@"" items:items];
    [alertView show];
}
*/
#pragma mark - Request

- (void) requestCartPorducts
{
    RequestCartProducts *request = [RequestCartProducts new];
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [self.tableView.mj_header endRefreshing];
         ResponseCartProducts *response = content;
         [self updateDataSource:response.result];
         
         self.shouldRefresh = NO;
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

- (void) requestCreateOrder
{
    [SVProgressHUD showWithStatus:nil];
    
    UserInfo *userInfo = [UserManager instance].userInfo;
    Address *addr = [userInfo.addrList objectAtIndex:self.selectedAddr];
    
    RequestOrderCreate *request = [RequestOrderCreate new];
    request.products = self.products;
    request.addrid = addr.addrid;
    
    [SCHttpServiceFace serviceWithPostRequest:request
                                    onSuccess:^(id content)
    {
        [SVProgressHUD dismiss];
        
        ResponseOrderCreate *response = content;
        
        PayViewController *payController = [PayViewController new];
        payController.order = response.order;
        payController.orderIds = response.orderids;
        payController.address = addr;
        payController.showForward = YES;
        payController.finishBlock = ^{
            //
            OrderModel *order = response.result[0];
            order.status = 1;
            OrderDetailController *controller = [OrderDetailController new];
            controller.orderModel = order;
            [self.navigationController pushViewController:controller animated:YES];
        };
        [self.navigationController pushViewController:payController animated:YES];
//        UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:payController];
//        [self.navigationController presentViewController:controller animated:YES completion:nil];
        //
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FORWARD_HIDE object:nil];
        
        self.shouldRefresh = YES;
        [self.dataSource removeAllObjects];
        [self.tableView reloadData];
        [self updateAmount];
        
        //
//        UserInfo *userInfo = [UserManager instance].userInfo;
//        userInfo.normalproduct -= self.products.count;
//        [self.ec_tabBarController updateBadge:userInfo.normalproduct atIndex:2];
    }
                                     onFailed:^(id content)
    {
        [self updateAmount];
        
        NSDictionary *msgData = content;
        NSNumber *codeObj = [msgData objectForKey:HTTP_KEY_CODE];
        NSInteger code = codeObj ? codeObj.integerValue : 0;
        NSString *msg = [msgData objectForKey:HTTP_KEY_MSG];
        if (code == ERR_NOT_PAYED) {
            [SVProgressHUD dismiss];
            [self showPayErrorDialog:msg];
        }
        else {
            NSString *text = FORMAT(@"[E%ld]\n%@", (long)code, msg);
            [SVProgressHUD showErrorWithStatus:text];
        }
    } onError:^(id content) {
        self.buyButton.enabled = YES;
        self.buyButton.backgroundColor = COLOR_SELECTED;
    }];
}

- (void) requestRemark:(NSString *)remark
{
    [SVProgressHUD showWithStatus:nil];
    
    RequestProductRemark *request = [RequestProductRemark new];
    request.productId = self.selectProduct.cartproductid;
    request.remark = remark;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [SVProgressHUD showSuccessWithStatus:@"成功添加备注"];
         self.selectProduct.remark = remark;
         [self updateRowAtIndex:self.indexPath model:self.selectProduct];
     }
                                 onFailed:^(id content)
     {
         
     }];
}

- (void) requestCancelBuy:(NSIndexPath *)indexPath
{
    [SVProgressHUD showWithStatus:nil];
    
    NSInteger index = indexPath.section-1;
    
    CartCellLayout* layout = self.dataSource[index][indexPath.row];
    CartProduct *product = layout.cartProduct;

    RequestCancelBuy *request = [RequestCancelBuy new];
    request.productId = product.cartproductid;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [SVProgressHUD showSuccessWithStatus:@"已删除 !"];
         //
         NSMutableArray *array = [NSMutableArray arrayWithArray:self.dataSource[index]];
         if (indexPath.row < array.count) {
             [array removeObjectAtIndex:indexPath.row];
         }
         [self.dataSource replaceObjectAtIndex:index withObject:array];
         
         // Delete the row from the data source.
         [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
         
         if (array.count == 0) {
             [self.dataSource removeObjectAtIndex:index];
         }
         [self.tableView reloadData];
         [self updateAmount];
         
         //
         UserInfo *userInfo = [UserManager instance].userInfo;
         userInfo.normalproduct -= 1;
         [self.ec_tabBarController updateBadge:userInfo.normalproduct atIndex:3 withStyle:WBadgeStyleNumber animationType:WBadgeAnimTypeBounce];
     }
                                 onFailed:^(id content)
     {
         
     }];
}

- (void) requestUserAddress
{
    RequestAddrList *request = [RequestAddrList new];
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         UserInfo *userInfo = [UserManager instance].userInfo;
         if (userInfo.defaultAddr) {
             self.addressView.address = userInfo.defaultAddr;
         }
         [self.tableView reloadData];
     } onFailed:nil];
}
/*
- (void) requestClearOutofStock
{
    [SVProgressHUD showWithStatus:nil];
    
    NSMutableArray *cpids = [NSMutableArray array];
    for (CartCellLayout *layout in self.outOfStocks) {
        [cpids addObject:layout.cartProduct.cartproductid];
    }
    
    RequestCartClear *request = [RequestCartClear new];
    request.cpids = cpids;
    
    [SCHttpServiceFace serviceWithPostRequest:request
                                    onSuccess:^(id content)
     {
         [SVProgressHUD dismiss];
         [self.outOfStocks removeAllObjects];
         [self.tableView reloadData];

     } onFailed:nil];
}
*/
#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count + 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        CGFloat offset = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
        return self.addressView.bottom + offset;
    }
//    else if (section == self.dataSource.count + 1) {
//        return self.outOfStocks.count > 0 ? kHeaderHeight : 0;
//    }
    if (self.dataSource) {
        NSArray *array = self.dataSource[section-1];
        if (array.count > 0) {
            return kHeaderHeight;
        }
    }
    return 0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        CGFloat offset = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.addressView.bottom + offset)];
        header.backgroundColor = CLEAR_COLOR;
        
        UserInfo *userInfo = [UserManager instance].userInfo;
        self.headerLabel.text = FORMAT(@"代购编号： %@", userInfo.yonghubianhao);
        UIView *labelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        labelView.backgroundColor = WHITE_COLOR;
        [labelView addSubview:self.headerLabel];
        [header addSubview:labelView];
        
        self.recycleButton.centerY = labelView.centerY;
        [header addSubview:self.recycleButton];

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, labelView.bottom-kPIXEL_WIDTH, SCREEN_WIDTH, kPIXEL_WIDTH)];
        line.backgroundColor = COLOR_SEPERATOR_LIGHT;
        [header addSubview:line];
        
        [header addSubview:self.addressView];
        
        return header;
    }
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHeaderHeight)];
    
    if (section > 0 && section <= self.pinpaiButtons.count) {
        header.backgroundColor = COLOR_BG_HEADER;
        UIButton *button = self.pinpaiButtons[section-1];
        [header addSubview:button];
    }
/*    else {
        header.backgroundColor = CLEAR_COLOR;
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(kOFFSET_SIZE, 0, SCREEN_WIDTH*0.5f, kHeaderHeight);
        label.font = [FontUtils smallFont];
        label.textColor = COLOR_TEXT_LIGHT;
        label.text = @"已失效商品";
        [header addSubview:label];
        
        self.clearButton.centerY = label.centerY;
        [header addSubview:self.clearButton];
    }
    */
    return header;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
//    else if (section == self.dataSource.count + 1) {
//        return self.outOfStocks.count;
//    }
    NSArray *array = self.dataSource[section-1];
    return array.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == self.dataSource.count + 1) {
//        CartCellLayout* layout = self.outOfStocks[indexPath.row];
//        return layout.cellHeight;
//    }
    NSArray *datas = self.dataSource[indexPath.section-1];
    if (indexPath.row < datas.count) {
        CartCellLayout* layout = datas[indexPath.row];
        return layout.cellHeight;
    }
    return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"cellIdentifier";
    CartTableCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[CartTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
//    if (indexPath.section == self.dataSource.count + 1) {
//        CartCellLayout* layout = self.outOfStocks[indexPath.row];
//        cell.invalid = YES;
//        cell.cellLayout = layout;
//        cell.indexPath = indexPath;
//    }
//    else {
    
//    }
    
    NSArray *datas = self.dataSource[indexPath.section-1];
    if (indexPath.row < datas.count) {
        CartCellLayout* layout = datas[indexPath.row];
        cell.invalid = NO;
        cell.cellLayout = layout;
        cell.indexPath = indexPath;
        [self callbackWithCell:cell];
    }
    
    return cell;
}

- (void) callbackWithCell:(CartTableCell *)cell
{
    @weakify(self)
    cell.clickedRemarkCallback = ^(CartTableCell* cell, CartProduct *model) {
        @strongify(self)
        self.indexPath = cell.indexPath;
        self.selectProduct = model;
        [self remarkAction:model];
    };
    
    cell.clickedDeleteCallback = ^(CartTableCell* cell, CartProduct *model) {
        @strongify(self)
        [self deleteAction:cell.indexPath];
    };
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == self.dataSource.count + 1) {
        return;
    }
    
    NSArray *products = self.dataSource[indexPath.section-1];
    CartCellLayout* layout = products[indexPath.row];
    if ([layout.cartProduct quehuo]) {
        return;
    }
    
    layout.checked = !layout.checked;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    //
    [self updateAmount];
    //
    NSInteger checkedCount = 0;
    NSInteger count = products.count;
    for (CartCellLayout* layout in products) {
        if (layout.checked) {
            checkedCount ++;
        }
        if ([layout.cartProduct quehuo]) {
            count --;
        }
    }
    BOOL checked = (checkedCount == count);
    IconButton *button = self.pinpaiButtons[indexPath.section-1];
    button.selected = checked;
    [button setImage:checked ? @"icon_check" : @"icon_uncheck"];
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteAction:indexPath];
    }
}
// 修改编辑按钮文字
- (NSString *) tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

#pragma mark - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate

- (NSAttributedString *) titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"购物车为空";
    NSDictionary *attributes = @{NSFontAttributeName : [FontUtils normalFont],
                                 NSForegroundColorAttributeName : COLOR_TEXT_LIGHT };
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *) imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return IMAGENAMED(@"image_cart_null");
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
    return kTableCellHeight;
}

#pragma mark - UIScrollViewDelegate

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [self.commentView hide];
}

#pragma mark - Views

- (TipMessageView *) messageView
{
    if (!_messageView) {
        
        NSInteger viplevel    = [UserManager instance].userInfo.viplevel;
        VIPMemberTarget *target = [UserManager targetByLevel:viplevel];
        NSInteger timeout = target.cartTimeout;
        NSString *msg = FORMAT(@"提示：购物车里商品有效期%ld分钟，请在%ld分钟内支付，超时回收；回收详情请查看回收清单", (long)timeout, (long)timeout);

        _messageView = [[TipMessageView alloc] initWithFrame:CGRectZero message:msg];
        @weakify(self)
        _messageView.closeBlock = ^{
            @strongify(self)
            [UIView animateWithDuration:.3f animations:^{
                [self.messageView hide];
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                self.messageView.hidden = YES;
            }];
        };
    }
    return _messageView;
}

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
        
#ifdef XCODE9VERSION
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
        }
#endif
    }
    return _tableView;
}

- (IconButton *) headerButtonWithTitle:(NSString *)title
{
    IconButton *button = [[IconButton alloc] initWithFrame:CGRectMake(kOFFSET_SIZE, 0, SCREEN_WIDTH-kOFFSET_SIZE*2, kHeaderHeight)];
    button.spacing = kOFFSET_SIZE*0.5;
    [button setTitleFont:BOLDTNRFONTSIZE(15)];
    [button setTextColor:COLOR_TEXT_DARK];
    
    [button setNormalTitle:title];
    [button setImage:@"icon_check"];
    
    button.selected = YES;

    [button addTarget:self action:@selector(headerButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    return button;
}

- (UILabel *) totalLabel
{
    if (!_totalLabel) {
        _totalLabel  = [[UILabel alloc] init];
        _totalLabel.backgroundColor = CLEAR_COLOR;
        _totalLabel.textColor = COLOR_TEXT_DARK;
        _totalLabel.font = [FontUtils buttonFont];
        _totalLabel.text = @"合计： ¥0　(0 件)";
    }
    return _totalLabel;
}

- (UIButton *) buyButton
{
    if (!_buyButton) {
        _buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _buyButton.backgroundColor = GRAY_COLOR;
        
        _buyButton.titleLabel.font = [FontUtils buttonFont];
        
        [_buyButton setNormalColor:WHITE_COLOR highlighted:LIGHTGRAY_COLOR selected:nil];
        [_buyButton setTitleColor:COLOR_TEXT_LIGHT forState:UIControlStateDisabled];
        [_buyButton setNormalTitle:@"结 算"];
        
        [_buyButton addTarget:self action:@selector(buyAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _buyButton.enabled = NO;
    }
    return _buyButton;
}
/*
- (CommentView *) commentView
{
    if (_commentView) {
        return _commentView;
    }
    _commentView = [[CommentView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kEDIT_BAR_HEIGHT)];
    _commentView.offsetHeight = kBOTTOM_BAR_HEIGHT;
    _commentView.containerView = self.view;
    @weakify(self)
    _commentView.sendBlock = ^(id content1, id content2) {
        @strongify(self)
        [self requestRemark:content2];
    };
    _commentView.hidden = YES;
    return _commentView;
}
*/
- (UILabel *) headerLabel
{
    if (!_headerLabel) {
        _headerLabel  = [[UILabel alloc] init];
        _headerLabel.frame = CGRectMake(kOFFSET_SIZE, 0, SCREEN_WIDTH-kOFFSET_SIZE*2, 44);
        _headerLabel.backgroundColor = CLEAR_COLOR;
        _headerLabel.left = kOFFSET_SIZE;
        _headerLabel.textColor = COLOR_TEXT_NORMAL;
        _headerLabel.font = [FontUtils normalFont];
        _headerLabel.text = @"代购编号：";
    }
    return _headerLabel;
}

- (AddressView *) addressView
{
    if (!_addressView) {
        _addressView  = [[AddressView alloc] initWithFrame:CGRectZero];
        _addressView.backgroundColor = WHITE_COLOR;
        @weakify(self)
        _addressView.actionBlock = ^ {
            @strongify(self)
            [self editAddressAction];
        };
    }
    return _addressView;
}

- (UIButton *) recycleButton
{
    if (_recycleButton) {
        return _recycleButton;
    }
    _recycleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _recycleButton.frame = CGRectMake(0, 0, 70, 24);
    _recycleButton.right = SCREEN_WIDTH - kOFFSET_SIZE;
    _recycleButton.backgroundColor = CLEAR_COLOR;
    _recycleButton.clipsToBounds = YES;
    _recycleButton.layer.cornerRadius = 3.0f;
    _recycleButton.layer.borderWidth = 0.5f;
    _recycleButton.layer.borderColor = COLOR_TEXT_NORMAL.CGColor;
    _recycleButton.titleLabel.font = [FontUtils smallFont];
    [_recycleButton setNormalTitle:@"回收清单"];
    [_recycleButton setNormalColor:RED_COLOR highlighted:COLOR_TEXT_NORMAL selected:nil];
    
    [_recycleButton addTarget:self action:@selector(recycleAction:)
               forControlEvents:UIControlEventTouchUpInside];
    
    return _recycleButton;
}

/*
- (UIButton *) clearButton
{
    if (!_clearButton) {
        _clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _clearButton.frame = CGRectMake(0, 0, 40, 24);
        _clearButton.right = SCREEN_WIDTH - kOFFSET_SIZE;
        _clearButton.backgroundColor = CLEAR_COLOR;
        _clearButton.clipsToBounds = YES;
        _clearButton.layer.cornerRadius = 3.0f;
        _clearButton.titleLabel.font = [FontUtils smallFont];
        [_clearButton setNormalTitle:@"清空"];
        [_clearButton setNormalColor:RED_COLOR highlighted:GRAY_COLOR selected:nil];
        
        [_clearButton addTarget:self action:@selector(clearAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearButton;
}
*/
@end
