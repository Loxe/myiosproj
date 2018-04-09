//
//  AfterSalesController.m
//  akucun
//
//  Created by Jarry on 2017/6/29.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "AfterSalesController.h"
#import "ASaleListController.h"
#import "MJRefresh.h"
#import "UIScrollView+EmptyDataSet.h"
#import "TopBarView.h"
#import "OrderDetailTableCell.h"
#import "RequestAfterSales.h"
#import "RequestProductRemark.h"
#import "MMAlertView.h"
#import "ASaleDetailController.h"

@interface AfterSalesController () <UITableViewDataSource,UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) TopBarView* topBarView;

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataSource;

@property (nonatomic, assign) NSInteger pageNo;

@end

@implementation AfterSalesController

- (void) setupContent
{
    [super setupContent];
    self.view.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    
    self.title = @"退款/售后";
    
    self.rightButton.width = 80.0f;
    [self.rightButton setNormalTitle:@"售后记录"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    
    [self.view addSubview:self.topBarView];
    [self.view addSubview:self.tableView];
    
    //
    @weakify(self)
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self refreshProductsList];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.textColor = LIGHTGRAY_COLOR;
    self.tableView.mj_header = refreshHeader;
    
    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        self.pageNo ++;
        [self requestProductsList:self.pageNo type:self.salesType];
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
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];

    self.topBarView.selectedIndex = self.salesType + 1;
}

- (IBAction) rightButtonAction:(id)sender
{
    ASaleListController *controller = [ASaleListController new];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) refreshProductsList
{
    [SVProgressHUD showWithStatus:nil];
    self.dataSource = nil;
    [self.tableView reloadData];
    
    GCD_DELAY(^{
        self.pageNo = 1;
        [self requestProductsList:self.pageNo type:self.salesType];
    }, 0.3f);
}

- (void) updateDataSource:(NSArray *)products
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    
    if (!self.dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    else if (self.pageNo == 1) {
        [self.dataSource removeAllObjects];
    }
    
    if (products.count == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView reloadData];
        return;
    }
    
    for (CartProduct *product in products) {
        CartCellLayout *layout = [[CartCellLayout alloc] initWithModel:product checkable:NO remark:NO];
        [self.dataSource addObject:layout];
    }
    
    [self.tableView reloadData];
}

- (void) updateRowAtIndex:(NSIndexPath *)indexPath product:(CartProduct *)product
{
    CartCellLayout *newLayout = [[CartCellLayout alloc] initWithModel:product checkable:NO remark:NO];
    
    AKTableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell coverScreenshotAndDelayRemoved:self.tableView cellHeight:newLayout.cellHeight];
    
    [self.dataSource replaceObjectAtIndex:indexPath.row withObject:newLayout];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Request

- (void) requestProductsList:(NSInteger)pageNo type:(NSInteger)type
{
    RequestAfterSales *request = [RequestAfterSales new];
    request.pageno = pageNo;
//    if (type == 1) {
//        request.status = 4;
//    }
//    else {
    request.status = type;
//    }
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         ResponseAfterSales *response = content;
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

- (void) requestRemark:(NSString *)remark product:(CartProduct *)product index:(NSIndexPath *)indexPath
{
    [SVProgressHUD showWithStatus:nil];
    
    RequestProductRemark *request = [RequestProductRemark new];
    request.productId = product.cartproductid;
    request.remark = remark;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [SVProgressHUD showSuccessWithStatus:@"成功添加备注"];
         product.remark = remark;
         [self updateRowAtIndex:indexPath product:product];
     }
                                 onFailed:nil];
}

#pragma mark - UITableViewDataSource

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
    
    if (indexPath.row < self.dataSource.count) {
        CartCellLayout* layout = self.dataSource[indexPath.row];
        cell.cellLayout = layout;
        cell.indexPath = indexPath;
        
        [self callbackWithCell:cell];
    }
    
    return cell;
}

- (void) callbackWithCell:(OrderDetailTableCell *)cell
{
    @weakify(self)
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
    
    cell.clickedActionCallback = ^(OrderDetailTableCell* cell, NSInteger action, CartProduct *model) {
        @strongify(self)
        if (action == ProductActionAfterSale) {
            // 售后进度
            ASaleDetailController *controller = [[ASaleDetailController alloc] initWithProduct:model.cartproductid];
            [self.navigationController pushViewController:controller animated:YES];
        }
    };
}

#pragma mark - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate

- (NSAttributedString *) titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无相关商品";
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
        CGRect frame = CGRectMake(0, self.topBarView.bottom, self.view.width, self.view.height - self.topBarView.bottom);
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
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

- (TopBarView *) topBarView
{
    if (!_topBarView) {
        NSArray *titles = @[@"全 部", @"平台缺货", @"用户取消", @"退货中", @"已退货"];
        _topBarView = [[TopBarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44) titles:titles];
        
        @weakify(self)
        _topBarView.selectBlock = ^(int index) {
            @strongify(self)
            self.salesType = index - 1;
            [self refreshProductsList];
        };
    }
    return _topBarView;
}

@end
