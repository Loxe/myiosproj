//
//  OSearchProductController.m
//  akucun
//
//  Created by Jarry Z on 2018/2/1.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "OSearchProductController.h"
#import "SearchBarLayout.h"
#import "AKScanViewController.h"
#import "RequestSearchProducts.h"
#import "RequestBarcodeSearch.h"
#import "CameraUtils.h"

@interface OSearchProductController () <UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIButton *scanButton;

@property (nonatomic, copy) NSString *searchText;

@end

@implementation OSearchProductController

- (void) setupContent
{
    [super setupContent];
    
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    flexBarButton.width = -12;
    self.navigationItem.leftBarButtonItems = @[flexBarButton, [[UIBarButtonItem alloc] initWithCustomView:self.scanButton]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    
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
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![NSString isEmpty:self.barcode]) {
        self.searchBar.text = self.barcode;
        [self searchBarcode:self.barcode];
        self.barcode = nil;
    }
}

#pragma mark - Actions

- (IBAction) rightButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
        
        [self searchBarcode:self.searchText];
    };
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - request

- (void) searchProductsBy:(NSString *)key
{
    if ([NSString isEmpty:self.liveId]) {
        [self alertWithTitle:@"请先选择活动品牌" detail:@"" block:^{
            [self rightButtonAction:nil];
        }];
        return;
    }
    
    [SVProgressHUD showWithStatus:nil];
    
    RequestSearchProducts *request =[RequestSearchProducts new];
    request.liveid = self.liveId;
    request.info = key;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
    {
        [SVProgressHUD dismiss];        
        ResponseUserProducts *response = content;
        [self updateDataSource:response.result];
        
    } onFailed:^(id content) {
        
    }];
}

- (void) searchBarcode:(NSString *)barcode
{
    [SVProgressHUD showWithStatus:nil];
    
    RequestBarcodeSearch *request = [RequestBarcodeSearch new];
    request.barcode = barcode;
    
    [SCHttpServiceFace serviceWithRequest:request onSuccess:^(id content)
     {
         [SVProgressHUD dismiss];
         ResponseBarcodeSearch *response = content;
         [self updateDataSource:response.result];
     } onFailed:nil];
    
}

#pragma mark -

- (void) configureCell:(OrderDetailTableCell *)cell
{
    cell.showStatus = self.showStatus;
}

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
        self.dataSource = [NSMutableArray array];
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
    
    [self searchProductsBy:self.searchText];
}

#pragma mark - Views

- (UISearchBar *) searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _searchBar.delegate = self;
        _searchBar.showsCancelButton = NO;
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.placeholder = @"备注/商品款号/序号 搜索";
        
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
