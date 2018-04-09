//
//  MyTeamController.m
//  akucun
//
//  Created by deepin do on 2018/1/16.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "MyTeamController.h"
#import "MJRefresh.h"
#import "UserManager.h"
#import "TeamRebateDetailController.h"
#import "WebViewController.h"
#import "TeamBannerCell.h"
#import "TeamHeaderCell.h"
#import "MemberRewardDetailCell.h"
#import "RewardSumBaseCell.h"
#import "RewardSectionHeaderView.h"
#import "RequestTeamDetail.h"
#import "ResponseTeamDetail.h"
#import "RequestTeamMembers.h"
#import "ResponseTeamList.h"
#import "VideoPreViewController.h"
#import "UINavigationController+WXSTransition.h"

@interface MyTeamController ()<UITableViewDataSource,UITableViewDelegate,RewardSumBaseCellDelegate>

@property (nonatomic, strong) UITableView  *tableView;

@property (nonatomic, strong) RewardSectionHeaderView *myHeader;
@property (nonatomic, strong) RewardSectionHeaderView *otherHeader;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger      pageNo;

@property (nonatomic, strong) NSMutableArray     *priceArray;
@property (nonatomic, strong) ResponseTeamDetail *response;

@property (nonatomic, assign) NSInteger          rewardTotal;

@end

@implementation MyTeamController

- (void) setupContent
{
    [super setupContent];
    
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
        [self requestTeamInfo];
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
    
    self.title = @"我的团队";
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
        [self requestTeamInfo];
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

- (void) requestTeamInfo
{
    RequestTeamDetail *request = [RequestTeamDetail new];
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [self.tableView.mj_header endRefreshing];
         ResponseTeamDetail *response = content;
         
         self.rewardTotal = response.rewardTotal;
         NSNumber *todoRewardNum  = [NSNumber numberWithInteger:response.todoReward];
         NSNumber *rewardTotalNum = [NSNumber numberWithInteger:response.rewardTotal];
         self.priceArray = [NSMutableArray arrayWithArray:@[todoRewardNum, rewardTotalNum]];
         
         self.response = response;
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

- (void) requestTeamList
{
    RequestTeamMembers *request = [RequestTeamMembers new];
    request.pageno = self.pageNo;
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [self.tableView.mj_header endRefreshing];
         ResponseTeamList *response = content;
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 3) {
        return self.dataSource.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    @weakify(self)
    if (indexPath.section == 0) {
        TeamBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamBannerCell" forIndexPath:indexPath];
        
        cell.playBtn.hidden = [NSString isEmpty:self.response.videoUrl];
        cell.detailBtn.hidden = [NSString isEmpty:self.response.ruleUrl];

        @weakify(cell)
        cell.playBlock = ^(id nsobject) {
            @strongify(self)
            @strongify(cell)
            // Calucate the toRect
            CGRect rect = [cell.BGImgView convertRect:cell.BGImgView.bounds toView:self.view];
            CGFloat w = rect.size.width;
            CGFloat h = rect.size.height;
            
            NSString *wStr     = [NSString stringWithFormat:@"%0.2f",w];
            CGFloat wf = [wStr floatValue];
            
            NSString *hStr     = [NSString stringWithFormat:@"%0.2f",h];
            CGFloat hf = [hStr floatValue];
            
            CGFloat scalePercent = hf / wf;
            CGFloat newScaleH = scalePercent * ([UIScreen mainScreen].bounds.size.width);
            CGRect toRect = CGRectMake(0, ([UIScreen mainScreen].bounds.size.height-newScaleH)*0.5, [UIScreen mainScreen].bounds.size.width, newScaleH);

            VideoPreViewController *vc = [[VideoPreViewController alloc]init];
            vc.showRect  = toRect;
//            vc.videoPath = @"http://cms.oss.aikucun.com/market/1516879850.mp4";
//            vc.coverPath = @"http://d.hiphotos.baidu.com/image/pic/item/a044ad345982b2b713b5ad7d3aadcbef76099b65.jpg";
            /*
            NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"team" ofType:@"mp4"];
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"teamPage" ofType:@"png"];
            vc.videoPath = videoPath;
            vc.coverPath = imagePath;
            */
            vc.vid       = nil;
            vc.videoPath = self.response.videoUrl;

            __weak VideoPreViewController *weakVC = vc;
            [self wxs_presentViewController:vc makeTransition:^(WXSTransitionProperty *transition) {
                transition.animationType = WXSTransitionAnimationTypeViewMoveToNextVC;
                transition.animationTime = 0.4;
                transition.startView  = cell.imageView;
                transition.targetView = weakVC.dumyView;
            }];
        };
        
        cell.detailBlock = ^(id nsobject) {
            @strongify(self)
            WebViewController *controller = [WebViewController new];
            controller.title = @"团队返利规则";
            controller.url = self.response.ruleUrl;
//            controller.url = FORMAT(@"%@/teaminviterule.do?action=teamrule", kHTTPServer);
            [self.navigationController pushViewController:controller animated:YES];
        };
        
        return cell;
        
    } else if (indexPath.section == 1) {
        TeamHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamHeaderCell" forIndexPath:indexPath];
        
        cell.response = self.response;

        return cell;
        
    } else if (indexPath.section == 2) {
        RewardSumBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RewardSumBaseCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.nameArray  = [NSMutableArray arrayWithArray:@[@" 待入账返利", @" 累积返利金额"]];
        cell.priceArray = self.priceArray;
        [cell.collectionView reloadData];

        return cell;
        
    } else {
        MemberRewardDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberRewardDetailCell" forIndexPath:indexPath];
        cell.model = self.dataSource[indexPath.row];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 306*SCREEN_WIDTH/621; // 根据图片实际尺寸算的，避免变形
    }
    else if (indexPath.section == 1) {
        return 260;
    }
    else if (indexPath.section == 2) {
        //return 100;
        return kRewardItemH+2.5*kOFFSET_SIZE;
    }
    else {
        return 30+kOFFSET_SIZE*2;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        [self.myHeader initWithTitle:@"我的返利" count:-1 actionTitle:@""];
        self.myHeader.clickBlock = ^(id nsobject) {
        };
        return self.myHeader;
        
    } else if (section == 3) {
        NSString *title = FORMAT(@"团队成员贡献【%ld人】",(long)[UserManager instance].userInfo.memberCount);
        [self.otherHeader initWithTitle:title count:-1  actionTitle:@""];

        return self.otherHeader;
        
    } else {
        UIView *v = [UIView new];
        v.backgroundColor = COLOR_BG_HEADER;
        return v;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 0;
    } else {
        return 35;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *v = [UIView new];
    v.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 15;
    } else if (section == 2) {
        return 15;
    }
    
    return 0;
}

#pragma mark - RewardSumBaseCellDelegate
- (void)didSelectRewardSumBaseCellTag:(NSInteger)index {
    if (self.rewardTotal > 0) {
        TeamRebateDetailController *vc = [TeamRebateDetailController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
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
        [_tableView registerClass:[TeamHeaderCell class]         forCellReuseIdentifier:@"TeamHeaderCell"];
        [_tableView registerClass:[RewardSumBaseCell class]      forCellReuseIdentifier:@"RewardSumBaseCell"];
        [_tableView registerClass:[MemberRewardDetailCell self]  forCellReuseIdentifier:@"MemberRewardDetailCell"];
        
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

- (RewardSectionHeaderView *)myHeader {
    if (_myHeader == nil) {
        _myHeader = [[RewardSectionHeaderView alloc]init];
        _myHeader.frame = CGRectMake(0, 0, SCREEN_WIDTH, 35);
        _myHeader.backgroundColor = WHITE_COLOR;
    }
    return _myHeader;
}

- (RewardSectionHeaderView *)otherHeader {
    if (_otherHeader == nil) {
        _otherHeader = [[RewardSectionHeaderView alloc]init];
        _otherHeader.frame = CGRectMake(0, 0, SCREEN_WIDTH, 35);
        _otherHeader.backgroundColor = WHITE_COLOR;
    }
    return _otherHeader;
}

- (NSMutableArray *)priceArray {
    if (_priceArray == nil) {
        _priceArray = [NSMutableArray arrayWithArray:@[@0.0, @0.0]];
    }
    return _priceArray;
}

@end
