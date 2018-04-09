//
//  InviteFriendListController.m
//  akucun
//
//  Created by deepin do on 2018/2/26.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "InviteFriendListController.h"
#import "MJRefresh.h"
#import "UserManager.h"
#import "InviteCodeCell.h"
#import "InviteFriendController.h"
#import "RequestRefCodeList.h"


@interface InviteFriendListController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *bannerImgView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation InviteFriendListController

- (void) setupContent
{
    [super setupContent];
    
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
        [self requestCodeList];
//    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)prepareNav {
    
    self.view.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = @"邀请好友";
}

- (void)prepareSubView {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    self.bannerImgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 273*SCREEN_WIDTH/621);
    self.tableView.tableHeaderView = self.bannerImgView;
    
    @weakify(self)
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self.tableView.mj_footer resetNoMoreData];
        self.tableView.mj_footer.hidden = YES;
        [self requestCodeList];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.textColor = LIGHTGRAY_COLOR;
    self.tableView.mj_header = refreshHeader;
}

- (void) requestCodeList
{
    RequestRefCodeList *request = [RequestRefCodeList new];
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [self.tableView.mj_header endRefreshing];
         ResponseRefcodeList *response = content;
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
    else {
        [self.dataSource removeAllObjects];
    }
    
    [SVProgressHUD dismiss];
    
    [self.dataSource addObjectsFromArray:dataArray];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InviteCodeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InviteCodeCell" forIndexPath:indexPath];

    RefCode *code = self.dataSource[indexPath.row];
    cell.refCode = code;
    
    @weakify(self)
    cell.shareBlock = ^(id nsobject) {
        @strongify(self)
        InviteFriendController *vc = [InviteFriendController new];
        vc.code = code.referralcode;
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kAvatorWH+kOFFSET_SIZE*2.5 ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [[UIView alloc]init];
    v.frame = CGRectMake(0, 0, SCREEN_WIDTH, 35);
    v.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    
    UILabel *l = [[UILabel alloc]init];
    l.frame = CGRectMake(kOFFSET_SIZE, 0, SCREEN_WIDTH, 35);
    l.textAlignment = NSTextAlignmentLeft;
    [v addSubview:l];
    
    NSString *prefixStr = @"本月邀请码: ";
    NSInteger count     = self.dataSource.count; // 这个根据实际数据来
    NSString *countStr  = FORMAT(@"%ld",count);
    if (count == 0) {
        countStr = @"--";
    }
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:FORMAT(@"%@%@ 个",prefixStr,countStr)];
    [attStr addAttribute:NSForegroundColorAttributeName
                   value:COLOR_TEXT_NORMAL
                   range:NSMakeRange(0, attStr.length)];
    [attStr addAttribute:NSFontAttributeName
                   value:SYSTEMFONT(14)
                   range:NSMakeRange(0, attStr.length)];
    [attStr addAttribute:NSForegroundColorAttributeName
                   value:COLOR_MAIN
                   range:NSMakeRange(prefixStr.length, countStr.length)];
    [attStr addAttribute:NSFontAttributeName
                   value:BOLDSYSTEMFONT(14)
                   range:NSMakeRange(prefixStr.length, countStr.length)];
    l.attributedText = attStr;
    
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

#pragma mark - LAZY
- (UIImageView *)bannerImgView {
    if (_bannerImgView == nil) {
        _bannerImgView = [[UIImageView alloc]init];
        _bannerImgView.image = [UIImage imageNamed:@"inviteFriendBanner"];
        _bannerImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _bannerImgView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = RGBCOLOR(240, 240, 240);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[InviteCodeCell class] forCellReuseIdentifier:@"InviteCodeCell"];
        
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


@end
