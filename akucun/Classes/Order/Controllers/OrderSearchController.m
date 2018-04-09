//
//  OrderSearchController.m
//  akucun
//
//  Created by Jarry on 2017/6/24.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "OrderSearchController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "CameraUtils.h"
#import "OrderDetailTableCell.h"
#import "ProductsManager.h"
#import "SCActionSheet.h"
#import "MMAlertView.h"
#import "AKScanViewController.h"
#import "AdOrderManager.h"
#import "SearchBarLayout.h"

@interface OrderSearchController () <UISearchBarDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIButton *scanButton;

@property (nonatomic, strong) NSArray* productsSource;

@property (nonatomic, copy) NSString *searchText;

@end

@implementation OrderSearchController

- (void) setupContent
{
    [super setupContent];
    
//    self.navigationItem.leftBarButtonItem = nil;
//    [self.navigationItem setHidesBackButton:YES];
    
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    flexBarButton.width = -12;
    self.navigationItem.leftBarButtonItems = @[flexBarButton, [[UIBarButtonItem alloc] initWithCustomView:self.scanButton]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    
#ifdef XCODE9VERSION
    if (@available(iOS 11.0, *)) {
        SearchBarLayout *container = [[SearchBarLayout alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
        [container addSubview:self.searchBar];
        //
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.searchBar.topAnchor constraintEqualToAnchor:container.topAnchor], // 顶部约束
                                                  [self.searchBar.leftAnchor constraintEqualToAnchor:container.leftAnchor constant:0], // 左边距约束
                                                  [self.searchBar.rightAnchor constraintEqualToAnchor:container.rightAnchor constant:0], // 右边距约束
                                                  [self.searchBar.bottomAnchor constraintEqualToAnchor:container.bottomAnchor], // 底部约束
                                                  [self.searchBar.centerXAnchor constraintEqualToAnchor:container.centerXAnchor constant:0], // 横向中心约束
                                                  ]];
        self.navigationItem.titleView = container;  // 顶部导航搜索
    }
    else {
        self.navigationItem.titleView = self.searchBar;  // 顶部导航搜索
    }
#else
    self.navigationItem.titleView = self.searchBar;
#endif
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self.view addSubview:self.tableView];

//    self.dataSource = [NSMutableArray array];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    
//    [self.searchBar becomeFirstResponder];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.searchBar endEditing:YES];
}

- (void) setProducts:(NSArray *)products
{
    _products = products;
    
    NSMutableArray *array = [NSMutableArray array];
    for (CartProduct *product in products) {
        product.showBarcode = YES;
        CartCellLayout *layout = [[CartCellLayout alloc] initWithModel:product checkable:NO remark:NO];
        [array addObject:layout];
    }
    self.productsSource = [NSArray arrayWithArray:array];
    self.dataSource = array;
    [self.tableView reloadData];
}

- (NSArray *) searchProducts:(NSString *)key
{
    NSMutableArray *array = [NSMutableArray array];
    for (CartProduct *product in self.products) {
        product.showBarcode = YES;
        NSRange range = [product.desc rangeOfString:key];
        if (range.length > 0) {
            CartCellLayout *layout = [[CartCellLayout alloc] initWithModel:product checkable:NO remark:NO];
            [array addObject:layout];
            continue;
        }
        range = [product.remark rangeOfString:key];
        if (range.length > 0) {
            CartCellLayout *layout = [[CartCellLayout alloc] initWithModel:product checkable:NO remark:NO];
            [array addObject:layout];
            continue;
        }
    }
    return array;
}

- (NSArray *) searchProductBarcode:(NSString *)barcode
{
    if (self.adOrder && self.adOrder.statu == 4) {
        NSArray *products = [[AdOrderManager instance] productsByBarcode:barcode order:self.adOrder.adorderid];
        NSMutableArray *array = [NSMutableArray array];
        for (AdProductDB *p in products) {
            CartProduct *product = [p productModel];
            product.showBarcode = YES;
            CartCellLayout *layout = [[CartCellLayout alloc] initWithModel:product checkable:NO remark:NO];
            [array addObject:layout];
        }
        return array;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    for (CartProduct *product in self.products) {
        if ([product.sku.barcode isEqualToString:barcode]) {
            CartCellLayout *layout = [[CartCellLayout alloc] initWithModel:product checkable:NO remark:NO];
            [array addObject:layout];
            continue;
        }
    }
    return array;
}

#pragma mark - Actions

- (IBAction) rightButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
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
    AKScanViewController *vc = [[AKScanViewController alloc] init];
    vc.title    = @"扫码搜索";
    vc.scanningType = AKScanningTypeBarCode;
    
    @weakify(self)
    vc.scanResultBlock = ^(NSString *codeString) {
        @strongify(self)
        INFOLOG(@"扫描结果: %@", codeString);

        [self.dataSource removeAllObjects];
        [self.tableView reloadData];
        
        self.searchBar.text = codeString;
        self.searchText = codeString;
        
        GCD_DEFAULT(^{
            NSArray *array = [self searchProductBarcode:codeString];
            GCD_MAIN(^{
                if (array.count == 0) {
                    [SVProgressHUD showInfoWithStatus:@"未找到相关商品!"];
                }
                else {
                    [SVProgressHUD dismiss];
                    [self.dataSource addObjectsFromArray:array];
                }
                [self.tableView reloadData];
            });
        });
    };
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Request

#pragma mark - UISearchBarDelegate

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    //    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void) searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    //    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([self.searchText isEqualToString:searchText]) {
        return;
    }
    
    if (searchText.length == 0) {
        self.dataSource = [NSMutableArray arrayWithArray:self.productsSource];
        [self.tableView reloadData];
    }
    else if (self.dataSource && self.dataSource.count > 0) {
        [self.dataSource removeAllObjects];
        [self.tableView reloadData];
    }
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [SVProgressHUD showWithStatus:nil];
    [searchBar endEditing:YES];
    [self.dataSource removeAllObjects];
    [self.tableView reloadData];
    
    self.searchText = searchBar.text;
    
    GCD_DEFAULT(^{
        NSArray *array = [self searchProducts:self.searchText];
        GCD_MAIN(^{
            if (array.count == 0) {
                [SVProgressHUD showInfoWithStatus:@"未找到相关商品!"];
            }
            else {
                [SVProgressHUD dismiss];
                [self.dataSource addObjectsFromArray:array];
            }
            [self.tableView reloadData];
        });
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

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
    
    CartCellLayout* layout = self.dataSource[indexPath.row];
    cell.cellLayout = layout;
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

#pragma mark - Views

- (UISearchBar *) searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _searchBar.delegate = self;
        _searchBar.showsCancelButton = NO;
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.placeholder = @"商品款号/序号/备注 筛选";
        
        // 修改placeholder字体的颜色和大小
        UITextField * searchField = [_searchBar valueForKey:@"_searchField"];
        if (searchField) {
            [searchField setValue:[FontUtils normalFont] forKeyPath:@"_placeholderLabel.font"];
        }
    }
    return _searchBar;
}

- (UIButton *) scanButton
{
    if (_scanButton) {
        return _scanButton;
    }
    
    _scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _scanButton.frame = CGRectMake(0, 0, 40, 40);
    
    UIImage *image = [IMAGENAMED(@"icon_scan") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _scanButton.imageView.tintColor = COLOR_APP_GREEN;
    [_scanButton setImage:image forState:UIControlStateNormal];
    
    [_scanButton addTarget:self action:@selector(scanAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return _scanButton;
}

@end
