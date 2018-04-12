//
//  DiscoverViewController.m
//  akucun
//
//  Created by Jarry Zhu on 2017/11/9.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "DiscoverViewController.h"
#import "ECTabBarController.h"
#import "MainViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "MJRefresh.h"
#import "DiscoverTableCell.h"
#import "RequestDiscoverList.h"
#import "RequestDiscoverComment.h"
#import "RequestGetVideoInfo.h"
#import "UserManager.h"
#import "CommentView.h"
#import "ShareActivity.h"
#import "UINavigationController+WXSTransition.h"
#import "VideoPreViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "CameraUtils.h"
#import "MMAlertView.h"

@interface DiscoverViewController () <UITableViewDataSource,UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataSource;
@property (nonatomic, assign) BOOL isOpened;

@property (nonatomic, assign) NSInteger pageNo;

@property (nonatomic, strong) CommentView *commentView;
@property (nonatomic, strong) NSIndexPath *clickedIndexPath;

@property (nonatomic, assign) BOOL isImageBrowser;

//@property(nonatomic, strong) ABMediaView         *mediaView;
@property (nonatomic, strong) AliyunVodPlayer     *aliplayer;

@property (nonatomic, copy) NSString *videoPath;
@property (nonatomic, assign) BOOL isForward;

@end

@implementation DiscoverViewController

- (void) setupContent
{
    [super setupContent];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = @"发现";
    
    [self ec_setTabTitle:@"发现"];
    [self ec_setTabImage:@"icon_discover"];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.commentView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).offset(kBOTTOM_BAR_HEIGHT);
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(@(kEDIT_BAR_HEIGHT));
    }];
    
    //
    @weakify(self)
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self.tableView.mj_footer resetNoMoreData];
        self.tableView.mj_footer.hidden = YES;
        self.pageNo = 1;
        [self requestListData:nil];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.textColor = LIGHTGRAY_COLOR;
    self.tableView.mj_header = refreshHeader;
    
    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        self.pageNo ++;
        [self requestListData:nil];
    }];
    refreshFooter.stateLabel.textColor = COLOR_TEXT_LIGHT;
    [refreshFooter setTitle:@"正在加载数据中..." forState:MJRefreshStateRefreshing];
    [refreshFooter setTitle:@"已加载完毕" forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = refreshFooter;
    self.tableView.mj_footer.hidden = YES;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [((MainViewController *)self.ec_tabBarController) updateLeftButton:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FORWARD_HIDE object:nil]; //临时修改，发通知让“转发按钮隐藏”
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [SVProgressHUD setContainerView:nil];

//    if (!self.dataSource || [UserManager instance].isDiscoverUpdated) {
//        [SVProgressHUD showWithStatus:nil];
//        self.pageNo = 1;
//        [self requestListData];
//    }
}

- (void) updateData
{
    if (self.isImageBrowser) {
        self.isImageBrowser = NO;
        return;
    }
    
    if (!self.dataSource || self.dataSource.count == 0) {
        [self.tableView.mj_header beginRefreshing];
    }
    else if (self.shouldUpdate) {
        [SVProgressHUD showWithStatus:nil];
        self.pageNo = 1;
        [self requestListData:nil];
    }
    
//    if (!self.dataSource || [UserManager instance].isDiscoverUpdated) {
//        [self.tableView.mj_header beginRefreshing];
//    }
}

- (void) updateDataSource:(NSArray *)array
{
    if (!self.dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    else if (self.pageNo == 1) {
        [self.dataSource removeAllObjects];
    }
    
    [SVProgressHUD dismiss];
    
    if (array.count == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView reloadData];
        return;
    }
    
    NSInteger index = 0;
    for (DiscoverData *data in array) {
        DiscoverCellLayout *layout = [[DiscoverCellLayout alloc] initWithModel:data isOpened:NO];
        [self.dataSource addObject:layout];
        index ++;
    }
    
//    [self updateTableData];
    self.tableView.mj_footer.hidden = (self.dataSource.count < kPAGE_SIZE);
    if (array.count < kPAGE_SIZE) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    else if (self.dataSource.count >= kPAGE_SIZE) {
        [self.tableView.mj_footer endRefreshing];
    }
    [self.tableView reloadData];
}

- (void) updateTableData
{
    self.tableView.mj_footer.hidden = (self.dataSource.count < kPAGE_SIZE);
    if (self.dataSource.count >= kPAGE_SIZE) {
        [self.tableView.mj_footer endRefreshing];
    }
    [self.tableView reloadData];
}

- (void) commentAction:(DiscoverData *)data
{
    self.commentView.object = data;
    self.commentView.placeHolder = @"添加评论";
    self.commentView.hidden = NO;
    [self.commentView show];
}

- (void) hideCommentView
{
    [self.commentView hide];
}

- (void) updateRowAtIndex:(NSIndexPath *)indexPath model:(DiscoverData *)model
{
    if (indexPath.row >= self.dataSource.count) {
        return;
    }
    DiscoverCellLayout *newLayout = [[DiscoverCellLayout alloc] initWithModel:model isOpened:self.isOpened];
    AKTableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell coverScreenshotAndDelayRemoved:self.tableView cellHeight:newLayout.cellHeight];
    
    [self.dataSource replaceObjectAtIndex:indexPath.row withObject:newLayout];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Request

- (void) requestListData:(voidBlock)finished
{
    RequestDiscoverList *request = [RequestDiscoverList new];
    request.pageno = self.pageNo;
    request.type = self.type;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [self.tableView.mj_header endRefreshing];

         self.shouldUpdate = NO;
         ResponseDiscoverList *response = content;
         [self updateDataSource:response.result];
         //
         if (self.pageNo == 1) {
             [self.ec_tabBarController updateBadge:0 atIndex:2 withStyle:WBadgeStyleRedDot animationType:WBadgeAnimTypeNone];
//             [UserManager instance].isDiscoverUpdated = NO;
             //
             if (response.result.count > 0) {
                 DiscoverData *data = response.result[0];
                 [UserManager instance].discoverTime = data.createtime;
                 
                 NSTimeInterval time = 0;
                 for (DiscoverData *item in response.result) {
                     if (time < item.createtime) {
                         time = item.createtime;
                     }
                     if (!item.isTop) {
                         break;
                     }
                 }
                 [[UserManager instance] updateDiscoverTime:time with:self.type];
             }
         }
         
         if (finished) {
             finished();
         }
         
     }
                                 onFailed:^(id content)
     {
         [self.tableView.mj_header endRefreshing];
     } onError:^(id content) {
         [self.tableView.mj_header endRefreshing];
     }];
}

- (void) requestComment:(NSString *)comment content:(DiscoverData *)data
{
    [SVProgressHUD showWithStatus:nil];
    
    RequestDiscoverComment *request = [RequestDiscoverComment new];
    request.comment = comment;
    request.contentid = data.Id;
    request.userid = [UserManager instance].userId;
    
    [SCHttpServiceFace serviceWithPostRequest:request onSuccess:^(id content)
    {
        [SVProgressHUD showSuccessWithStatus:@"评论发表成功"];
        
        DiscoverComment *commentObj = [DiscoverComment new];
        commentObj.content = comment;
        commentObj.nickname = [UserManager instance].userInfo.name;
        [data addComment:commentObj];
        
        [self updateRowAtIndex:self.clickedIndexPath model:data];

    } onFailed:^(id content) {
        
    }];
}

- (void) requestVideoInfo:(NSString *)videoId
{
    RequestGetVideoInfo *request = [RequestGetVideoInfo new];
    request.videoId = videoId;
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         HttpResponseBase *response = content;
         VideoInfo *videoInfo = [VideoInfo yy_modelWithDictionary:response.responseData];
//         INFOLOG(@"=== url : %@", videoInfo.playURL);
         
         NSString *name = FORMAT(@"%@.%@", videoInfo.videoId, videoInfo.format);
         NSString *path = [NSHomeDirectory() stringByAppendingString:FORMAT(@"/Documents/%@",name)];
         if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
             // 从沙盒保存到相册
             [self saveVideo:[NSURL URLWithString:path]];
         }
         else {
             [self downloadVideo:videoInfo.playURL name:name path:path];
         }
         
     } onFailed:^(id content) {
         
     }];
}

- (void) downloadVideo:(NSString *)videoUrl name:(NSString *)videoName path:(NSString *)videoPath
{
    self.videoPath = videoPath;
    
    [SCHttpServiceFace serviceWithDownloadURL:videoUrl
                                         path:videoPath
                                        onSuc:^(id content)
     {
         // 从沙盒保存到相册
         [self saveVideo:[NSURL URLWithString:videoPath]];
     }
                                      onError:^(id content)
     {
         [SVProgressHUD showErrorWithStatus:@"下载视频出错了"];
     }];
}

- (void) saveVideo:(NSURL*)url
{
    if ([CameraUtils isPhotoAlbumNotDetermined]) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == PHAuthorizationStatusAuthorized) {
                    // 用户授权
                    [self writeVideoToAlbum:url];
                }
                else {
                    // 用户拒绝授权
                    [self showPhotoAlbumDenied];
                }
            });
        }];
    }
    else if ([CameraUtils isPhotoAlbumDenied]) {
        // 相册访问已被禁用
        [self showPhotoAlbumDenied];
    }
    else {
        // 用户允许访问相册
        [self writeVideoToAlbum:url];
    }
}

- (void) writeVideoToAlbum:(NSURL*)url
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeVideoAtPathToSavedPhotosAlbum:url
                                completionBlock:^(NSURL *assetURL, NSError *error)
    {
        if (error) {
            NSLog(@"保存视频到相册失败:%@",error);
            [SVProgressHUD showErrorWithStatus:@"保存视频到相册失败"];
        }
        else {
            INFOLOG(@"==> assetURL : %@", assetURL.absoluteString);
            if (self.isForward) {
                [ShareActivity forwardVideo:assetURL parent:self view:nil finished:^(int flag) {
                    //
                    [SVProgressHUD showSuccessWithStatus:@"分享成功 ！"];
                    // 删除临时文件
                    if ([[NSFileManager defaultManager] fileExistsAtPath:self.videoPath]) {
                        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:self.videoPath error:nil];
                        DEBUGLOG(@"delete file : %d [%@]", success, self.videoPath);
                    }
                    
                } canceled:nil];
            }
            else {
                [SVProgressHUD showSuccessWithStatus:@"视频已保存至相册 ！"];
                // 删除临时文件
                if ([[NSFileManager defaultManager] fileExistsAtPath:self.videoPath]) {
                    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:self.videoPath error:nil];
                    DEBUGLOG(@"delete file : %d [%@]", success, self.videoPath);
                }
            }
        }
    }];
}

- (void) showPhotoAlbumDenied
{
    [SVProgressHUD dismiss];
    MMPopupItemHandler handler = ^(NSInteger index) {
        if (index == 1) {
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    };
    NSArray *items =
    @[MMItemMake(@"取消", MMItemTypeNormal, handler),
      MMItemMake(@"去设置", MMItemTypeHighlight, handler)];
    
    NSString *title = @"相册访问未授权";
    NSString *detailText = @"\n相册访问未授权，您可以在设置中打开";
    
    MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:title detail:detailText items:items];
    [alertView show];
}

#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DiscoverCellLayout* layout = self.dataSource[indexPath.row];
    return layout.cellHeight;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"DiscoverIdentifier";
    DiscoverTableCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[DiscoverTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.row < self.dataSource.count) {
        DiscoverCellLayout* layout = self.dataSource[indexPath.row];
        cell.cellLayout = layout;
        cell.indexPath = indexPath;
        
        [self callbackWithCell:cell];
    }
    
    return cell;
}

- (void) callbackWithCell:(DiscoverTableCell *)cell
{
    @weakify(self)
    cell.clickedCommentCallback = ^(DiscoverTableCell *cell, DiscoverData *model) {
        @strongify(self)
        self.clickedIndexPath = cell.indexPath;
        [self commentAction:model];
    };

    cell.clickedForwardCallback = ^(DiscoverTableCell* cell, DiscoverData *model) {
        @strongify(self)
        [self.commentView hide];
        self.isForward = YES;
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        NSString *content = FORMAT(@"%@\n%@", model.title, model.content);
        pasteboard.string = content;
        
        if (model.type == DISCOVER_TYPE_IMAGE) {
            [ShareActivity forwardWithImages:model.imagesArray parent:self view:nil finished:^(int flag) {
                //
                [SVProgressHUD showSuccessWithStatus:@"分享成功 ！"];
                
            } canceled:nil];
        }
        else if (model.type == DISCOVER_TYPE_VIDEO) {

            [SVProgressHUD showWithStatus:@"视频处理中，请稍候..."];
            [self requestVideoInfo:model.videoId];
            
            /*
            NSString *imageUrl = FORMAT(@"%@?x-oss-process=image/resize,w_600,limit_0", model.imagesUrl);
            [ShareActivity forwardWithURL:model.videoUrl title:content image:imageUrl parent:self view:nil finished:^(int flag) {
                //
                [SVProgressHUD showSuccessWithStatus:@"分享成功 ！"];
                
            } canceled:nil];
             */
        }
    };
    
    cell.clickedSaveCallback = ^(DiscoverTableCell* cell, DiscoverData *model) {
        @strongify(self)
        [self.commentView hide];
        self.isForward = NO;
        [SVProgressHUD showWithStatus:@"视频下载中，请稍候..."];
        [self requestVideoInfo:model.videoId];
    };
    
    cell.clickedOpenCallback = ^(DiscoverTableCell *cell, DiscoverData *model, BOOL open) {
        @strongify(self)
        self.isOpened = open;
        [self updateRowAtIndex:cell.indexPath model:model];
    };
    
    cell.clickedImageCallback = ^(DiscoverTableCell* cell, NSInteger imageIndex) {
        @strongify(self)
        self.isImageBrowser = YES;
    };
    // MARK: 方式三
    cell.clickedVideoCallback = ^(DiscoverTableCell *cell, DiscoverData *model, UIImageView *imageView) {
        @strongify(self)
        self.isImageBrowser = YES;
        // Calucate the toRect
        CGRect rect = [imageView convertRect:imageView.bounds toView:self.view];
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
        vc.showRect = toRect;
        vc.videoPath = model.videoUrl;
        vc.coverPath = model.imagesUrl;
        vc.vid       = model.videoId;
        
        __weak VideoPreViewController *weakVC = vc;
        [self wxs_presentViewController:vc makeTransition:^(WXSTransitionProperty *transition) {
            transition.animationType = WXSTransitionAnimationTypeViewMoveToNextVC;
            transition.animationTime = 0.4;
            transition.startView  = imageView;
            transition.targetView = weakVC.dumyView;
            //transition.targetView = weakVC.player.playerView;
            //transition.transitionType = WXSTransitionTypePresent;
        }];
    };
    
    // MARK: 方式二
    //    cell.clickedVideoCallback = ^(DiscoverTableCell *cell, DiscoverData *model, UIImageView *imageView) {
    //        @strongify(self)
    //
    //        ABMediaView *mediaView = [[ABMediaView alloc]initWithFrame:self.view.bounds];
    //        self.mediaView         = mediaView;
    //        [mediaView setAutoPlayAfterPresentation:YES];
    //        [mediaView setAllowLooping:YES];
    //        [mediaView setCloseButtonHidden:YES];
    //        [mediaView setPlayButtonHidden:YES];
    //        [mediaView changeVideoToAspectFit: YES];
    //        [mediaView setShouldDismissAfterFinish: NO];
    //        [mediaView setShouldDisplayFullscreen:YES];
    //        mediaView.contentMode = UIViewContentModeScaleAspectFit;
    //
    //        mediaView.presentFromOriginRect = YES;
    //        mediaView.imageViewNotReused    = YES;
    //
    //        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissPlayer)];
    //        [mediaView addGestureRecognizer:tap];
    //
    //        [mediaView setVideoURL:model.videoUrl withThumbnailURL:model.imagesUrl];
    //        [[ABMediaView sharedManager] presentMediaView:mediaView animated:YES];
    //    };
    
    // MARK: 方式一
    //    cell.clickedVideoCallback = ^(DiscoverTableCell *cell, DiscoverData *model, UIImageView *imageView) {
    //        @strongify(self)
    //
    //        CGRect rect = [imageView convertRect:imageView.bounds toView:self.view];
    //        Calucate the toRect
    //        CGRect rect = [imageView convertRect:imageView.bounds toView:self.view];
    //        CGFloat w = rect.size.width;
    //        CGFloat h = rect.size.height;
    //
    //        NSString *wStr     = [NSString stringWithFormat:@"%0.2f",w];
    //        CGFloat wf = [wStr floatValue];
    //
    //        NSString *hStr     = [NSString stringWithFormat:@"%0.2f",h];
    //        CGFloat hf = [hStr floatValue];
    //
    //        CGFloat scalePercent = hf / wf;
    //        CGFloat newScaleH = scalePercent * ([UIScreen mainScreen].bounds.size.width);
    //        CGRect toRect = CGRectMake(0, ([UIScreen mainScreen].bounds.size.height-newScaleH)*0.5, [UIScreen mainScreen].bounds.size.width, newScaleH);
    //
    //        // 播放视频
    //        VideoPreViewController *vc = [[VideoPreViewController alloc]init];
    //        vc.showRect = toRect;
    //        vc.videoURL = model.videoUrl;
    //        vc.coverURL = model.imagesUrl;
    //        //        vc.videoURL = [NSURL URLWithString:model.videoUrl];
    //        //        vc.coverURL = [NSURL URLWithString:model.imagesUrl];
    //        __weak VideoPreViewController *weakVC = vc;
    //
    //        [self wxs_presentViewController:vc makeTransition:^(WXSTransitionProperty *transition) {
    //            transition.animationType = WXSTransitionAnimationTypeViewMoveToNextVC;
    //            transition.animationTime = 0.4;
    //            transition.startView  = imageView;
    //            //            transition.targetView = weakVC.player.playerView;
    //            transition.targetView = weakVC.dumyView;
    //            //            transition.transitionType = WXSTransitionTypePresent;
    //        }];
    //    };
}

//- (void)dismissPlayer {
//    [self.mediaView dismissMediaViewAnimated:YES withCompletion:nil];
//}

#pragma mark - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate

- (NSAttributedString *) titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无动态信息";
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

#pragma mark - UIScrollViewDelegate

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self hideCommentView];
}

#pragma mark - Lazy Load

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

- (CommentView *) commentView
{
    if (_commentView) {
        return _commentView;
    }
    _commentView = [[CommentView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kEDIT_BAR_HEIGHT)];
    _commentView.offsetHeight = kBOTTOM_BAR_HEIGHT;
    _commentView.containerView = self.view;
    @weakify(self)
    _commentView.sendBlock = ^(id content1, id content2) {
        @strongify(self)
        DiscoverData *data = content1;
        [self requestComment:content2 content:data];
    };
    
    _commentView.hidden = YES;
    
    return _commentView;
}

@end
