//
//  OrderCheckViewController.m
//  akucun
//
//  Created by Jarry Z on 2018/1/22.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "OrderCheckViewController.h"
#import "OrderLivesController.h"
#import "RequestUserProducts.h"
#import "RequestDeliverApply.h"
#import <QuickLook/QuickLook.h>
#import "OSearchProductController.h"

@interface OrderCheckViewController () <QLPreviewControllerDataSource, QLPreviewControllerDelegate>

@property (nonatomic, strong) OrderLivesController *livesController;

@property (nonatomic, strong) UIView *toolBar;
@property (nonatomic, strong) UIButton *updateButton, *downloadButton;

@property (nonatomic, strong) LiveInfo *liveInfo;

@end

@implementation OrderCheckViewController

- (void) setupContent
{
    [super setupContent];
    
    self.title = @"客户对账";
    
    [self.rightButton setTitleFont:ICON_FONT(22)];
    [self.rightButton setNormalTitle:kIconSearch];
    self.rightButton.hidden = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    
    [self.view addSubview:self.toolBar];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.toolBar.mas_bottom);
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
    
    //
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
    
    self.rightButton.hidden = NO;

    if (liveInfo.checksheeturl && liveInfo.checksheeturl.length > 0) {
        [self.updateButton setNormalTitle:@"更新对账单"];
        self.downloadButton.enabled = YES;
    }
    else {
        [self.updateButton setNormalTitle:@"申请对账单"];
        self.downloadButton.enabled = NO;
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [UIView animateWithDuration:.2f animations:^{
//        self.livesController.view.top = 40;
//        self.livesController.view.alpha = 1.0f;
//    }];
}

- (void) rightButtonAction:(id)sender
{
    OSearchProductController *controller = [OSearchProductController new];
    controller.liveId = self.liveInfo.liveid;
    controller.showStatus = YES;
    [self.navigationController pushViewController:controller animated:YES];
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
        //
        if (![NSString isEmpty:response.checksheeturl]) {
            self.liveInfo.checksheeturl = response.checksheeturl;
            [self.updateButton setNormalTitle:@"更新对账单"];
            self.downloadButton.enabled = YES;
        }
        
    } onFailed:^(id content) {
        [self.tableView.mj_header endRefreshing];
    } onError:^(id content) {
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark -

- (IBAction) updateAction:(id)sender
{
    [SVProgressHUD showWithStatus:nil];
    
    RequestDeliverApply *request = [RequestDeliverApply new];
    request.liveid = self.liveInfo.liveid;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
    {
        [SVProgressHUD dismiss];
        
        NSString *detailText = @"对账单申请已提交，生成对账单过程可能需要几分钟时间，请稍候下载对账单查看";
        [self alertWithTitle:@"申请已提交" detail:detailText block:nil];
        
    } onFailed:^(id content) {
        
    }];
}

- (IBAction) downloadAction:(id)sender
{
    if (!self.liveInfo.checksheeturl || self.liveInfo.checksheeturl.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"对账单还未生成，请稍候再试"];
        return;
    }
    
    [self downloadFile:self.liveInfo.checksheeturl];
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

#pragma mark -

- (void) configureCell:(OrderDetailTableCell *)cell
{
    cell.showStatus = YES;
}

#pragma mark -

- (UIView *) toolBar
{
    if (!_toolBar) {
        _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, kOrderLivesTopHeight, SCREEN_WIDTH, kOrderLivesTopHeight)];
        
        [_toolBar addSubview:self.updateButton];
        [_toolBar addSubview:self.downloadButton];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kOrderLivesTopHeight-kPIXEL_WIDTH, SCREEN_WIDTH, kPIXEL_WIDTH)];
        line.backgroundColor = COLOR_SEPERATOR_LINE;
        [_toolBar addSubview:line];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.5f, 0, kPIXEL_WIDTH, kOrderLivesTopHeight)];
        line2.backgroundColor = COLOR_SEPERATOR_LINE;
        [_toolBar addSubview:line2];
    }
    return _toolBar;
}

- (UIButton *) updateButton
{
    if (!_updateButton) {
        _updateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        CGFloat height = kOrderLivesTopHeight;
        _updateButton.frame = CGRectMake(0, 0, SCREEN_WIDTH*0.5f, height);
        
        _updateButton.titleLabel.font = [FontUtils normalFont];
        
        [_updateButton setNormalColor:COLOR_TEXT_NORMAL highlighted:COLOR_SELECTED selected:nil];
        [_updateButton setNormalTitle:@"更新对账单"];
        
        [_updateButton addTarget:self action:@selector(updateAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _updateButton;
}

- (UIButton *) downloadButton
{
    if (!_downloadButton) {
        _downloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        CGFloat height = kOrderLivesTopHeight;
        _downloadButton.frame = CGRectMake(SCREEN_WIDTH*0.5f, 0, SCREEN_WIDTH*0.5f, height);
        
        _downloadButton.titleLabel.font = [FontUtils normalFont];
        
        [_downloadButton setNormalColor:COLOR_TEXT_NORMAL highlighted:COLOR_SELECTED selected:nil];
        [_downloadButton setNormalTitle:@"下载对账单"];
        [_downloadButton setNormalTitleColor:nil disableColor:COLOR_TEXT_LIGHT];
        
        [_downloadButton addTarget:self action:@selector(downloadAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downloadButton;
}

@end
