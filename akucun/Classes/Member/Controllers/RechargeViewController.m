//
//  RechargeViewController.m
//  akucun
//
//  Created by Jarry on 2017/9/17.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RechargeViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "MJRefresh.h"
#import "RechargeTableCell.h"
#import "NSString+akucun.h"
#import "RequestRechargeList.h"
#import "RequestBuyRecharge.h"
#import "PopupPaystyleView.h"
#import "MMAlertView.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApiManager.h"
#import "NoticeView.h"
#import "PayType.h"

@interface RechargeViewController () <UITableViewDataSource,UITableViewDelegate, WXApiManagerDelegate>

@property (nonatomic, strong) NoticeView* noticeView;

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataSource;

@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UIButton *customButton;

//@property (nonatomic, strong) RechargeItem *rechargeItem;

@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation RechargeViewController

- (void) setupContent
{
    [super setupContent];
    //self.view.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = @"账户充值";
    
    self.selectedIndex = -1;

    [self.view addSubview:self.noticeView];
    [self.view addSubview:self.tableView];
    
    /*
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.view);
        make.left.equalTo(self.view).offset(kOFFSET_SIZE);
        make.right.equalTo(self.view).offset(-kOFFSET_SIZE);
    }];
    
    @weakify(self)
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self.tableView.mj_footer resetNoMoreData];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.textColor = LIGHTGRAY_COLOR;
    self.tableView.mj_header = refreshHeader;
     */
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.dataSource) {
        [self requestRechargeList];
    }
}

- (IBAction) submitAction:(id)sender
{
    if (self.selectedIndex < 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择充值套餐 !"];
        return;
    }

    PayType *type1 = [PayType new];
    type1.paytype = kPayTypeWEIXIN;
    type1.name = @"微信支付";
    
    PayType *type2 = [PayType new];
    type2.paytype = kPayTypeALIPAY;
    type2.name = @"支付宝";
    
    RechargeItem *rechargeItem = self.dataSource[self.selectedIndex];
    PopupPaystyleView *popupView = [[PopupPaystyleView alloc] initWithTitle:FORMAT(@"需支付 ¥ %ld", (long)rechargeItem.jine) types:@[type1,type2] value:rechargeItem.jine];
    @weakify(self)
    popupView.selectBlock = ^(int type) {
        @strongify(self)
        [self requestBuyRecharge:type recharge:rechargeItem];
    };
    [popupView show];
}

- (IBAction) customAction:(id)sender
{
    MMAlertView *alertView =
    [[MMAlertView alloc] initWithInputTitle:@"自定义充值"
                                     detail:@"\n支持1～5000元任意金额的充值"
                                placeholder:@"请输入充值金额(元)"
                                   keyboard:UIKeyboardTypeNumberPad
                                    handler:^(NSString *text)
     {
         NSInteger value = [text integerValue];
         if (value > 5000 || value <= 0) {
             [SVProgressHUD showInfoWithStatus:@"请输入有效的金额"];
             return;
         }
         
         RechargeItem *item = [RechargeItem new];
         item.payjine = value;
         
         PopupPaystyleView *popupView = [[PopupPaystyleView alloc] initWithTitle:FORMAT(@"需支付 ¥ %ld", (long)item.payjine) types:nil value:item.payjine];
         @weakify(self)
         popupView.selectBlock = ^(int type) {
             @strongify(self)
             [self requestBuyRecharge:type recharge:item];
         };
         [popupView show];
         
     }];
    [alertView show];
}

- (void) showSuccess
{
    MMPopupItemHandler handler = ^(NSInteger index) {
        [self.navigationController popViewControllerAnimated:YES];
    };
    NSArray *items =
    @[MMItemMake(@"确定", MMItemTypeHighlight, handler)];
    
    MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"充值成功" detail:@"\n请稍候查看您的账户余额 ！" items:items];
    [alertView show];
}

#pragma mark - Request

- (void) requestRechargeList
{
    [SVProgressHUD showWithStatus:nil];
    
    RequestRechargeList *request = [RequestRechargeList new];
    
    [SCHttpServiceFace serviceWithRequest:request onSuccess:^(id content)
     {
         [SVProgressHUD dismiss];
         
         ResponseRechargeList *response = content;
         self.dataSource = response.result;
         [self.tableView reloadData];
         
         if (response.desc && response.desc.length > 0) {
             [self.noticeView updateMessage:response.desc];
             self.noticeView.top = 0.0f;
             self.noticeView.hidden = NO;
             self.tableView.top = self.noticeView.bottom;
             self.tableView.height = self.view.height - self.noticeView.height;
         }
         else {
             self.noticeView.bottom = 0.0f;
             self.noticeView.hidden = YES;
             self.tableView.top = 0.0f;
             self.tableView.height = self.view.height;
         }
         self.tableView.hidden = NO;
         
     } onFailed:^(id content) {
         
     }];
}

- (void) requestBuyRecharge:(NSInteger)payType recharge:(RechargeItem *)rechargeItem
{
    [SVProgressHUD showWithStatus:nil];
    
    RequestBuyRecharge *request = [RequestBuyRecharge new];
    request.deltaid = rechargeItem.deltaid;
    request.payjine = rechargeItem.payjine;
    request.paytype = payType;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [SVProgressHUD dismiss];
         
         ResponseBuyRecharge *response = content;
         if (payType == kPayTypeALIPAY) {
             [self doAlipayPay:response.payInfo];
         }
         else if (payType == kPayTypeWEIXIN) {
             [self doWeixinPay:response.payInfo];
         }
         
     } onFailed:^(id content) {
         
     }];
}

#pragma mark - AliPay

- (void) doAlipayPay:(NSString *)payInfo
{
    // NOTE: 调用支付接口开始支付
    [[AlipaySDK defaultService] payOrder:payInfo
                              fromScheme:@"akucunApp"
                                callback:^(NSDictionary *resultDic)
     {
         INFOLOG(@"AliPay : %@",resultDic);
         [self handleAlipayResult:resultDic];
     }];
}

- (void) didRecvAlipayResult:(NSNotification*)notification
{
    NSDictionary *result = notification.userInfo;
    INFOLOG(@"AliPay result : %@",result);
    [self handleAlipayResult:result];
}

- (void) handleAlipayResult:(NSDictionary *)result
{
    NSInteger status = [result getIntegerValueForKey:@"resultStatus"];
    switch (status) {
        case 9000:
        {
            [self showSuccess];
        }
            break;
            
        case 8000:
        case 6004:
        {
            [SVProgressHUD showInfoWithStatus:@"正在处理中，请查询支付状态！"];
        }
            break;
            
        case 6001:
        {
            [SVProgressHUD showInfoWithStatus:@"已取消支付！"];
        }
            break;
            
        case 4000:
        {
            [SVProgressHUD showErrorWithStatus:@"订单支付失败！"];
        }
            break;
            
        default:
        {
            [SVProgressHUD showErrorWithStatus:@"支付发生错误！"];
        }
            break;
    }
}

#pragma mark - WeixinPay

- (void) doWeixinPay:(NSDictionary *)payInfo
{
    [WXApiManager sharedManager].delegate = self;
    [WXApiManager payRequest:payInfo];
}

- (void) managerDidRecvPayResponse:(PayResp *)payResp
{
    if (payResp.errCode == WXSuccess) {
        //
        [self showSuccess];
    }
    else {
        ERRORLOG(@"支付失败: retcode = %d, retstr = %@", payResp.errCode, payResp.errStr);
        [SVProgressHUD showErrorWithStatus:FORMAT(@"支付失败！[code：%d]", payResp.errCode)];
    }
}

#pragma mark - UITableViewDataSource

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10.0f)];
    return footer;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"cellIdentifier";
    RechargeTableCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[RechargeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    RechargeItem *item = self.dataSource[indexPath.section];
    cell.rechargeItem = item;
    
    cell.cellSelected = (self.selectedIndex == indexPath.section);
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (self.selectedIndex == indexPath.section) {
        return;
    }
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    if (self.selectedIndex >= 0) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:0 inSection:self.selectedIndex]];
    }
    
    self.selectedIndex = indexPath.section;
    RechargeItem *rechargeItem = self.dataSource[indexPath.section];
    //
    self.submitButton.enabled = YES;
    self.submitButton.backgroundColor = COLOR_SELECTED;
    [self.submitButton setNormalTitle:FORMAT(@"充 值 ¥%ld", (long)rechargeItem.payjine)];
    
    [indexPaths addObject:indexPath];
    [tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - 

- (UITableView *) tableView
{
    if (!_tableView) {
        CGRect frame = CGRectMake(kOFFSET_SIZE, 0, SCREEN_WIDTH-kOFFSET_SIZE*2, self.view.height);
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        _tableView.backgroundColor = CLEAR_COLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
        _tableView.showsVerticalScrollIndicator = NO;
        
        CGSize size1 = [@"Text" sizeWithFont:BOLDSYSTEMFONT(16) maxWidth:SCREEN_WIDTH];
        CGSize size2 = [@"Text" sizeWithFont:[FontUtils smallFont] maxWidth:SCREEN_WIDTH];
        _tableView.rowHeight = size1.height + size2.height + kOFFSET_SIZE * 2 + 10.0f;
        
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
        
        CGSize size = [@"Text" sizeWithFont:[FontUtils normalFont] maxWidth:SCREEN_WIDTH];
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kOFFSET_SIZE * 1.5 + size.height)];
        UILabel *vipTitle = [[UILabel alloc] init];
        vipTitle.font = [FontUtils normalFont];
        vipTitle.textColor = COLOR_TEXT_DARK;
        vipTitle.text = @"选择充值套餐";
        [vipTitle sizeToFit];
        vipTitle.top = kOFFSET_SIZE;
        [header addSubview:vipTitle];
        _tableView.tableHeaderView = header;
        
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-kOFFSET_SIZE*2, kOFFSET_SIZE * 4 + 50)];
        footer.backgroundColor = CLEAR_COLOR;
        [footer addSubview:self.submitButton];
        
//        self.customButton.top = self.submitButton.bottom + kOFFSET_SIZE;
//        [footer addSubview:self.customButton];
        
        footer.height = self.submitButton.bottom + kOFFSET_SIZE;
        _tableView.tableFooterView = footer;
        
        _tableView.hidden = YES;
    }
    return _tableView;
}

- (NoticeView *) noticeView
{
    if (!_noticeView) {
        _noticeView = [[NoticeView alloc] initWithFrame:CGRectZero];
        _noticeView.bottom = 0.0f;
        _noticeView.hidden = YES;
    }
    return _noticeView;
}

- (UIButton *) submitButton
{
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _submitButton.backgroundColor = COLOR_BG_TEXT_DISABLED;
        _submitButton.frame = CGRectMake(0, kOFFSET_SIZE*2, SCREEN_WIDTH - kOFFSET_SIZE*2, isPad ? 50 : kFIELD_HEIGHT);
        _submitButton.clipsToBounds = YES;
        _submitButton.layer.cornerRadius = 5;
        
        _submitButton.titleLabel.font = [FontUtils buttonFont];
        
        [_submitButton setNormalColor:WHITE_COLOR highlighted:COLOR_TEXT_LIGHT selected:nil];
        [_submitButton setNormalTitleColor:nil disableColor:COLOR_TEXT_LIGHT];
        [_submitButton setNormalTitle:@"充 值"];
        
        [_submitButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _submitButton.enabled = NO;
    }
    return _submitButton;
}

- (UIButton *) customButton
{
    if (!_customButton) {
        _customButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _customButton.backgroundColor = COLOR_BG_TEXT_DISABLED;
        _customButton.frame = CGRectMake(0, kOFFSET_SIZE, SCREEN_WIDTH - kOFFSET_SIZE*2, isPad ? 50 : kFIELD_HEIGHT);
        _customButton.clipsToBounds = YES;
        _customButton.layer.cornerRadius = 5;
        _customButton.layer.borderColor = COLOR_SEPERATOR_LINE.CGColor;
        _customButton.layer.borderWidth = 0.5f;
        
        _customButton.titleLabel.font = [FontUtils buttonFont];
        
        [_customButton setNormalColor:COLOR_TEXT_NORMAL highlighted:COLOR_SELECTED selected:nil];
        [_customButton setNormalTitle:@"自定义充值"];
        
        [_customButton addTarget:self action:@selector(customAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _customButton;
}

@end
