//
//  InviteViewController.m
//  akucun
//
//  Created by deepin do on 2018/1/16.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "InviteViewController.h"
#import "MJRefresh.h"
#import "MyCodeController.h"
#import "MyTeamController.h"
#import "WebViewController.h"
#import "InviteRewardDetailController.h"
#import "TableCellBase.h"
#import "InviteHeaderCell.h"
#import "InviteWaitCell.h"
#import "RewardSumBaseCell.h"
#import "RewardSectionHeaderView.h"
#import "UIImageView+WebCache.h"
#import "RequestUserInvite.h"
#import "ResponseInviteLists.h"
#import "InvitingUser.h"
#import "RequestActiveCode.h"
#import "UserManager.h"

//#import "ABMediaView.h"
//#import "VideoShowController.h"
#import "UINavigationController+WXSTransition.h"
#import "VideoPreViewController.h"

@interface InviteViewController ()<UITableViewDataSource,UITableViewDelegate,RewardSumBaseCellDelegate>

@property (nonatomic, strong) UITableView  *tableView;
@property (nonatomic, strong) UIButton     *inviteButton;
//@property (nonatomic, strong) ABMediaView  *mediaView;

@property (nonatomic, strong) RewardSectionHeaderView *invitingHeader;
@property (nonatomic, strong) RewardSectionHeaderView *invitedHeader;

@property (nonatomic, strong) NSMutableArray *dataSource;         // 待批准邀请数组
//@property (nonatomic, assign) BOOL           isWaitingInvite;     // 是否有待批准邀请
@property (nonatomic, assign) NSInteger      pageNo;

@property (nonatomic, assign) NSInteger memberCount;        // 已邀请用户数
@property (nonatomic, assign) NSInteger toInviteCount;      // 待邀请用户数
@property (nonatomic, assign) NSInteger todoReward;         // 待入账邀请奖励金额
@property (nonatomic, assign) NSInteger rewardTotal;        // 已入账邀请奖励金额

@property (nonatomic, strong) NSMutableArray   *priceArray;  // 已经邀请数组
@property (nonatomic, strong) NSMutableArray   *nameArray;

@property(nonatomic, copy) NSString *videoUrl;
@property(nonatomic, copy) NSString *ruleUrl;

@end

@implementation InviteViewController

- (void) setupContent
{
    [super setupContent];
    
    // 初始化
    UserInfo *userInfo = [UserManager instance].userInfo;
    self.memberCount = userInfo.memberCount;
    self.toInviteCount = userInfo.inviteCount;
    
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
    if (!self.dataSource) {
        [SVProgressHUD showWithStatus:nil];
        [self requestUserInfo];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)showUserGuide {
    if (![self isVisible]) {
        return;
    }
    
    if (self.toInviteCount > 0 && self.dataSource.count > 0) {
        InviteWaitCell *cell = (InviteWaitCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        if (!cell ) {
            return;
        }
        
        [cell showUserGuide];
    }
}

- (void)prepareNav {
    
    self.view.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = @"邀请好友";
}

- (void)prepareSubView {
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.inviteButton];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    CGFloat height = isPad ? kFIELD_HEIGHT_PAD : 44;
    [self.inviteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(@(height+kSafeAreaBottomHeight));
    }];
    
    @weakify(self)
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self.tableView.mj_footer resetNoMoreData];
        self.tableView.mj_footer.hidden = YES;
        self.pageNo = 1;
        [self requestUserInfo];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.textColor = LIGHTGRAY_COLOR;
    self.tableView.mj_header = refreshHeader;
}

- (void) requestUserInfo
{
    RequestUserInvite *request = [RequestUserInvite new];
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
    {
        [self.tableView.mj_header endRefreshing];
        ResponseInviteLists *response = content;
        
        self.toInviteCount = response.result.count;
        self.memberCount   = response.memberCount;
        self.todoReward    = response.todoReward;
        self.rewardTotal   = response.rewardTotal;
        
        self.videoUrl = response.videoUrl;
        self.ruleUrl = response.ruleUrl;
        
        NSNumber *todoRewardNum  = [NSNumber numberWithInteger:self.todoReward];
        NSNumber *rewardTotalNum = [NSNumber numberWithInteger:self.rewardTotal];
        self.priceArray = [NSMutableArray arrayWithArray:@[todoRewardNum, rewardTotalNum]];
        [self updateDataSource:response.result];
        
        //
        [UserManager instance].userInfo.inviteCount = self.toInviteCount;
        [UserManager instance].userInfo.memberCount = self.memberCount;
        
        if (response.result.count > 0) {
            GCD_DELAY(^{
                [self showUserGuide];
            }, .3f);
        }
    
    } onFailed:^(id content)
    {
        [self.tableView.mj_header endRefreshing];
    } onError:^(id content)
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
//        self.isWaitingInvite = NO;
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView reloadData];
        return;
    }
    
//    self.isWaitingInvite = YES;
    [self.dataSource addObjectsFromArray:dataArray];
    
    self.tableView.mj_footer.hidden = (self.dataSource.count < 20);
    if (self.dataSource.count >= 20) {
        [self.tableView.mj_footer endRefreshing];
    }
    [self.tableView reloadData];
}

- (void) requestActiveUser:(NSString *)userId code:(NSString *)code
{
    [SVProgressHUD showWithStatus:nil];
    
    RequestActiveCode *request = [RequestActiveCode new];
    request.referralcode = code;
    request.ruserid      = userId;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [SVProgressHUD showSuccessWithStatus:@"批准成功 ！"];
         [self requestUserInfo];
         
     } onFailed:^(id content) {
         
     }];
}

- (void)invite:(UIButton *)btn {
    MyCodeController *vc = [MyCodeController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        if (self.toInviteCount == 0) {
            return 1;
        }
        return self.toInviteCount;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    @weakify(self)
    if (indexPath.section == 0) {
        
        InviteHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InviteHeaderCell" forIndexPath:indexPath];
        
        cell.playBtn.hidden = [NSString isEmpty:self.videoUrl];
        cell.detailBtn.hidden = [NSString isEmpty:self.ruleUrl];
        
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
            
            // 播放视频
            VideoPreViewController *vc = [[VideoPreViewController alloc]init];
            vc.showRect  = toRect;
            /*
            NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"invite" ofType:@"mp4"];
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"invitePage" ofType:@"png"];
            vc.videoPath = videoPath;
//            vc.coverPath = @"http://d.hiphotos.baidu.com/image/pic/item/a044ad345982b2b713b5ad7d3aadcbef76099b65.jpg";
            vc.coverPath = imagePath;
            */
            vc.vid       = nil;
            vc.videoPath = self.videoUrl;
            
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
            controller.title = @"邀请奖励规则";
            controller.url = self.ruleUrl;
//            controller.url = FORMAT(@"%@/teaminviterule.do?action=inviterule", kHTTPServer);
            [self.navigationController pushViewController:controller animated:YES];
        };
        
        return cell;
        
    } else if (indexPath.section == 1) {
        
        if (self.toInviteCount == 0) {
            TableCellBase *cell = [[TableCellBase alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.showSeperator = NO;
            cell.selectionDisabled = YES;
            cell.textLabel.font = [FontUtils smallFont];
            cell.textLabel.textColor = COLOR_TEXT_LIGHT;
            cell.textLabel.text = @"暂无待批准成员";
            return cell;
        }
        
        InviteWaitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InviteWaitCell" forIndexPath:indexPath];
        InvitingUser *model = self.dataSource[indexPath.row];
        if (model.avatar && model.avatar.length > 0) {
            [cell.avatorImgView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
        }
        else {
            cell.avatorImgView.image = [UIImage imageNamed:@"userAvator"];
        }
        cell.nameLabel.text = model.nick;
        [cell.nameLabel sizeToFit];
//        [cell.nameLabel showBadgeWithStyle:WBadgeStyleNew value:1 animationType:WBadgeAnimTypeBounce];
        [cell.avatorImgView showBadgeWithStyle:WBadgeStyleNew value:1 animationType:WBadgeAnimTypeBounce];
        
        cell.approveBlock = ^(id nsobject) {
            @strongify(self)
            NSString *referralcode = [UserManager instance].userInfo.preferralcode;
            [self requestActiveUser:model.invitingId code:referralcode];
        };
        
        return cell;
        
    } else {
        RewardSumBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RewardSumBaseCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.nameArray   = self.nameArray;
        cell.priceArray  = self.priceArray;
        [cell.collectionView reloadData];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 306*SCREEN_WIDTH/621; // 根据图片实际尺寸算的，避免变形
    }
    else if (indexPath.section == 1) {
        return 60;
    }
    else {
        //return 100;
        return kRewardItemH+2.5*kOFFSET_SIZE;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        [self.invitingHeader initWithTitle:@"待批准邀请：" count:self.toInviteCount actionTitle:@""];
        self.invitingHeader.nameLabel.textColor = COLOR_MAIN;
        
        return self.invitingHeader;
        
    } else if (section == 2) {
        
//        NSString *titleStr  = [NSString stringWithFormat:@"已邀请成员： %ld",self.memberCount];
        NSString *actionStr = self.memberCount > 0 ? @"我的团队" : @"";
        [self.invitedHeader initWithTitle:@"已邀请成员：" count:self.memberCount actionTitle:actionStr];
        
        if (self.memberCount > 0) {
            @weakify(self)
            self.invitedHeader.clickBlock = ^(id nsobject) {
                @strongify(self)
                MyTeamController *vc = [MyTeamController new];
                [self.navigationController pushViewController:vc animated:YES];
            };
        } else {
            self.invitedHeader.clickBlock = ^(id nsobject) {
            };
        }
        return self.invitedHeader;
        
    } else {
        
        UIView *v = [UIView new];
        v.backgroundColor = COLOR_BG_HEADER;
        return v;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return 30;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *v = [UIView new];
    v.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kPIXEL_WIDTH)];
    line.backgroundColor = COLOR_SEPERATOR_LIGHT;
    [v addSubview:line];
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return kPIXEL_WIDTH;
    }
    return 15;
}

#pragma mark - RewardSumBaseCellDelegate
- (void)didSelectRewardSumBaseCellTag:(NSInteger)index {
    if (self.rewardTotal > 0) {
        InviteRewardDetailController *vc = [InviteRewardDetailController new];
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
        
        [_tableView registerClass:[InviteHeaderCell class] forCellReuseIdentifier:@"InviteHeaderCell"];
        [_tableView registerClass:[InviteWaitCell self]    forCellReuseIdentifier:@"InviteWaitCell"];
        [_tableView registerClass:[RewardSumBaseCell class]   forCellReuseIdentifier:@"RewardSumBaseCell"];
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
        }
    }
    return _tableView;
}

- (UIButton *)inviteButton {
    if (!_inviteButton) {
        _inviteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _inviteButton.frame = CGRectMake(20, kOFFSET_SIZE, SCREEN_WIDTH - 40, isPad ? 50 : kFIELD_HEIGHT);
        _inviteButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, kSafeAreaBottomHeight*0.5, 0);
        
        _inviteButton.titleLabel.font = BOLDSYSTEMFONT(16);
        [_inviteButton setNormalColor:WHITE_COLOR highlighted:COLOR_TEXT_LIGHT selected:nil];
        [_inviteButton setBackgroundColor:COLOR_SELECTED];
        [_inviteButton setNormalTitle:@"立即邀请"];
        
        [_inviteButton addTarget:self action:@selector(invite:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _inviteButton;
}

- (RewardSectionHeaderView *)invitingHeader {
    if (_invitingHeader == nil) {
        _invitingHeader = [[RewardSectionHeaderView alloc]init];
        _invitingHeader.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
        _invitingHeader.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    }
    return _invitingHeader;
}

- (RewardSectionHeaderView *)invitedHeader {
    if (_invitedHeader == nil) {
        _invitedHeader = [[RewardSectionHeaderView alloc]init];
        _invitedHeader.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
        _invitedHeader.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    }
    return _invitedHeader;
}

- (NSMutableArray *)priceArray {
    if (_priceArray == nil) {
        _priceArray = [NSMutableArray arrayWithArray:@[@0.0, @0.0]];
    }
    return _priceArray;
}

- (NSMutableArray *)nameArray {
    if (_nameArray == nil) {
        _nameArray = [NSMutableArray arrayWithArray:@[@" 待入账奖励", @" 已奖励金额"]];
    }
    return _nameArray;
}

@end
