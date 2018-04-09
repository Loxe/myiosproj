//
//  PayViewController.m
//  akucun
//
//  Created by Jarry on 2017/5/3.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "PayViewController.h"
#import "TableCellBase.h"
#import "AddressView.h"
#import "AddressViewController.h"
#import "UserManager.h"
#import "PaystyleTableCell.h"
#import "RequestPayOrder.h"
#import "RequestPayQuery.h"
#import "RequestPaytypes.h"
#import "RequestUserAccount.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApiManager.h"
#import "MMAlertView.h"
#import "umfPaySdkIphone.h"

typedef NS_ENUM(NSInteger, ePayStatus)
{
    AKPayStatusInit = 0 ,
    AKPayStatusPending = 2 ,
    AKPayStatusSuccess = 3 ,
    AKPayStatusFailed = 4
};

@interface PayViewController () <UITableViewDataSource, UITableViewDelegate, WXApiManagerDelegate, umfPaySdkDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *payButton;

@property (nonatomic, strong) NSArray *payTypes;

@property (nonatomic, strong) AddressView *addressView;

@property (nonatomic, assign) BOOL isPaying;

@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, copy) NSString *paymentId;
@property (nonatomic, assign) NSInteger queryCount;

@end

@implementation PayViewController

- (void) setupContent
{
    [super setupContent];
    self.view.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    self.title = @"支付订单";
}

- (void) initViewData
{
    [super initViewData];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.payButton];
    
    CGFloat height = isPad ? kFIELD_HEIGHT_PAD : 44;
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(@(height+kSafeAreaBottomHeight));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.payButton.mas_top);
    }];
    
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRecvAlipayResult:) name:NOTIFICATION_ALIPAY_SUCCESS object:nil];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 解决 SIGSEGV 闪退问题
    [WXApiManager sharedManager].delegate = nil;
    [umfPaySdkIphone sharedUmfManager].sdkDelegate = nil;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    //
    if (!self.payTypes) {
        [self requestPayType];
    }
    
//    [self.tableView reloadData];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (self.showForward) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FORWARD_SHOW object:nil];
    }
}

- (void) setAddress:(Address *)address
{
    _address = address;
    self.addressView.address = address;
    [self.addressView updateLayout];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void) setLogistics:(Logistics *)logistics
{
    _logistics = logistics;
    self.addressView.logistics = logistics;
    [self.addressView updateLayout];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Actions

- (IBAction) leftButtonAction:(id)sender
{
    MMPopupItemHandler handler = ^(NSInteger index) {
        if (index == 1) {
            [self.navigationController popViewControllerAnimated:YES];
            if (self.cancelBlock) {
                self.cancelBlock();
            }
        }
    };
    NSArray *items =
    @[MMItemMake(@"继续支付", MMItemTypeNormal, handler),
      MMItemMake(@"确定离开", MMItemTypeHighlight, handler)];
    
    NSString *detailText = @"\n订单未支付，确定离开后可以在我的订单中继续完成支付; \n超时未支付系统将取消您的订单！";
    MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"订单未支付" detail:detailText items:items];
    [alertView show];
}

- (IBAction) editAddressAction:(id)sender
{
    AddressViewController *controller = [AddressViewController new];
    controller.finishBlock = ^{
        //
//        UserInfo *userInfo = [UserManager instance].userInfo;
//        self.addressView.address = userInfo.addr;
//        [self updateLayout];
//        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction) payAction:(id)sender
{
    if (self.isPaying) {
        return;
    }
    if (self.selectIndex >= self.payTypes.count) {
        return;
    }
    
    PayType *payType = self.payTypes[self.selectIndex];
    if (payType.paytype == kPayTypeUMFAliPay) {
        if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay:"]]) {
            [SVProgressHUD showInfoWithStatus:@"检测到您的手机未安装支付宝APP"];
            return;
        }
    }
    
    [self requestPayOrder:payType.paytype];
    self.isPaying = YES;
    self.payButton.enabled = NO;
}

#pragma mark - 

- (void) requestPayType
{
    [SVProgressHUD showWithStatus:nil];
    RequestPaytypes *request = [RequestPaytypes new];
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [SVProgressHUD dismiss];

         ResponsePaytypes *response = content;
         self.payTypes = [response validPayTypes];
         
         //
         UserInfo *userInfo = [UserManager instance].userInfo;
         if (userInfo.isBalancePay) {
             if (userInfo.account.keyongyue < self.order.zongjine) {
                 self.selectIndex = 1;
             }
             [self requestUserAccount];
         }
         PayType *payType = self.payTypes[self.selectIndex];
         [self.payButton setNormalTitle:FORMAT(@"%@ ¥%.2f", payType.name, self.order.zongjine/100.0f)];
         self.payButton.hidden = NO;

         [self.tableView reloadData];
         
     } onFailed:^(id content) {
         
     }];
}

- (void) requestUserAccount
{
    RequestUserAccount *request = [RequestUserAccount new];
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [SVProgressHUD dismiss];
         
         [self.tableView reloadData];

//         [self requestPayOrder:kPayTypeALIPAY pay:NO];
         
     } onFailed:nil];
}

- (void) requestPayOrder:(NSInteger)payType
{
    [SVProgressHUD showWithStatus:nil];
    
    RequestPayOrder *request = [RequestPayOrder new];
    request.paytype = payType;
    request.orders = self.orderIds;
    
    @weakify(self)
    [SCHttpServiceFace serviceWithPostRequest:request
                                    onSuccess:^(id content)
     {
         @strongify(self)
         [SVProgressHUD dismiss];
         
         ResponsePayOrder *response = content;
         response.order.shangpinjianshu = self.order.shangpinjianshu;
         self.order = response.order;
         self.paymentId = response.paymentId;
         [self.tableView reloadData];

         self.queryCount = 0;
         if (payType == kPayTypeALIPAY) {
             [self doAlipayPay:response.payInfo];
         }
         else if (payType == kPayTypeWEIXIN) {
             [self doWeixinPay:response.payInfo];
         }
         else if (payType == kPayTypeYUE) {
             
             [self alertWithTitle:@"订单支付成功！" detail:@"请稍候在我的订单中查询订单状态" block:^{
                 [self.navigationController popViewControllerAnimated:NO];
                 if (self.finishBlock) {
                     self.finishBlock();
                 }
             }];
         }
         else if (payType == kPayTypeUMFWXPay ||
                  payType == kPayTypeUMFAliPay ||
                  payType == kPayTypeUMFChinaUnionPay) {
             // 联动优势 支付
             [self doUMFPay:payType info:response.payInfo];
         }
         
     }
                                     onFailed:^(id content)
     {
         @strongify(self)
         self.isPaying = NO;
         self.payButton.enabled = YES;
     }
                                      onError:^(id content)
     {
         @strongify(self)
         self.isPaying = NO;
         self.payButton.enabled = YES;
     }];
}

- (void) requestPayQuery
{
    self.queryCount ++;
    
    RequestPayQuery *request = [RequestPayQuery new];
    request.paymentId = self.paymentId;
    
    @weakify(self)
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
    {
        @strongify(self)
        HttpResponseBase *response = content;
        NSDictionary *jsonData = response.responseData;
        NSInteger payStatus = [jsonData getIntegerValueForKey:@"paystatu"];
        if (payStatus == AKPayStatusSuccess) {
            // 支付成功
            [SVProgressHUD showSuccessWithStatus:@"订单支付成功！"];
            GCD_DELAY(^{
                [self.navigationController popViewControllerAnimated:NO];
                if (self.finishBlock) {
                    self.finishBlock();
                }
            }, 2.0f);
        }
        else if (payStatus == AKPayStatusPending) {
            // 支付处理中
            if (self.queryCount < 3) {
                GCD_DELAY(^{
                    [self requestPayQuery];
                }, 2.0f);
            }
            else {
                [self alertWithTitle:@"支付处理中" detail:@"请稍候在我的订单中查询订单状态" block:^{
                    [self.navigationController popViewControllerAnimated:NO];
                    if (self.finishBlock) {
                        self.finishBlock();
                    }
                }];
            }
        }
        else if (payStatus == AKPayStatusFailed) {
            // 支付失败
            [SVProgressHUD dismiss];
            [self alertWithTitle:@"支付失败" detail:@"请重新支付，您可以尝试其他支付方式" block:nil];
        }
        
    } onFailed:^(id content) {
        
    }];
}

#pragma mark - 联动支付

- (void) doUMFPay:(NSInteger)payType info:(NSDictionary *)payInfo
{
    [umfPaySdkIphone sharedUmfManager].sdkDelegate = self;
    // 服务器返回的PayInfo信息校验
    if (![self validUMFPayinfo:payInfo]) {
        [SVProgressHUD showErrorWithStatus:@"订单支付信息不完整"];
        self.isPaying = NO;
        self.payButton.enabled = YES;
        return;
    }

    if (payType == kPayTypeUMFWXPay) {
        // 微信支付
        [[umfPaySdkIphone sharedUmfManager] initializeWeiXinPayment:payInfo];
    }
    else if (payType == kPayTypeUMFAliPay) {
        // 支付宝
        [[umfPaySdkIphone sharedUmfManager] initializeAlipayPayment:payInfo];
    }
    else if (payType == kPayTypeUMFChinaUnionPay) {
        // 银联快捷支付 H5收银台
        [[umfPaySdkIphone sharedUmfManager] initializeWebPayment:payInfo navVC:self.navigationController];
    }
    else {
        // 联动收银台
        [[umfPaySdkIphone sharedUmfManager] initializePayment:payInfo];
    }
}

- (BOOL) validUMFPayinfo:(NSDictionary *)payInfo
{
    if ((payInfo == nil) || [payInfo isEqual:[NSNull null]]) {
        return NO;
    }
    return [payInfo checkNullForKey:@"merIds"] && [payInfo checkNullForKey:@"tradeNo"] && [payInfo checkNullForKey:@"merCustId"] && [payInfo checkNullForKey:@"sign"];
}

/**
 * wxResultCode 微信支付返回的状态码,其他支付方式用不到
 */
- (void) paymentEnd:(UMFPayResult)resultCode withPayType:(UMFPayType)payType wxResultCode:(int)wxCode
{
    self.isPaying = NO;
    self.payButton.enabled = YES;
    INFOLOG(@"-> 联动支付 [Type: %ld] 结果 ：[%ld]  wxResultCode: [%ld]", (long)payType, (long)resultCode, (long)wxCode);
    switch (resultCode) {
        case kUMFPayResultSuccess:  // 支付成功
        {
            if (self.paymentId && self.paymentId.length > 0) {
                [SVProgressHUD showWithStatus:nil];
                [self requestPayQuery];
            }
            else {
                [self alertWithTitle:@"支付成功" detail:@"请稍候在我的订单中查询订单状态" block:^{
                    [self.navigationController popViewControllerAnimated:NO];
                    if (self.finishBlock) {
                        self.finishBlock();
                    }
                }];
            }
        }
            break;
        case kUMFPayResultCancel:  // 取消支付
        {
            [SVProgressHUD showInfoWithStatus:@"已取消支付"];
        }
            break;
        case kUMFPayResultError:  // 支付失败
        {
            [self alertWithTitle:@"支付失败" detail:@"请重新支付，您可以尝试其他支付方式" block:nil];
        }
            break;
        case kUMFPayResultFinished:  // 支付完成,商户需要自己查单
        {
            if (self.paymentId && self.paymentId.length > 0) {
                [SVProgressHUD showWithStatus:nil];
                [self requestPayQuery];
            }
            else {
                [self alertWithTitle:@"支付完成" detail:@"请稍候在我的订单中查询订单状态" block:^{
                    [self.navigationController popViewControllerAnimated:NO];
                    if (self.finishBlock) {
                        self.finishBlock();
                    }
                }];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - AliPay

- (void) doAlipayPay:(NSString *)payInfo
{
    // NOTE: 调用支付接口开始支付
    @weakify(self)
    [[AlipaySDK defaultService] payOrder:payInfo
                              fromScheme:@"akapp"
                                callback:^(NSDictionary *resultDic)
    {
        @strongify(self)
        INFOLOG(@"AliPay : %@",resultDic);
        [self handleAlipayResult:resultDic];
    }];
}

- (void) didRecvAlipayResult:(NSNotification*)notification
{
    self.isPaying = NO;
    self.payButton.enabled = YES;
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
            if (self.paymentId && self.paymentId.length > 0) {
                [SVProgressHUD showWithStatus:nil];
                [self requestPayQuery];
            }
            else {
                [SVProgressHUD showSuccessWithStatus:@"订单支付成功！"];
                GCD_DELAY(^{
                    [self.navigationController popViewControllerAnimated:NO];
                    if (self.finishBlock) {
                        self.finishBlock();
                    }
                }, 2.0f);
            }
        }
            break;

        case 8000:
        case 6004:
        {
            if (self.paymentId && self.paymentId.length > 0) {
                [SVProgressHUD showWithStatus:nil];
                [self requestPayQuery];
            }
            else {
                [SVProgressHUD showInfoWithStatus:@"正在处理中，请查询支付状态！"];
                [self.navigationController popViewControllerAnimated:NO];
                if (self.finishBlock) {
                    self.finishBlock();
                }
            }
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
    self.isPaying = NO;
    self.payButton.enabled = YES;
    if (payResp.errCode == WXSuccess) {
        if (self.paymentId && self.paymentId.length > 0) {
            [SVProgressHUD showWithStatus:nil];
            [self requestPayQuery];
        }
        else {
            [SVProgressHUD showSuccessWithStatus:@"订单支付成功！"];
            GCD_DELAY(^{
                [self.navigationController popViewControllerAnimated:NO];
                if (self.finishBlock) {
                    self.finishBlock();
                }
            }, 2.0f);
        }
    }
    else if (payResp.errCode == WXErrCodeUserCancel) {
        [SVProgressHUD showErrorWithStatus:FORMAT(@"已取消支付！[code：%d]", payResp.errCode)];
    }
    else {
        ERRORLOG(@"支付失败: retcode = %d, retstr = %@", payResp.errCode, payResp.errStr);
        [SVProgressHUD showErrorWithStatus:FORMAT(@"支付失败！[code：%d]", payResp.errCode)];
    }
}


#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 1) {
        return 4;
    }
    
    else if (section == 2) {
        return self.payTypes ? self.payTypes.count : 0;
    }
    
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = isPad ? kPadCellHeight : kTableCellHeight;
    if (indexPath.section == 2) {
        return height * 1.3f;
    }
    return height;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.addressView.height;
    }
    else if (section == 2 && !self.payTypes) {
        return 0;
    }
    return 0.5f;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.addressView;
    }
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5f)];
    header.backgroundColor = COLOR_SEPERATOR_LINE;
    return header;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 0;
    }
    return isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CGFloat height = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    footer.backgroundColor = CLEAR_COLOR;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5f, SCREEN_WIDTH, 0.5f)];
    line.backgroundColor = COLOR_SEPERATOR_LINE;
    [footer addSubview:line];
    return footer;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        PaystyleTableCell *cell = [[PaystyleTableCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        PayType *payType = self.payTypes[indexPath.row];
        if (payType.paytype == kPayTypeYUE) {
            cell.imageView.image = [IMAGENAMED(@"logo_yue") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            cell.textLabel.text = @"余额支付";
            UserAccount *account = [UserManager instance].userInfo.account;
            if (account.keyongyue < self.order.zongjine) {
                cell.selectionDisabled = YES;
                cell.imageView.tintColor = COLOR_TEXT_LIGHT;
                cell.textLabel.textColor = COLOR_TEXT_LIGHT;
                cell.detailTextLabel.textColor = COLOR_TEXT_LIGHT;
                cell.detailTextLabel.text = @"账户余额不足";
            }
            else {
                cell.selectionDisabled = NO;
                cell.imageView.tintColor = COLOR_SELECTED;
                cell.textLabel.textColor = COLOR_TEXT_DARK;
                cell.detailTextLabel.textColor = COLOR_APP_ORANGE;
                cell.detailTextLabel.text = FORMAT(@"可用余额: %@", [NSString priceString:account.keyongyue]);
            }
        }
        else if (payType.paytype == kPayTypeWEIXIN) {
            cell.imageView.image = IMAGENAMED(@"logo_wxpay");
            cell.textLabel.text = payType.name;
            cell.detailTextLabel.text = payType.content;
        }
        else if (payType.paytype == kPayTypeALIPAY) {
            cell.imageView.image = IMAGENAMED(@"logo_alipay");
            cell.textLabel.text = payType.name;
            cell.detailTextLabel.text = payType.content;
        }
        else if (payType.paytype == kPayTypeUMFWXPay) {
            cell.imageView.image = IMAGENAMED(@"logo_wxpay");
            cell.textLabel.text = payType.name;
            cell.detailTextLabel.text = payType.content;
        }
        else if (payType.paytype == kPayTypeUMFAliPay) {
            cell.imageView.image = IMAGENAMED(@"logo_alipay");
            cell.textLabel.text = payType.name;
            cell.detailTextLabel.text = payType.content;
        }
        else if (payType.paytype == kPayTypeUMFChinaUnionPay) {
            cell.imageView.image = IMAGENAMED(@"logo_umpay");
            cell.textLabel.text = payType.name;
            cell.detailTextLabel.text = payType.content;
        }
        else {
            cell.textLabel.text = payType.name;
        }
        
        cell.checked = (indexPath.row == self.selectIndex);
//        cell.showSeperator = (indexPath.row < self.payTypes.count-1);
        
        return cell;
    }
    
    TableCellBase *cell = [[TableCellBase alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.detailTextLabel.textColor = COLOR_SELECTED;
    
    if (indexPath.section == 1) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionDisabled = YES;
        
        if (indexPath.row == 0) {
            cell.textLabel.text = FORMAT(@"商品金额（%ld 件）", (long)self.order.shangpinjianshu);
            cell.detailTextLabel.text = FORMAT(@"¥ %.2f", self.order.shangpinjine/100.0f);
        }
        else if (indexPath.row == 1) {
            cell.textLabel.text = @"优惠金额";
            cell.detailTextLabel.text = FORMAT(@"- ¥ %.2f", self.order.dikoujine/100.0f);
        }
        else if (indexPath.row == 2) {
            cell.textLabel.text = @"运 费";
            cell.detailTextLabel.text = FORMAT(@"+ ¥ %.2f", self.order.yunfei/100.0f);
        }
        else if (indexPath.row == 3) {
            cell.showSeperator = NO;

            cell.textLabel.font = [FontUtils buttonFont];
            cell.textLabel.textColor = COLOR_TEXT_DARK;
            cell.textLabel.text = @"应付金额";
            
            cell.detailTextLabel.font = BOLDSYSTEMFONT(18);
            cell.detailTextLabel.text = FORMAT(@"¥ %.2f", self.order.zongjine/100.0f);
        }
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2) {
        TableCellBase *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.selectionDisabled) {
            return;
        }
        
        self.selectIndex = indexPath.row;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
        
        PayType *payType = self.payTypes[indexPath.row];
        [self.payButton setNormalTitle:FORMAT(@"%@ ¥%.2f", payType.name, self.order.zongjine/100.0f)];
    }
}

#pragma mark - Lazy Load

- (UITableView *) tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        //        _tableView.frame = CGRectMake(0, self.titleView.height, self.view.width, self.view.height-self.titleView.height);
        _tableView.backgroundColor = CLEAR_COLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
        _tableView.showsVerticalScrollIndicator = NO;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
//        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kOFFSET_SIZE)];
//        footer.backgroundColor = CLEAR_COLOR;
//        _tableView.tableFooterView = footer;
    }
    return _tableView;
}

- (UIButton *) payButton
{
    if (!_payButton) {
        _payButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        CGFloat height = isPad ? 50 : 44;
        _payButton.frame = CGRectMake(0, self.view.height-height, SCREEN_WIDTH, height);
        _payButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, kSafeAreaBottomHeight*0.5, 0);

        _payButton.titleLabel.font = BOLDSYSTEMFONT(16);
        
        [_payButton setNormalColor:WHITE_COLOR highlighted:COLOR_SEPERATOR_LIGHT selected:nil];
        [_payButton setNormalTitleColor:nil disableColor:RGBCOLOR(0xF0, 0xF0, 0xF0)];
        [_payButton setBackgroundColor:COLOR_SELECTED];
        [_payButton setNormalTitle:@"去支付"];
        [_payButton setTitle:@"支付中请稍候..." forState:UIControlStateDisabled];
        
        [_payButton addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
        _payButton.hidden = YES;
    }
    return _payButton;
}

- (AddressView *) addressView
{
    if (!_addressView) {
        _addressView  = [[AddressView alloc] initWithFrame:CGRectZero];
        _addressView.backgroundColor = WHITE_COLOR;
        _addressView.editButton.hidden = YES;
    }
    return _addressView;
}

@end
