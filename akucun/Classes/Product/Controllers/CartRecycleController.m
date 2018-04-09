//
//  CartRecycleController.m
//  akucun
//
//  Created by Jarry on 2017/9/2.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "CartRecycleController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "MJRefresh.h"
#import "CartRecycleCell.h"
#import "RequestCartRecycleList.h"
#import "RequestProductBuy.h"
#import "RequestGetSKU.h"

@interface CartRecycleController () <UITableViewDataSource,UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) NSMutableArray* dataSource;

@end

@implementation CartRecycleController

- (void) setupContent
{
    [super setupContent];
    self.view.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    
    self.title = @"回收清单";
    
    [self.view addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    //
    @weakify(self)
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self requestRecyclePorducts];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.textColor = LIGHTGRAY_COLOR;
    self.tableView.mj_header = refreshHeader;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.dataSource) {
        [SVProgressHUD showWithStatus:nil];
        [self requestRecyclePorducts];
    }
}

- (void) updateDataSource:(NSArray *)products
{
    [SVProgressHUD dismiss];

    if (!self.dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    
    [self.dataSource removeAllObjects];
    for (CartProduct *item in products) {
        CartCellLayout *layout = [[CartCellLayout alloc] initWithModel:item checkable:NO remark:YES];
        [self.dataSource addObject:layout];
    }
    
    [self.tableView reloadData];
}

- (void) updateRowAtIndex:(NSIndexPath *)indexPath model:(CartProduct *)model
{
    if (indexPath.row >= self.dataSource.count) {
        return;
    }
    CartCellLayout *newLayout = [[CartCellLayout alloc] initWithModel:model checkable:NO remark:YES];
    AKTableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell coverScreenshotAndDelayRemoved:self.tableView cellHeight:newLayout.cellHeight];
    
    [self.dataSource replaceObjectAtIndex:indexPath.row withObject:newLayout];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Request

- (void) requestRecyclePorducts
{
    RequestCartRecycleList *request = [RequestCartRecycleList new];
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [self.tableView.mj_header endRefreshing];
         ResponseRecycleList *response = content;
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

- (void) requestBuyProduct:(CartProduct *)product finished:(idBlock)finishedBlock
{
    [SVProgressHUD showWithStatus:nil];
    RequestProductBuy *request = [RequestProductBuy new];
    request.productId = product.productid;
    request.skuId = product.skuid;
    request.remark = product.remark;
    request.cartproductid = product.cartproductid;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ADD_TO_CART object:nil];
         
         [SVProgressHUD showSuccessWithStatus:@"已成功添加到购物车"];
         //
         [self requestGetSKU:product finished:finishedBlock];
     }
                                 onFailed:^(id content)
     {
         if (finishedBlock) {
             finishedBlock(product);
         }
     }];
}

- (void) requestGetSKU:(CartProduct *)product finished:(idBlock)finished
{
    RequestGetSKU *request = [RequestGetSKU new];
    request.productId = product.productid;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         product.buystatus = 3;
         if (finished) {
             finished(product);
         }
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
    CartRecycleCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[CartRecycleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    CartCellLayout* layout = self.dataSource[indexPath.row];
    cell.cellLayout = layout;
    cell.indexPath = indexPath;
    [self callbackWithCell:cell];
    
    return cell;
}

- (void) callbackWithCell:(CartRecycleCell *)cell
{
    @weakify(self)
    cell.clickedBuyCallback = ^(CartRecycleCell* cell, CartProduct *model) {
        @strongify(self)
        [self requestBuyProduct:model finished:^(id content) {
            [self updateRowAtIndex:cell.indexPath model:content];
        }];
    };
}

#pragma mark - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate

- (NSAttributedString *) titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无回收记录";
    NSDictionary *attributes = @{NSFontAttributeName : [FontUtils normalFont],
                                 NSForegroundColorAttributeName : COLOR_TEXT_LIGHT };
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *) imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return IMAGENAMED(@"image_product_null");
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

#pragma mark - Views

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
