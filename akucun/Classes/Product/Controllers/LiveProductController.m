//
//  LiveProductController.m
//  akucun
//
//  Created by Jarry Zhu on 2017/12/21.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "LiveProductController.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "ProductTableCell.h"
#import "LiveTableCell.h"
#import "ProductsManager.h"
#import "UserManager.h"
#import "MJRefresh.h"
#import "ShareActivity.h"
#import "AKShareConfirm.h"
#import "NoticeView.h"
#import "NavTitleButton.h"
#import "PopupLivesView.h"
#import "RequestLiveProducts.h"
#import "RequestTrackSku.h"

@interface LiveProductController ()
{
    NSInteger _scrollIndex;
}

@property (nonatomic, strong) NoticeView* noticeView;
@property (nonatomic, strong) UIButton *updatedView;
@property (nonatomic, strong) NavTitleButton *titleButton;

@property (nonatomic, strong) YugaoCellLayout *liveCellLayout;

@property (nonatomic, strong) NSTimer   *liveTimer;

@property (nonatomic, assign) BOOL isSynced;

@end

@implementation LiveProductController

- (void) initViewData
{
    [self.view addSubview:self.noticeView];
    [self.view addSubview:self.tableView];
//    [self.view addSubview:self.commentView];
    [self.view addSubview:self.updatedView];
    
//    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_bottom).offset(kBOTTOM_BAR_HEIGHT);
//        make.width.equalTo(self.view.mas_width);
//        make.height.equalTo(@(kEDIT_BAR_HEIGHT));
//    }];
    
    //
    @weakify(self)
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self reloadProducts];
//        [self requestSyncProducts];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.textColor = LIGHTGRAY_COLOR;
    self.tableView.mj_header = refreshHeader;
    
    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        NSArray *products = [ProductsManager loadProductsStartWith:self.dataSource.count liveId:self.liveInfo.liveid];
        [self updateDataSource:products];
    }];
    refreshFooter.stateLabel.textColor = COLOR_TEXT_LIGHT;
    [refreshFooter setTitle:@"正在加载数据中..." forState:MJRefreshStateRefreshing];
    [refreshFooter setTitle:@"已加载完毕" forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = refreshFooter;
    self.tableView.mj_footer.hidden = YES;
    
    //
    self.dataSource = [NSMutableArray array];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSyncProducts) name:NOTIFICATION_SYNC_COMPLETE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterForeground:) name:NOTIFICATION_APP_FOREGROUND object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground:) name:NOTIFICATION_APP_BACKGROUND object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldSyncLiveData:) name:NOTIFICATION_SYNC_LIVEDATA object:nil];
}

- (void) didEnterBackground:(NSNotification *)notification
{
    [self stopTimer];
}

- (void) didEnterForeground:(NSNotification *)notification
{
    if ([self isVisible]) {

        if (!self.dataSource || self.dataSource.count == 0) {
            [SVProgressHUD showWithStatus:nil];
            [self.tableView.mj_footer beginRefreshing];
        }

        [self requestSyncProducts];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.isImageBrowser) {
        self.isImageBrowser = NO;
        return;
    }
    
    NSString *title = FORMAT(@"%@", self.liveInfo.pinpaiming);
    [self.titleButton setTitle:title];
    self.ec_tabBarController.navigationItem.titleView = self.titleButton;
    
    if (self.liveInfo) {
        self.liveCellLayout = [[YugaoCellLayout alloc] initWithModel:self.liveInfo isOpened:NO];
        [self.tableView reloadData];
        
        // 公告
        [self hideNoticeView];
        NSString *notice = self.liveInfo.content;
        if (!notice || notice.length == 0) {
            self.noticeView.hidden = YES;
        }
        else if (![self.noticeView.notice isEqualToString:notice]) {
            self.noticeView.hidden = NO;
            [self.noticeView updateNotice:notice content:@""];
            [self showNoticeView];
        }
    }

    [SVProgressHUD showWithStatus:nil];
//    [self.tableView.mj_footer beginRefreshing];
    [self requestSyncProducts];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [((MainViewController *)self.ec_tabBarController) updateLeftButton:self.leftButton];
//    NSString *title = FORMAT(@"%@", self.liveInfo.pinpaiming);
//    self.navigationController.title = title;
    [self ec_setTitle:@""];
    
    
//    [((MainViewController *)self.ec_tabBarController) setLiveId:self.liveId];
    
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (self.isImageBrowser) {
        return;
    }
    
    [self stopTimer];
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tableView.top = self.noticeView.bottom;
    self.tableView.height = self.view.height - self.noticeView.bottom;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) shouldSyncLiveData:(NSNotification *)notification
{
    INFOLOG(@"===> 强制同步活动商品");
    NSString *liveId = notification.userInfo[@"liveId"];
    if ([liveId isEqualToString:self.liveInfo.liveid]) {
        [self stopTimer];
        [SVProgressHUD showWithStatus:nil];
        [self.dataSource removeAllObjects];
        [self.tableView reloadData];
        [self requestSyncProducts];
    }
}

- (void) updateLive:(LiveInfo *)liveInfo
{
    self.liveInfo = liveInfo;
    [self.dataSource removeAllObjects];
    [self.tableView reloadData];
}

- (void) updateDataSource:(NSArray *)products
{
    [SVProgressHUD dismiss];
    if (!products || products.count == 0) {
        [self.tableView reloadData];
        self.tableView.mj_footer.hidden = (self.dataSource.count == 0);
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    
    NSInteger index = self.dataSource.count;
    for (ProductModel *product in products) {
        ProductCellLayout *layout = [[ProductCellLayout alloc] initWithModel:product];
        [self.dataSource addObject:layout];
        index ++;
    }
    
    [self updateTableData];
}

- (NSInteger) insertDataSource:(NSArray *)products
{
    [self.tableView.mj_header endRefreshing];
    if (products.count == 0) {
        return 0;
    }
    
    if (products.count > 20) {
        [self reloadProducts];
        return products.count;
    }
    
    NSMutableArray *indexs = [NSMutableArray array];
    NSMutableArray *layouts = [NSMutableArray array];
    NSInteger i = 0;
    for (ProductModel *product in products) {
        if (self.liveInfo.liveid && ![self.liveInfo.liveid isEqualToString:product.liveid]) {
            continue;
        }
        ProductCellLayout *layout = [[ProductCellLayout alloc] initWithModel:product];
        [layouts addObject:layout];
        [indexs addObject:[NSIndexPath indexPathForRow:i inSection:1]];
        i ++;
    }
    
    [self.tableView beginUpdates];

    [self.dataSource insertObjects:layouts atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, layouts.count)]];
    
    [self.tableView insertRowsAtIndexPaths:indexs withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self.tableView endUpdates];
    
    return layouts.count;
}

- (void) updateTableData
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
    self.tableView.mj_footer.hidden = (self.dataSource.count < kProductPageCount);
    if ([ProductsManager hasMore:self.dataSource.count]) {
        [self.tableView.mj_footer endRefreshing];
    }
    else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    
    self.isSynced = YES;
}

- (void) reloadProducts
{
    if (!self.isSynced) {
        [self.tableView.mj_header endRefreshing];
        return;
    }
    [self.dataSource removeAllObjects];
    [self updateTableData];
    
//    NSArray *products = [ProductsManager loadProductsStartWith:0 liveId:self.liveInfo.liveid];
//    [self updateDataSource:products];
    
    [self requestSyncProducts];
}

- (void) showUpdatedView:(NSInteger)count
{
    if (count == 0) {
        return;
    }
    //
    [self.updatedView setNormalTitle:FORMAT(@"已更新 %ld 件商品", (unsigned long)count)];
    
    [UIView animateWithDuration:0.3f delay:0.5f options:UIViewAnimationOptionCurveLinear animations:^{
        self.updatedView.top = 0;
        self.updatedView.alpha = 0.8f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.3f delay:5.0f options:UIViewAnimationOptionCurveLinear animations:^{
            self.updatedView.top = -20;
            self.updatedView.alpha = 0.0f;
        } completion:nil];
    }];
}

- (void) showNoticeView
{
//    if (![UserManager isVIP]) {
//        self.noticeView.hidden = YES;
//        return;
//    }
    
    self.noticeView.hidden = NO;
    if (self.noticeView.top == 0.0f) {
        return;
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        self.noticeView.top = 0.0f;
        self.tableView.top = self.noticeView.bottom;
        self.tableView.height = self.view.height - self.noticeView.height;
    }];
}

- (void) hideNoticeView
{
    if (self.noticeView.top < 0.0f) {
        return;
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        self.noticeView.bottom = 0.0f;
        self.tableView.top = 0.0f;
        self.tableView.height = self.view.height;
    }];
}

- (void) updateSkus:(NSArray *)skus
{
    for (ProductSKU *sku in skus) {
        ProductModel *product = [self productById:sku.productid];
        if (product) {
            [product updateSKU:sku];
        }
    }
}

//
- (ProductModel *) productById:(NSString *)productId
{
    if (!self.dataSource || self.dataSource.count == 0) {
        return nil;
    }
    NSArray *array = [[NSArray alloc] initWithArray:self.dataSource];
    for (ProductCellLayout *layout in array) {
        if ([layout.productModel.Id isEqualToString:productId]) {
            return layout.productModel;
        }
    }
    return nil;
}

#pragma mark - Request

- (void) requestSyncProducts
{
    self.isSynced = NO;
    [ProductsManager syncProductsWith:self.liveInfo.liveid
                             finished:^(id content)
    {
//        [SVProgressHUD dismiss];
        NSInteger count = [self insertDataSource:content];
        NSLog(@"--> Updated : %ld", (long)count);
        [self showUpdatedView:count];
        
        [self.tableView.mj_footer beginRefreshing];

        //
        NSInteger time = [LiveManager periodTime];
        if (time > 0) {
            [self requestTrackSKU];
            [self startTimer:time];
        }
        else {
            [self requestTrackSKU];
        }
        
    } failed:^{
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void) requestTrackSKU
{
    RequestTrackSku *request = [RequestTrackSku new];
    request.liveid = self.liveInfo.liveid;
    request.syncsku = [ProductsManager skuTimeByLive:self.liveInfo.liveid];
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
    {
        ResponseTrackSku *response = content;
        if (response.result.count > 0 && response.result.count < 100) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                [self updateSkus:response.result];
            });
        }
        
    } onFailed:^(id content) {
        
    }];
}

#pragma mark - Actions

- (IBAction) switchLiveAction:(id)sender
{
    NSInteger index = [ProductsManager instance].forwardPinpai;
    PopupLivesView *optionsView = [[PopupLivesView alloc] initWithTitle:@"选择切换活动专场" lives:[LiveManager instance].liveDatas selected:index];
    @weakify(self)
    optionsView.completeBolck = ^(int index, id content) {
        @strongify(self)
        LiveInfo *liveInfo = [LiveManager liveInfoAtIndex:index];
        if (liveInfo.begintimestamp > [NSDate timeIntervalValue]) {
            // 品牌活动未开始
            [SVProgressHUD showInfoWithStatus:@"该品牌活动暂未开始"];
            return;
        }
        
        [ProductsManager instance].forwardPinpai = index;
        
        self.liveInfo = liveInfo;
        [self.titleButton setTitle:self.liveInfo.pinpaiming];
        [((MainViewController *)self.ec_tabBarController) updateForwardPinpai:self.liveInfo.liveid];
        
        [SVProgressHUD showWithStatus:nil];
        [self.dataSource removeAllObjects];
        
        self.liveCellLayout = [[YugaoCellLayout alloc] initWithModel:self.liveInfo isOpened:NO];
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        [self requestSyncProducts];

        // 公告
        [self hideNoticeView];
        NSString *notice = self.liveInfo.content;
        if (!notice || notice.length == 0) {
            self.noticeView.hidden = YES;
        }
        else if (![self.noticeView.notice isEqualToString:notice]) {
            self.noticeView.hidden = NO;
            [self.noticeView updateNotice:notice content:@""];
            [self showNoticeView];
        }
    };
    [optionsView show];
}

- (IBAction) leftButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.liveCellLayout ? 1 : 0;
    }
    return self.dataSource.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return self.liveCellLayout ? self.liveCellLayout.cellHeight : 0;
    }
    if (indexPath.row >= self.dataSource.count) {
        return 0;
    }
    ProductCellLayout* layout = self.dataSource[indexPath.row];
    return layout.cellHeight;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString* ygIdentifier = @"liveIdentifier";
        LiveTableCell* cell = [tableView dequeueReusableCellWithIdentifier:ygIdentifier];
        if (!cell) {
            cell = [[LiveTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ygIdentifier];
        }
        if (indexPath.row < 1) {
            cell.indexPath = indexPath;
            cell.showPinpai = NO;
            cell.cellLayout = self.liveCellLayout;
            [self callbackWithLiveCell:cell];
        }
        return cell;
    }
    
    static NSString* cellIdentifier = @"cellIdentifier";
    ProductTableCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ProductTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [self configueCell:cell atIndexPath:indexPath];
    return cell;
}

- (void) configueCell:(ProductTableCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [super configueCell:cell atIndexPath:indexPath];
    
//    @weakify(self)
//    cell.clickedAvatarCallback = ^(ProductTableCell* cell, ProductModel *model) {
//        @strongify(self)
//        [self hideCommentView];
//    };
}

- (void) callbackWithLiveCell:(LiveTableCell *)cell
{
    @weakify(self)
    cell.clickedImageCallback = ^(LiveTableCell* cell, NSInteger imageIndex) {
        @strongify(self)
//        [self hideCommentView];
        self.isImageBrowser = YES;
    };
    
    cell.clickedForwardCallback = ^(LiveTableCell* cell, LiveInfo *model) {
        @strongify(self)
//        [self hideCommentView];
        NSArray *imagesUrl = [model imagesUrl];
        [AKShareConfirm showWithConfirmed:^(BOOL check1, BOOL check2)
         {
             UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
             pasteboard.string = model.yugaoneirong;
             
             NSInteger type = ShareOptionOnlyPictures;
             if (check1) {
                 type = ShareOptionMergedPicture;
             }
             else if (check2) {
                 type = ShareOptionPicturesAndText;
             }
             [ShareActivity forwardWithItems:imagesUrl
                                        text:(check1||check2) ? model.yugaoneirong : nil
                                        data:nil
                                        type:type
                                      parent:self
                                        view:nil
                                    finished:nil
                                    canceled:nil];
         } model:model showOption:(imagesUrl.count<9)];
    };
    
    cell.clickedPinpaiCallback = ^(LiveTableCell* cell, LiveInfo *model) {
//        @strongify(self)
//        [self hideCommentView];
    };
    
    cell.clickedOpenCallback = ^(LiveTableCell *cell, BOOL isOpen) {
        @strongify(self)
        if (cell.indexPath.row >= 1) {
            return;
        }
        YugaoCellLayout *layout = self.liveCellLayout;
        LiveInfo* model = layout.model;
        YugaoCellLayout* newLayout = [[YugaoCellLayout alloc] initWithModel:model isOpened:isOpen];
        
        [cell coverScreenshotAndDelayRemoved:self.tableView cellHeight:newLayout.cellHeight];
        
        self.liveCellLayout = newLayout;
        [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    };
}

#pragma mark - UIScrollViewDelegate

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [self hideCommentView];
    
    NSIndexPath *path =  [self.tableView indexPathForRowAtPoint:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y)];
    if (path.section == 2 && path.row % kProductPageCount == (kProductPageCount-3) && path.row != _scrollIndex) {
        _scrollIndex = path.row;
        [self.tableView.mj_footer beginRefreshing];
    }
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.updatedView.top == 0) {
        [UIView animateWithDuration:0.3f animations:^{
            self.updatedView.top = -20;
            self.updatedView.alpha = 0.0f;
        }];
    }
}

- (void) scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (self.noticeView.hidden) {
        return;
    }
    if (velocity.y > 0.3) { // 往上滚动, 隐藏
        [self hideNoticeView];
    }
    else if (velocity.y < -0.3) {
        [self showNoticeView];
    }
}

#pragma mark - Timer

- (void) startTimer:(NSInteger)time
{
    if (self.liveTimer) {
        [self.liveTimer invalidate];
        self.liveTimer = nil;
    }

    self.liveTimer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
}

- (void) stopTimer
{
    if (self.liveTimer && [self.liveTimer isValid]) {
        [self.liveTimer invalidate];
        self.liveTimer = nil;
    }
}

- (void) timerFired:(NSTimer *)timer
{
    [self requestSyncProducts];
}

#pragma mark - Views

- (UIButton *) updatedView
{
    if (_updatedView) {
        return _updatedView;
    }
    
    _updatedView = [UIButton buttonWithType:UIButtonTypeCustom];
    _updatedView.frame = CGRectMake(0, -20, SCREEN_WIDTH, 20);
    _updatedView.backgroundColor = [COLOR_SELECTED colorWithAlphaComponent:0.8f];
    _updatedView.titleLabel.font = [FontUtils smallFont];
    [_updatedView setNormalColor:WHITE_COLOR];
    [_updatedView setNormalTitle:@"已更新 2 件商品"];
    _updatedView.alpha = 0.0f;
    
    return _updatedView;
}

- (NoticeView *) noticeView
{
    if (!_noticeView) {
        _noticeView = [[NoticeView alloc] initWithFrame:CGRectZero];
        _noticeView.bottom = 0.0f;
        _noticeView.hidden = YES;
        
        //初始化一个长按手势
        UILongPressGestureRecognizer *longPressGest = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressView:)];
        //        //长按等待时间
        //        longPressGest.minimumPressDuration = 1;
        //长按时候,手指头可以移动的距离
        longPressGest.allowableMovement = 30;
        [_noticeView addGestureRecognizer:longPressGest];
    }
    return _noticeView;
}

-(void) longPressView:(UILongPressGestureRecognizer *)longPressGest
{
    if (longPressGest.state==UIGestureRecognizerStateBegan) {
        NSLog(@"长按手势开启");
        // 公告
        NSString *notice = self.liveInfo.content;
        if (notice && notice.length > 0) {
            UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = notice;
            [SVProgressHUD showInfoWithStatus:@"公告内容已复制"];
        }
    }
}

- (NavTitleButton *) titleButton
{
    if (!_titleButton) {
        _titleButton  = [[NavTitleButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        [_titleButton addTarget:self action:@selector(switchLiveAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleButton;
}

@end
