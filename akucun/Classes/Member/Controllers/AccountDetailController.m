//
//  AccountDetailController.m
//  akucun
//
//  Created by Jarry on 2017/6/18.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "AccountDetailController.h"
#import "YuemxCellLayout.h"
#import "AKTableViewCell.h"
#import "RequestAccountDetail.h"
#import "MJRefresh.h"
#import "UserManager.h"
#import "UIScrollView+EmptyDataSet.h"
#import "RechargeViewController.h"

@interface AccountDetailController () <UITableViewDataSource,UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataSource;

@property (nonatomic, assign) NSInteger pageNo;

@property (nonatomic, strong) UILabel *amountLabel;

@property (nonatomic, strong) UIButton *rechargeButton;

@end

@implementation AccountDetailController

- (void) setupContent
{
    [super setupContent];
    self.view.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = @"账户余额明细";
    
    [self updateAmount];
    [self.view addSubview:self.tableView];

    //
    @weakify(self)
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self.tableView.mj_footer resetNoMoreData];
        self.pageNo = 1;
        [self requestDetailRecord];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.textColor = LIGHTGRAY_COLOR;
    self.tableView.mj_header = refreshHeader;
    
    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        self.pageNo ++;
        [self requestDetailRecord];
    }];
    refreshFooter.stateLabel.textColor = COLOR_TEXT_LIGHT;
    [refreshFooter setTitle:@"正在加载数据中..." forState:MJRefreshStateRefreshing];
    [refreshFooter setTitle:@"已加载完毕" forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = refreshFooter;
    self.tableView.mj_footer.hidden = YES;
    
    //
//    _dataSource = [NSMutableArray array];
    self.pageNo = 1;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [SVProgressHUD showWithStatus:nil];
    [self requestDetailRecord];
}

- (void) updateDataSource:(NSArray *)records
{
    [SVProgressHUD dismiss];
    if (!self.dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    else if (self.pageNo == 1) {
        [self.dataSource removeAllObjects];
    }
    
    if (records.count == 0) {
        [self updateTableData];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    
    for (AccountRecord *record in records) {
        YuemxCellLayout *layout = [[YuemxCellLayout alloc] initWithModel:record];
        [self.dataSource addObject:layout];
    }
    
    [self updateTableData];
    [self.tableView.mj_footer endRefreshing];
}

- (void) updateTableData
{
    [self.tableView.mj_header endRefreshing];
    self.tableView.mj_footer.hidden = (self.dataSource.count < 20);
    [self.tableView reloadData];
}

- (void) updateAmount
{
    UserAccount *account = [UserManager instance].userInfo.account;
    NSString *yueStr = [NSString priceString:account.keyongyue];
    NSString *accountStr = FORMAT(@"账户余额： %@", yueStr);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:accountStr];
    [attStr addAttribute:NSForegroundColorAttributeName value:COLOR_MAIN range:NSMakeRange(accountStr.length-yueStr.length, yueStr.length)];
    [attStr addAttribute:NSFontAttributeName value:SYSTEMFONT(27) range:NSMakeRange(accountStr.length-yueStr.length+2, yueStr.length-2)];
    self.amountLabel.attributedText = attStr;
}

- (IBAction) rechargeAction:(id)sender
{
    RechargeViewController *controller = [RechargeViewController new];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Request

- (void) requestDetailRecord
{
    RequestAccountDetail *request = [RequestAccountDetail new];
    request.pageno = self.pageNo;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
    {
        ResponseAccountDetail *response = content;
        [self updateDataSource:response.result];
        
        [self updateAmount];
        
    } onFailed:^(id content) {
        
    }];
}

#pragma mark - UITableViewDataSource
/*
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5f;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5f)];
    footer.backgroundColor = COLOR_SEPERATOR_LINE;
    return footer;
}*/

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YuemxCellLayout* layout = self.dataSource[indexPath.row];
    return layout.cellHeight;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"cellIdentifier";
    AKTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[AKTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    cell.showSeperator = (indexPath.row < self.dataSource.count-1);

    YuemxCellLayout* cellLayout = self.dataSource[indexPath.row];
    cell.cellLayout = cellLayout;

    return cell;
}

#pragma mark - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate

- (NSAttributedString *) titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无账户明细";
    NSDictionary *attributes = @{NSFontAttributeName : [FontUtils normalFont],
                                 NSForegroundColorAttributeName : COLOR_TEXT_LIGHT };
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *) imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return IMAGENAMED(@"image_account");
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
        
//        CGFloat height = isPad ? kPadCellHeight : kTableCellHeight;
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kTableCellHeight)];
        headerView.backgroundColor = WHITE_COLOR;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kTableCellHeight-0.5f, SCREEN_WIDTH, 0.5f)];
        line.backgroundColor = COLOR_SEPERATOR_LINE;
        [headerView addSubview:line];
        
        [headerView addSubview:self.amountLabel];
        
        self.rechargeButton.right = SCREEN_WIDTH - kOFFSET_SIZE;
        self.rechargeButton.centerY = kTableCellHeight * 0.5f;
        [headerView addSubview:self.rechargeButton];
        
        _tableView.tableHeaderView = headerView;
    }
    return _tableView;
}

- (UILabel *) amountLabel
{
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(kOFFSET_SIZE, 0, SCREEN_WIDTH-kOFFSET_SIZE*2, kTableCellHeight)];
        _amountLabel.textColor = COLOR_TEXT_DARK;
        _amountLabel.font = BOLDSYSTEMFONT(14);
    }
    return _amountLabel;
}

- (UIButton *) rechargeButton
{
    if (_rechargeButton) {
        return _rechargeButton;
    }
    _rechargeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rechargeButton.frame = CGRectMake(0, 0, 50, 26);
    _rechargeButton.right = SCREEN_WIDTH - kOFFSET_SIZE;
    _rechargeButton.backgroundColor = COLOR_SELECTED;
    _rechargeButton.clipsToBounds = YES;
    _rechargeButton.layer.cornerRadius = 3.0f;
    _rechargeButton.titleLabel.font = [FontUtils smallFont];
    [_rechargeButton setNormalTitle:@"充 值"];
    [_rechargeButton setNormalColor:WHITE_COLOR highlighted:GRAY_COLOR selected:nil];
    
    [_rechargeButton addTarget:self action:@selector(rechargeAction:)
         forControlEvents:UIControlEventTouchUpInside];
        
    return _rechargeButton;
}

@end
