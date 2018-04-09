//
//  TeamListController.m
//  akucun
//
//  Created by deepin do on 2018/1/30.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "TeamListController.h"
#import "MJRefresh.h"
#import "UserManager.h"
#import "WebViewController.h"
#import "TeamBannerCell.h"
#import "FriendListCell.h"
#import "FriendSectionHeader.h"

#import "RequestTeamDetail.h"
#import "ResponseTeamDetail.h"
#import "RequestTeamMembers.h"
#import "ResponseTeamList.h"
#import "VideoPreViewController.h"
#import "UINavigationController+WXSTransition.h"

@interface TeamListController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView  *tableView;
@property (nonatomic, strong) FriendSectionHeader *friendHeader;
//@property (nonatomic, strong) RewardSectionHeaderView *otherHeader;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger      pageNo;

@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) NSInteger activeCount;
@property (nonatomic, assign) NSInteger lostCount;

@property (nonatomic, assign) NSInteger vipFlag;    // 0 1 2

@end

@implementation TeamListController

- (void) setupContent
{
    [super setupContent];
    
    [self prepareNav];
    //[self prepareSubView];
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
        [self requestTeamList];
        [self prepareSubView];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)prepareNav {
    
    self.view.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = @"我的好友";
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
        [self requestTeamList];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.textColor = LIGHTGRAY_COLOR;
    self.tableView.mj_header = refreshHeader;
    
    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        self.pageNo ++;
        [self requestTeamList];
    }];
    refreshFooter.stateLabel.textColor = COLOR_TEXT_LIGHT;
    [refreshFooter setTitle:@"正在加载数据中..." forState:MJRefreshStateRefreshing];
    [refreshFooter setTitle:@"" forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = refreshFooter;
    self.tableView.mj_footer.hidden = YES;
}

- (void) requestTeamList
{
    RequestTeamMembers *request = [RequestTeamMembers new];
    request.pageno = self.pageNo;
    if (self.vipFlag > 0) {
        request.vipfalg = self.vipFlag==1 ? @"DESC" : @"ASC";
    }
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [SVProgressHUD dismiss];
         [self.tableView.mj_header endRefreshing];
         ResponseTeamList *response = content;
         self.totalCount = response.totalCount;
         self.activeCount = response.activeCount;
         self.lostCount = response.lostCount;
         [self updateDataSource:response.result flag:[response didReachEnd]];
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

- (void) updateDataSource:(NSArray *)dataArray flag:(BOOL)reachEnd
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
    if (reachEnd) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    else {
        [self.tableView.mj_footer endRefreshing];
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return self.dataSource.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        TeamBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamBannerCell" forIndexPath:indexPath];
        cell.BGImgView.image  = [UIImage imageNamed:@"teamListBanner"];
        cell.playBtn.hidden   = YES;
        cell.detailBtn.hidden = YES;
        
        return cell;
        
    } else {
//        MemberRewardDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberRewardDetailCell" forIndexPath:indexPath];
//        cell.model = self.dataSource[indexPath.row];
//        cell.personCountLabel.hidden = YES;
//        return cell;
        
        FriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendListCell" forIndexPath:indexPath];
        cell.model = self.dataSource[indexPath.row];

        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 273*SCREEN_WIDTH/621; // 根据图片实际尺寸算的，避免变形
    }
    else {
        return 30+kOFFSET_SIZE*2;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        
        if (self.totalCount > 0) {
            [self.friendHeader setInvitedCount:self.totalCount activeCount:self.activeCount andLostCount:self.lostCount];
        }
        
        self.friendHeader.friendLabel.text = FORMAT(@"我的好友【%ld】", (long)[UserManager instance].userInfo.memberCount);
//        self.friendHeader.friendLabel.text = @"我的好友";
        return self.friendHeader;
        
    } else {
        UIView *v = [UIView new];
        v.backgroundColor = COLOR_BG_HEADER;
        return v;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 86;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *v = [UIView new];
    v.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    if (section == 0) {
//        return 15;
//    }
    
    return 0;
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
        
        [_tableView registerClass:[TeamBannerCell class]         forCellReuseIdentifier:@"TeamBannerCell"];
//        [_tableView registerClass:[MemberRewardDetailCell self]  forCellReuseIdentifier:@"MemberRewardDetailCell"];
        [_tableView registerClass:[FriendListCell self]  forCellReuseIdentifier:@"FriendListCell"];
        
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

//- (RewardSectionHeaderView *)otherHeader {
//    if (_otherHeader == nil) {
//        _otherHeader = [[RewardSectionHeaderView alloc]init];
//        _otherHeader.frame = CGRectMake(0, 0, SCREEN_WIDTH, 35);
//        _otherHeader.backgroundColor = WHITE_COLOR;
//    }
//    return _otherHeader;
//}

- (FriendSectionHeader *)friendHeader {
    if (_friendHeader == nil) {
        _friendHeader = [[FriendSectionHeader alloc]init];
        _friendHeader.frame = CGRectMake(0, 0, SCREEN_WIDTH, 86);
        _friendHeader.backgroundColor = WHITE_COLOR;
        @weakify(self)
        _friendHeader.actionBlock = ^(int flag){
            @strongify(self)
            self.vipFlag = flag;
            [SVProgressHUD showWithStatus:nil];
            self.pageNo = 1;
            [self requestTeamList];
        };
    }
    return _friendHeader;
}

@end
