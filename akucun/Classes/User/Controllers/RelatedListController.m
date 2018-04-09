//
//  RelatedListController.m
//  akucun
//
//  Created by Jarry Z on 2018/4/3.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RelatedListController.h"
#import "MJRefresh.h"
#import "FriendListCell.h"
#import "RelatedUserHeader.h"
#import "RequestRelatedUserList.h"
#import "PGDatePickManager.h"

@interface RelatedListController () <UITableViewDataSource,UITableViewDelegate,PGDatePickerDelegate>
{
    CGFloat _headerHeight;
}

@property (nonatomic, strong) UITableView  *tableView;
@property (nonatomic, strong) RelatedUserHeader *headerView;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, assign) NSInteger year,month, lastYear,lastMonth;

@end

@implementation RelatedListController

- (void) setupContent
{
    [super setupContent];
    self.title = @"关联账号管理";
    
    CGSize size = [@"TEXT" sizeWithMaxWidth:320 andFont:BOLDSYSTEMFONT(13)];
    _headerHeight = size.height*4 + kOFFSET_SIZE*3 + 10;

    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    @weakify(self)
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self requestRelatedUserList];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.textColor = LIGHTGRAY_COLOR;
    self.tableView.mj_header = refreshHeader;
    
    //
    self.dataSource = [UserManager instance].relatedUserList;
    
    NSDate  *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:currentDate];
    NSInteger year = components.year;
    NSInteger month = components.month - 1;
    if (month == 0) {
        month = 12;
        year -= 1;
    }
    self.lastYear = year;
    self.lastMonth = month;
    self.year = year;
    self.month = month;
    [self.headerView.monthButton setTitle:FORMAT(@"%ld年%02ld月",(long)year,(long)month) icon:nil];
}

- (void) updateData
{
    [self.tableView reloadData];
}

- (void) selectMonth
{
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerMode = PGDatePickerModeYearAndMonth;
    
    datePicker.minimumDate = [NSDate setYear:2018 month:1];
    datePicker.maximumDate = [NSDate setYear:self.lastYear month:self.lastMonth];

    datePicker.lineBackgroundColor = COLOR_MAIN;
    datePicker.textColorOfSelectedRow = COLOR_MAIN;
    datePicker.textColorOfOtherRow = COLOR_TEXT_NORMAL;
    
    datePickManager.isShadeBackgroud = YES;
    datePickManager.style = PGDatePickManagerStyle3;
    datePickManager.cancelButtonFont = [FontUtils buttonFont];
    datePickManager.confirmButtonFont = [FontUtils buttonFont];
    datePickManager.confirmButtonTextColor = COLOR_MAIN;
    
    [datePicker setDate:[NSDate setYear:self.year month:self.month] animated:YES];
    [self presentViewController:datePickManager animated:NO completion:nil];
}

#pragma mark - PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents
{
    self.year = dateComponents.year;
    self.month = dateComponents.month;
    [self.headerView.monthButton setTitle:FORMAT(@"%ld年%02ld月",(long)self.year,(long)self.month) icon:nil];
    [SVProgressHUD showWithStatus:nil];
    [self requestRelatedUserList];
}

#pragma mark -

- (void) requestRelatedUserList
{
    RequestRelatedUserList *request = [RequestRelatedUserList new];
    request.month = FORMAT(@"%ld-%02ld",(long)self.year,(long)self.month);
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [SVProgressHUD dismiss];
         [self.tableView.mj_header endRefreshing];
         
         ResponseRelatedUserList *response = content;
         [UserManager instance].relatedUserList = response.result;
         self.dataSource = response.result;
         self.totalSales = response.totalSales;
         self.accountSales = response.accountSales;
         self.shadowSales = response.shadowSales;
         [self updateData];
     }
                                 onFailed:^(id content)
     {
         [self.tableView.mj_header endRefreshing];
     } onError:^(id content) {
         [self.tableView.mj_header endRefreshing];
     }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RelatedListCell" forIndexPath:indexPath];
    
    Member *item = self.dataSource[indexPath.row];
    cell.usershadow = item.usershadow;
    cell.model = item;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30+kOFFSET_SIZE*2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    self.headerView.majorLabel.text = FORMAT(@"主账号的业绩： %@", [NSString amountCommaFullString:self.accountSales]);
    self.headerView.relatedLabel.text = FORMAT(@"关联账号业绩： %@", [NSString amountCommaFullString:self.shadowSales]);
    self.headerView.totalLabel.text = FORMAT(@"总计销售业绩： %@", [NSString amountCommaFullString:self.totalSales]);
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return _headerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    v.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

#pragma mark - LAZY
- (UITableView *) tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[FriendListCell class]  forCellReuseIdentifier:@"RelatedListCell"];
        
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kTableCellHeight+kSafeAreaBottomHeight)];
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

- (RelatedUserHeader *) headerView
{
    if (_headerView == nil) {
        _headerView = [[RelatedUserHeader alloc]init];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _headerHeight);
        _headerView.backgroundColor = RGBCOLOR(0xF9, 0xF9, 0xF9);
        @weakify(self)
        _headerView.actionBlock = ^{
            @strongify(self)
            [self selectMonth];
        };
    }
    return _headerView;
}

@end
