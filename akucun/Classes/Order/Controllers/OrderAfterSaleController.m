//
//  OrderAfterSaleController.m
//  akucun
//
//  Created by Jarry Z on 2018/1/22.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "OrderAfterSaleController.h"
#import "OrderLivesController.h"
#import "OSearchProductController.h"
#import "AKScanViewController.h"
#import "TextButton.h"
#import "RequestUserProducts.h"
#import "CameraUtils.h"

@interface OrderAfterSaleController ()

@property (nonatomic, strong) TextButton *scanButton;

@property (nonatomic, strong) OrderLivesController *livesController;

@property (nonatomic, strong) LiveInfo *liveInfo;

@end

@implementation OrderAfterSaleController

- (void) setupContent
{
    [super setupContent];
    
    self.title = @"申请售后";
    
    self.rightButton.width = 30;
    [self.rightButton setTitleFont:ICON_FONT(22)];
    [self.rightButton setNormalTitle:kIconSearch];
//    self.rightButton.hidden = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.scanButton];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(kOrderLivesTopHeight);
    }];
    //
    @weakify(self)
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self.tableView.mj_footer resetNoMoreData];
        self.tableView.mj_footer.hidden = YES;
        
        self.pageNo = 1;
        [self requestProducts:self.liveInfo];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.textColor = LIGHTGRAY_COLOR;
    self.tableView.mj_header = refreshHeader;
    
    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        self.pageNo ++;
        [self requestProducts:self.liveInfo];
    }];
    refreshFooter.stateLabel.textColor = COLOR_TEXT_LIGHT;
    [refreshFooter setTitle:@"正在加载数据中..." forState:MJRefreshStateRefreshing];
    [refreshFooter setTitle:@"已加载完毕" forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = refreshFooter;
    self.tableView.mj_footer.hidden = YES;
    
    self.livesController = [OrderLivesController new];
    self.livesController.view.frame = self.view.bounds;
    self.livesController.viewHeight = self.view.height;
    [self.view addSubview:self.livesController.view];
    [self addChildViewController:self.livesController];
    
    self.livesController.selectBlock = ^(id content) {
        @strongify(self)
        [self.tableView.mj_footer resetNoMoreData];
        self.tableView.mj_footer.hidden = YES;
        [self.dataSource removeAllObjects];
        self.dataSource = nil;
        [self.tableView reloadData];
        
        self.liveInfo = content;
        [self.tableView.mj_header beginRefreshing];
    };
}

- (void) setLiveInfo:(LiveInfo *)liveInfo
{
    _liveInfo = liveInfo;
    
    self.navigationItem.rightBarButtonItems = @[ [[UIBarButtonItem alloc] initWithCustomView:self.rightButton], [[UIBarButtonItem alloc] initWithCustomView:self.scanButton] ];
}

- (void) refreshData
{
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - Actions

- (void) rightButtonAction:(id)sender
{
    OSearchProductController *controller = [OSearchProductController new];
    controller.liveId = self.liveInfo.liveid;
    controller.showStatus = YES;
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
    AKScanViewController *vc = [[AKScanViewController alloc] init];
    vc.title    = @"扫码搜索";
    vc.scanningType = AKScanningTypeBarCode;
    
    @weakify(self)
    vc.scanResultBlock = ^(NSString *codeString) {
        @strongify(self)
        INFOLOG(@"扫描结果: %@", codeString);
        
        OSearchProductController *controller = [OSearchProductController new];
        controller.liveId = self.liveInfo ? self.liveInfo.liveid : @"";
        controller.showStatus = YES;
        controller.barcode = codeString;
        [self.navigationController pushViewController:controller animated:YES];
    };
    
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark -

- (void) requestProducts:(LiveInfo *)liveInfo
{
    [SVProgressHUD showWithStatus:nil];
    RequestUserProducts *request = [RequestUserProducts new];
    request.liveid = liveInfo.liveid;
    request.pageno = self.pageNo;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [SVProgressHUD dismiss];
         [self.tableView.mj_header endRefreshing];
         
         ResponseUserProducts *response = content;
         [self updateDataSource:response.result];
         
     } onFailed:^(id content) {
         [self.tableView.mj_header endRefreshing];
     } onError:^(id content) {
         [self.tableView.mj_header endRefreshing];
     }];
}

#pragma mark - Views

- (TextButton *) scanButton
{
    if (_scanButton) {
        return _scanButton;
    }
    
    _scanButton = [TextButton buttonWithType:UIButtonTypeCustom];
    _scanButton.frame = CGRectMake(0, 0, 40, 44);
    _scanButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    _scanButton.imageSize = 20;
    
    _scanButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_scanButton setNormalImage:@"icon_scan" selectedImage:nil];
    
    [_scanButton addTarget:self action:@selector(scanAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return _scanButton;
}

@end
