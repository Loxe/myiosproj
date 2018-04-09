//
//  LogisticsInfoController.m
//  akucun
//
//  Created by deepin do on 2017/12/7.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "LogisticsInfoController.h"
#import "LogisticsTransferCell.h"
#import "LogisticsExpressCell.h"
#import "LogisticsDetailCell.h"
#import "RequestWuliuTrace.h"
#import "OptionsPopupView.h"
#import "MJRefresh.h"

@interface LogisticsInfoController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView  *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSArray *danhaoArray;
@property (nonatomic, copy) NSString *danhao;

@end

@implementation LogisticsInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareNav];
    [self prepareSubView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (!self.dataSource) {
        [self requestTraceInfo];
    }
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

}

- (void)prepareNav {
    
    self.navigationItem.title = @"物流查询";
    
    self.rightButton.width = 80.0f;
    [self.rightButton setNormalTitle:@"选择单号"];
    self.rightButton.hidden = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
}

- (void)prepareSubView {
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    //
    @weakify(self)
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self requestTraceInfo];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.textColor = LIGHTGRAY_COLOR;
    self.tableView.mj_header = refreshHeader;
}

- (void) setDeliverId:(NSString *)deliverId
{
    _deliverId = deliverId;
    
    self.danhaoArray = [deliverId componentsSeparatedByString:@","];
    self.danhao = self.danhaoArray[0];
    self.rightButton.hidden = (self.danhaoArray.count == 1);
}

- (IBAction) rightButtonAction:(id)sender
{
    OptionsPopupView *optionsView = [[OptionsPopupView alloc] initWithTitle:@"选择快递单号" options:self.danhaoArray selected:-1];
    @weakify(self)
    optionsView.completeBolck = ^(int index, id content) {
        @strongify(self)
        self.danhao = content;
        [self requestTraceInfo];
    };
    [optionsView show];
}

#pragma mark -

- (void) requestTraceInfo
{
    if (!self.danhao || self.danhao.length == 0) {
        self.dataSource = [NSMutableArray array];
        [self.tableView reloadData];
        return;
    }
    
    [SVProgressHUD showWithStatus:nil];
    
    RequestWuliuTrace *request = [RequestWuliuTrace new];
    request.deliverId = self.danhao;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
    {
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];

        ResponseWuliuTrace *response = content;
        self.dataSource = response.result;
        [self.tableView reloadData];
        
    } onFailed:^(id content) {
        [self.tableView.mj_header endRefreshing];
    } onError:^(id content) {
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return self.dataSource.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        LogisticsTransferCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LogisticsTransferCell" forIndexPath:indexPath];
        
        if (self.adOrder) {
            cell.adOrder = self.adOrder;
        }
        else if (self.order) {
            cell.order = self.order;
        }
        
        return cell;
        
    } else if (indexPath.section == 1) {
        
        LogisticsExpressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LogisticsExpressCell" forIndexPath:indexPath];
        
        cell.wuliuhao = self.danhao;
        cell.wuliugongsi = self.wuliugongsi;
        
        cell.copyBlock = ^(id content) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = content;
            [SVProgressHUD showInfoWithStatus:@"快递单号已复制"];
        };
        
        return cell;
        
    } else {
        LogisticsDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LogisticsDetailCell" forIndexPath:indexPath];
        @weakify(self)
        cell.phoneBlock = ^(id content){
            @strongify(self)
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",content];
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
        };
        
        cell.logisticsInfo = self.dataSource[indexPath.item];
        
        [cell.redPoint setHidden:YES];
        [cell.blackPoint setHidden:NO];
        [cell.topLine setHidden:NO];
        [cell.bottomLine setHidden:NO];
        [cell.sepLine setHidden:NO];

        //根据总数量来判断
        /* 若是0个怎么显示
         若是1个怎么显示
         若是2个怎么显示
         若是大于2个怎么显示
         */
        if (indexPath.item == 0) {
            [cell.blackPoint setHidden:YES];
            [cell.redPoint setHidden:NO];
            [cell.topLine setHidden:YES];
            cell.infoLabel.textColor = COLOR_TEXT_DARK;
        }
        
        if (indexPath.item == self.dataSource.count-1) {
            [cell.bottomLine setHidden:YES];
            [cell.sepLine setHidden:YES];
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = isPad ? kPadCellHeight : kTableCellHeight;
    if (indexPath.section == 0) {
        return height*3;
    } else if (indexPath.section == 1) {
        return 50+kOFFSET_SIZE*2;
    } else {
        CGFloat offset = kOFFSET_SIZE;
        LogisticsInfo *info = self.dataSource[indexPath.item];
        CGSize size = [info.content sizeWithMaxWidth:(SCREEN_WIDTH-(offset*3+20)) andFont:[FontUtils normalFont]];
        return size.height + offset*3.5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *v = [UIView new];
    v.backgroundColor = RGBCOLOR(240, 240, 240);
    
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kOFFSET_SIZE;
}

- (UITableView *)tableView {
    
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = RGBCOLOR(240, 240, 240);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[LogisticsTransferCell class] forCellReuseIdentifier:@"LogisticsTransferCell"];
        [_tableView registerClass:[LogisticsExpressCell class] forCellReuseIdentifier:@"LogisticsExpressCell"];
        [_tableView registerClass:[LogisticsDetailCell class] forCellReuseIdentifier:@"LogisticsDetailCell"];
        
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kSafeAreaBottomHeight)];
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
