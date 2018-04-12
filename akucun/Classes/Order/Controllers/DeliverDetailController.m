//
//  DeliverDetailController.m
//  akucun
//
//  Created by Jarry Z on 2018/4/12.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "DeliverDetailController.h"
#import "MJRefresh.h"
#import "UIScrollView+EmptyDataSet.h"
#import <QuickLook/QuickLook.h>
#import "OrderDetailTableCell.h"

@interface DeliverDetailController () <UITableViewDataSource,UITableViewDelegate, QLPreviewControllerDataSource, QLPreviewControllerDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataSource;

@property (nonatomic, assign) NSInteger pageNo;


@end

@implementation DeliverDetailController

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
        //        [self refreshProductsList];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.textColor = LIGHTGRAY_COLOR;
    self.tableView.mj_header = refreshHeader;
    
    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        self.pageNo ++;
        //        [self requestProductsList:self.pageNo type:self.salesType];
    }];
    refreshFooter.stateLabel.textColor = COLOR_TEXT_LIGHT;
    [refreshFooter setTitle:@"正在加载数据中..." forState:MJRefreshStateRefreshing];
    [refreshFooter setTitle:@"已加载完毕" forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = refreshFooter;
    self.tableView.mj_footer.hidden = YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

//- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _headerHeight-0.5f, SCREEN_WIDTH, 0.5f)];
//    line.backgroundColor = COLOR_SEPERATOR_LINE;
//    return line;
//}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
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
    static NSString* cellIdentifier = @"OrderDetailTableCell";
    OrderDetailTableCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (indexPath.row < self.dataSource.count) {
        CartCellLayout* layout = self.dataSource[indexPath.row];
        cell.cellLayout = layout;
    }
    
    cell.indexPath = indexPath;
//    [self callbackWithCell:cell];
    
    return cell;
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
        
        [_tableView registerClass:[OrderDetailTableCell class]         forCellReuseIdentifier:@"OrderDetailTableCell"];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
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

@end
