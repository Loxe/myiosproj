//
//  DeliverLivesController.m
//  akucun
//
//  Created by Jarry Z on 2018/4/12.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "DeliverLivesController.h"
#import "MJRefresh.h"
#import "UIScrollView+EmptyDataSet.h"
#import <QuickLook/QuickLook.h>
#import "DeliverLiveTableCell.h"
#import "RequestDeliverLives.h"

@interface DeliverLivesController () <UITableViewDataSource,UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, QLPreviewControllerDataSource, QLPreviewControllerDelegate>

@property (nonatomic, strong) UIButton *filterButton;

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataSource;

@property (nonatomic, assign) NSInteger pageNo;

@end

@implementation DeliverLivesController

- (void) setupContent
{
    [super setupContent];
    self.view.backgroundColor = COLOR_BG_LIGHTGRAY;
    
    [self.view addSubview:self.tableView];
    
    //
    @weakify(self)
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self.tableView.mj_footer resetNoMoreData];
        self.tableView.mj_footer.hidden = YES;
        self.pageNo = 1;
        [self requestDeliverLives];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.textColor = LIGHTGRAY_COLOR;
    self.tableView.mj_header = refreshHeader;
    
    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        self.pageNo ++;
        [self requestDeliverLives];
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
}

- (void) updateData
{
    if (!self.dataSource || self.dataSource.count == 0) {
        [SVProgressHUD showWithStatus:nil];
        self.pageNo = 1;
        [self requestDeliverLives];
    }
    else {
        [self.tableView setContentOffset:CGPointMake(0,0) animated:YES];
    }
}

- (void) updateDataSource:(NSArray *)result
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    
    if (!self.dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    else if (self.pageNo == 1) {
        [self.dataSource removeAllObjects];
    }
    
    if (result.count == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView reloadData];
        return;
    }
    
    [self.dataSource addObjectsFromArray:result];
    
    [self.tableView reloadData];
    self.tableView.mj_footer.hidden = (self.dataSource.count < 20);
    if (self.dataSource.count >= 20) {
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark - Action

- (IBAction) filterAction:(id)sender
{
    
}

#pragma mark - Request

- (void) requestDeliverLives
{
    RequestDeliverLives *request = [RequestDeliverLives new];
    request.pageno = self.pageNo;
    request.type = self.type;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
    {
        ResponseDeliverLives *response = content;
        [self updateDataSource:response.result];
        
    } onFailed:^(id content) {
        [self.tableView.mj_header endRefreshing];
    } onError:^(id content) {
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - UITableViewDataSource

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.dataSource && self.dataSource.count > 0) {
        return 56;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 56)];
    header.backgroundColor = COLOR_BG_LIGHTGRAY;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 36)];
    contentView.backgroundColor = WHITE_COLOR;
    [header addSubview:contentView];

    UILabel *textLabel = [UILabel new];
    textLabel.font = SYSTEMFONT(14);
    textLabel.textColor = COLOR_MAIN;
    if (self.type == 1) {
        textLabel.text = @"拣货中活动列表";
    }
    else {
        textLabel.text = @"已发货活动列表";
    }
    [textLabel sizeToFit];
    textLabel.centerY = 18;
    textLabel.left = kOFFSET_SIZE;
    [contentView addSubview:textLabel];
    
    self.filterButton.right = SCREEN_WIDTH - kOFFSET_SIZE;
    self.filterButton.centerY = textLabel.centerY;
    [contentView addSubview:self.filterButton];

    return header;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeliverLiveTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeliverLiveTableCell" forIndexPath:indexPath];
    
    LiveInfo *item = self.dataSource[indexPath.row];
    cell.type = self.type;
    cell.liveInfo = item;
    
    return cell;
}

#pragma mark - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate

- (NSAttributedString *) titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无相关活动订单";
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
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = CLEAR_COLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
        
        [_tableView registerClass:[DeliverLiveTableCell class]         forCellReuseIdentifier:@"DeliverLiveTableCell"];
        
        CGFloat offset = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
        _tableView.rowHeight = 90 + offset*2;

        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kSafeAreaBottomHeight)];
        _tableView.tableFooterView = footer;
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
        }
    }
    return _tableView;
}

- (UIButton *) filterButton
{
    if (_filterButton == nil) {
        _filterButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 24)];
        _filterButton.backgroundColor = COLOR_MAIN;
        _filterButton.layer.masksToBounds = NO;
        _filterButton.layer.cornerRadius = 3.0f;
        
        _filterButton.titleLabel.font = BOLDSYSTEMFONT(13);
        [_filterButton setNormalColor:WHITE_COLOR highlighted:COLOR_TEXT_LIGHT selected:nil];
        
        [_filterButton setNormalTitle:@"筛选"];
        [_filterButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
        [_filterButton setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
        [_filterButton setNormalImage:@"icon_arrow_down_w" selectedImage:nil];
        
        [_filterButton addTarget:self action:@selector(filterAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _filterButton;
}

@end
