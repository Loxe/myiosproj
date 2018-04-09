//
//  ASaleListController.m
//  akucun
//
//  Created by Jarry on 2017/9/11.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ASaleListController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "MJRefresh.h"
#import "RequestAfterSaleList.h"
#import "ASaleServiceCell.h"
#import "ASaleDetailController.h"

@interface ASaleListController () <UITableViewDataSource,UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataSource;

@property (nonatomic, assign) NSInteger pageNo;

@end

@implementation ASaleListController

- (void) setupContent
{
    [super setupContent];
    self.view.backgroundColor = COLOR_BG_LIGHTGRAY;
    self.title = @"售后申请记录";
    
    [self.view addSubview:self.tableView];
    
    //
    @weakify(self)
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self refreshListData];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.textColor = LIGHTGRAY_COLOR;
    self.tableView.mj_header = refreshHeader;
    
    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        self.pageNo ++;
        [self requestASaleList:self.pageNo];
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
    
    if (!self.dataSource) {
        [SVProgressHUD showWithStatus:nil];
        self.pageNo = 1;
        [self requestASaleList:self.pageNo];
    }
    else {
        [self.tableView reloadData];
    }
}

- (void) refreshListData
{
    [SVProgressHUD showWithStatus:nil];
    self.dataSource = nil;
    [self.tableView.mj_footer resetNoMoreData];
    self.tableView.mj_footer.hidden = YES;
    [self.tableView reloadData];
    
    GCD_DELAY(^{
        self.pageNo = 1;
        [self requestASaleList:self.pageNo];
    }, 0.3f);
}

- (void) updateDataSource:(NSArray *)array
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    
    if (!self.dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    else if (self.pageNo == 1) {
        [self.dataSource removeAllObjects];
    }
    
    if (array.count == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView reloadData];
        return;
    }
    
    for (ASaleService *item in array) {
        ASaleCellLayout *layout = [[ASaleCellLayout alloc] initWithModel:item];
        [self.dataSource addObject:layout];
    }
    
    [self.tableView reloadData];
    self.tableView.mj_footer.hidden = (self.dataSource.count < 20);
    if (self.dataSource.count >= 20) {
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark - Request

- (void) requestASaleList:(NSInteger)pageNo
{
    RequestAfterSaleList *request = [RequestAfterSaleList new];
    request.pageno = pageNo;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
    {
        ResponseAfterSaleList *response = content;
        [self updateDataSource:response.result];
        
    } onFailed:^(id content) {
        [self.tableView.mj_header endRefreshing];
    } onError:^(id content) {
        [self.tableView.mj_header endRefreshing];
    }];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ASaleCellLayout* layout = self.dataSource[indexPath.row];
    return layout.cellHeight;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"cellIdentifier";
    ASaleServiceCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ASaleServiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.row < self.dataSource.count) {
        ASaleCellLayout* layout = self.dataSource[indexPath.row];
        cell.cellLayout = layout;
        
        [self callbackWithCell:cell];
    }
    
    return cell;
}

- (void) callbackWithCell:(ASaleServiceCell *)cell
{
//    @weakify(self)
//    cell.clickedPayCallback = ^(OrderTableCell* cell, OrderModel *model) {
//        @strongify(self)
//        [self requestOrderDetail:model];
//    };
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < self.dataSource.count) {
        ASaleCellLayout* layout = self.dataSource[indexPath.row];
        ASaleDetailController *controller = [[ASaleDetailController alloc] initWithService:layout.model];
        @weakify(self)
        controller.finishedBlock = ^{
            @strongify(self)
            [self refreshListData];
        };
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate

- (NSAttributedString *) titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无售后申请记录";
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

#pragma mark - Lazy Load

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

@end
