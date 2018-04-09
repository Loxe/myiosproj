//
//  TrailerViewController.m
//  akucun
//
//  Created by Jarry Zhu on 2017/12/28.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "TrailerViewController.h"
#import "YugaoTableCell.h"
#import "AKShareConfirm.h"
#import "LiveManager.h"
#import "ProductsManager.h"
#import "MJRefresh.h"
#import "ShareActivity.h"
#import "UserManager.h"
#import "RequestLiveTrailer.h"
#import "UIScrollView+EmptyDataSet.h"

@interface TrailerViewController () <UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataSource;

@property (nonatomic, assign) BOOL isImageBrowser;

@end

@implementation TrailerViewController

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
        [self requestTrailerList];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.textColor = LIGHTGRAY_COLOR;
    self.tableView.mj_header = refreshHeader;
    
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
        [self requestTrailerList];
    }
}

- (void) updateDataSource
{
    if (!self.dataSource) {
        self.dataSource = [NSMutableArray array];
    }

    // 预告
    [self.dataSource removeAllObjects];
    //
    NSArray *array = [LiveManager instance].trailerInfos;
    for (Trailer *trailer in array) {
        YugaoCellLayout *layout = [[YugaoCellLayout alloc] initWithTrailer:trailer isOpened:NO];
        [self.dataSource addObject:layout];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Request

- (void) requestTrailerList
{
    RequestLiveTrailer *request = [RequestLiveTrailer new];
    
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

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.dataSource.count) {
        return 0;
    }
    YugaoCellLayout* layout = self.dataSource[indexPath.row];
    return layout.cellHeight;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* ygIdentifier = @"ygIdentifier";
    YugaoTableCell* cell = [tableView dequeueReusableCellWithIdentifier:ygIdentifier];
    if (!cell) {
        cell = [[YugaoTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ygIdentifier];
    }
    if (indexPath.row < self.dataSource.count) {
        cell.indexPath = indexPath;
        cell.cellLayout = self.dataSource[indexPath.row];
        [self callbackWithYugaoCell:cell];
    }

    return cell;
}

- (void) callbackWithYugaoCell:(YugaoTableCell *)cell
{
    @weakify(self)
    cell.clickedImageCallback = ^(YugaoTableCell* cell, NSInteger imageIndex) {
        @strongify(self)
        self.isImageBrowser = YES;
    };
    
    cell.clickedForwardCallback = ^(YugaoTableCell* cell, Trailer *model) {
        @strongify(self)
        NSArray *imagesUrl = [model imagesUrl];
        [AKShareConfirm showWithConfirmed:^(BOOL check1, BOOL check2) {
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
    
    cell.clickedOpenCallback = ^(YugaoTableCell *cell, BOOL isOpen) {
        @strongify(self)
        if (cell.indexPath.row >= self.dataSource.count) {
            return;
        }
        YugaoCellLayout *layout = self.dataSource[cell.indexPath.row];
        Trailer* model = layout.trailer;
        YugaoCellLayout* newLayout = [[YugaoCellLayout alloc] initWithTrailer:model isOpened:isOpen];
        
        [cell coverScreenshotAndDelayRemoved:self.tableView cellHeight:newLayout.cellHeight];
        
        [self.dataSource replaceObjectAtIndex:cell.indexPath.row withObject:newLayout];
        [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    
    cell.clickedPinpaiCallback = ^(YugaoTableCell* cell) {
        [SVProgressHUD showInfoWithStatus:@"该品牌活动暂未开始 !"];
    };
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
