//
//  LiveListViewController.m
//  akucun
//
//  Created by Jarry Zhu on 2017/12/28.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "LiveListViewController.h"
#import "MainViewController.h"
#import "LiveProductController.h"
#import "LiveTableCell.h"
#import "CorpTableCell.h"
#import "AKShareConfirm.h"
#import "LiveManager.h"
#import "ProductsManager.h"
#import "MJRefresh.h"
#import "ShareActivity.h"
#import "UserManager.h"
#import "RequestLiveList.h"
#import "RequestLiveListNew.h"
#import "UIScrollView+EmptyDataSet.h"

@interface LiveListViewController () <UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataSource;

//@property (nonatomic, strong) CorpInfo *corpInfo;
@property (nonatomic, strong) CorpCellLayout *corpLayout;

@property (nonatomic, assign) BOOL isImageBrowser;

@end

@implementation LiveListViewController

- (void) setupContent
{
    self.view.backgroundColor = COLOR_BG_LIGHTGRAY;
}

- (void) initViewData
{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    //
    @weakify(self)
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        NSInteger type = self.liveType;
        if (![LiveManager instance].liveInfos) {
            type = -1;
        }
        [self requestLiveList:type];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.textColor = LIGHTGRAY_COLOR;
    self.tableView.mj_header = refreshHeader;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterForeground:) name:NOTIFICATION_APP_FOREGROUND object:nil];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) didEnterForeground:(NSNotification *)notification
{
    [self.tableView.mj_header beginRefreshing];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, -64)];
    
    if (self.isImageBrowser) {
        self.isImageBrowser = NO;
        return;
    }

    if (!self.dataSource) {
        [self.tableView.mj_header beginRefreshing];
    }
    else {
        [self requestLiveList:self.liveType];
    }
}

- (void) updateDataSource
{
    if (!self.dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    
    // 活动
    [self.dataSource removeAllObjects];
    
    NSArray *array = nil;
    if (self.liveType == 3) {
        array = [LiveManager instance].dxLives;
    }
    else if (self.liveType == 1) {
        array = [LiveManager instance].explosionLives;
    }
    else {
        array = [LiveManager instance].liveInfos;
    }
    
    for (LiveInfo *liveInfo in array) {
        YugaoCellLayout *layout = [[YugaoCellLayout alloc] initWithModel:liveInfo isOpened:NO];
        [self.dataSource addObject:layout];
    }
    
    // 活动结束 下架
    NSString *overLives = [LiveManager instance].overLiveIds;
    if (overLives && overLives.length > 0) {
        
        NSArray *array = [overLives componentsSeparatedByString:@","];
        for (NSString *liveId in array) {
            [[ProductsManager instance] deleteDataByLive:liveId];
        }
        [LiveManager instance].overLiveIds = nil;
    }
    
    self.corpLayout = [[CorpCellLayout alloc] initWithModel:[LiveManager instance].dxCorpInfo isOpened:NO];
    
    [self.tableView reloadData];
}

- (void) gotoLiveDetail:(LiveInfo *)liveInfo
{
    if (liveInfo.begintimestamp > [NSDate timeIntervalValue]) {
        // 品牌活动未开始
        [SVProgressHUD showInfoWithStatus:@"该品牌活动暂未开始 !"];
        return;
    }
    
    LiveProductController *controller = [LiveProductController new];
    controller.liveInfo = liveInfo;
    [self.navigationController pushViewController:controller animated:YES];
    
    [((MainViewController *)self.ec_tabBarController) updateForwardPinpai:liveInfo.liveid];
}

#pragma mark - Request

- (void) requestLiveList:(NSInteger)type
{
    RequestLiveListNew *request = [RequestLiveListNew new];
    request.modeltype = type;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
    {
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self updateDataSource];
        
    } onFailed:^(id content) {
        [self.tableView.mj_header endRefreshing];
    } onError:^(id content) {
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.liveType == 3) {
            return self.corpLayout ? 1 : 0;
        }
        return 0;
    }
    return self.dataSource.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.liveType == 3) {
            return self.corpLayout.cellHeight;
        }
        return 0;
    }
    if (indexPath.row >= self.dataSource.count) {
        return 0;
    }
    YugaoCellLayout* layout = self.dataSource[indexPath.row];
    return layout.cellHeight;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CorpTableCell *cell = [[CorpTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.indexPath = indexPath;
        cell.cellLayout = self.corpLayout;
        [self callbackWithCorpCell:cell];
        return cell;
    }
    
    static NSString* ygIdentifier = @"liveIdentifier";
    LiveTableCell* cell = [tableView dequeueReusableCellWithIdentifier:ygIdentifier];
    if (!cell) {
        cell = [[LiveTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ygIdentifier];
    }
    
    if (indexPath.row < self.dataSource.count) {
        cell.indexPath = indexPath;
        YugaoCellLayout* layout = self.dataSource[indexPath.row];
        cell.cellLayout = layout;
        cell.showPinpai = YES;
        [self callbackWithLiveCell:cell];
    }
    
    return cell;
}

- (void) callbackWithLiveCell:(LiveTableCell *)cell
{
    @weakify(self)
    cell.clickedImageCallback = ^(LiveTableCell* cell, NSInteger imageIndex) {
        @strongify(self)
        self.isImageBrowser = YES;
    };
    
    cell.clickedForwardCallback = ^(LiveTableCell* cell, LiveInfo *model) {
        @strongify(self)
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
                                    finished:^(int flag)
             {
                 [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FORWARD_SHOW object:nil];
             }
                                    canceled:^
             {
                 [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FORWARD_SHOW object:nil];
             }];
         } model:model showOption:(imagesUrl.count<9)];
    };
    
    cell.clickedPinpaiCallback = ^(LiveTableCell* cell, LiveInfo *model) {
        @strongify(self)
        [self gotoLiveDetail:model];
    };
    
    cell.clickedOpenCallback = ^(LiveTableCell *cell, BOOL isOpen) {
        @strongify(self)
        if (cell.indexPath.row >= self.dataSource.count) {
            return;
        }
        YugaoCellLayout *layout = self.dataSource[cell.indexPath.row];
        LiveInfo* model = layout.model;
        YugaoCellLayout* newLayout = [[YugaoCellLayout alloc] initWithModel:model isOpened:isOpen];
        
        [cell coverScreenshotAndDelayRemoved:self.tableView cellHeight:newLayout.cellHeight];
        
        [self.dataSource replaceObjectAtIndex:cell.indexPath.row withObject:newLayout];
        [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    };
}

- (void) callbackWithCorpCell:(CorpTableCell *)cell
{
    @weakify(self)
    cell.clickedImageCallback = ^(CorpTableCell* cell, NSInteger imageIndex) {
        @strongify(self)
        self.isImageBrowser = YES;
    };
    
    cell.clickedForwardCallback = ^(CorpTableCell* cell, CorpInfo *model) {
        @strongify(self)
        NSArray *imagesUrl = [model imagesUrl];
        [AKShareConfirm showWithConfirmed:^(BOOL check1, BOOL check2)
         {
             UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
             pasteboard.string = model.descriptioninfo;
             
             NSInteger type = ShareOptionOnlyPictures;
             if (check1) {
                 type = ShareOptionMergedPicture;
             }
             else if (check2) {
                 type = ShareOptionPicturesAndText;
             }
             [ShareActivity forwardWithItems:imagesUrl
                                        text:(check1||check2) ? model.descriptioninfo : nil
                                        data:nil
                                        type:type
                                      parent:self
                                        view:nil
                                    finished:nil
                                    canceled:nil];
         } model:model showOption:(imagesUrl.count<9)];
    };
    
    cell.clickedOpenCallback = ^(CorpTableCell *cell, BOOL isOpen) {
        @strongify(self)
        CorpInfo* model = self.corpLayout.model;
        CorpCellLayout* newLayout = [[CorpCellLayout alloc] initWithModel:model isOpened:isOpen];
        
        [cell coverScreenshotAndDelayRemoved:self.tableView cellHeight:newLayout.cellHeight];
        
        self.corpLayout = newLayout;
        [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    };
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        return;
    }
    
    YugaoCellLayout* layout = self.dataSource[indexPath.row];
    [self gotoLiveDetail:layout.model];
}

#pragma mark - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate

- (NSAttributedString *) titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"更多活动敬请期待";
    NSDictionary *attributes = @{NSFontAttributeName : [FontUtils normalFont],
                                 NSForegroundColorAttributeName : COLOR_TEXT_LIGHT };
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *) imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return IMAGENAMED(@"image_coming_soon");
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
    return 0;
}

#pragma mark - Views

- (UITableView *) tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = CLEAR_COLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
        _tableView.bounces = YES;
        
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

@end
