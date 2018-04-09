//
//  FollowViewController.m
//  akucun
//
//  Created by Jarry on 2017/9/17.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "FollowViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "MJRefresh.h"
#import "ECTabBarController.h"
#import "MainViewController.h"
#import "UserManager.h"
#import "ProductTableCell.h"
#import "RequestFollowList.h"
#import "RequestUpdateSKU.h"

@interface FollowViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, assign) NSInteger pageNo;

@end

@implementation FollowViewController

- (void) setupContent
{
    [super setupContent];
    self.view.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    
    self.title = @"已关注";
    
    [self ec_setTabTitle:@"已关注"];
    [self ec_setTabImage:@"icon_follow"];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self.view addSubview:self.tableView];
//    [self.view addSubview:self.commentView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
//    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_bottom).offset(kBOTTOM_BAR_HEIGHT);
//        make.width.equalTo(self.view.mas_width);
//        make.height.equalTo(@(kEDIT_BAR_HEIGHT));
//    }];
    
    //
    @weakify(self)
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [SVProgressHUD showWithStatus:nil];
        [self.tableView.mj_footer resetNoMoreData];
        self.tableView.mj_footer.hidden = YES;
        
        [self.dataSource removeAllObjects];
        self.dataSource = nil;
        [self.tableView reloadData];
        
        self.pageNo = 1;
        [self requestFollowList:self.pageNo];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.textColor = LIGHTGRAY_COLOR;
    self.tableView.mj_header = refreshHeader;
    
    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        self.pageNo ++;
        [self requestFollowList:self.pageNo];
    }];
    refreshFooter.stateLabel.textColor = COLOR_TEXT_LIGHT;
    [refreshFooter setTitle:@"正在加载数据中..." forState:MJRefreshStateRefreshing];
    [refreshFooter setTitle:@"已加载完毕" forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = refreshFooter;
    self.tableView.mj_footer.hidden = YES;
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

    if (self.isImageBrowser) {
        self.isImageBrowser = NO;
        return;
    }
    
    if (!self.dataSource || self.dataSource.count == 0) {
        [self.tableView.mj_header beginRefreshing];
    }
    else {
        [SVProgressHUD showWithStatus:nil];
        [self.tableView.mj_footer resetNoMoreData];
        self.pageNo = 1;
        [self requestFollowList:self.pageNo];
    }
    
    [self.ec_tabBarController updateBadge:0 atIndex:1 withStyle:WBadgeStyleNumber animationType:WBadgeAnimTypeNone];
}

- (void) updateDataSource:(NSArray *)products
{
    [SVProgressHUD dismiss];
    
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
    
    BOOL refresh = (self.dataSource.count == 0);
    
    NSInteger index = 0;
    for (ProductModel *product in products) {
        ProductCellLayout *layout = [[ProductCellLayout alloc] initWithModel:product];
        [self.dataSource addObject:layout];
        index ++;
    }
    
    [self updateTableData];
    
    if (refresh) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void) updateTableData
{
    [self.tableView reloadData];

    self.tableView.mj_footer.hidden = (self.dataSource.count < kPAGE_SIZE);
    if (self.dataSource.count >= kPAGE_SIZE) {
        [self.tableView.mj_footer endRefreshing];
    }
}

- (void) productFollowCancelled:(ProductModel *)product index:(NSIndexPath *)indexPath
{
    //
    [self.dataSource removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self.tableView reloadData];
}

#pragma mark - Request

- (void) requestFollowList:(NSInteger)pageNo
{
    RequestFollowList *request = [RequestFollowList new];
    request.pageno = pageNo;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         ResponseFollowList *response = content;
         [self requestUpdateSKU:response.products];
         
         [ProductsManager instance].followCount = 0;
     }
                                 onFailed:^(id content)
     {
         [self.tableView.mj_header endRefreshing];
     } onError:^(id content) {
         [self.tableView.mj_header endRefreshing];
     }];
}

- (void) requestUpdateSKU:(NSArray *)products
{
    if (products.count == 0) {
        [self.tableView.mj_header endRefreshing];
        [self updateDataSource:products];
        return;
    }
    
    RequestUpdateSKU *request = [RequestUpdateSKU new];
    request.products = products;
    
    [SCHttpServiceFace serviceWithPostRequest:request
                                    onSuccess:^(id content)
     {
         [self.tableView.mj_header endRefreshing];
         //
         ResponseSKUList *response = content;
         [self updateDataSource:response.products];
         
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

- (void) configueCell:(ProductTableCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [super configueCell:cell atIndexPath:indexPath];
}

#pragma mark - UIScrollViewDelegate

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [self.commentView hide];
}

#pragma mark - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate

- (NSAttributedString *) titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无关注商品";
    NSDictionary *attributes = @{NSFontAttributeName : [FontUtils normalFont],
                                 NSForegroundColorAttributeName : COLOR_TEXT_LIGHT };
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *) imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return IMAGENAMED(@"image_follow");
}

- (BOOL) emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return self.dataSource ? YES : NO;
}

- (BOOL) emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

//- (CGFloat) verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
//{
//    return -kTableCellHeight;
//}

@end
