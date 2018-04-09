//
//  MessagesController.m
//  akucun
//
//  Created by Jarry on 2017/6/29.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "MessagesController.h"
#import "MJRefresh.h"
#import "UIScrollView+EmptyDataSet.h"
#import "RequestMsgList.h"
#import "RequestMsgRead.h"
#import "RequestMsgReadAll.h"
#import "MessageCellLayout.h"
#import "MessageCell.h"
#import "UserManager.h"

//@import GLNotificationBar;

@interface MessagesController () <UITableViewDataSource,UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataSource;

@property (nonatomic, assign) NSInteger pageNo;

@end

@implementation MessagesController

- (void) setupContent
{
    [super setupContent];
//    self.view.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    
    self.title = @"消息列表";
    
    self.rightButton.hidden = YES;
    self.rightButton.width = 80.0f;
    [self.rightButton setNormalTitle:@"全标已读"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];

    [self.view addSubview:self.tableView];

    //
    @weakify(self)
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self refreshMessages:YES];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.textColor = LIGHTGRAY_COLOR;
    self.tableView.mj_header = refreshHeader;
    
    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        self.pageNo ++;
        [self requestMessages:self.pageNo];
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

    if (!self.dataSource) {
        self.pageNo = 1;
        [SVProgressHUD showWithStatus:nil];
        [self requestMessages:self.pageNo];
    }
}

- (IBAction) rightButtonAction:(id)sender
{
    [self requestReadAll];
}

- (void) updateDataSource:(NSArray *)messages
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    
    if (!self.dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    else if (self.pageNo == 1) {
        [self.dataSource removeAllObjects];
    }
    
    if (messages.count == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView reloadData];
        return;
    }
    
    for (Message *message in messages) {
        MessageCellLayout *layout = [[MessageCellLayout alloc] initWithModel:message];
        [self.dataSource addObject:layout];
    }
    
    [self.tableView reloadData];
    
    self.tableView.mj_footer.hidden = (self.dataSource.count < 20);
    [self.tableView.mj_footer endRefreshing];
//    NSArray *indexPaths = [self.tableView indexPathsForVisibleRows];
//    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    
    self.rightButton.hidden = self.dataSource.count > 0 ? NO : YES;
}

- (void) refreshMessages:(BOOL)clear
{
    NSTimeInterval delay = 0.0f;
    if (clear) {
        self.dataSource = nil;
        self.tableView.mj_footer.hidden = YES;
        [self.tableView.mj_footer resetNoMoreData];
        [self.tableView reloadData];
        delay = 0.3f;
    }

    GCD_DELAY(^{
        self.pageNo = 1;
        [self requestMessages:self.pageNo];
    }, delay);
}

- (void) updateRowAtIndex:(NSIndexPath *)indexPath model:(Message *)model
{
    MessageCellLayout *newLayout = [[MessageCellLayout alloc] initWithModel:model];
    
    AKTableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell coverScreenshotAndDelayRemoved:self.tableView cellHeight:newLayout.cellHeight];
    
    [self.dataSource replaceObjectAtIndex:indexPath.row withObject:newLayout];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Request

- (void) requestMessages:(NSInteger)pageNo
{
    RequestMsgList *request = [RequestMsgList new];
    request.pageno = pageNo;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         ResponseMsgList *response = content;
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

- (void) requestReadMsg:(Message *)msg index:(NSIndexPath *)indexPath
{
    [SVProgressHUD showWithStatus:nil];
    
    RequestMsgRead *request = [RequestMsgRead new];
    request.msgid = msg.msgid;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [SVProgressHUD dismiss];
         msg.readflag = 1;
         [UserManager instance].userInfo.unreadnum --;
         [self updateRowAtIndex:indexPath model:msg];
     }
                                 onFailed:nil];
}

- (void) requestReadAll
{
    [SVProgressHUD showWithStatus:nil];
    
    RequestMsgReadAll *request = [RequestMsgReadAll new];
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [UserManager instance].userInfo.unreadnum = 0;
         [self refreshMessages:NO];
     }
                                 onFailed:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCellLayout* layout = self.dataSource[indexPath.row];
    return layout.cellHeight;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"cellIdentifier";
    MessageCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    MessageCellLayout* layout = self.dataSource[indexPath.row];
    cell.cellLayout = layout;

//        [self callbackWithCell:cell];
    
    return cell;
}

//- (void) callbackWithCell:(OrderDetailTableCell *)cell
//{
//    @weakify(self)
//}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    MessageCellLayout* layout = self.dataSource[indexPath.row];
    Message *message = layout.model;
    
    if (message.readflag == 0) {
        [self requestReadMsg:message index:indexPath];
    }
/*
    GLNotificationBar * notificationBar = [[GLNotificationBar alloc] initWithTitle:message.title message:message.content preferredStyle:GLNotificationStyleDetailedBanner handler:^(BOOL flag) {
        
    }];
    [notificationBar showTime:0.0f];
    [notificationBar notificationSound:nil ofType:nil vibrate:YES];
 */
}

#pragma mark - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate

- (NSAttributedString *) titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无消息内容";
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

#pragma mark - Lazy Load

- (UITableView *) tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = CLEAR_COLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
        //        _tableView.showsVerticalScrollIndicator = NO;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
    }
    return _tableView;
}

@end
