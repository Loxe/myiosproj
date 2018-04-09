//
//  MeViewController.m
//  akucun
//
//  Created by deepin do on 2018/1/7.
//  Copyright © 2018年 Sucang. All rights reserved.
//


#import "MeViewController.h"
#import "AppDelegate.h"
#import "ECTabBarController.h"
#import "MainViewController.h"
#import "AccountSetupController.h"
#import "RechargeViewController.h"
#import "AccountDetailController.h"
#import "UserEditViewController.h"
#import "MyOrderController.h"
#import "ASaleListController.h"
#import "AfterSalesController.h"
#import "TradeListController.h"
#import "OrderCheckViewController.h"
#import "OrderAfterSaleController.h"
#import "MJRefresh.h"
#import "MeMoreCell.h"
#import "MeSaleCell.h"
#import "UserManager.h"
#import "MeOrderCell.h"
#import "MeHeaderCell.h"
#import "MeFeedSaleCell.h"
#import "JXMCSUserManager.h"
#import "MeSectionHeaderView.h"
#import "RequestUserInfo.h"
#import "RequestAddrList.h"
#import "RequestOrderCount.h"
#import "UIImageView+WebCache.h"
#import "IDCardController.h"
#import "UIView+DDExtension.h"
#import "CameraUtils.h"
#import "PopupPeihuoView.h"
#import "MMAlertView.h"
#import "RequestReportScan.h"
#import "RequestBarcodeSearch.h"
#import "UserGuideManager.h"
#import "MeMoreCell.h"
#import "InviteFriendController.h"
#import "TeamListController.h"
#import "BarcodeScanController.h"
#import "InviteFriendListController.h"
#import "WebViewController.h"

@interface MeViewController ()<UITableViewDataSource,UITableViewDelegate,MeSaleCellDelegate,MeOrderCellDelegate,MeFeedSaleCellDelegate,MeMoreCellDelegate>

@property (nonatomic, strong) UITableView  *tableView;

@property (nonatomic, strong) MeSectionHeaderView *orderHeaderView;
@property (nonatomic, strong) MeSectionHeaderView *feedHeaderView;

@property (nonatomic, assign) NSInteger count0, count1, count2, count3, count4;
@property (nonatomic, assign) NSInteger acount0, acount1, acount2, acount3, acount4;

@end

@implementation MeViewController

- (void) setupContent
{
    [super setupContent];
    
    [self prepareNav];
    [self prepareSubView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateUserInfo) name:NOTIFICATION_UPDATE_USERINFO object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceivedReward) name:NOTIFICATION_REWARD_RECEIVED object:nil];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) initViewData
{
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.ec_tabBarController.navigationController.navigationBar setTitleTextAttributes:@{ NSFontAttributeName: SYSTEMFONT(18) }];
    
//    self.msgCount = 0;
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FORWARD_HIDE object:nil]; //临时修改，发通知让“转发按钮隐藏”
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    [self requestOrderCount];
    [self requestUserInfo];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void) didUpdateUserInfo
{
    if ([self isVisible]) {
        [self.tableView reloadData];
    }
}

- (void) didReceivedReward
{
    GCD_DELAY(^{
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
        CGFloat offset = isPad ? 20 : kOFFSET_SIZE;
        CGFloat top = kSafeAreaTopHeight + 50 + offset*4;
        [UserGuideManager createFrameUserGuide:nil title:@"奖励已发放至您的账户余额，\n\n可以点击进入查看明细" focusedFrame:CGRectMake(5, top, SCREEN_WIDTH-10, 60)];
    }, .3f)
}

- (void)showUserGuide
{
    if (![self isVisible]) {
        return;
    }
    
    if (self.count0 > 0) {
        // 有未支付订单
        MeOrderCell *cell = (MeOrderCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        if (!cell) {
            return;
        }
        
        [cell showGuideAt:0];
    }
    else {
        // 更多功能
//        [self updateMoreCell];
    }
}

- (void)updateMoreCell
{
    MeMoreCell *cell = (MeMoreCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    if (!cell) {
        return;
    }
    
    UserInfo *userInfo = [UserManager instance].userInfo;
    if (userInfo.prcstatu) { // 邀请码功能提示
        // 显示 New
        [cell updateItemAt:5];
        // 显示 邀请好友 新功能引导
        if ([UserGuideManager shouldShowGuide:kUserGuideFuncInvite]) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3] atScrollPosition:UITableViewScrollPositionNone animated:NO];
            [cell showGuideAt:5];
            return;
        }
        // 显示 有好友需要开通 功能引导
        if (userInfo.inviteCount > 0 && [UserGuideManager shouldShowGuide:kUserGuideNewInvitation]) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3] atScrollPosition:UITableViewScrollPositionNone animated:NO];
            [cell showGuideAt:5];
            return;
        }
    }
    
    if (userInfo.memberCount > 0)  {    // 团队成员
        // 显示 New
        [cell updateItemAt:6];
        // 显示 我的团队 新功能引导
        if ([UserGuideManager shouldShowGuide:kUserGuideNewTeam]) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3] atScrollPosition:UITableViewScrollPositionNone animated:NO];
            [cell showGuideAt:6];
            return;
        }
    }
}

- (void)prepareNav
{
    self.view.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = @"我";
    
    [self ec_setTabTitle:@"我"];
    [self ec_setTabImage:@"icon_my"];
}

- (void)prepareSubView
{
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    @weakify(self)
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self requestUserInfo];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.textColor = LIGHTGRAY_COLOR;
    self.tableView.mj_header = refreshHeader;
}

- (void) requestUserInfo
{
    RequestUserInfo *request = [RequestUserInfo new];
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [self.tableView.mj_header endRefreshing];
         //
         [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
         
         [self requestUserAddress];
         
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

- (void) requestUserAddress
{
    RequestAddrList *request = [RequestAddrList new];
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [self requestOrderCount];
     } onFailed:nil];
}

- (void) requestOrderCount
{
    RequestOrderCount *request = [RequestOrderCount new];
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         HttpResponseBase *response = content;
         NSDictionary *jsonData = response.responseData;
         
         NSDictionary *stat = [jsonData objectForKey:@"stat"];
         self.count0 = [stat getIntegerValueForKey:@"0"];
         self.count1 = [stat getIntegerValueForKey:@"1"];
         self.count2 = [stat getIntegerValueForKey:@"3"];
         self.count3 = [stat getIntegerValueForKey:@"2"];
         self.count4 = [stat getIntegerValueForKey:@"4"];
         
         NSDictionary *aftersale = [jsonData objectForKey:@"aftersalestat"];
         self.acount0 = [aftersale getIntegerValueForKey:@"0"];
         self.acount1 = [aftersale getIntegerValueForKey:@"1"];
         self.acount2 = [aftersale getIntegerValueForKey:@"2"];
         self.acount3 = [aftersale getIntegerValueForKey:@"3"];
         self.acount4 = [aftersale getIntegerValueForKey:@"5"];
         
         [self.tableView reloadData];
         
         GCD_DELAY(^{
             [self showUserGuide];
         }, .3f);
         
     } onFailed:^(id content)
     {
     } onError:^(id content)
     {
     }];
}

#pragma mark - Actions

- (IBAction) editUserAction:(id)sender
{
    UserEditViewController *controller = [UserEditViewController new];
    controller.finishBlock = ^{
    };
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) orderAction:(NSInteger)type
{
    MyOrderController *controller = [MyOrderController new];
    controller.orderType = type;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) salesAction:(NSInteger)type
{
    if (type == 100) {
        ASaleListController *controller = [ASaleListController new];
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
    
    AfterSalesController *controller = [AfterSalesController new];
    controller.salesType = type;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /** 获取当前登录用户的信息 */
    UserInfo *userInfo = [UserManager instance].userInfo;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            MeHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeHeaderCell" forIndexPath:indexPath];
            @weakify(self)
            cell.avatarBlock = ^{
                @strongify(self)
                AccountSetupController *vc = [AccountSetupController new];
                [self.navigationController pushViewController:vc animated:YES];
            };
            cell.levelRuleBlock = ^(id nsobject) {
                @strongify(self)
                WebViewController *controller = [WebViewController new];
                controller.title = @"VIP等级规则";
                controller.url = URL_VIPLEVEL_RULE;
                [self.navigationController pushViewController:controller animated:YES];
            };
            cell.rechargeBlock = ^{
                @strongify(self)
                RechargeViewController *controller = [RechargeViewController new];
                [self.navigationController pushViewController:controller animated:YES];
            };
            cell.accountBlock = ^{
                @strongify(self)
                AccountDetailController *controller = [AccountDetailController new];
                [self.navigationController pushViewController:controller animated:YES];
            };
            
            [cell updateData];
            
            return cell;
        } else {
            MeSaleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeSaleCell" forIndexPath:indexPath];
            cell.delegate = self;
            cell.collectionView.contentOffset = CGPointMake(0, 0);
            cell.priceArray = @[@(userInfo.todaystat), @(userInfo.todayfee), @(userInfo.monthfee),@(userInfo.monthsale), @(userInfo.lastmonthstat), @(userInfo.lastmonthfee)];
            //NSLog(@"---collectionView.contentOffset.x %lf",cell.collectionView.contentOffset.x);
            [cell.collectionView reloadData];
            return cell;
        }
        
    } else if (indexPath.section == 1) {
        
        MeOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeOrderCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.countArray = @[@(self.count0),@(self.count1),@(self.count2),@(self.count3),@(self.count4)];
        [cell.collectionView reloadData];
        return cell;
        
    } else if (indexPath.section == 2) {
        
        MeFeedSaleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeFeedSaleCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.countArray = @[@(self.acount0),@(self.acount1),@(self.acount2),@(self.acount3),@(self.acount4)];
        [cell.collectionView reloadData];
        return cell;
        
    } else {
        
        MeMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeMoreCell" forIndexPath:indexPath];
        cell.delegate = self;
        /** 获取当前登录用户的信息 */
        UserInfo *userInfo = [UserManager instance].userInfo;
        BOOL inviteStatus  = userInfo.prcstatu;
        BOOL reload = NO;
        if (inviteStatus && ![cell.btnTitleArray containsObject:@"邀请好友"]) {
            [cell.btnTitleArray addObject:@"邀请好友"];
            [cell.btnImgArray addObject:@"invite"];
            [cell.btnTagArray addObject:@KInviteFriendTag];
            [cell.btnBGColorArray addObject:RGBCOLOR(144, 108, 246)];
            reload = YES;
        }
        if (userInfo.memberCount > 0 && ![cell.btnTitleArray containsObject:@"我的好友"]) {
            [cell.btnTitleArray addObject:@"我的好友"];
            [cell.btnImgArray addObject:@"team"];
            [cell.btnTagArray addObject:@KMyTeamTag];
            [cell.btnBGColorArray addObject:RGBCOLOR(149, 204, 223)];
            reload = YES;
        }
        if (reload) {
            [cell.collectionView reloadData];
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat offset = isPad ? 20 : kOFFSET_SIZE;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UserInfo *userInfo = [UserManager instance].userInfo;
            if (userInfo.isBalancePay) {  // 支持余额功能
                return isPad ? 115+5*offset : 115+4.2*offset;
            }
            return 75+3*offset;
        } else {
            return isPad ? kItemH+1.5*kOFFSET_SIZE : kItemH+2.2*kOFFSET_SIZE;
        }
    } else if (indexPath.section == 1) {
        return isPad ? 125 : 90;
    } else if (indexPath.section == 2) {
        return isPad ? 125 : 90;
    } else {
        return  isPad ? 180+1.5*kOFFSET_SIZE : 180;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        [self.feedHeaderView setHeaderViewNameTitle:@"我的订单" actionTitle:@"查看全部"];
        @weakify(self)
        self.feedHeaderView.clickBlock = ^(id nsobject) {
//            NSLog(@"我的订单 全部");
            @strongify(self)
            [self orderAction:0];
        };
        return self.feedHeaderView;
        
    } else if (section == 2) {
        [self.orderHeaderView setHeaderViewNameTitle:@"退款/售后" actionTitle:@"查看全部"];
        @weakify(self)
        self.orderHeaderView.clickBlock = ^(id nsobject) {
//            NSLog(@"退款/售后申请记录");
            @strongify(self)
            [self salesAction:-1];
        };
        return self.orderHeaderView;
        
    } else {
        
        UIView *v = [UIView new];
        v.backgroundColor = COLOR_BG_HEADER;
        return v;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    } else if (section == 1) {
        return isPad ? kOFFSET_SIZE : 30;
    } else if (section == 2) {
        return isPad ? kOFFSET_SIZE : 30;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    v.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return isPad ? 0.5*kOFFSET_SIZE : 15;
    } else if (section == 1) {
        return isPad ? 0.5*kOFFSET_SIZE : 15;
    } else if (section == 2) {
        return isPad ? 0.5*kOFFSET_SIZE : 15;
    } else {
        return 0;
    }
}

#pragma mark - MeSaleCellDelegate
- (void)didSelectMeSaleCellTag:(NSInteger)index
{
//    if (![UserManager isPrimaryAccount]) {
//        [SVProgressHUD showInfoWithStatus:@"为了保护您的个人隐私，\n请用手机号主账号登录后查看"];
//    }
}

#pragma mark - MeOrderCellDelegate
- (void)didSelectMeOrderCellTag:(NSInteger)index
{
    if (index == 0) {
        NSLog(@"待支付");
    } else if (index == 1) {
        NSLog(@"待发货");
    } else if (index == 2) {
        NSLog(@"拣货中");
    } else if (index == 3) {
        NSLog(@"已发货");
    } else if (index == 4) {
        NSLog(@"已取消");
    }
    
    [self orderAction:(index+1)];
}

#pragma mark - MeFeedSaleCellDelegate
- (void)didSelectMeFeedSaleCellTag:(NSInteger)index
{
    /*
    if (index == 0) {
        NSLog(@"平台缺货");
    } else if (index == 1) {
        NSLog(@"用户取消");
    } else if (index == 2) {
        NSLog(@"退货中");
    } else if (index == 3) {
        NSLog(@"已退货");
    } else if (index == 4) {
        NSLog(@"售后申请");
    }*/
    
    if (index == 4) {
        [self salesAction:100];
    }
    else {
        [self salesAction:(index)];
    }
}

#pragma mark - MeMoreCellDelegate
- (void)didSelectMeMoreCellTag:(NSInteger)clickTag
{
    if (clickTag == KPersonOrderTag) {
        TradeListController *vc = [TradeListController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (clickTag == KCustomerCheckTag) {
        // 对账
        OrderCheckViewController *vc = [OrderCheckViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (clickTag == KScanPickingTag) {
        // 扫码分拣
        [self scanAction];
    }
    
    if (clickTag == KApplyFeedTag) {
        // 申请售后
        [self aftersalesAction];
    }
    
    if (clickTag == KCustomerServiceTag) {
        // 联系客服
        [self requestCSAction];
    }
    /*else if (index == 4) {
        NSLog(@"实名认证");
        IDCardController *controller = [IDCardController new];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:controller];
        [self presentViewController:nav animated:YES completion:nil];
    }*/
    
    if (clickTag == KInviteFriendTag) {
//        InviteViewController *vc = [InviteViewController new];
//        InviteFriendController *vc = [InviteFriendController new];
        InviteFriendListController *vc = [InviteFriendListController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (clickTag == KMyTeamTag) {
//        MyTeamController *vc = [MyTeamController new];
        TeamListController *vc = [TeamListController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    /*else if (index == 6) {
        NSLog(@"销售统计");
    }*/
}

#pragma mark - 扫码分拣

- (void) scanAction
{
    if ([CameraUtils isCameraNotDetermined]) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    // 用户授权
//                    self.scanReader.title = @"扫码分拣";
//                    [self presentViewController:self.scanReader animated:YES completion:nil];
                    [self showSGQScanVC];
                }
                else {
                    // 用户拒绝授权
                    [self showCameraDenied];
                }
            });
        }];
    }
    else if ([CameraUtils isCameraDenied]) {
        // 摄像头已被禁用
        [self showCameraDenied];
    }
    else {
        // 用户允许访问摄像头
        [self showSGQScanVC];
    }
}

- (void) showSGQScanVC
{
//    [SVProgressHUD showWithStatus:@"摄像头开启中，请稍候..."];
//    BarcodeScanController *scanController = [AppDelegate sharedDelegate].scanController;
//    if (!scanController) {
//        scanController = [[BarcodeScanController alloc] init];
//        [AppDelegate sharedDelegate].scanController = scanController;
//    }
    BarcodeScanController *scanController = [[BarcodeScanController alloc] init];
    scanController.liveId = nil;
    [self.ec_tabBarController presentViewController:scanController animated:YES completion:nil];
}

- (void) showCameraDenied
{
    [self confirmWithTitle:@"摄像头未授权" detail:@"摄像头访问未授权，您可以在设置中打开" btnText:@"去设置" block:^{
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    } canceled:nil];
}

#pragma mark - 申请售后

- (void) aftersalesAction
{
    OrderAfterSaleController *vc = [OrderAfterSaleController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 请求客服页面

- (void) requestCSAction
{
    NSString *tempAPPKEY = @"";
    
    /** 保留之前会话判断 */
    if ([ServiceTypeManager instance].serviceType == ServiceTypeNone) {
        tempAPPKEY = JX_FEEDAPPKEY;
        [ServiceTypeManager instance].serviceType = ServiceTypeFeed;
    }
    
    if ([ServiceTypeManager instance].serviceType == ServiceTypeFeed) {
        tempAPPKEY = JX_FEEDAPPKEY;
        [ServiceTypeManager instance].serviceType = ServiceTypeFeed;
    }
    
    if ([ServiceTypeManager instance].serviceType == ServiceTypeSale) {
        tempAPPKEY = JX_SALEAPPKEY;
        [ServiceTypeManager instance].serviceType = ServiceTypeSale;
//        [sClient.mcsManager leaveService];
    }
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    // 获取当前登录用户的信息
    NSString *userID = [UserManager subuserId]; // 子账号ID
    NSString *name   = [UserManager instance].userInfo.name;
    NSString *bianhao = [UserManager instance].userInfo.yonghubianhao;
    NSString *viplevel = kIntergerToString([UserManager instance].userInfo.viplevel);
    NSDictionary *clientConfig = @{@"cid" : userID,
                                   @"crm" : @{@"name" : FORMAT(@"%@ [%@]",name,bianhao),
                                              @"extend1" : bianhao,
                                              @"extend2" : viplevel
                                              }
                                   };
    
    [sClient initializeSDKWithAppKey:tempAPPKEY andLaunchOptions:nil andConfig:clientConfig];
    WEAKSELF;
    [[JXMCSUserManager sharedInstance] loginWithCallback:^(BOOL success, id response) {
        [SVProgressHUD dismiss];
        if (success) {
//            [ServiceTypeManager instance].serviceType = ServiceTypeFeed;
            JXMcsChatConfig *config = [JXMcsChatConfig defaultConfig];
            NSString *avatorStr = [UserManager instance].userInfo.avatar;
            NSURL *url = [NSURL URLWithString:avatorStr];
            NSData *data = [NSData dataWithContentsOfURL:url];
            config.avatorImage = [UIImage imageWithData:data];
            
            UIViewController *topVC = [weakSelf.view topViewController];
            [[JXMCSUserManager sharedInstance] requestCSForUI:topVC.navigationController witConfig:config];
            
        } else {
            NSLog(@"%@", response);
        }
    }];
//    /** 佳信售后客服 */
//    if ([ServiceTypeManager instance].serviceType == ServiceTypeSale) {
//        [sClient.mcsManager leaveService];
//    }
//
//    [SVProgressHUD showWithStatus:@"加载中..."];
//    // 获取当前登录用户的信息
//    NSString *userID = [UserManager subuserId]; // 子账号ID
//    NSString *name   = [UserManager instance].userInfo.name;
//    NSString *bianhao = [UserManager instance].userInfo.yonghubianhao;
//    NSString *viplevel = kIntergerToString([UserManager instance].userInfo.viplevel);
//    NSDictionary *clientConfig = @{@"cid" : userID,
//                                   @"crm" : @{@"name" : name,
//                                              @"extend1" : bianhao,
//                                              @"extend2" : viplevel
//                                              }
//                                   };
//
//    [sClient initializeSDKWithAppKey:JX_FEEDAPPKEY andLaunchOptions:nil andConfig:clientConfig];
//    WEAKSELF;
//    [[JXMCSUserManager sharedInstance] loginWithCallback:^(BOOL success, id response) {
//        [SVProgressHUD dismiss];
//        if (success) {
//            [ServiceTypeManager instance].serviceType = ServiceTypeFeed;
//            JXMcsChatConfig *config = [JXMcsChatConfig defaultConfig];
//            NSString *avatorStr = [UserManager instance].userInfo.avatar;
//            NSURL *url = [NSURL URLWithString:avatorStr];
//            NSData *data = [NSData dataWithContentsOfURL:url];
//            config.avatorImage = [UIImage imageWithData:data];
//
//            UIViewController *topVC = [weakSelf.view topViewController];
//            [[JXMCSUserManager sharedInstance] requestCSForUI:topVC.navigationController witConfig:config];
//
//        } else {
//            NSLog(@"%@", response);
//        }
//    }];
}

#pragma mark - LAZY
- (UITableView *)tableView
{
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = RGBCOLOR(240, 240, 240);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[MeHeaderCell class]   forCellReuseIdentifier:@"MeHeaderCell"];
        [_tableView registerClass:[MeSaleCell class]      forCellReuseIdentifier:@"MeSaleCell"];
        [_tableView registerClass:[MeFeedSaleCell class] forCellReuseIdentifier:@"MeFeedSaleCell"];
        [_tableView registerClass:[MeOrderCell class]    forCellReuseIdentifier:@"MeOrderCell"];
        [_tableView registerClass:[MeMoreCell class]      forCellReuseIdentifier:@"MeMoreCell"];
        
//        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kSafeAreaBottomHeight)];
//        _tableView.tableFooterView = footer;
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
        }
    }
    return _tableView;
}

- (MeSectionHeaderView *)feedHeaderView
{
    if (_feedHeaderView == nil) {
        _feedHeaderView = [[MeSectionHeaderView alloc]init];
        _feedHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
        _feedHeaderView.backgroundColor = WHITE_COLOR;
    }
    return _feedHeaderView;
}

- (MeSectionHeaderView *)orderHeaderView
{
    if (_orderHeaderView == nil) {
        _orderHeaderView = [[MeSectionHeaderView alloc]init];
        _orderHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
        _orderHeaderView.backgroundColor = WHITE_COLOR;
    }
    return _orderHeaderView;
}

@end
