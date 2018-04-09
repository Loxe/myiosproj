//
//  OrderLivesController.m
//  akucun
//
//  Created by Jarry Z on 2018/1/22.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "OrderLivesController.h"
#import "MJRefresh.h"
#import "UIScrollView+EmptyDataSet.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "RequestUserLives.h"
#import "TextButton.h"


@interface OrderLivesController () <UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) TextButton *liveButton;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray* dataSource;
@property (nonatomic, assign) NSInteger pageNo;

@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation OrderLivesController

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.dataSource) {
        [SVProgressHUD showWithStatus:nil];
        self.pageNo = 1;
        [self requestListData];
    }
}

- (IBAction) selectLiveAction:(id)sender
{
    if (!self.liveButton.showImage) {
        return;
    }
    self.liveButton.showImage = NO;
    [self.liveButton setNormalTitle:@"请选择活动品牌"];
    [self.liveButton setImage:nil forState:UIControlStateNormal];
    
    [UIView animateWithDuration:.2f animations:^{
//        self.tableView.top = kOrderLivesTopHeight;
        self.view.height = self.viewHeight;
        self.tableView.frame = CGRectMake(0, kOrderLivesTopHeight, SCREEN_WIDTH, self.viewHeight-44-kSafeAreaBottomHeight-kOrderLivesTopHeight);
    }];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = WHITE_COLOR; //RGBCOLOR(0xF5, 0xF5, 0xF5);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:self.tableView];
    
    self.liveButton.hidden = YES;
    [self.view addSubview:self.liveButton];
    
    // 设置下拉刷新，上拉加载
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

- (void) updateDataSource:(NSArray *)array
{
    if (!self.dataSource) {
        self.selectedIndex = -1;
        self.dataSource = [NSMutableArray array];
    }
    else if (self.pageNo == 1) {
        self.selectedIndex = -1;
        [self.dataSource removeAllObjects];
    }
    
    [SVProgressHUD dismiss];
    
    if (array.count == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView reloadData];
        return;
    }
    
    [self.dataSource addObjectsFromArray:array];
    
    if (self.dataSource.count > 0) {
        self.liveButton.hidden = NO;
        self.tableView.frame = CGRectMake(0, kOrderLivesTopHeight, SCREEN_WIDTH, self.viewHeight-44-kSafeAreaBottomHeight-kOrderLivesTopHeight);
    }
    
    [self updateTableData];
}

- (void) updateTableData
{
    self.tableView.mj_footer.hidden = (self.dataSource.count < kPAGE_SIZE);
    if (self.dataSource.count >= kPAGE_SIZE) {
        [self.tableView.mj_footer endRefreshing];
    }
    [self.tableView reloadData];
}

- (void) requestListData
{
    RequestUserLives *request = [RequestUserLives new];
    request.pageno = self.pageNo;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
    {
        [self.tableView.mj_header endRefreshing];
        ResponseUserLives *response = content;
        [self updateDataSource:response.result];
        
    } onFailed:^(id content) {
        [self.tableView.mj_header endRefreshing];
    } onError:^(id content) {
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableCellHeight*1.2f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return .1f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kPIXEL_WIDTH;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kPIXEL_WIDTH)];
    header.backgroundColor = COLOR_SEPERATOR_LINE;
    //    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0.0f, header.width, 0.5f)];
    //    line.backgroundColor = COLOR_SEPERATOR_LINE;
    //    [header addSubview:line];
    return header;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"OrderLiveTableCell";
    OrderLiveTableCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[OrderLiveTableCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.row == self.dataSource.count-1) {
        cell.showSeperator = NO;
    }
    
    LiveInfo *liveInfo = self.dataSource[indexPath.row];
    cell.liveInfo = liveInfo;
    
    cell.checked = (indexPath.row == self.selectedIndex);

    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectedIndex = indexPath.row;
    [self.tableView reloadData];
    
    LiveInfo *liveInfo = self.dataSource[indexPath.row];
    [self.liveButton setNormalTitle:liveInfo.pinpaiming];
    self.liveButton.showImage = YES;
    [self.liveButton sd_setImageWithURL:[NSURL URLWithString:liveInfo.pinpaiurl]
                               forState:UIControlStateNormal
                       placeholderImage:nil
                                options:SDWebImageDelayPlaceholder];
    
    [UIView animateWithDuration:.2f animations:^{
        self.tableView.top = -SCREEN_WIDTH;
        self.view.height = kOrderLivesTopHeight;
    }];
 
    if (self.selectBlock) {
        self.selectBlock(liveInfo);
    }

}

#pragma mark - Views

- (TextButton *) liveButton
{
    if (_liveButton) {
        return _liveButton;
    }
    
    _liveButton = [TextButton buttonWithType:UIButtonTypeCustom];
    _liveButton.backgroundColor = WHITE_COLOR;
    _liveButton.frame = CGRectMake(0, 0, SCREEN_WIDTH, kOrderLivesTopHeight);
    _liveButton.titleEdgeInsets = UIEdgeInsetsMake(0, kOFFSET_SIZE, 0, kOFFSET_SIZE);
    
    [_liveButton setTitleFont:[FontUtils normalFont]];
    [_liveButton setNormalColor:COLOR_SELECTED highlighted:COLOR_TEXT_LIGHT selected:nil];
    [_liveButton setNormalTitleColor:nil disableColor:COLOR_TEXT_LIGHT];
    [_liveButton setNormalTitle:@"请选择活动品牌"];
    _liveButton.imageSize = 26;
    
    //
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kOrderLivesTopHeight-kPIXEL_WIDTH, SCREEN_WIDTH, kPIXEL_WIDTH)];
    line.backgroundColor = COLOR_SEPERATOR_LINE;
    [_liveButton addSubview:line];
    
    UIImageView *arrowImage = [[UIImageView alloc] init];
    arrowImage.frame = CGRectMake(SCREEN_WIDTH-kOFFSET_SIZE-20, 0, 20, kOrderLivesTopHeight);
    arrowImage.image = [IMAGENAMED(@"icon_down_arrow") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    arrowImage.tintColor = COLOR_MAIN;
    arrowImage.contentMode = UIViewContentModeCenter;
    [_liveButton addSubview:arrowImage];

    [_liveButton addTarget:self action:@selector(selectLiveAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return _liveButton;
}

- (UITableView *) tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = CLEAR_COLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
        _tableView.showsVerticalScrollIndicator = NO;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
        }
    }
    return _tableView;
}

#pragma mark - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate

- (NSAttributedString *) titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"您还没有下单记录哦";
    NSDictionary *attributes = @{NSFontAttributeName : [FontUtils normalFont],
                                 NSForegroundColorAttributeName : COLOR_TEXT_LIGHT };
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *) imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return IMAGENAMED(@"image_order");
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

@end

#pragma mark -

@implementation OrderLiveTableCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    self.detailTextLabel.backgroundColor = CLEAR_COLOR;
    self.detailTextLabel.textColor = COLOR_APP_RED;
    self.detailTextLabel.font = FA_ICONFONTSIZE(16);
    
    self.seperatorLine.backgroundColor = COLOR_SEPERATOR_LIGHT;
    
    [self.contentView addSubview:self.logoImage];
    [self.contentView addSubview:self.timeLabel];

    return self;
}

- (void) setLiveInfo:(LiveInfo *)liveInfo
{
    _liveInfo = liveInfo;
    
    self.textLabel.text = liveInfo.pinpaiming;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:liveInfo.begintimestamp];
    self.timeLabel.text = [date formattedDateWithFormatString:@"M月dd日"] ;
    [self.timeLabel sizeToFit];
    
    [self.logoImage sd_setImageWithURL:[NSURL URLWithString:liveInfo.pinpaiurl] placeholderImage:nil];
}

- (void) setChecked:(BOOL)checked
{
    _checked = checked;
    
    self.detailTextLabel.text = checked ? FA_ICONFONT_SELECT : @"";
    self.textLabel.textColor = checked ? COLOR_SELECTED : COLOR_TEXT_NORMAL;
    self.timeLabel.textColor = checked ? COLOR_SELECTED : COLOR_TEXT_NORMAL;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.logoImage.frame = CGRectMake(kOFFSET_SIZE, (self.height-30)/2.0f, 30, 30);
    self.textLabel.left = self.logoImage.right + kOFFSET_SIZE;
    self.textLabel.top = self.logoImage.top-2;
    
    self.timeLabel.left = self.textLabel.left;
    self.timeLabel.bottom = self.logoImage.bottom+2;
}

- (UIImageView *) logoImage
{
    if (!_logoImage) {
        CGFloat top = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
        _logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(kOFFSET_SIZE, top, 30, 30)];
        _logoImage.backgroundColor = WHITE_COLOR;
        _logoImage.contentMode = UIViewContentModeScaleAspectFit;
        _logoImage.clipsToBounds = YES;
        _logoImage.userInteractionEnabled = YES;
        
        _logoImage.layer.cornerRadius = 3.0f;
        _logoImage.layer.borderColor = COLOR_SEPERATOR_LIGHT.CGColor;
        _logoImage.layer.borderWidth = kPIXEL_WIDTH;
    }
    return _logoImage;
}

- (UILabel *) timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = BOLDSYSTEMFONT(9);
        _timeLabel.textColor = COLOR_TEXT_NORMAL;
    }
    return _timeLabel;
}

@end
