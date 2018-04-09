//
//  VIPPurchaseController.m
//  akucun
//
//  Created by Jarry on 2017/8/12.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "VIPPurchaseController.h"
#import "WebViewController.h"
#import "UserManager.h"
#import "RequestMemberBuy.h"
#import "RequestVIPList.h"
#import "RequestVIPPurchase.h"
#import "RequestUserInfo.h"
#import "RequestUseCode.h"
#import "RequestPaytypes.h"
#import "VIPUserView.h"
#import "VIPItemView.h"
#import "YYText.h"
#import "PopupPaystyleView.h"
#import "MMAlertView.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApiManager.h"
//#ifdef APPSTORE
//#import "IAPShare.h"
//#endif

@interface VIPPurchaseController () <UITableViewDataSource,UITableViewDelegate, WXApiManagerDelegate>
{
    CGFloat _itemHeight;
}

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataSource;

@property (nonatomic, strong) VIPUserView *userView;
//@property (nonatomic, strong) VIPItemView *vipItemView;

@property (nonatomic, strong) UILabel *vipTextLabel;

@property (nonatomic, strong) UIButton *buyButton;
@property (nonatomic, strong) UIButton *inviteButton;

@property (nonatomic, strong) VIPItem *vipItem ;

@property (nonatomic, strong) UILabel    *navLabel;
@property (nonatomic, strong) TextButton *backBtn;
@property (nonatomic, strong) UIView     *topView;
@property (nonatomic, strong) UIView     *topLine;

//#ifdef APPSTORE
//@property (nonatomic, strong) SKProduct *product;
//#endif

@end

@implementation VIPPurchaseController

- (void) setupContent
{
    [super setupContent];
    
    UserInfo *userInfo = [UserManager instance].userInfo;
//    userInfo.vipflag = 0;
    self.userView.userInfo = userInfo;
    [self.view addSubview:self.userView];
    
    if ([UserManager isVIP]) {
        self.title = @"会员等级";
        [self.buyButton setNormalTitle:@"会员续费"];
    }
    else {
        self.title = @"开通会员";
        [self.buyButton setNormalTitle:@"开通会员"];
    }
    
    // 考虑导航栏的高
    CGFloat statusH = kSafeAreaTopHeight - 44;
    [self.view addSubview:self.topView];
    [self.view addSubview:self.topLine];
    [self.view addSubview:self.backBtn];
//    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view).offset(0.5*offset);
//        make.top.equalTo(self.view).offset(statusH);
//        make.width.height.equalTo(@44);
//    }];
    
    [self.view addSubview:self.navLabel];
    [self.navLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(statusH);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@44);
    }];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.userView.mas_bottom);
    }];
    
    [self requestVIPList];
}

- (void) setTitle:(NSString *)title
{
    [super setTitle:title];
    self.navLabel.text = title;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - Action

- (void) selectPaytypes:(NSArray *)payTypes
{
    PopupPaystyleView *popupView = [[PopupPaystyleView alloc] initWithTitle:FORMAT(@"需支付 ¥ %ld", (long)self.vipItem.jine) types:payTypes value:self.vipItem.jine];
    @weakify(self)
    popupView.selectBlock = ^(int type) {
        @strongify(self)
        [self requestBuyVIP:type];
    };
    [popupView show];
}

- (IBAction) buyAction:(id)sender
{
//#ifdef APPSTORE
//    [self getIAPProducts];
//#else
    PayType *type1 = [PayType new];
    type1.paytype = kPayTypeWEIXIN;
    type1.name = @"微信支付";
    
    PayType *type2 = [PayType new];
    type2.paytype = kPayTypeALIPAY;
    type2.name = @"支付宝";

    [self selectPaytypes:@[type1,type2]];
    
//    [self requestPayType];
    
//#endif
}

- (IBAction) inviteAction:(id)sender
{
    MMAlertView *inputAlert =
    [[MMAlertView alloc] initWithInputTitle:@"邀请码\n"
                                     detail:@""
                                placeholder:@"请输入邀请码"
                                    handler:^(NSString *text)
     {
         [self requestActiveCode:text];
     }];
//    inputAlert.attachedView = self.view;
    [inputAlert show];
}

- (IBAction) ruleAction:(id)sender
{
    WebViewController *controller = [WebViewController new];
    controller.title = @"VIP等级规则";
    controller.url = URL_VIPLEVEL_RULE;
    [self.navigationController pushViewController:controller animated:YES];
}
/*
#ifdef APPSTORE
#pragma mark - IAP

- (void) getIAPProducts
{
    [SVProgressHUD showWithStatus:nil];
    
    NSSet* dataSet = [[NSSet alloc] initWithObjects:@"com.akucun.vip1", nil];
    [IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:dataSet];
    
#ifndef DEBUG
    [IAPShare sharedHelper].iap.production = YES;
#endif
    
    // 请求商品信息
    [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request, SKProductsResponse* response)
     {
         self.product = response.products[0];
         INFOLOG(@"=== IAP : %@ (%@) %@", self.product.localizedTitle, self.product.localizedDescription, self.product.priceLocale);
         
         [self buyIAPProduct:self.product];
     }];
}

- (void) buyIAPProduct:(SKProduct *)product
{
    [SVProgressHUD showWithStatus:nil];

    [[IAPShare sharedHelper].iap buyProduct:product
                               onCompletion:^(SKPaymentTransaction* trans)
    {
        if(trans.error) {
            ERRORLOG(@"Error : %@", trans.error);
            [SVProgressHUD showErrorWithStatus:trans.error.description];
        }
        else if(trans.transactionState == SKPaymentTransactionStatePurchased) {

            [SVProgressHUD dismiss];

            // 购买验证
            NSData *receiptData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
            
            NSString *receipt = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];// [GTMBase64 stringByEncodingData:receiptData];
            
            INFOLOG(@"IAP Buy Success : %@", receipt);

            [[IAPShare sharedHelper].iap checkReceipt:receiptData onCompletion:^(NSString *response, NSError *error) {
            
                INFOLOG(@"IAP Check Success : %@", response);
                
                NSDictionary *jsonData = [response objectFromJSONString];
                NSInteger status = [jsonData getIntegerValueForKey:@"status"];
                if (status == 0) {
                    NSDictionary *receipt = [jsonData objectForKey:@"receipt"];
                    NSArray *inAppArray = [receipt objectForKey:@"in_app"];
                    NSDictionary *result = [inAppArray lastObject];
                    if (result) {
                        NSString *transId = [result getStringForKey:@"transaction_id"];
                        [self requestMemberBuy:@"com.akucun.vip1" transId:transId];
                    }
                }
                else {
                    [SVProgressHUD showErrorWithStatus:@"会员购买失败，请重试 ！"];
                }
            }];
            
        }
        else if(trans.transactionState == SKPaymentTransactionStateFailed) {
            ERRORLOG(@"Error : %@", trans.error);
            [SVProgressHUD showErrorWithStatus:trans.error.description];

            if (trans.error.code == SKErrorPaymentCancelled) {
                
            }
            else if (trans.error.code == SKErrorClientInvalid) {
                
            }
            else if (trans.error.code == SKErrorPaymentInvalid) {
                
            }
            else if (trans.error.code == SKErrorPaymentNotAllowed) {
                
            }
            else if (trans.error.code == SKErrorStoreProductNotAvailable) {
            }
            else {
            }
        }
    }];
}

#endif
*/

- (void) showSuccess
{
    MMPopupItemHandler handler = ^(NSInteger index) {
        [self requestUserInfo];
        if (self.completionBlock) {
            self.completionBlock(self);
        }
    };
    NSArray *items =
    @[MMItemMake(@"确定", MMItemTypeHighlight, handler)];
    
    MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"会员购买成功 !\n请稍候查看会员状态" detail:@"" items:items];
    [alertView show];
}

#pragma mark -

- (void) requestVIPList
{
    [SVProgressHUD showWithStatus:nil];
    
    RequestVIPList *request = [RequestVIPList new];
    
    [SCHttpServiceFace serviceWithRequest:request onSuccess:^(id content)
     {
         [SVProgressHUD dismiss];
         
         ResponseVIPList *response = content;
         self.vipItem = response.result[0];
         [self.tableView reloadData];

     } onFailed:^(id content) {
         
     }];
}

- (void) requestBuyVIP:(NSInteger)payType
{
    [SVProgressHUD showWithStatus:nil];

    RequestVIPPurchase *request = [RequestVIPPurchase new];
    request.productid = self.vipItem.Id;
    request.paytype = payType;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
    {
        [SVProgressHUD dismiss];
        
        ResponseVIPPurchase *response = content;
        if (payType == kPayTypeALIPAY) {
            [self doAlipayPay:response.payInfo];
        }
        else if (payType == kPayTypeWEIXIN) {
            [self doWeixinPay:response.payInfo];
        }
        
    } onFailed:^(id content) {
        
    }];
}

// 购买成功 提交结果
- (void) requestMemberBuy:(NSString *)productId transId:(NSString *)transId
{
    RequestMemberBuy *request = [RequestMemberBuy new];
    request.productid = productId;
    request.transactionid = transId;
    
    [SCHttpServiceFace serviceWithRequest:request onSuccess:^(id content)
    {
        HttpResponseBase *response = content;
        NSDictionary *jsonData = response.responseData;
        NSDictionary *vipInfo = [jsonData objectForKey:@"vipinfo"];
        NSString *endTime = [vipInfo getStringForKey:@"vipendtime"];
        [UserManager instance].userInfo.vipendtime = endTime;
        self.userView.userInfo = [UserManager instance].userInfo;
        
        //
        [self showSuccess];
        
    } onFailed:^(id content) {

    }];
}

- (void) requestUserInfo
{
    [SVProgressHUD showWithStatus:nil];

    RequestUserInfo *request = [RequestUserInfo new];
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [SVProgressHUD dismiss];
         
         UserInfo *userInfo = [UserManager instance].userInfo;
         self.userView.userInfo = userInfo;
         
         if ([UserManager isVIP]) {
             self.title = @"会员状态";
             [self.buyButton setNormalTitle:@"会员续费"];
             self.inviteButton.hidden = YES;
         }
         else {
             self.title = @"开通会员";
             [self.buyButton setNormalTitle:@"开通会员"];
             self.inviteButton.hidden = NO;
         }
     }
                                 onFailed:^(id content)
     {
     }
                                  onError:^(id content)
     {
     }];
}

- (void) requestActiveCode:(NSString *)code
{
    [SVProgressHUD showWithStatus:nil];
    RequestUseCode *request = [RequestUseCode new];
    request.referralcode = code;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [SVProgressHUD dismiss];
         
         MMPopupItemHandler handler = ^(NSInteger index) {
             [self requestUserInfo];
         };
         NSArray *items =
         @[MMItemMake(@"确定", MMItemTypeHighlight, handler)];
         
         MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"邀请码已成功提交 !" detail:@"\n系统将为您开通会员，请稍候查看会员状态" items:items];
         [alertView show];
         
     } onFailed:^(id content) {
         
     }];
}
/*
- (void) requestPayType
{
    [SVProgressHUD showWithStatus:nil];
    RequestPaytypes *request = [RequestPaytypes new];
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [SVProgressHUD dismiss];
         
         ResponsePaytypes *response = content;
         NSArray *payTypes = [response validPayTypes];
         [self selectPaytypes:payTypes];
         
     } onFailed:^(id content) {
         
     }];
}*/

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

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"cellIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    VIPItemView *vipItemView = [[VIPItemView alloc] initWithFrame:CGRectMake(kOFFSET_SIZE, 0, SCREEN_WIDTH - kOFFSET_SIZE*2, _itemHeight)];
    [vipItemView setTitle:self.vipItem.miaoshu desp:nil price: FORMAT(@"¥ %ld", (long)self.vipItem.jine)];
    [cell.contentView addSubview:vipItemView];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)back:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -

- (UITableView *) tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = CLEAR_COLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
        _tableView.showsVerticalScrollIndicator = NO;
        
        CGSize size1 = [@"Text" sizeWithFont:BOLDSYSTEMFONT(17) maxWidth:SCREEN_WIDTH];
        CGSize size2 = [@"Text" sizeWithFont:[FontUtils smallFont] maxWidth:SCREEN_WIDTH];
        _itemHeight = size1.height + size2.height + kOFFSET_SIZE * 3;
        _tableView.rowHeight = _itemHeight;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        CGSize size = [@"Text" sizeWithFont:[FontUtils normalFont] maxWidth:SCREEN_WIDTH];
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kOFFSET_SIZE * 1.5 + size.height)];
        UILabel *vipTitle = [[UILabel alloc] init];
        vipTitle.font = [FontUtils normalFont];
        vipTitle.textColor = COLOR_TEXT_DARK;
        vipTitle.text = @"会员套餐";
        [vipTitle sizeToFit];
        vipTitle.left = kOFFSET_SIZE;
        vipTitle.top = kOFFSET_SIZE;
        [header addSubview:vipTitle];
        _tableView.tableHeaderView = header;
        
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kOFFSET_SIZE * 3 + 44)];
        footer.backgroundColor = CLEAR_COLOR;
        
        UILabel *vipDetail = [[UILabel alloc] init];
        vipDetail.font = [FontUtils normalFont];
        vipDetail.textColor = COLOR_TEXT_DARK;
        vipDetail.text = @"会员权益";
        [vipDetail sizeToFit];
        vipDetail.left = kOFFSET_SIZE;
        vipDetail.top = kOFFSET_SIZE;
        [footer addSubview:vipDetail];
        
        TextButton *ruleButton = [[TextButton alloc] init];
        ruleButton.frame = CGRectMake(0, 0, 120, 30);
        ruleButton.right = SCREEN_WIDTH - kOFFSET_SIZE;
        ruleButton.centerY = vipDetail.centerY;
        [ruleButton setTitleFont:BOLDSYSTEMFONT(13)];
        [ruleButton setTitleAlignment:NSTextAlignmentRight];
        [ruleButton setNormalTitle:@"等级规则>"];
        [ruleButton setNormalColor:COLOR_TEXT_NORMAL highlighted:COLOR_SELECTED selected:nil];
        [ruleButton addTarget:self action:@selector(ruleAction:) forControlEvents:UIControlEventTouchUpInside];
        [footer addSubview:ruleButton];

        UIView *detailView = [[UIView alloc] init];
        detailView.layer.borderColor = COLOR_SEPERATOR_LIGHT.CGColor;
        detailView.layer.borderWidth = 1.0f;
        [detailView addSubview:self.vipTextLabel];
        detailView.left = kOFFSET_SIZE;
        detailView.top = vipDetail.bottom + kOFFSET_SIZE * 0.5f;
        detailView.width = SCREEN_WIDTH - kOFFSET_SIZE*2;
        detailView.height = self.vipTextLabel.bottom + kOFFSET_SIZE;
        [footer addSubview:detailView];
        
        self.buyButton.top = detailView.bottom + kOFFSET_SIZE * 4;
        [footer addSubview:self.buyButton];
        
//        if (![UserManager isVIP]) {
//            self.inviteButton.top = self.buyButton.bottom + kOFFSET_SIZE;
//            [footer addSubview:self.inviteButton];
//            footer.height = self.inviteButton.bottom + kOFFSET_SIZE;
//        }
//        else {
            footer.height = self.buyButton.bottom + kOFFSET_SIZE;
//        }
        _tableView.tableFooterView = footer;
    }
    return _tableView;
}

- (VIPUserView *) userView
{
    if (!_userView) {
        _userView = [[VIPUserView alloc] initWithFrame:CGRectMake(0, kSafeAreaTopHeight, SCREEN_WIDTH, 0)];
    }
    return _userView;
}

- (UILabel *) vipTextLabel
{
    if (!_vipTextLabel) {
        _vipTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(kOFFSET_SIZE, kOFFSET_SIZE, SCREEN_WIDTH-kOFFSET_SIZE*4, 0)];
        _vipTextLabel.font = [FontUtils normalFont];
        _vipTextLabel.textColor = COLOR_TEXT_NORMAL;
        _vipTextLabel.numberOfLines = 0;
        
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:@"1. 系统仅支持VIP会员下单，享受特价优惠\n2. 根据您的日常转发和下单行为，系统会自动调整会员级别\n3. 不同会员级别，有不同的购物车商品数量限制和订单支付时限"];
        
        attributedText.yy_font = [FontUtils normalFont];
        attributedText.yy_color = COLOR_TEXT_NORMAL;
        attributedText.yy_lineSpacing = 10.0f;
        
        _vipTextLabel.attributedText = attributedText;
        
        [_vipTextLabel sizeToFit];
    }
    return _vipTextLabel;
}

- (UIButton *) buyButton
{
    if (!_buyButton) {
        _buyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _buyButton.backgroundColor = COLOR_SELECTED;
        CGFloat height = isPad ? 50 : kFIELD_HEIGHT;
        _buyButton.frame = CGRectMake(kOFFSET_SIZE, kOFFSET_SIZE*2, SCREEN_WIDTH - kOFFSET_SIZE*2, height);
        _buyButton.clipsToBounds = YES;
        _buyButton.layer.cornerRadius = 5;
        _buyButton.layer.borderWidth = 0.5f;
        _buyButton.layer.borderColor = RGBCOLOR(225, 225, 225).CGColor;
        
        _buyButton.titleLabel.font = BOLDSYSTEMFONT(16);
        
        [_buyButton setNormalColor:WHITE_COLOR highlighted:COLOR_TEXT_LIGHT selected:nil];
        
        [_buyButton addTarget:self action:@selector(buyAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyButton;
}

- (UIButton *) inviteButton
{
    if (!_inviteButton) {
        _inviteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _inviteButton.backgroundColor = COLOR_BG_TEXT_DISABLED;
        CGFloat height = isPad ? 50 : kFIELD_HEIGHT;
        _inviteButton.frame = CGRectMake(kOFFSET_SIZE, kOFFSET_SIZE*2, SCREEN_WIDTH - kOFFSET_SIZE*2, height);
        _inviteButton.clipsToBounds = YES;
        _inviteButton.layer.cornerRadius = 5;
        _inviteButton.layer.borderWidth = 0.5f;
        _inviteButton.layer.borderColor = COLOR_SEPERATOR_LINE.CGColor;
        
        _inviteButton.titleLabel.font = BOLDSYSTEMFONT(16);
        
        [_inviteButton setNormalColor:COLOR_TEXT_NORMAL highlighted:COLOR_SELECTED selected:nil];
        [_inviteButton setNormalTitle:@"输入邀请码"];

        [_inviteButton addTarget:self action:@selector(inviteAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _inviteButton;
}

- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc]init];
        _topView.backgroundColor = RGBCOLOR(249, 249, 249);
        _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kSafeAreaTopHeight);
    }
    return _topView;
}

- (UIView *)topLine
{
    if (!_topLine) {
        _topLine = [[UIView alloc]init];
        _topLine.backgroundColor = COLOR_TEXT_NORMAL;
        _topLine.frame = CGRectMake(0, kSafeAreaTopHeight-kPIXEL_WIDTH, SCREEN_WIDTH, kPIXEL_WIDTH);
    }
    return _topLine;
}

- (TextButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [[TextButton alloc]init];
        //[_backBtn setImage:[UIImage imageNamed:@"collegeBack"] forState:UIControlStateNormal];
        CGFloat statusH = kSafeAreaTopHeight - 44;
        _backBtn.frame = CGRectMake(16, statusH, 60, 44);
        _backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _backBtn.clipsToBounds = YES;
        
        [_backBtn setTitleFont:FA_ICONFONTSIZE(30)];
        [_backBtn setTitleAlignment:NSTextAlignmentLeft];
        
        [_backBtn setTitle:FA_ICONFONT_BACK forState:UIControlStateNormal];
        [_backBtn setTitleColor:COLOR_TEXT_DARK forState:UIControlStateNormal];
        [_backBtn setTitleColor:COLOR_SELECTED forState:UIControlStateHighlighted];
        
        [_backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UILabel *)navLabel
{
    if (_navLabel == nil) {
        _navLabel = [[UILabel alloc]init];
        _navLabel.text = @"会员等级";
        _navLabel.font = SYSTEMFONT(18);
        _navLabel.textColor = COLOR_TITLE;
    }
    return _navLabel;
}

@end
