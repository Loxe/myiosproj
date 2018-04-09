//
//  InvitedListController.m
//  akucun
//
//  Created by Jarry Zhu on 2017/10/25.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "InvitedListController.h"
#import "MJRefresh.h"
#import "NSString+akucun.h"
#import "RequestInviteList.h"
#import "RequestActiveCode.h"

@interface InvitedListController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataSource;

@property (nonatomic, assign) NSInteger pageNo;

@end

@implementation InvitedListController

- (void) setupContent
{
    [super setupContent];
    self.view.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);

    self.title = @"我的邀请记录";
    
    [self.view addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    //
    @weakify(self)
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self refreshList];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.textColor = LIGHTGRAY_COLOR;
    self.tableView.mj_header = refreshHeader;
    
    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        self.pageNo ++;
        [self getInvitedList:self.pageNo];
    }];
    refreshFooter.stateLabel.textColor = COLOR_TEXT_LIGHT;
    [refreshFooter setTitle:@"正在加载数据中..." forState:MJRefreshStateRefreshing];
    [refreshFooter setTitle:@"已加载完毕" forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = refreshFooter;
    self.tableView.mj_footer.hidden = YES;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [SVProgressHUD showWithStatus:nil];
    [self refreshList];
//    [self requestActiveUser:@"8af54b0e5b5803c8015b581801fc0093" code:@"520BWZ"];
}

- (void) refreshList
{
    [self.tableView.mj_footer resetNoMoreData];
    self.pageNo = 1;
    [self getInvitedList:self.pageNo];
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
    //
    //    [ProductsManager instance].forwardCount = 0;
    //    [self.ec_tabBarController updateBadge:0 atIndex:1];
}

- (void) getInvitedList:(NSInteger)page
{
    RequestInviteList *request = [RequestInviteList new];
    request.pageno = page;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
    {
        [self.tableView.mj_header endRefreshing];
        ResponseInviteList *response = content;
        [self updateDataSource:response.result];
        
    } onFailed:^(id content) {
        [self.tableView.mj_header endRefreshing];
    } onError:^(id content) {
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void) requestActiveUser:(NSString *)userId code:(NSString *)code
{
    [SVProgressHUD showWithStatus:nil];
    
    RequestActiveCode *request = [RequestActiveCode new];
    request.referralcode = code;
    request.ruserid = userId;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
    {
        [SVProgressHUD showSuccessWithStatus:@"该用户已成功开通会员 ！"];
        
        [self refreshList];
        
    } onFailed:^(id content) {
        
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"cellIdentifier";
    InvitedTableCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[InvitedTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    InvitedUser *item = self.dataSource[indexPath.row];
    cell.userItem = item;
    
    @weakify(self)
    cell.actionBlock = ^(InvitedUser *item) {
        @strongify(self)
        [self requestActiveUser:item.ruserid code:item.referralcode];
    };
    
    return cell;
}

#pragma mark - Views

- (UITableView *) tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = CLEAR_COLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
        
        CGSize size1 = [@"Cell" sizeWithFont:[FontUtils buttonFont] maxWidth:SCREEN_WIDTH];
        CGSize size2 = [@"Cell" sizeWithFont:[FontUtils smallFont] maxWidth:SCREEN_WIDTH];
        CGFloat offset = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
        _tableView.rowHeight = size1.height + size2.height + offset*3.0f + 50;

        _tableView.delegate = self;
        _tableView.dataSource = self;
        
#ifdef XCODE9VERSION
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
        }
#endif
    }
    return _tableView;
}

@end

@implementation InvitedTableCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.backgroundColor = CLEAR_COLOR;
    self.contentView.backgroundColor = WHITE_COLOR;
    
    self.textLabel.textColor = COLOR_TEXT_DARK;
    self.textLabel.font = [FontUtils buttonFont];

    self.detailTextLabel.backgroundColor = RED_COLOR;
    self.detailTextLabel.textColor = COLOR_TEXT_NORMAL;
    self.detailTextLabel.font = [FontUtils smallFont];
    
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.activeButton];
    
    CGFloat offset = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(offset);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textLabel);
        make.top.equalTo(self.textLabel.mas_bottom).offset(offset*0.8f);
    }];
    [self.activeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.equalTo(@(40));
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.bottom.equalTo(self).offset(-offset);
    }];

    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0.0f, SCREEN_WIDTH, 0.5f)];
    topLine.backgroundColor = COLOR_SEPERATOR_LINE;
    [self.contentView addSubview:topLine];
    
    _seperatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, kTableCellHeight-1.0f, SCREEN_WIDTH, 0.5f)];
    _seperatorLine.backgroundColor = COLOR_SEPERATOR_LINE;
    [self.contentView addSubview:_seperatorLine];
    
    return self;
}

- (void) setUserItem:(InvitedUser *)userItem
{
    _userItem = userItem;
    
    self.textLabel.text = FORMAT(@"%@  (%@)", userItem.nicheng, userItem.yonghubianhao);
    self.timeLabel.text = userItem.createtime;
    
    if (userItem.statu > 0) {
        self.activeButton.backgroundColor = RGBCOLOR(0xE9, 0xE9, 0xE9);
        [self.activeButton setNormalColor:COLOR_TEXT_NORMAL];
        [self.activeButton setNormalTitle:@"已开通"];
        self.activeButton.enabled = NO;
    }
    else {
        self.activeButton.backgroundColor = COLOR_APP_RED;
        [self.activeButton setNormalColor:WHITE_COLOR];
        [self.activeButton setNormalTitle:@"开通会员"];
        self.activeButton.enabled = YES;
    }
}

- (IBAction) activeAction:(id)sender
{
    if (self.actionBlock) {
        self.actionBlock(self.userItem);
    }
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat offset = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
    self.seperatorLine.bottom = self.height-offset;
}

- (UILabel *) timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [FontUtils smallFont];
        _timeLabel.textColor = COLOR_TEXT_NORMAL;
    }
    return _timeLabel;
}

- (UIButton *) activeButton
{
    if (!_activeButton) {
        _activeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _activeButton.backgroundColor = COLOR_APP_RED;
        
        _activeButton.titleLabel.font = [FontUtils normalFont];
        [_activeButton setNormalColor:WHITE_COLOR highlighted:COLOR_TEXT_LIGHT selected:nil];
        [_activeButton setNormalTitle:@"开通会员"];
        
        [_activeButton addTarget:self action:@selector(activeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _activeButton;
}

@end
