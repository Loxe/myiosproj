//
//  ForwardViewController.m
//  akucun
//
//  Created by Jarry on 2017/3/21.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ForwardViewController.h"
#import "ECTabBarController.h"
#import "MainViewController.h"
#import "Gallop.h"
#import "UserManager.h"
#import "ProductTableCell.h"
#import "RequestForwardList.h"
#import "MJRefresh.h"
#import "ProductsManager.h"
#import "LWImageBrowser.h"
#import "UIScrollView+EmptyDataSet.h"
#import "MMAlertView.h"

@interface ForwardViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) UILabel *forwardLabel, *totalLabel, *countLabel1, *countLabel2;

@property (nonatomic, assign) NSInteger pageNo;

@end

@implementation ForwardViewController

- (void) setupContent
{
    [super setupContent];
    self.view.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);

    self.title = @"已转发";
    
    [self ec_setTabTitle:@"已转发"];
    [self ec_setTabImage:@"icon_forward"];
    
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
        [self.tableView.mj_footer resetNoMoreData];
        self.pageNo = 1;
        [self requestForwardList:self.pageNo];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.textColor = LIGHTGRAY_COLOR;
    self.tableView.mj_header = refreshHeader;
    
    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        self.pageNo ++;
        [self requestForwardList:self.pageNo];
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

    [self updateHeader];
    
//    [self.dataSource removeAllObjects];
//    [self.tableView reloadData];
    [SVProgressHUD showWithStatus:nil];
    [self.tableView.mj_footer resetNoMoreData];
    self.pageNo = 1;
    [self requestForwardList:self.pageNo];
}

- (void) updateDataSource:(NSArray *)products
{
    if (!self.dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    else if (self.pageNo == 1) {
        [self.dataSource removeAllObjects];
    }
    
    [SVProgressHUD dismiss];
    
    if (products.count == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [UIView performWithoutAnimation:^{
            [self.tableView reloadData];
        }];
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
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    //
//    [ProductsManager instance].forwardCount = 0;
//    [self.ec_tabBarController updateBadge:0 atIndex:1];
}

- (void) updateTableData
{
    [UIView performWithoutAnimation:^{
        [self.tableView reloadData];
    }];
    self.tableView.mj_footer.hidden = (self.dataSource.count < 20);
    if (self.dataSource.count >= 20) {
        [self.tableView.mj_footer endRefreshing];
    }
}

- (void) updateHeader
{
    UserInfo *userInfo = [UserManager instance].userInfo;
    self.headerLabel.text = FORMAT(@"代购编号： %@", userInfo.yonghubianhao);
    self.forwardLabel.text = FORMAT(@"已转发： %ld 次", (long)userInfo.forwardcount);
    self.totalLabel.text = FORMAT(@"已奖励： %ld 元", (long)(userInfo.keyongdikou + userInfo.yiyongdikou));
    self.countLabel1.text = FORMAT(@"可抵扣余额： %ld 元", (long)userInfo.keyongdikou);
    self.countLabel2.text = FORMAT(@"已抵扣金额： %ld 元", (long)userInfo.yiyongdikou);
}

#pragma mark - Request

- (void) requestForwardList:(NSInteger)pageNo
{
    RequestForwardList *request = [RequestForwardList new];
    request.pageno = pageNo;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [self.tableView.mj_header endRefreshing];
         
         ResponseForwardList *response = content;
         [self updateDataSource:response.products];
         [self updateHeader];
     }
                                 onFailed:^(id content)
     {
         [self.tableView.mj_header endRefreshing];
     }];
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 44*3+kOFFSET_SIZE;
    }
    return 0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44*3+kOFFSET_SIZE)];
    header.backgroundColor = CLEAR_COLOR;
    
    UIView *labelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44*3)];
    labelView.backgroundColor = WHITE_COLOR;
    [labelView addSubview:self.headerLabel];
    [labelView addSubview:self.forwardLabel];
    [labelView addSubview:self.totalLabel];
    [labelView addSubview:self.countLabel1];
    [labelView addSubview:self.countLabel2];
    [header addSubview:labelView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 44.0f-kPIXEL_WIDTH, SCREEN_WIDTH, kPIXEL_WIDTH)];
    line.backgroundColor = COLOR_SEPERATOR_LIGHT;
    [header addSubview:line];
    line = [[UIView alloc] initWithFrame:CGRectMake(kOFFSET_SIZE, 88.0f-kPIXEL_WIDTH, SCREEN_WIDTH-kOFFSET_SIZE, kPIXEL_WIDTH)];
    line.backgroundColor = COLOR_SEPERATOR_LIGHT;
    [header addSubview:line];

    return header;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return self.dataSource.count;
}

- (void) configueCell:(ProductTableCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [super configueCell:cell atIndexPath:indexPath];
    cell.hideForward = YES;
}

#pragma mark - UIScrollViewDelegate

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [self.commentView hide];
    
}

#pragma mark - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate

- (NSAttributedString *) titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无转发商品";
    NSDictionary *attributes = @{NSFontAttributeName : [FontUtils normalFont],
                                 NSForegroundColorAttributeName : COLOR_TEXT_LIGHT };
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *) imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return IMAGENAMED(@"image_forward");
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
    return kTableCellHeight;
}

#pragma mark - Views

- (UILabel *) headerLabel
{
    if (!_headerLabel) {
        _headerLabel  = [[UILabel alloc] init];
        _headerLabel.frame = CGRectMake(kOFFSET_SIZE, 0, SCREEN_WIDTH-kOFFSET_SIZE*2, 44);
        _headerLabel.textColor = COLOR_TEXT_NORMAL;
        _headerLabel.font = [FontUtils normalFont];
        _headerLabel.text = @"代购编号：";
    }
    return _headerLabel;
}

- (UILabel *) forwardLabel
{
    if (!_forwardLabel) {
        _forwardLabel  = [[UILabel alloc] init];
        _forwardLabel.frame = CGRectMake(kOFFSET_SIZE, 44, SCREEN_WIDTH-kOFFSET_SIZE*2, 44);
        _forwardLabel.textColor = COLOR_TEXT_NORMAL;
        _forwardLabel.font = [FontUtils normalFont];
    }
    return _forwardLabel;
}

- (UILabel *) totalLabel
{
    if (!_totalLabel) {
        _totalLabel  = [[UILabel alloc] init];
        _totalLabel.frame = CGRectMake(kOFFSET_SIZE, 44, SCREEN_WIDTH-kOFFSET_SIZE*2, 44);
        _totalLabel.textColor = COLOR_TEXT_NORMAL;
        _totalLabel.font = [FontUtils normalFont];
        _totalLabel.textAlignment = NSTextAlignmentRight;
    }
    return _totalLabel;
}

- (UILabel *) countLabel1
{
    if (!_countLabel1) {
        _countLabel1  = [[UILabel alloc] init];
        _countLabel1.frame = CGRectMake(kOFFSET_SIZE, 44*2, SCREEN_WIDTH-kOFFSET_SIZE*2, 44);
        _countLabel1.textColor = COLOR_TEXT_NORMAL;
        _countLabel1.font = [FontUtils normalFont];
    }
    return _countLabel1;
}

- (UILabel *) countLabel2
{
    if (!_countLabel2) {
        _countLabel2  = [[UILabel alloc] init];
        _countLabel2.frame = CGRectMake(kOFFSET_SIZE, 44*2, SCREEN_WIDTH-kOFFSET_SIZE*2, 44);
        _countLabel2.textColor = COLOR_TEXT_NORMAL;
        _countLabel2.font = [FontUtils normalFont];
        _countLabel2.textAlignment = NSTextAlignmentRight;
    }
    return _countLabel2;
}

@end
