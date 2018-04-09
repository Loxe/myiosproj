//
//  ProductsViewController.m
//  akucun
//
//  Created by Jarry on 2017/4/26.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ProductsViewController.h"
#import "MMAlertView.h"
#import "Gallop.h"
#import "UserManager.h"
#import "MJRefresh.h"
#import "ProductsManager.h"
#import "LWImageBrowser.h"
#import "AKShareConfirm.h"
#import "RequestUpdateSKU.h"
#import "TextButton.h"
#import "PopupLivesView.h"
#import "SearchBarLayout.h"

@interface ProductsViewController () <UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) TextButton *filterButton;

@property (nonatomic, strong) UIView *quickView;
@property (nonatomic, strong) UIButton *quehuoButton, *youhuoButton;

@property (nonatomic, copy) NSString *searchText;

@property (nonatomic, strong) LiveInfo *liveInfo;

@end

@implementation ProductsViewController

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.searchBar endEditing:YES];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [self.searchBar becomeFirstResponder];
}

- (void) setupContent
{
    [super setupContent];
    
    self.navigationItem.leftBarButtonItem = nil;
    [self.navigationItem setHidesBackButton:YES];
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
    
    [self.view addSubview:self.filterButton];
    [self.view addSubview:self.tableView];
//    self.commentView.offsetHeight = 0;
//    [self.view addSubview:self.commentView];
    [self.view addSubview:self.quickView];

//    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_bottom);
//        make.width.equalTo(self.view.mas_width);
//        make.height.equalTo(@(kEDIT_BAR_HEIGHT));
//    }];
    
    //
    self.dataSource = [NSMutableArray array];
    
    //
    @weakify(self)
    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        [SVProgressHUD showWithStatus:nil];
        NSArray *products = nil;
        if ([self.searchText isEqualToString:@"光"]) {
            products = [ProductsManager searchQuehuoProductsWith:self.dataSource.count liveId:self.liveId];
        }
        else if ([self.searchText isEqualToString:@"有货"]) {
            products = [ProductsManager searchYouhuoProductsWith:self.dataSource.count liveId:self.liveId];
        }
        else {
            products = [ProductsManager searchProductsBy:self.searchText liveId:self.liveId startWith:self.dataSource.count];
        }
        [self requestUpdateSKU:products];
    }];
    refreshFooter.stateLabel.textColor = COLOR_TEXT_LIGHT;
    [refreshFooter setTitle:@"正在加载数据中..." forState:MJRefreshStateRefreshing];
    [refreshFooter setTitle:@"已搜索完毕" forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = refreshFooter;
    self.tableView.mj_footer.hidden = YES;
}

- (void) setLiveId:(NSString *)liveId
{
    _liveId = liveId;

    if (!liveId) {
        [self.filterButton setNormalTitle:@"搜索品牌 ： 全部"];
        return;
    }
    LiveInfo *liveInfo = [LiveManager getLiveInfo:liveId];
    [self.filterButton setNormalTitle:FORMAT(@"搜索品牌 ： %@", liveInfo.pinpaiming)];
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tableView.top = self.filterButton.bottom;
    self.tableView.height = self.view.height - self.filterButton.bottom;
}

- (void) addProducts:(NSArray *)products skus:(NSArray *)skus
{
    for (ProductModel *product in products) {
        [self updateSkus:skus forProduct:product];
        ProductCellLayout *layout = [[ProductCellLayout alloc] initWithModel:product];
        [self.dataSource addObject:layout];
    }
}

- (void) updateSkus:(NSArray *)skus forProduct:(ProductModel *)product
{
    for (ProductSKU *sku in skus) {
        if ([sku.productid isEqualToString:product.Id]) {
            [product updateSKU:sku];
        }
    }
}

- (void) updateResult:(NSArray *)products
{
    [SVProgressHUD dismiss];
    if (!products || products.count == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    
    [self updateTableData];
    
    if (products.count < 10) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    else {
        [self.tableView.mj_footer endRefreshing];
    }
}

- (void) updateTableData
{
    [self.tableView reloadData];

    self.tableView.mj_footer.hidden = (self.dataSource.count == 0);
    self.quickView.hidden = (self.dataSource.count > 0);
}

#pragma mark - Actions

- (IBAction) filterAction:(id)sender
{
    NSInteger selectIndex = 0;
    if (self.liveId) {
        selectIndex = [LiveManager liveIndexByLiveId:self.liveId] + 1;
    }
    NSMutableArray *options = [NSMutableArray arrayWithArray:[LiveManager instance].liveDatas];
    [options insertObject:@"全部" atIndex:0];
    PopupLivesView *optionsView = [[PopupLivesView alloc] initWithTitle:@"选择品牌" lives:options selected:selectIndex];
    @weakify(self)
    optionsView.completeBolck = ^(int index, id content) {
        @strongify(self)
        if (index == 0) {
            self.liveId = nil;
        }
        else {
            LiveInfo *liveInfo = [LiveManager liveInfoAtIndex:(index-1)];
            self.liveId = liveInfo.liveid;
            //
            [SVProgressHUD showWithStatus:nil];
            [ProductsManager syncProductsWith:liveInfo.liveid
                                     finished:^(id content)
             {
                 [SVProgressHUD dismiss];
             } failed:nil];
        }
        self.searchBar.text = @"";
        self.searchText = @"";
        if (self.dataSource.count > 0) {
            [self.dataSource removeAllObjects];
            [self updateTableData];
        }
    };
    [optionsView show];
}

- (IBAction) quehuoAction:(id)sender
{
    [SVProgressHUD showWithStatus:nil];
    [self.searchBar endEditing:YES];
    [self.dataSource removeAllObjects];
    [self updateTableData];
    
    self.searchText = @"光";
    self.searchBar.text = self.searchText;
    NSArray *products = [ProductsManager searchQuehuoProductsWith:0 liveId:self.liveId];
    if (!products || products.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"未找到相关商品!"];
        return;
    }
    
    [self requestUpdateSKU:products];
}

- (IBAction) youhuoAction:(id)sender
{
    [SVProgressHUD showWithStatus:nil];
    [self.searchBar endEditing:YES];
    [self.dataSource removeAllObjects];
    [self updateTableData];
    
    self.searchText = @"有货";
    self.searchBar.text = self.searchText;
    NSArray *products = [ProductsManager searchYouhuoProductsWith:0 liveId:self.liveId];
    if (!products || products.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"未找到相关商品!"];
        return;
    }
    
    [self requestUpdateSKU:products];
}

- (IBAction) rightButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Request

- (void) requestUpdateSKU:(NSArray *)products
{
    if (products.count == 0) {
        [self updateResult:products];
        return;
    }
    
    RequestUpdateSKU *request = [RequestUpdateSKU new];
    request.products = products;
    
    [SCHttpServiceFace serviceWithPostRequest:request
                                    onSuccess:^(id content)
     {
         ResponseSKUList *response = content;
         GCD_DEFAULT(^{
             [self addProducts:products skus:response.result];
             
             GCD_MAIN(^{
                 [self updateResult:products];
             });
         });

     } onFailed:^(id content) {
         
     }];
}

#pragma mark - UIScrollViewDelegate

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [self.commentView hide];
}

#pragma mark - UISearchBarDelegate

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
//    [searchBar setShowsCancelButton:YES animated:YES];
    if (self.dataSource.count > 0) {
        [self.dataSource removeAllObjects];
        [self updateTableData];
    }
}

- (void) searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
//    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([self.searchText isEqualToString:searchText]) {
        return;
    }
    
    if (self.dataSource.count > 0) {
        [self.dataSource removeAllObjects];
        [self updateTableData];
    }
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [SVProgressHUD showWithStatus:nil];
    [searchBar endEditing:YES];
    [self.dataSource removeAllObjects];
    [self updateTableData];
    
    self.searchText = searchBar.text;
    NSArray *products = nil;
    if ([self.searchText isEqualToString:@"光"]) {
        products = [ProductsManager searchQuehuoProductsWith:0 liveId:self.liveId];
    }
    else if ([self.searchText isEqualToString:@"有货"]) {
        products = [ProductsManager searchYouhuoProductsWith:0 liveId:self.liveId];
    }
    else {
        products = [ProductsManager searchProductsBy:self.searchText liveId:self.liveId startWith:0];
    }
    if (!products || products.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"未找到相关商品!"];
        return;
    }

    [self requestUpdateSKU:products];
//    if (products.count > 0) {
//        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
//    }
}

#pragma mark - Views

- (UISearchBar *) searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _searchBar.delegate = self;
        _searchBar.showsCancelButton = NO;
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.placeholder = @"搜索商品款号/序号/关键字";
//        _searchBar.searchTextPositionAdjustment = UIOffsetMake(10, 0);

        // 修改placeholder字体的颜色和大小
        UITextField * searchField = [_searchBar valueForKey:@"_searchField"];
        if (searchField) {
//            [searchField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
            [searchField setValue:[FontUtils normalFont] forKeyPath:@"_placeholderLabel.font"];
        }
    }
    return _searchBar;
}

- (TextButton *) filterButton
{
    if (_filterButton) {
        return _filterButton;
    }
    
    _filterButton = [TextButton buttonWithType:UIButtonTypeCustom];
    _filterButton.backgroundColor = WHITE_COLOR;
    _filterButton.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    _filterButton.titleEdgeInsets = UIEdgeInsetsMake(0, kOFFSET_SIZE, 0, kOFFSET_SIZE);
    
    [_filterButton setTitleFont:[FontUtils normalFont]];
    [_filterButton setNormalColor:COLOR_TEXT_DARK highlighted:COLOR_SELECTED selected:nil];
    
    [_filterButton setNormalTitle:@"搜索品牌 ： 全部"];
    
    //
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39, SCREEN_WIDTH, kPIXEL_WIDTH)];
    line.backgroundColor = COLOR_SEPERATOR_LINE;
    [_filterButton addSubview:line];
    
    [_filterButton addTarget:self action:@selector(filterAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return _filterButton;
}

- (UIView *) quickView
{
    if (!_quickView) {
        _quickView = [[UIView alloc] initWithFrame:self.view.bounds];
        _quickView.backgroundColor = WHITE_COLOR;
        _quickView.top = 40;
        
        [_quickView addSubview:self.quehuoButton];
        self.youhuoButton.left = self.quehuoButton.right + kOFFSET_SIZE;
        [_quickView addSubview:self.youhuoButton];
    }
    return _quickView;
}

- (UIButton *) quehuoButton
{
    if (_quehuoButton) {
        return _quehuoButton;
    }
    _quehuoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _quehuoButton.frame = CGRectMake(kOFFSET_SIZE, kOFFSET_SIZE, 100, 28);
    _quehuoButton.backgroundColor = COLOR_BG_TEXT;
    _quehuoButton.clipsToBounds = YES;
    _quehuoButton.layer.cornerRadius = 3.0f;
//    _quehuoButton.layer.borderWidth = 0.5f;
//    _quehuoButton.layer.borderColor = COLOR_TEXT_LIGHT.CGColor;
    _quehuoButton.titleLabel.font = [FontUtils smallFont];
    [_quehuoButton setNormalTitle:@"看看哪些光了"];
    [_quehuoButton setNormalColor:COLOR_TEXT_NORMAL highlighted:COLOR_SELECTED selected:nil];
    
    [_quehuoButton addTarget:self action:@selector(quehuoAction:)
           forControlEvents:UIControlEventTouchUpInside];
    
    return _quehuoButton;
}

- (UIButton *) youhuoButton
{
    if (_youhuoButton) {
        return _youhuoButton;
    }
    _youhuoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _youhuoButton.frame = CGRectMake(kOFFSET_SIZE, kOFFSET_SIZE, 100, 28);
    _youhuoButton.backgroundColor = COLOR_BG_TEXT;
    _youhuoButton.clipsToBounds = YES;
    _youhuoButton.layer.cornerRadius = 3.0f;
    //    _quehuoButton.layer.borderWidth = 0.5f;
    //    _quehuoButton.layer.borderColor = COLOR_TEXT_LIGHT.CGColor;
    _youhuoButton.titleLabel.font = [FontUtils smallFont];
    [_youhuoButton setNormalTitle:@"看看哪些没光"];
    [_youhuoButton setNormalColor:COLOR_TEXT_NORMAL highlighted:COLOR_SELECTED selected:nil];
    
    [_youhuoButton addTarget:self action:@selector(youhuoAction:)
            forControlEvents:UIControlEventTouchUpInside];
    
    return _youhuoButton;
}

@end
