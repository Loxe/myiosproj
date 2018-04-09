//
//  InviteRewardDetailController.m
//  akucun
//
//  Created by deepin do on 2018/1/17.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "InviteRewardDetailController.h"
#import "MJRefresh.h"
#import "RewardSumBaseCell.h"
#import "ScrollMonthCell.h"
#import "RewardDetailBaseCell.h"
#import "BuyerRewardDetailCell.h"
#import "UIView+DDExtension.h"
#import "RequestUserInviteDetail.h"
#import "ResponseUserInviteDetail.h"

@interface InviteRewardDetailController ()<UITableViewDataSource,UITableViewDelegate,ScrollMonthCellDelegate>

@property (nonatomic, strong) UITableView  *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;   // 代购成员数组
@property (nonatomic, assign) NSInteger      pageNo;
@property (nonatomic, assign) NSString       *month;        // 当前请求月份

@property (nonatomic, assign) NSInteger todoReward;         // 待入账邀请奖励金额
@property (nonatomic, assign) NSInteger rewardTotal;        // 已入账邀请奖励金额
@property (nonatomic, assign) NSInteger rewardMonth;        // 当月邀请金额
@property (nonatomic, assign) NSInteger invitedCount;       // 代购成员数

@property (nonatomic, strong) NSMutableArray   *priceArray;  // 已经邀请数组
@property (nonatomic, strong) NSMutableArray   *monthArray;

@end

@implementation InviteRewardDetailController

- (void) setupContent
{
    [super setupContent];
    
    [self initMonth];
    [self getCurrentOneYearMonths];
    [self prepareNav];
//    [self prepareSubView];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    [self.tableView.mj_header beginRefreshing];
    if (!self.dataSource) {
        [SVProgressHUD showWithStatus:nil];
        self.pageNo = 1;
        [self requestListData];
        [self prepareSubView];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)initMonth {
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    NSInteger year  = [dateComponent year];
    NSInteger month = [dateComponent month];
    
    if (month < 10) {
        self.month = [NSString stringWithFormat:@"%ld-0%ld",(long)year,(long)month];
    } else {
        self.month = [NSString stringWithFormat:@"%ld-%ld",(long)year,(long)month];
    }
}

- (void)prepareNav {
    
    self.view.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = @"邀请奖励明细";
}

- (void)prepareSubView {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    @weakify(self)
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self.tableView.mj_footer resetNoMoreData];
        self.tableView.mj_footer.hidden = YES;
        self.pageNo = 1;
        [self requestListData];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.textColor = LIGHTGRAY_COLOR;
    self.tableView.mj_header = refreshHeader;
    
    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        self.pageNo ++;
        [self requestListData];
    }];
    refreshFooter.stateLabel.textColor = COLOR_TEXT_LIGHT;
    [refreshFooter setTitle:@"正在加载数据中..." forState:MJRefreshStateRefreshing];
    [refreshFooter setTitle:@"已加载完毕" forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = refreshFooter;
    self.tableView.mj_footer.hidden = YES;
}

- (void) requestListData
{
    RequestUserInviteDetail *request = [RequestUserInviteDetail new];
    request.month  = self.month;
    request.pageno = self.pageNo;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [self.tableView.mj_header endRefreshing];
         ResponseUserInviteDetail *response = content;
         
         self.invitedCount  = response.result.count;
         self.rewardMonth   = response.rewardMonth;
         self.todoReward    = response.todoReward;
         self.rewardTotal   = response.rewardTotal;
         
         NSNumber *todoRewardNum  = [NSNumber numberWithInteger:self.todoReward];
         NSNumber *rewardTotalNum = [NSNumber numberWithInteger:self.rewardTotal];
         self.priceArray = [NSMutableArray arrayWithArray:@[todoRewardNum, rewardTotalNum]];
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

- (void) updateDataSource:(NSArray *)dataArray
{
    if (!self.dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    else if (self.pageNo == 1) {
        [self.dataSource removeAllObjects];
    }
    
    [SVProgressHUD dismiss];
    
    if (dataArray.count == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView reloadData];
        return;
    }

    [self.dataSource addObjectsFromArray:dataArray];
    
    self.tableView.mj_footer.hidden = (self.dataSource.count < 20);
    if (self.dataSource.count >= 20) {
        [self.tableView.mj_footer endRefreshing];
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 3) {
        return self.dataSource.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        RewardSumBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RewardSumBaseCell" forIndexPath:indexPath];
        cell.nameArray   = [NSMutableArray arrayWithArray:@[@" 待入账奖励", @" 累积奖励金额"]];
        cell.priceArray  = self.priceArray;
        [cell.collectionView reloadData];
        
        return cell;
        
    } else if (indexPath.section == 1) {
        
        ScrollMonthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScrollMonthCell" forIndexPath:indexPath];
        if (self.monthArray != nil && self.monthArray.count > 0) {
            cell.monthArray = self.monthArray;
        }
        cell.delegate = self;

        return cell;
        
    } else if (indexPath.section == 2) {
        
        RewardDetailBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RewardDetailBaseCell" forIndexPath:indexPath];
        cell.descLabel.text = @"月邀请奖励金额";
        cell.countNum       = [NSNumber numberWithInteger:self.rewardMonth];
        
        return cell;
        
    } else {
        BuyerRewardDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BuyerRewardDetailCell" forIndexPath:indexPath];
        cell.model = self.dataSource[indexPath.row];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        //return 100;
        return kRewardItemH+2.5*kOFFSET_SIZE;
    } else if (indexPath.section == 1) {
        return kMonthItemH;
    } else if (indexPath.section == 2) {
        return 60;
    } else {
        return 90;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *v = [UIView new];
    v.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 15;
    }
    return 0;
}

#pragma mark - ScrollMonthCellDelegate
- (void)didSelectScrollMonthCellTag:(NSInteger)index {
//    NSLog(@"didSelectScrollMonthCellTag %ld",index);
    self.dataSource = [NSMutableArray array];
    self.pageNo = 1;
    self.month  = self.monthArray[index];
    [self requestListData];
}

- (void)getCurrentOneYearMonths {
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    NSInteger year  = [dateComponent year];
    NSInteger month = [dateComponent month];
    
    NSMutableArray *array = [NSMutableArray array];
    
    if (year<2018) {
        NSLog(@"系统时间不会小于2018");
    } else if (year == 2018) {
        for (NSInteger i = 1; i <= month; i ++) {
            NSString *str = @"";
            if (i < 10) {
                str = [NSString stringWithFormat:@"%ld-0%ld",(long)year,(long)i];
            } else {
                str = [NSString stringWithFormat:@"%ld-%ld",(long)year,(long)i];
            }
            [array addObject:str];
        }
    } else {
        for (NSInteger i = 1; i <= month; i ++) {
            NSString *str = @"";
            if (i < 10) {
                str = [NSString stringWithFormat:@"%ld-0%ld",(long)year,(long)i];
            } else {
                str = [NSString stringWithFormat:@"%ld-%ld",(long)year,(long)i];
            }
            [array addObject:str];
        }
        if (array.count<12) {
            for (NSInteger i = 12; i >= 1; i --) {
                NSString *str = @"";
                if (i < 10) {
                    str = [NSString stringWithFormat:@"%ld-0%ld",(long)year,(long)i];
                } else {
                    str = [NSString stringWithFormat:@"%ld-%ld",(long)year,(long)i];
                }
                [array addObject:str];
            }
        }
    }
    
    self.monthArray = array;
//    NSLog(@"year %ld--month %ld",year,month);
}

#pragma mark - LAZY
- (UITableView *)tableView {
    
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = RGBCOLOR(240, 240, 240);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[RewardSumBaseCell class]     forCellReuseIdentifier:@"RewardSumBaseCell"];
        [_tableView registerClass:[ScrollMonthCell class]       forCellReuseIdentifier:@"ScrollMonthCell"];
        [_tableView registerClass:[RewardDetailBaseCell class]  forCellReuseIdentifier:@"RewardDetailBaseCell"];
        [_tableView registerClass:[BuyerRewardDetailCell self]  forCellReuseIdentifier:@"BuyerRewardDetailCell"];
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
        }
    }
    return _tableView;
}

- (NSMutableArray *)priceArray {
    if (_priceArray == nil) {
        _priceArray = [NSMutableArray arrayWithArray:@[@0.0, @0.0]];
    }
    return _priceArray;
}

- (NSMutableArray *)monthArray {
    if (_monthArray == nil) {
        _monthArray = [NSMutableArray array];
    }
    return _monthArray;
}


@end
