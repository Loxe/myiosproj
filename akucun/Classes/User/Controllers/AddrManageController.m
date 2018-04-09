//
//  AddrManageController.m
//  akucun
//
//  Created by Jarry on 2017/7/15.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "AddrManageController.h"
#import "AddressViewController.h"
#import "AddressTableCell.h"
#import "MJRefresh.h"
#import "UserManager.h"
#import "RequestAddrList.h"
#import "RequestDelAddr.h"
#import "RequestDefaultAddr.h"
#import "SCActionSheet.h"
#import "MMAlertView.h"
#import "UIScrollView+EmptyDataSet.h"

@interface AddrManageController () <UITableViewDataSource,UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSArray* dataSource;

@property (nonatomic, strong) UIButton *addButton;

@end

@implementation AddrManageController

- (void) setupContent
{
    [super setupContent];
    self.view.backgroundColor = RGBCOLOR(250, 250, 250);
    
    self.title = @"地址管理";
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.addButton];
    
    CGFloat height = isPad ? kFIELD_HEIGHT_PAD : kFIELD_HEIGHT;
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view).insets(UIEdgeInsetsMake(0, kOFFSET_SIZE, kOFFSET_SIZE+kSafeAreaBottomHeight, kOFFSET_SIZE));
        make.height.mas_equalTo(@(height));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.addButton.mas_top).offset(-kOFFSET_SIZE);
    }];

    //
    @weakify(self)
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self requestAddressList];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.textColor = LIGHTGRAY_COLOR;
    self.tableView.mj_header = refreshHeader;
    
    UserInfo *userInfo = [UserManager instance].userInfo;
    if (userInfo.addrList.count > 0) {
        self.dataSource = userInfo.addrList;
    }

    self.selectIndex = -1;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.dataSource) {
        [SVProgressHUD showWithStatus:nil];
    }
    [self requestAddressList];
}

- (void) setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
    
    if (selectIndex >= 0) {
        self.title = @"选择地址";
        [self.tableView reloadData];
    }
}

- (void) addressAction:(Address *)addr type:(NSInteger)action
{
    switch (action) {
        case AddrActionEdit:
        {
            AddressViewController *controller = [AddressViewController new];
            controller.addr = addr;
//            @weakify(self)
//            controller.finishBlock = ^{
//                @strongify(self)
//                [self requestAddressList];
//            };
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
            
        case AddrActionDefault:
        {
            [self requestSetDefault:addr];
        }
            break;
            
        case AddrActionDelete:
        {
            //
            MMPopupItemHandler block = ^(NSInteger index) {
                if (index == 1) {
                    // Request
                    [self requestDelete:addr];
                }
            };
            
            NSArray *items =
            @[MMItemMake(@"取消", MMItemTypeNormal, block),
              MMItemMake(@"确定", MMItemTypeHighlight, block)];
            
            MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"删除确认" detail:@"\n是否确认删除该地址 ?" items:items];
            [alertView show];
/*
            NSArray *options = @[@"删除"];
            SCActionSheet *sheetView = [[SCActionSheet alloc] initWithTitle:@"是否确认删除该地址 ?" message:nil items:options];
            [sheetView showWithController:self finished:^(int index) {
                [self requestDelete:addr];
            }];
 */
        }
            break;
            
        default:
            break;
    }
}

- (IBAction) addAction:(id)sender
{
    AddressViewController *controller = [AddressViewController new];
    @weakify(self)
    controller.finishBlock = ^{
        @strongify(self)
        [self requestAddressList];
    };
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Request

- (void) requestSetDefault:(Address *)addr
{
    [SVProgressHUD showWithStatus:nil];
    RequestDefaultAddr *request = [RequestDefaultAddr new];
    request.addrid = addr.addrid;
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [SVProgressHUD showSuccessWithStatus:@"设置成功 ！"];
         //
         [self requestAddressList];
     }
                                 onFailed:^(id content)
     {
     }];
}

- (void) requestDelete:(Address *)addr
{
    [SVProgressHUD showWithStatus:nil];
    RequestDelAddr *request = [RequestDelAddr new];
    request.addrid = addr.addrid;
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [SVProgressHUD showSuccessWithStatus:@"地址已删除 ！"];
         //
         [self requestAddressList];
     }
                                 onFailed:^(id content)
     {
     }];
}

- (void) requestAddressList
{
//    [SVProgressHUD showWithStatus:nil];    
    RequestAddrList *request = [RequestAddrList new];
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [SVProgressHUD dismiss];
         [self.tableView.mj_header endRefreshing];
         
         ResponseAddrList *response = content;
         self.dataSource = response.result;
         if (self.selectIndex >= 0 && self.selectIndex >= self.dataSource.count) {
             self.selectIndex = self.dataSource.count - 1;
         }
         [self.tableView reloadData];
         self.addButton.hidden = (self.dataSource.count > 0);
     }
                                 onFailed:^(id content)
     {
         [self.tableView.mj_header endRefreshing];
     } onError:^(id content) {
         [self.tableView.mj_header endRefreshing];
     }];
}

#pragma mark - UITableViewDataSource

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section > 0 || self.dataSource.count == 0) {
        return kPIXEL_WIDTH;
    }
    return 50.0f;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section > 0 || self.dataSource.count == 0) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kPIXEL_WIDTH)];
        line.backgroundColor = COLOR_SEPERATOR_LINE;
        return line;
    }
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50.0f)];
    header.backgroundColor = COLOR_MAIN;
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(kOFFSET_SIZE, 8, SCREEN_WIDTH-kOFFSET_SIZE*2, 20)];
    tipLabel.numberOfLines = 0;
    tipLabel.textColor = WHITE_COLOR;
    tipLabel.font = [FontUtils smallFont];
    [header addSubview:tipLabel];

    NSString *text = FORMAT(@"主子账号只允许使用同一个地址（每个月限制修改 %ld 次）\n", (long)[UserManager instance].addrCount);
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:text];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing = 2;
    [attrStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attrStr.length)];
    
    NSMutableAttributedString *alertStr = [[NSMutableAttributedString alloc]initWithString:@"注意：包括微信子账号及关联账号修改的都是同一个地址"];
//    [alertStr addAttribute:NSForegroundColorAttributeName value:RED_COLOR range:NSMakeRange(0, alertStr.length)];
    [alertStr addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(13) range:NSMakeRange(0, alertStr.length)];
    [attrStr appendAttributedString:alertStr];

    tipLabel.attributedText = attrStr;
    [tipLabel sizeToFit];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 50.0f-kPIXEL_WIDTH, SCREEN_WIDTH, kPIXEL_WIDTH)];
    line.backgroundColor = COLOR_SEPERATOR_LINE;
    [header addSubview:line];
    return header;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kOFFSET_SIZE;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kOFFSET_SIZE)];
    footer.backgroundColor = CLEAR_COLOR;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5f, SCREEN_WIDTH, 0.5f)];
    line.backgroundColor = COLOR_SEPERATOR_LINE;
    [footer addSubview:line];
    return footer;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;//return self.dataSource.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"cellIdentifier";
    AddressTableCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[AddressTableCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    if (self.selectIndex < 0) {
        cell.selectionDisabled = YES;
    }
    else {
        cell.cellChecked = (self.selectIndex == indexPath.section);
    }
    
    Address *addr = self.dataSource[indexPath.section];
    cell.address = addr;
    
    @weakify(self)
    cell.actionBlock = ^(int type, id content) {
        @strongify(self)
        [self addressAction:content type:type];
    };
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AddressTableCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.selectionDisabled) {
        return;
    }
    
    if (self.finishBlock) {
        Address *addr = self.dataSource[indexPath.section];
        self.finishBlock(addr);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate

- (NSAttributedString *) titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"您还没有添加地址";
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

//- (CGFloat) verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
//{
//    return -kTableCellHeight;
//}

#pragma mark - Lazy Load

- (UITableView *) tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = RGBCOLOR(250, 250, 250);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
        _tableView.showsVerticalScrollIndicator = NO;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        
        CGFloat offset = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
        CGSize size1 = [@"Cell" boundingRectWithSize:CGSizeMake(320, 60) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[FontUtils buttonFont]} context:nil].size;
        CGSize size2 = [@"Cell" boundingRectWithSize:CGSizeMake(320, 60) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[FontUtils smallFont]} context:nil].size;
        _tableView.rowHeight = size1.height + size2.height + offset*2 + kOFFSET_SIZE * 0.5f + 46;
        /*
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kOFFSET_SIZE * 2 + 44)];
        footer.backgroundColor = CLEAR_COLOR;
        [footer addSubview:self.addButton];
        _tableView.tableFooterView = footer;*/
        
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

- (UIButton *) addButton
{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _addButton.frame = CGRectMake(20, kOFFSET_SIZE, SCREEN_WIDTH - 40, isPad ? 50 : kFIELD_HEIGHT);
        _addButton.clipsToBounds = YES;
        _addButton.layer.cornerRadius = 5;
        _addButton.layer.borderWidth = 0.5f;
        _addButton.layer.borderColor = RGBCOLOR(225, 225, 225).CGColor;
        
        _addButton.titleLabel.font = BOLDSYSTEMFONT(16);
        
        [_addButton setNormalColor:WHITE_COLOR highlighted:COLOR_TEXT_LIGHT selected:nil];
        [_addButton setBackgroundColor:COLOR_SELECTED];
        [_addButton setNormalTitle:@"新建地址"];
        
        [_addButton addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _addButton.hidden = YES;
    }
    return _addButton;
}

@end
