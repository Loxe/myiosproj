//
//  TeamRebateDetailController.m
//  akucun
//
//  Created by deepin do on 2018/1/17.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "TeamRebateDetailController.h"
#import "MJRefresh.h"
#import "RewardSumBaseCell.h"
#import "ScrollMonthCell.h"
#import "RewardDetailBaseCell.h"
#import "UIView+DDExtension.h"
#import "RequestTeamRewardDetail.h"
#import "ResponseTeamRewardDetail.h"

@interface TeamRebateDetailController ()<UITableViewDataSource,UITableViewDelegate,ScrollMonthCellDelegate>

@property (nonatomic, strong) UITableView  *tableView;
@property (nonatomic, assign) NSString     *month;           // 当前请求月份
@property (nonatomic, assign) NSInteger    monthTotal;       // 当月返利返利总额
@property (nonatomic, strong) NSMutableArray   *priceArray;  // 返利金额数组
@property (nonatomic, strong) NSMutableArray   *titleArray;
@property (nonatomic, strong) NSMutableArray   *descArray;
@property (nonatomic, strong) NSMutableArray   *detailCountArray;
@property (nonatomic, strong) NSMutableArray   *monthArray;

@end

@implementation TeamRebateDetailController

- (void) setupContent
{
    [super setupContent];
    
    [self initMonth];
    [self getCurrentOneYearMonths];
    [self prepareNav];
    [self prepareSubView];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //    [self.tableView.mj_header beginRefreshing];
//    if (!self.dataSource) {
        [SVProgressHUD showWithStatus:nil];
        [self requestUserInfo];
        [self prepareSubView];
//    }
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
    
    self.title = @"团队返利明细";
}

- (void)prepareSubView {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    @weakify(self)
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self requestUserInfo];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.textColor = LIGHTGRAY_COLOR;
    self.tableView.mj_header = refreshHeader;
}

- (void) requestUserInfo
{
    RequestTeamRewardDetail *request = [RequestTeamRewardDetail new];
    request.month = self.month;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [self.tableView.mj_header endRefreshing];
         ResponseTeamRewardDetail *response = content;
         [SVProgressHUD dismiss];
         
         self.monthTotal = response.totalReward;
         
         NSNumber *todoRewardNum  = [NSNumber numberWithInteger:response.todoReward];
         NSNumber *rewardTotalNum = [NSNumber numberWithInteger:response.rewardTotal];
         self.priceArray          = [NSMutableArray arrayWithArray:@[todoRewardNum, rewardTotalNum]];
         
         NSNumber *mySaleNum    = [NSNumber numberWithInteger:response.mySale];
         NSNumber *oneAmountNum = [NSNumber numberWithInteger:response.oneLevelAmount];
         NSNumber *twoAmountNum = [NSNumber numberWithInteger:response.twoLevelAmount];
         NSNumber *oneRewardNum = [NSNumber numberWithInteger:response.oneLevelReward];
         NSNumber *twoRewardNum = [NSNumber numberWithInteger:response.twoLevelReward];
         self.detailCountArray  = [NSMutableArray arrayWithArray:@[mySaleNum, oneAmountNum, twoAmountNum, oneRewardNum, twoRewardNum]];
         
         NSString *personStr = [NSString stringWithFormat:@"(团队销售额%@)",response.oneLevelRewardRate];
         NSString *teamStr   = [NSString stringWithFormat:@"(个人销售额%@)",response.twoLevelRewardRate];
         self.descArray      = [NSMutableArray arrayWithArray:@[@"", @"", @"", personStr, teamStr]];
         
         [self.tableView reloadData];
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

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return 5;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        RewardSumBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RewardSumBaseCell" forIndexPath:indexPath];
        cell.nameArray   = [NSMutableArray arrayWithArray:@[@" 待入账返利", @" 累积返利金额"]];
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
    
        cell.descLabel.text       = self.titleArray[indexPath.row];
        cell.descMarkLabel.text   = self.descArray[indexPath.row];
        cell.countNum             = self.detailCountArray[indexPath.row];

        if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2) {
            cell.countLabel.textColor = COLOR_TEXT_NORMAL;
        }
        
        if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3) {
            [cell.separateLine setHidden:YES];
        }

        return cell;
        
    } else {
        RewardDetailBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RewardDetailBaseCell" forIndexPath:indexPath];
        NSString *month = [self.month componentsSeparatedByString:@"-"][1];
        cell.descLabel.text       = [NSString stringWithFormat:@"%@月返利总额",month];
        cell.descLabel.textColor  = COLOR_MAIN;
        cell.descLabel.font       = BOLDSYSTEMFONT(15);
        cell.countNum             = [NSNumber numberWithInteger:self.monthTotal];
        
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
        return 80;
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
//    NSLog(@"click %ld",index);
    self.month  = self.monthArray[index];
    [self requestUserInfo];
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
//    NSLog(@"year %ld--month %ld",(long)year,(long)month);
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
        
        [_tableView registerClass:[RewardSumBaseCell class]   forCellReuseIdentifier:@"RewardSumBaseCell"];
        [_tableView registerClass:[ScrollMonthCell class]       forCellReuseIdentifier:@"ScrollMonthCell"];
        [_tableView registerClass:[RewardDetailBaseCell class]  forCellReuseIdentifier:@"RewardDetailBaseCell"];
        
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

- (NSMutableArray *)titleArray {
    if (_titleArray == nil) {
        _titleArray = [NSMutableArray arrayWithArray:@[@"我的销售额",@"直属团队销售额",@"间接团队销售额",@"直接团队返利",@"间接团队返利"]];
    }
    return _titleArray;
}

- (NSMutableArray *)descArray {
    if (_descArray == nil) {
        _descArray = [NSMutableArray arrayWithArray:@[@"", @"", @"", @"", @""]];
    }
    return _descArray;
}

- (NSMutableArray *)detailCountArray {
    if (_detailCountArray == nil) {
        _detailCountArray = [NSMutableArray arrayWithArray:@[@0.0, @0.0, @0.0, @0.0, @0.0]];
    }
    return _detailCountArray;
}

- (NSMutableArray *)monthArray {
    if (_monthArray == nil) {
        _monthArray = [NSMutableArray array];
    }
    return _monthArray;
}


@end
