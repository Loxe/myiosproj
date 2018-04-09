//
//  MainViewController.m
//  akucun
//
//  Created by Jarry on 2017/3/21.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "MainViewController.h"
#import "ECTNavItemController.h"
#import "MMAlertView.h"
#import "HomeViewController.h"
#import "LiveProductController.h"
#import "DiscoverPageController.h"
#import "FollowViewController.h"
#import "CartViewController.h"
#import "AccountSetupController.h"
#import "ForwardConfigController.h"
#import "MessagesController.h"
#import "ProductsViewController.h"
#import "VIPPurchaseController.h"
#import "UserManager.h"
#import "ProductsManager.h"
#import "LiveManager.h"
#import <GTSDK/GeTuiSdk.h>
#import "ZYSuspensionView.h"
#import "PopupForwardView.h"
#import "ShareActivity.h"
#import "RequestProductForward.h"
#import "RequestMsgList.h"
#import "RequestUseCode.h"
#import "RequestUserInfo.h"
#import "RequestRewardStatus.h"
#import "RequestUserStatus.h"
#import "RequestDiscoverCheck.h"
#import "RequestLiveCheck.h"
#import "RequestRewardReceived.h"
#import "LZActionSheet.h"
#import "TZImagePickerController.h"
#import "MomentViewController.h"
#import "PhotoSelectModel.h"
#import "VideoSelectModel.h"

#import "TZImageManager.h"
#import <AliyunVideoSDK/AliyunVideoSDK.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UIViewController+DDExtension.h"
#import "PermissonManger.h"
#import "LeftMenuController.h"
#import "JXMCSUserManager.h"

#import "MeViewController.h"
#import "CodeScanAlert.h"
#import "WaveBallView.h"
#import "BallWaveView.h"

#import "PopupImageView.h"
#import "RequestIdeos.h"
#import "SDWebImageManager.h"
#import "VIPZeroController.h"
#import "VIPLevelAlertView.h"
#import "SCLAlertView.h"
#import "RewardAlertView.h"
#import "EBBannerView.h"

@interface MainViewController () <ZYSuspensionViewDelegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AliyunVideoBaseDelegate>

@property (nonatomic, strong) UIView *leftMenuView;
@property (nonatomic, strong) UIButton *tapButton;
@property (nonatomic, strong) UILabel *leftTitleLabel;
@property (nonatomic, strong) LeftMenuController *leftMenuController;
@property (nonatomic, assign) BOOL isLeftMenuOpened;

@property (nonatomic, strong) HomeViewController *homeController;
@property (nonatomic, strong) DiscoverPageController *discoverController;

@property (nonatomic, strong) TextButton *messageButton, *listButton;
@property (nonatomic, strong) UIButton *settingButton;

//@property (nonatomic, strong) ZYSuspensionView *floatingButton;
//@property (nonatomic, strong) BallWaveView *floatingButton;
@property (nonatomic, strong) WaveBallView *floatingButton;

@property (nonatomic, assign) BOOL isDowngradeShowed;

//@property (nonatomic, strong) NSDictionary *rewardInfo;
@property (nonatomic, strong) NSMutableArray *rewardInfos;
@property (nonatomic, assign) BOOL isShowReward;

@end

@implementation MainViewController

- (BOOL) shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void) updateLeftButton:(UIButton *)button
{
    if (button) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    else {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.listButton];
    }
}

- (void) updateForwardPinpai:(NSString *)pinpaiId
{
    if (pinpaiId) {
        self.liveId = pinpaiId;
        [ProductsManager instance].forwardPinpai = [LiveManager liveIndexByLiveId:pinpaiId];
    }
    [self didShowForward];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    //
    self.leftMenuController = [LeftMenuController new];
    self.leftMenuController.view.frame = self.leftMenuView.bounds;
    [self.leftMenuView addSubview:self.leftMenuController.view];
    [self addChildViewController:self.leftMenuController];
    [self.view addSubview:self.leftMenuView];
    //
    @weakify(self)
    self.leftMenuController.selectBlock = ^(int index, id content) {
        @strongify(self)
        [self hideLeftMenu:NO];
        
        if (self.selectedIndex != 0) {
            self.selectedIndex = 0;
        }
        
        LiveInfo *liveInfo = content;
        [self updateForwardPinpai:liveInfo.liveid];

        UIViewController *viewController = [self.homeController.navigationController.viewControllers lastObject];
        if ([viewController isKindOfClass:[LiveProductController class]]) {
            
            LiveProductController *pController = (LiveProductController *)viewController;
            [pController updateLive:liveInfo];
            
            return;
        }
        
        LiveProductController *controller = [LiveProductController new];
        controller.liveInfo = liveInfo;
        [self.homeController.navigationController pushViewController:controller animated:YES];
        

    };
    
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRecvTokenExpired) name:NOTIFICATION_TOKEN_EXPIRED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNotVIPMsg) name:NOTIFICATION_NOT_VIP object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAddFollow) name:NOTIFICATION_ADD_FOLLOW object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAddProductToCart) name:NOTIFICATION_ADD_TO_CART object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didHideForward) name:NOTIFICATION_FORWARD_HIDE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didShowForward) name:NOTIFICATION_FORWARD_SHOW object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceivedMsg) name:NOTIFICATION_RECIEVED_MSG object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterForeground:) name:NOTIFICATION_APP_FOREGROUND object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMePageAfterVIP0Upgrade) name:NOTIFICATION_VIP0_UPGRADED object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedRewardInfo:) name:NOTIFICATION_REWARD_INFO object:nil];

    //    //
    //    [self requestMessages];
    
//    if (![UserManager isVIP]) {
//        GCD_DELAY(^{
//            [self showNotVIPMsg];
//        }, 1.0f);
//    }
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if (![UserManager isVIP]) {
        [self showVIPZeroPage];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

//    [self updateMessage];
    
    if (![UserManager isVIP]) {
        if ([UserManager instance].userInfo.isDowngrade) {
            if (self.isDowngradeShowed) {
                return;
            }
            [self showDowngradeDialog:@"您上月销售额未能达标，\n已降级为VIP0\n"];
            self.isDowngradeShowed = YES;
        }
        return;
    }
    
    if (self.selectedIndex < 2 || self.selectedIndex == 3) {
        [self didShowForward];
    }
    
    //
    if (self.selectedIndex != 2) {
        [self requestCheckDiscover];
    }
    
    GCD_DELAY(^{
        if (self.rewardInfos && self.rewardInfos.count > 0) {
            [self showRewardAlert:self.rewardInfos[0]];
        }
        else if (self.isFirstLogin) {
            // 用户重新登录 检查是否有奖励
            [self requestRewardstatus];
            self.isFirstLogin = NO;
        }
        else {
            [self requestUserStatus];
        }
    }, .3f);
    
//    [self showUserLevelStatus:2 msg:@"还差¥5000元销售额就升级VIP2了\n更多专享特权等着你呦！"];
}

#pragma mark - VIP0功能

- (void) showVIPZeroPage
{
    if ([UserManager instance].userInfo.isDowngrade) {
        return;
    }
    VIPZeroController *vc = [VIPZeroController new];
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:NO completion:nil];
}

- (void) showDowngradeDialog:(NSString *)msg
{
    SCLAlertView *alert = [[SCLAlertView alloc]initWithNewWindowWidth:SCREEN_WIDTH-4*kOFFSET_SIZE];
    alert.backgroundType = SCLAlertViewBackgroundShadow;
    [alert setTitleFontFamily:nil withSize:10];
    alert.labelTitle.font = BOLDSYSTEMFONT(20);
    alert.labelTitle.textColor = COLOR_MAIN;
    alert.viewText.font = SYSTEMFONT(18);
    
    alert.useLargerIcon = NO;
    alert.tintTopCircle = NO;
    alert.shouldDismissOnTapOutside = YES;
    alert.circleIconHeight = 32;
    alert.hideAnimationType = SCLAlertViewHideAnimationFadeOut;
    alert.showAnimationType = SCLAlertViewShowAnimationFadeIn;
    
//    @weakify(self)
//    [alert addButton:@"寻求导师帮助" actionBlock:^{
//        @strongify(self)
//        DDCollegeController *vc = [DDCollegeController new];
//        [self.navigationController pushViewController:vc animated:YES];
//    }];
    
    alert.attributedFormatBlock = ^NSAttributedString* (NSString *value)
    {
        NSMutableAttributedString *subTitle = [[NSMutableAttributedString alloc]initWithString:value];
        
        // 段落换行居中及默认属性
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        style.paragraphSpacing = 10; //段落间距
        style.lineSpacing = 2; // 行间距
        [style setAlignment:NSTextAlignmentCenter];
        [subTitle addAttribute:NSFontAttributeName value:SYSTEMFONT(17) range:NSMakeRange(0, value.length)];
        [subTitle addAttribute:NSForegroundColorAttributeName value:COLOR_TEXT_NORMAL range:NSMakeRange(0, value.length)];
        [subTitle addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, value.length)];
        
        return subTitle;
    };
    
    [alert showCustom:self
                image:[UIImage imageNamed:@"regret"]
                color:COLOR_MAIN
                title:@"很遗憾"
             subTitle:msg
     closeButtonTitle:nil
             duration:0.0f];
}

- (void) showUserLevelStatus:(NSInteger)status msg:(NSString *)msg
{
    if (status == 0) {
        //
        if ([UserManager isVIP]) {
            [self requestPromotion];
        }
        return;
    }
    
    VIPLevelAlertType type = VIPLevelAlertTypeGrading;
    if (status == 1) {
        type = VIPLevelAlertTypeGrading;
    }
    else if (status == 2) {
        type = VIPLevelAlertTypeUpgrade;
    }
    else if (status == 3) {
        type = VIPLevelAlertTypeDemotion;
    }

    UserInfo *userInfo = [UserManager instance].userInfo;
    NSInteger level = userInfo.viplevel;
    
    VIPLevelAlertView *alertView = [[VIPLevelAlertView alloc] initWithType:type title:FORMAT(@"VIP%ld",(long)level) subTitle:msg actionBtnTitle:nil];
    alertView.isShowCloseBtn = NO;
    [alertView showWithBGTapDismiss:YES];
    
    NSString *today = [[NSDate date] formattedDateWithFormatString:@"yyyyMMdd"];
    [[NSUserDefaults standardUserDefaults] setValue:today forKey:UDK_USER_VIP_STATUS];
}

- (void) showMePageAfterVIP0Upgrade
{
    self.selectedIndex = 4;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.settingButton];
}

- (void) initTabBarController
{
    NSMutableArray *controllers = [NSMutableArray array];
    
    self.homeController = [HomeViewController new];
    ECTNavItemController *homeController = [[ECTNavItemController alloc] initWithRootViewController:self.homeController];
    homeController.navigationBarHidden = YES;
    [homeController setTabTitle:@"首页" image:@"icon_home"];
    [controllers addObject:homeController];
    
    [controllers addObject:[FollowViewController new]];
    
    DiscoverPageController *discoverController = [DiscoverPageController new];
    [controllers addObject:discoverController];
    self.discoverController = discoverController;
    
    [controllers addObject:[CartViewController new]];
    //    [controllers addObject:[MyViewController new]];
    [controllers addObject:[MeViewController new]];
    
    [self setViewControllers:controllers];
    
    UserInfo *userInfo = [UserManager instance].userInfo;
    [self updateBadge:userInfo.normalproduct atIndex:3 withStyle:WBadgeStyleNumber animationType:WBadgeAnimTypeBounce];
    
    self.delegate = self;
    
    UIBarButtonItem *searchButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchAction:)];
    self.navigationItem.rightBarButtonItem = searchButton;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.listButton];
}

- (void) didEnterForeground:(NSNotification *)notification
{
    if (self.selectedIndex != 2) {
        [self requestCheckDiscover];
    }
    else {
        [self requestCheckLive];
    }
    // 请求活动图片信息
    if ([UserManager isVIP]) {
        [self requestPromotion];
    }
}

/*
- (void) shouldSyncLiveData:(NSNotification *)notification
{
    [ProductsManager clearHistoryData];
    [SVProgressHUD showWithStatus:@"同步数据中..."];
    [ProductsManager syncProducts:^{
        //
        [SVProgressHUD dismiss];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SYNC_COMPLETE object:nil];
        
    } failed:nil];
}*/

- (void) didReceivedMsg
{
    [self.messageButton setNormalColor:COLOR_SELECTED];
}

- (void) updateMessage
{
    NSInteger count = [UserManager instance].userInfo.unreadnum;
    if (count > 0) {
        [self.messageButton setNormalColor:COLOR_SELECTED];
    }
    else {
        [self.messageButton setNormalColor:COLOR_TITLE];
    }
    
    //
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:count];
    //    [GeTuiSdk setBadge:count];
}

- (void) didHideForward
{
    if (self.floatingButton.alpha == 0.0f) {
        return;
    }
    self.floatingButton.alpha = 0.0f;
    [self.floatingButton removeFromScreen];
    //    [UIView animateWithDuration:.2f animations:^{
    //        self.floatingButton.alpha = 0.0f;
    //    } completion:^(BOOL finished) {
    //        [self.floatingButton removeFromScreen];
    //    }];
}

- (void) didShowForward
{
    NSInteger index = [ProductsManager getForwardIndex];
    if (index > 1) {
        [self.floatingButton setNormalTitle:FORMAT(@"继续转发\n( %ld )", (long)(index))];
    }
    else {
        [self.floatingButton setNormalTitle:@"开始转发"];
    }
    
    // 显示波浪形进度
    UserInfo *userInfo = [UserManager instance].userInfo;
    NSInteger viplevel = userInfo.viplevel;
    VIPMemberTarget *target = [UserManager targetByLevel:viplevel];
    if (viplevel == 0 && userInfo.isDowngrade) {
        self.floatingButton.waterBgColor = RGBCOLOR(0xAA, 0xAA, 0xAA);
        self.floatingButton.backWaterColor  = COLOR_TEXT_NORMAL;
    }
    else if (target && userInfo.monthsale < target.minsale) {
        // 保级
        self.floatingButton.waterBgColor = RGBCOLOR(102, 102, 102);
        self.floatingButton.backWaterColor  = COLOR_BG_TRACK;
    }
    else {
        // 升级
        self.floatingButton.waterBgColor = COLOR_BG_TRACK;
        self.floatingButton.backWaterColor  = COLOR_MAIN;
    }

    self.floatingButton.title    = [NSString stringWithFormat:@"VIP%ld",(long)viplevel];

    [self.floatingButton show];
    self.floatingButton.alpha = .9f;

    // 进度
    CGFloat percent = [UserManager getSalesPercent:viplevel sales:userInfo.monthsale];
    self.floatingButton.percent  = percent;

    //    [UIView animateWithDuration:.2f animations:^{
    //        self.floatingButton.alpha = .9f;
    //    }];
}

- (void) didRecvTokenExpired
{
    [self.floatingButton removeFromScreen];
    
    [GeTuiSdk unbindAlias:[UserManager userId] andSequenceNum:@"seq-1" andIsSelf:YES];
    [UserManager clearToken];
    [UserManager clearUserInfo];
    
    //
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UDK_PROMOTION_IMAGE];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UDK_USER_VIP_STATUS];
    
    //
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    [self.navigationController popToRootViewControllerAnimated:NO];
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    GCD_DELAY(^{
        [SVProgressHUD dismiss];
    }, .5f);
}

- (void) didAddFollow
{
    NSInteger count = [ProductsManager instance].followCount;
    [self updateBadge:count atIndex:1 withStyle:WBadgeStyleNumber animationType:WBadgeAnimTypeNone];
}

- (void) didAddProductToCart
{
    UserInfo *userInfo = [UserManager instance].userInfo;
    userInfo.normalproduct ++;
    [self updateBadge:userInfo.normalproduct atIndex:3 withStyle:WBadgeStyleNumber animationType:WBadgeAnimTypeBounce];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    [self didHideForward];
}

- (void) showNotVIPMsg
{
    [self showDowngradeDialog:@"您未能达到爱库存VIP1的等级标准，\n暂时不能下单。\n"];
}

- (void) receivedRewardInfo:(NSNotification *)notification
{
    NSDictionary *payload = notification.userInfo;
    if (!self.rewardInfos) {
        self.rewardInfos = [NSMutableArray array];
    }
    [self.rewardInfos addObject:payload];
    
    if (self.isViewLoaded && self.view.window && !self.isShowReward) {
        // 只有当前在首页时弹出提示，不在首页时下次进入首页弹提示
        [self showRewardAlert:self.rewardInfos[0]];
    }
}

- (void) showRewardAlert:(NSDictionary *)jsonData
{
    NSDictionary *payload = [jsonData objectForKey:@"payload"];
    NSInteger type = [payload getIntegerValueForKey:@"type"];
    NSInteger amount = [payload getIntegerValueForKey:@"amount"];
    
    [MMPopupView hideAll];
    
    RewardAlertView *alertView = [[RewardAlertView alloc] initWithType:type value:amount*100];
    [alertView showWithBGTapDismiss:NO];
    @weakify(self)
    alertView.actionBlock = ^{
        @strongify(self)
        self.isShowReward = NO;
        [self requestRewardReceived:type];
        
        if (self.rewardInfos.count > 0) {
            [self showRewardAlert:self.rewardInfos[0]];
        }
        else {
            self.selectedIndex = 4;
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.settingButton];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REWARD_RECEIVED object:nil];
        }
    };
    
    self.isShowReward = YES;
    [self.rewardInfos removeObjectAtIndex:0];
}

#pragma mark - Request

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

- (void) requestUserInfo
{
    [SVProgressHUD showWithStatus:nil];
    
    RequestUserInfo *request = [RequestUserInfo new];
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [SVProgressHUD dismiss];
     }
                                 onFailed:^(id content)
     {
     }
                                  onError:^(id content)
     {
     }];
}

- (void) requestUserStatus
{
    NSString *today = [[NSDate date] formattedDateWithFormatString:@"yyyyMMdd"];
    NSString *date = [[NSUserDefaults standardUserDefaults] stringForKey:UDK_USER_VIP_STATUS];
    if (date && [date isEqualToString:today]) {
        // 请求活动图片信息
        [self requestPromotion];
        return;
    }
    
    RequestUserStatus *request = [RequestUserStatus new];
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         HttpResponseBase *response = content;
         NSDictionary *jsonData = response.responseData;
         NSInteger status = [jsonData getIntegerValueForKey:@"stuts"];
         NSString *msg = [jsonData getStringForKey:@"msg"];
         [self showUserLevelStatus:status msg:msg];
         
     } onFailed:nil];
}

- (void) requestCheckDiscover
{
    RequestDiscoverCheck *request = [RequestDiscoverCheck new];
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         ResponseDiscoverCheck *response = content;
         if (response.isUpdated) {
             [self updateBadge:1 atIndex:2 withStyle:WBadgeStyleRedDot animationType:WBadgeAnimTypeScale];
//             [UserManager instance].isDiscoverUpdated = YES;
         }
         [self.discoverController updateNewFlag:response.flagData];
         
         [self requestCheckLive];
         
     } onFailed:nil];
}

- (void) requestCheckLive
{
    RequestLiveCheck *request = [RequestLiveCheck new];
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         ResponseLiveCheck *response = content;
         [self.homeController updateNewFlag:response.flagData];
         self.leftMenuController.shouldUpdate = response.isLiveUpdated;
         if (response.isLiveUpdated) {
             [self.listButton showBadgeWithStyle:WBadgeStyleRedDot value:1 animationType:WBadgeAnimTypeScale];
         }
         
     } onFailed:nil];
}

- (void) requestPromotion
{
    // 活动图片弹窗 每天只显示一次
    NSString *today = [[NSDate date] formattedDateWithFormatString:@"yyyyMMdd"];
    NSString *date = [[NSUserDefaults standardUserDefaults] stringForKey:UDK_PROMOTION_IMAGE];
    if (date && [date isEqualToString:today]) {
        return;
    }
    
    RequestIdeos *request = [RequestIdeos new];
    request.type = 1;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         HttpResponseBase *response = content;
         NSString *url = response.responseData;
         if (url && url.length > 0) {
             SDWebImageManager* manager = [SDWebImageManager sharedManager];
             [manager loadImageWithURL:[NSURL URLWithString:url]
                               options:0
                              progress:nil
                             completed:^(UIImage * _Nullable image,
                                         NSData * _Nullable data,
                                         NSError * _Nullable error,
                                         SDImageCacheType cacheType,
                                         BOOL finished,
                                         NSURL * _Nullable imageURL)
              {
                  PopupImageView *popupView = [[PopupImageView alloc] initWithImage:image];
                  [popupView show];
                  //
                  [[NSUserDefaults standardUserDefaults] setValue:today forKey:UDK_PROMOTION_IMAGE];
              }];
         }
         
     } onFailed:nil];
}

- (void) requestRewardstatus
{
    RequestRewardStatus *request = [RequestRewardStatus new];
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         HttpResponseBase *response = content;
         NSDictionary *jsonData = response.responseData;
         NSArray *array = [jsonData objectForKey:@"Draw"];
         if (array.count > 0) {
             self.rewardInfos = [NSMutableArray arrayWithArray:array] ;
             [self showRewardAlert:self.rewardInfos[0]];
         }
         else {
             [self requestUserStatus];
         }
         
     } onFailed:nil];
}

- (void) requestRewardReceived:(NSInteger)type
{
    RequestRewardReceived *request = [RequestRewardReceived new];
    request.type = type;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         
     } onFailed:nil];
}

#pragma mark - Actions

- (IBAction) listAction:(id)sender
{
    if (self.isLeftMenuOpened) {
        [self hideLeftMenu:YES];
    }
    else {
        [self showLeftMenu];
        [self.listButton clearBadge];
    }
}

- (IBAction) messageAction:(id)sender
{
    MessagesController *controller = [MessagesController new];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction) settingAction:(id)sender
{
    AccountSetupController *controller = [AccountSetupController new];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction) searchAction:(id)sender
{
    //    [self didShowForward];
    ProductsViewController *controller = [ProductsViewController new];
    controller.liveId = self.liveId;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction) cameraAction:(id)sender
{
    typeof(self) __weak weakSelf = self;
    LZActionSheet *sheet = [[LZActionSheet alloc] initWithTitle:@"发布内容" buttonTitles:@[@"小视频",@"拍照",@"从手机相册选择"] redButtonIndex:-1 cancelTextColor:[UIColor blackColor] clicked:^(NSInteger buttonIndex) {
        switch (buttonIndex) {
            case 0:
                //[weakSelf takeVideo];        //1. 之前视频录制及选择
                [weakSelf takeAliVideo];       //2. 阿里云视频录制及选择
                //[weakSelf takePhotoOrVideo]; //3. 仿微信拍照&视频录制
                break;
            case 1:
                [weakSelf takePicture];
                break;
            case 2:
                [weakSelf takeAlbum];
                break;
        }
    }];

    [sheet show];
}

#pragma mark - ActionSheetActions
#pragma mark - 视频录制与视频选择
- (void)takeAliVideo {
    // 先判断摄像头的权限
    AVAuthorizationStatus vAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (vAuthStatus == AVAuthorizationStatusRestricted || vAuthStatus == AVAuthorizationStatusDenied) {
        // 若是已经拒绝，弹框跳到设置页面
        [self showSettingSuggetAlert];
    }
    
    // 先判断麦克风的权限
    AVAuthorizationStatus aAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (aAuthStatus == AVAuthorizationStatusRestricted || aAuthStatus == AVAuthorizationStatusDenied) {
        // 若是已经拒绝，弹框跳到设置页面
        [self showSettingSuggetAlert];
    }
    
    // 再判断相册写入权限
    ALAuthorizationStatus alAuthStatus = [ALAssetsLibrary authorizationStatus];
    if (alAuthStatus == ALAuthorizationStatusRestricted || alAuthStatus == ALAuthorizationStatusDenied) {
        // 若是已经拒绝，弹框跳到设置页面
        [self showSettingSuggetAlert];
        
    } else {
        
        AliyunVideoRecordParam *vrPara = [[AliyunVideoRecordParam alloc]init];
        vrPara.ratio       = isPad ? AliyunVideoVideoRatio1To1 : AliyunVideoVideoRatio3To4;
        vrPara.size        = AliyunVideoVideoSize540P;
        vrPara.minDuration = 1;
        vrPara.maxDuration = 120;
        vrPara.position    = AliyunCameraPositionBack;
        vrPara.beautifyStatus = YES;
        vrPara.beautifyValue  = 100;
        vrPara.videoQuality   = AliyunVideoQualityHight;
        vrPara.torchMode      = AliyunCameraTorchModeOff;
        vrPara.outputPath     = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/record_save.mp4"];
        
        AliyunVideoUIConfig *config     = [[AliyunVideoUIConfig alloc] init];
        config.timelineDeleteColor      = [UIColor redColor];
        config.timelineBackgroundCollor = [UIColor clearColor];
        //config.cutTopLineColor      = [UIColor clearColor];
        //config.cutBottomLineColor   = [UIColor clearColor];
        
        config.hiddenImportButton   = NO;
        config.hiddenFlashButton    = NO;
        config.hiddenBeautyButton   = NO;
        config.hiddenDeleteButton   = NO;
        config.hiddenCameraButton   = NO;
        config.hiddenDurationLabel  = NO;
        
        config.recordOnePart   = NO;
        config.imageBundleName = @"QPSDK";
        config.recordType      = AliyunVideoRecordTypeCombination;
        [[AliyunVideoBase shared] registerWithAliyunIConfig:config];
        
        UIViewController *recordVC = [[AliyunVideoBase shared] createRecordViewControllerWithRecordParam:vrPara];
        [AliyunVideoBase shared].delegate = self;
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:recordVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark - 小视频
- (void)takeVideo {
    // 加权限判断，若是要用这个方法的话
    TZImagePickerController *pickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self];
    pickerVC.showSelectBtn     = YES;
    pickerVC.allowPickingVideo = YES;
    pickerVC.allowPickingGif   = NO;
    pickerVC.allowPickingImage = NO;
    [self presentViewController:pickerVC animated:YES completion:nil];
}

#pragma mark - 拍照
- (void)takePicture {
#if TARGET_IPHONE_SIMULATOR //模拟器
#elif TARGET_OS_IPHONE      //真机
    
    // 先判断相机权限
    AVAuthorizationStatus avAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (avAuthStatus == AVAuthorizationStatusRestricted || avAuthStatus == AVAuthorizationStatusDenied) {
        [self showSettingSuggetAlert];
    }
    
    // 再判断相册写入权限
    ALAuthorizationStatus alAuthStatus = [ALAssetsLibrary authorizationStatus];
    if (alAuthStatus == ALAuthorizationStatusRestricted || alAuthStatus == ALAuthorizationStatusDenied) {
        // 若是已经拒绝，弹框跳到设置页面
        [self showSettingSuggetAlert];
        
    } else {
        UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
        imagePickerVC.delegate   = self;
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }
#endif
}

#pragma mark - 从手机相册选择
- (void)takeAlbum {
    // 加权限判断，若是要用这个方法的话
    TZImagePickerController *pickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:4 delegate:self];
    pickerVC.showSelectBtn     = YES;
    pickerVC.allowPickingImage = YES;
    pickerVC.allowPickingVideo = NO;
    pickerVC.allowPickingGif   = NO;
    [self presentViewController:pickerVC animated:YES completion:nil];
}

#pragma mark - 拍照和视频在一个界面
- (void)takePhotoOrVideo {
    //    ZLCustomCamera *vc     = [[ZLCustomCamera alloc]init];
    //    vc.allowRecordVideo    = YES;
    //    vc.sessionPreset       = ZLCaptureSessionPreset1280x720;
    //    vc.circleProgressColor = [UIColor orangeColor];
    //    vc.maxRecordDuration   = 10.0;
    //    //    vc.maxRecordTime = 15.0;
    //
    //    dd_weak(self);
    //    vc.doneBlock = ^(UIImage *image, NSURL *videoUrl) {
    //
    //        dd_strong(weakSelf);
    //        NSLog(@"image %@ videoURL %@",image,videoUrl);
    //    };
    //
    //    [self presentViewController:vc animated:YES completion:^{
    //    }];
}

- (void)showSettingSuggetAlert {
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"权限设置" message:@"当前未有摄像头、麦克风或者相册的访问权限" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *settingAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[PermissonManger new] toSettingPage];
    }];
    [vc addAction:cancelAction];
    [vc addAction:settingAction];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *selectedImage = [[UIImage alloc]init];
    if (picker.allowsEditing) {
        selectedImage = [info valueForKey:UIImagePickerControllerEditedImage];
    } else {
        selectedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    }
    
    // 开启队列组，将拍摄照片存储到本地，并获取asset
    dispatch_group_t uploadGroup =dispatch_group_create();
    dispatch_group_enter(uploadGroup);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 获取照片写入权限先
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 再次判断权限
                if (status == PHAuthorizationStatusAuthorized) {
                    NSLog(@"已经授权");
                    // 展示视频处理动画
                    [SVProgressHUD showWithStatus:@"正在处理..."];
                } else {
                    POPUPINFO(@"拍摄的照片未保存");
                    return ;
                }
            });
            
            // 照片写入
            __block TZAssetModel *assetModel;
            if (selectedImage) {
                [[TZImageManager manager] savePhotoWithImage:selectedImage completion:^(NSError *error){
                    //NSLog(@"--存储本地拍的照片error -%@",error);
                    if (!error) {
                        //下面两个方法及两处都必须设置为YES，保证最后lastObject取到的一定是当前拍的，不然index就不对了
                        [[TZImageManager manager] getCameraRollAlbum:YES allowPickingImage:YES completion:^(TZAlbumModel *model) {
                            //NSLog(@"TZAlbumModel --%@",model);
                            
                            [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:YES allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                                //NSLog(@"TZAssetModel---%@",models);
                                
                                if (models.count > 0) {
                                    assetModel = [models lastObject];
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [SVProgressHUD dismiss];
                                    });
                                    dispatch_group_leave(uploadGroup);
                                }
                            }];
                        }];
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [SVProgressHUD dismiss];
                        });
                    }
                }];
            }
            
            dispatch_group_notify(uploadGroup, dispatch_get_global_queue(0, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    PhotoSelectModel *model = [[PhotoSelectModel alloc]init];
                    model.selectImage = selectedImage;
                    model.asset       = assetModel.asset;
                    
                    MomentViewController *sendVC = [[MomentViewController alloc]init];
                    [sendVC.selectedArray addObject:model];
                    sendVC.selectType = PhotoSelectTypeImage;
                    
                    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:sendVC];
                    [self presentViewController:nav animated:YES completion:nil];
                });
            });
        }];
    });
}

#pragma mark - TZImagePickerControllerDelegate

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    
    //NSLog(@"coverImage %@ asset %@", coverImage, asset);
    NSMutableArray *tempArray = [NSMutableArray array];
    VideoSelectModel *model = [[VideoSelectModel alloc]init];
    model.coverImage = coverImage;
    model.asset      = asset;
    [tempArray addObject:model];
    
    MomentViewController *sendVC = [[MomentViewController alloc]init];
    sendVC.selectedArray = tempArray;
    sendVC.selectType    = PhotoSelectTypeVideo;
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:sendVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    //NSLog(@"选择的图片 %@ %@", photos, assets);
    NSMutableArray *tempArray = [NSMutableArray array];
    if (photos.count != 0) {
        for (int i = 0; i < photos.count; i++) {
            PhotoSelectModel *model = [[PhotoSelectModel alloc]init];
            model.selectImage = photos[i];
            model.asset       = assets[i];
            [tempArray addObject:model];
        }
    }
    
    MomentViewController *sendVC = [[MomentViewController alloc]init];
    sendVC.selectedArray = tempArray;
    sendVC.selectType = PhotoSelectTypeImage;
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:sendVC];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - ALiVideoRecordBaseDelegate
// 退出录制页面
- (void)videoBaseRecordVideoExit {
    //NSLog(@"退出录制页面");
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 视频录制完成回调
- (void)videoBase:(AliyunVideoBase *)base recordCompeleteWithRecordViewController:(UIViewController *)recordVC videoPath:(NSString *)videoPath {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"录制完成 videoPath %@",videoPath);
    
    dispatch_group_t uploadGroup =dispatch_group_create();
    dispatch_group_enter(uploadGroup);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 获取照片写入权限先
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
            // 再次判断权限
            if (status == PHAuthorizationStatusAuthorized) {
                NSLog(@"已经授权");
                // 展示视频处理动画
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD showWithStatus:@"正在处理..."];
                });
                
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    POPUPINFO(@"录制的视频未保存");
                });
                
                return ;
            }
            
            // 视频写入
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
            [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:videoPath] completionBlock:^(NSURL *assetURL, NSError *error) {
                
                if (!error) {
                    //NSLog(@"=====assetURL %@",assetURL);
                    // 获取裁剪后的视频封面图
                    //UIImage *thumbnailImage = [self getScreenShotImageFromVideoPath:videoPath];
                    UIImage *thumbnailImage = [self getCaptureImageFromVideoPath:videoPath];
                    
                    __block TZAssetModel *assetModel;
                    [[TZImageManager manager] getCameraRollAlbum:YES allowPickingImage:NO completion:^(TZAlbumModel *model) {
                        NSLog(@"TZAlbumModel --%@",model);
                        
                        [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:YES allowPickingImage:NO completion:^(NSArray<TZAssetModel *> *models) {
                            NSLog(@"TZAssetModel---%@",models);
                            
                            if (models.count > 0) {
                                assetModel = [models firstObject];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [SVProgressHUD dismiss];
                                });
                                dispatch_group_leave(uploadGroup);
                            }
                        }];
                    }];
                    
                    dispatch_group_notify(uploadGroup, dispatch_get_global_queue(0, 0), ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSMutableArray *tempArray = [NSMutableArray array];
                            VideoSelectModel *model = [[VideoSelectModel alloc]init];
                            model.coverImage        = thumbnailImage;
                            model.videoPath         = videoPath;
                            model.asset             = assetModel.asset;
                            [tempArray addObject:model];
                            
                            MomentViewController *sendVC = [[MomentViewController alloc]init];
                            sendVC.selectedArray = tempArray;
                            sendVC.selectType = PhotoSelectTypeVideo;
                            
                            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:sendVC];
                            [self presentViewController:nav animated:YES completion:nil];
                        });
                    });
                    
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                    });
                }
            }];
        }];
    });
}

// 录制页跳转相册
- (AliyunVideoCropParam *)videoBaseRecordViewShowLibrary:(UIViewController *)recordVC {
    //NSLog(@"录制页跳转Library");
    AliyunVideoCropParam *vcPara = [[AliyunVideoCropParam alloc] init];
    vcPara.minDuration = 2.0;
    vcPara.videoOnly   = YES;
    vcPara.maxDuration = 10.0*60;
    vcPara.fps        = 25;
    vcPara.gop        = 1;
    vcPara.size       = AliyunVideoVideoSize540P;
    vcPara.ratio      = isPad ? AliyunVideoVideoRatio1To1 : AliyunVideoVideoRatio3To4;//AliyunVideoVideoRatio9To16;
    vcPara.cutMode    = AliyunVideoCutModeScaleAspectFill;
    vcPara.videoQuality = AliyunVideoQualityHight;
    vcPara.outputPath   = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/cut_save.mp4"];
    return vcPara;
}

// 视频裁剪完成的回调
- (void)videoBase:(AliyunVideoBase *)base cutCompeleteWithCropViewController:(UIViewController *)cropVC videoPath:(NSString *)videoPath {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"视频裁剪完成  %@", videoPath);
    
    dispatch_group_t uploadGroup =dispatch_group_create();
    dispatch_group_enter(uploadGroup);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 获取照片写入权限先
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
            // 再次判断权限
            if (status == PHAuthorizationStatusAuthorized) {
                NSLog(@"已经授权");
                // 展示视频处理动画
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD showWithStatus:@"正在处理..."];
                });
                
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    POPUPINFO(@"录制的视频未保存");
                });
                
                return ;
            }
            
            // 视频写入
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
            [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:videoPath] completionBlock:^(NSURL *assetURL, NSError *error) {
                
                if (!error) {
                    //NSLog(@"=====assetURL %@",assetURL);
                    // 获取裁剪后的视频封面图
                    UIImage *thumbnailImage = [self getCaptureImageFromVideoPath:videoPath];
                    
                    __block TZAssetModel *assetModel;
                    [[TZImageManager manager] getCameraRollAlbum:YES allowPickingImage:NO completion:^(TZAlbumModel *model) {
                        NSLog(@"TZAlbumModel --%@",model);
                        
                        [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:YES allowPickingImage:NO completion:^(NSArray<TZAssetModel *> *models) {
                            NSLog(@"TZAssetModel---%@",models);
                            
                            if (models.count > 0) {
                                assetModel = [models firstObject];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [SVProgressHUD dismiss];
                                });
                                dispatch_group_leave(uploadGroup);
                            }
                        }];
                    }];
                    
                    dispatch_group_notify(uploadGroup, dispatch_get_global_queue(0, 0), ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSMutableArray *tempArray = [NSMutableArray array];
                            VideoSelectModel *model = [[VideoSelectModel alloc]init];
                            model.coverImage        = thumbnailImage;
                            model.videoPath         = videoPath;
                            model.asset             = assetModel.asset;
                            [tempArray addObject:model];
                            
                            MomentViewController *sendVC = [[MomentViewController alloc]init];
                            sendVC.selectedArray = tempArray;
                            sendVC.selectType = PhotoSelectTypeVideo;
                            
                            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:sendVC];
                            [self presentViewController:nav animated:YES completion:nil];
                        });
                    });
                    
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                    });
                }
            }];
        }];
    });
    
    //    ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
    //    [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:videoPath] completionBlock:^(NSURL *assetURL, NSError *error) {
    //
    //        NSLog(@"=====assetURL %@",assetURL);
    //        // 获取裁剪后的视频封面图
    //        UIImage *thumbnailImage = [self getScreenShotImageFromVideoPath:videoPath];
    //
    //        __block TZAssetModel *assetModel;
    //        [[TZImageManager manager] getCameraRollAlbum:YES allowPickingImage:NO completion:^(TZAlbumModel *model) {
    //            NSLog(@"TZAlbumModel --%@",model);
    //            [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:YES allowPickingImage:NO completion:^(NSArray<TZAssetModel *> *models) {
    //                NSLog(@"TZAssetModel---%@",models);
    //                if (models.count > 0) {
    //                    assetModel = [models firstObject];
    //                    dispatch_group_leave(uploadGroup);
    //                }
    //            }];
    //        }];
    //
    //        dispatch_group_notify(uploadGroup, dispatch_get_global_queue(0, 0), ^{
    //            dispatch_async(dispatch_get_main_queue(), ^{
    //                NSMutableArray *tempArray = [NSMutableArray array];
    //                VideoSelectModel *model = [[VideoSelectModel alloc]init];
    //                model.coverImage        = thumbnailImage;
    //                model.videoPath         = videoPath;
    //                model.asset             = assetModel.asset;
    //                [tempArray addObject:model];
    //
    //                MomentViewController *sendVC = [[MomentViewController alloc]init];
    //                sendVC.selectedArray = tempArray;
    //                sendVC.selectType = PhotoSelectTypeVideo;
    //
    //                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:sendVC];
    //                [self presentViewController:nav animated:YES completion:nil];
    //            });
    //        });
    //    }];
}

- (AliyunVideoRecordParam *)videoBasePhotoViewShowRecord:(UIViewController *)photoVC {
    //NSLog(@"跳转录制页");
    return nil;
}

// 图片裁剪完成回调
- (void)videoBase:(AliyunVideoBase *)base cutCompeleteWithCropViewController:(UIViewController *)cropVC image:(UIImage *)image {
    //NSLog(@"图片裁剪完成 image %@",image);
}

// 退出相册页
- (void)videoBasePhotoExitWithPhotoViewController:(UIViewController *)photoVC {
    //NSLog(@"退出相册页");
    [photoVC.navigationController popViewControllerAnimated:YES];
}

// 根据path获取视频的缩略图方法---ipad上会崩，所以把方法单独写到这里
- (UIImage *)getCaptureImageFromVideoPath:(NSString *)filePath {
    
    UIImage *shotImage;
    //视频路径URL
    NSURL *fileURL    = [NSURL fileURLWithPath:filePath];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileURL options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time    = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    shotImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    
    return shotImage;
}

#pragma mark - ZYSuspensionViewDelegate

- (void) suspensionViewClick:(ZYSuspensionView *)suspensionView
{
    NSArray *liveInfos = [LiveManager instance].liveInfos;
    if (!liveInfos || liveInfos.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"中场休息中，新的活动还没开始哦 ！"];
        return;
    }
    
    if ([LiveManager periodTime] != 0) {
        [SVProgressHUD showWithStatus:nil];
        NSInteger pinpaiIndex = [ProductsManager instance].forwardPinpai;
        LiveInfo *liveInfo = [LiveManager liveInfoAtIndex:pinpaiIndex];
        [ProductsManager syncProductsWith:liveInfo.liveid
                                 finished:^(id content)
         {
             [SVProgressHUD dismiss];
             [self forwardAction];
         } failed:nil];
    }
    else {
        [self forwardAction];
    }
}

- (void) forwardAction
{
//    [self didHideForward];
    __block NSInteger index = [ProductsManager getForwardIndex];
    NSString *title = @"开始转发商品";
    if (index > 1) {
        title = @"继续转发商品";
    }
    ProductModel *model = [ProductsManager getForwardProduct:0];
    if (!model) {
        [SVProgressHUD showInfoWithStatus:@"找不到活动商品"];
        return;
    }
    PopupForwardView *popupView = [[PopupForwardView alloc] initWithProduct:model title:title];
    @weakify(self)
    popupView.finishBlock = ^(id content, BOOL checked1, BOOL checked2) {
        @strongify(self)
        ProductModel *product = content;
        BOOL canbeForward = [product canbeForward]; // 是否转发缺货尺码
        if (!canbeForward && [product isQuehuo]) {
            [SVProgressHUD showInfoWithStatus:@"该商品已卖光了"];
            [self didShowForward];
            return;
        }
        
        NSString *descContent = [product weixinDesc];
        NSArray *imagesUrl = [product imagesUrl];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = descContent;
        
        NSInteger type = ShareOptionOnlyPictures;
        if (checked1) {
            type = ShareOptionMergedPicture;
        }
        else if (checked2) {
            type = ShareOptionPicturesAndText;
        }
        //
        NSInteger price = product.bohuojia/100;
        NSInteger priceOption = [UserManager instance].userConfig.priceOption;
        if (price > 0 && priceOption > 0) {
            price += priceOption;
        }
        NSInteger diaopai = product.diaopaijia/100;
        [ShareActivity forwardWithItems:imagesUrl
                                   text:(checked1||checked2)?descContent:nil
                                   data:@{@"price":@(price),@"diaopai":@(diaopai)}
                                   type:type
                                 parent:self
                                   view:self.floatingButton
                               finished:^(int type)
         {
             if (type == 100) {
                 [SVProgressHUD showSuccessWithStatus:@"保存成功！"];
             }
             [self requestForwardPorduct:product type:type];
             //
             NSInteger nextIndex = [ProductsManager updateNextValidIndex:product.xuhao];
             if (nextIndex == product.xuhao) {
                 [self showForwardEndDialog];
             }
             else {
                 [self.floatingButton setNormalTitle:FORMAT(@"继续转发\n( %ld )", (long)nextIndex)];
                 [self didShowForward];
                 [self forwardAction];
             }

         }
                               canceled:^
         {
             [self didShowForward];
             if (product.xuhao > 1) {
                 [self.floatingButton setNormalTitle:FORMAT(@"继续转发\n( %ld )", (long)(product.xuhao))];
             }
             else {
                 [self.floatingButton setNormalTitle:@"开始转发"];
             }
         }];
    };
    popupView.cancelBlock = ^{
        @strongify(self)
        [self didShowForward];
    };
    popupView.settingBlock = ^{
        @strongify(self)
        [self didHideForward];
        ForwardConfigController *controller = [ForwardConfigController new];
        [self.navigationController pushViewController:controller animated:YES];
    };
    
    [SVProgressHUD setContainerView:nil];
    [popupView show];
}

- (void) requestForwardPorduct:(ProductModel *)product type:(NSInteger)desc
{
    RequestProductForward *request = [RequestProductForward new];
    request.productId = product.Id;
    request.dest = desc;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         product.forward = 1;
         [[ProductsManager instance] updateProductForward:product];
     }
                                 onFailed:^(id content)
     {
         
     }];
}

- (void) showForwardEndDialog
{
    NSInteger pinpaiIndex = [ProductsManager instance].forwardPinpai;
    LiveInfo *liveInfo = [LiveManager liveInfoAtIndex:(pinpaiIndex+1)];
    if (!liveInfo) {
        [SVProgressHUD showInfoWithStatus:@"该活动已转发完成"];
        return;
    }
    
    [SVProgressHUD showInfoWithStatus:FORMAT(@"该活动已转发完成，开始转发下一场活动\n【%@】",liveInfo.pinpaiming)];
    
    [ProductsManager instance].forwardPinpai = pinpaiIndex+1;
    [ProductsManager updateForwardIndex:1];

    [self.floatingButton setNormalTitle:@"开始转发"];
    [self forwardAction];
}

#pragma mark - ECTabBarControllerDelegate

- (void) tabBarController:(ECTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (![viewController isKindOfClass:[ECTNavItemController class]]) {
        self.navigationItem.titleView = nil;
    }
    
    if ([viewController isKindOfClass:[MeViewController class]]) {
        [self updateLeftButton:self.messageButton];
        [self didHideForward];
    }
    else if ([viewController isKindOfClass:[DiscoverPageController class]]) {
        [self didHideForward];
    }
    else {
        [self didShowForward];
    }
    
    self.navigationItem.rightBarButtonItem = [self rightButtonItem];
}

- (UIBarButtonItem *) rightButtonItem
{
    UIBarButtonItem *rightButtonItem = nil;
    UIViewController *viewController = self.selectedViewController;
    if ([viewController isKindOfClass:[MeViewController class]]) {
        rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.settingButton];
    }
    else if ([viewController isKindOfClass:[DiscoverPageController class]]) {
        if ([UserManager instance].userInfo.allowUpload) {
            rightButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(cameraAction:)];
        }
        else {
            rightButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchAction:)];
        }
    }
    else {
        rightButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchAction:)];
    }
    return rightButtonItem;
}

- (UIButton *) settingButton
{
    if (!_settingButton) {
        _settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _settingButton.frame = CGRectMake(0, 0, 25, 44);
/*
        [_settingButton.titleLabel setFont:FA_ICONFONTSIZE(22)];
        [_settingButton setTitle:FA_ICONFONT_SETTING forState:UIControlStateNormal];
        [_settingButton setTitleColor:[COLOR_TITLE colorWithAlphaComponent:0.6f] forState:UIControlStateNormal];
        [_settingButton setTitleColor:COLOR_SELECTED forState:UIControlStateHighlighted];
*/
        [_settingButton setNormalImage:@"icon_setting" hilighted:@"icon_setting_hl" selectedImage:nil];
        
        [_settingButton addTarget:self action:@selector(settingAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingButton;
}

- (TextButton *) messageButton
{
    if (!_messageButton) {
        _messageButton = [TextButton buttonWithType:UIButtonTypeCustom];
        _messageButton.frame = CGRectMake(0, kIOS7Offset, 44, 44);
        
        [_messageButton setTitleFont:FA_ICONFONTSIZE(20)];
        [_messageButton setTitleAlignment:NSTextAlignmentLeft];
        
        [_messageButton setTitle:FA_ICONFONT_MESSAGE forState:UIControlStateNormal];
        [_messageButton setTitleColor:COLOR_TITLE forState:UIControlStateNormal];
        [_messageButton setTitleColor:COLOR_SELECTED forState:UIControlStateHighlighted];
        
        [_messageButton addTarget:self action:@selector(messageAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _messageButton;
}

- (TextButton *) listButton
{
    if (!_listButton) {
        _listButton = [TextButton buttonWithType:UIButtonTypeCustom];
        _listButton.frame = CGRectMake(0, kIOS7Offset, 44, 44);
        _listButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _listButton.clipsToBounds = YES;
        
        [_listButton setTitleFont:FA_ICONFONTSIZE(20)];
        [_listButton setTitleAlignment:NSTextAlignmentLeft];
        
        [_listButton setTitle:FA_ICONFONT_MENU forState:UIControlStateNormal];
        [_listButton setTitleColor:COLOR_TITLE forState:UIControlStateNormal];
        [_listButton setTitleColor:COLOR_SELECTED forState:UIControlStateHighlighted];
        
        [_listButton addTarget:self action:@selector(listAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _listButton.badgeBgColor = COLOR_SELECTED;
        _listButton.badgeCenterOffset = CGPointMake(-24, 12);
        [_listButton clearBadge];
    }
    return _listButton;
}

//- (BallWaveView *) floatingButton
//{
//    if (!_floatingButton) {
//        _floatingButton = [[BallWaveView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-kBOTTOM_BAR_HEIGHT-100, 80, 80)];
////        _floatingButton = [[BallWaveView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-kBOTTOM_BAR_HEIGHT-100, 80, 80)];
//        _floatingButton.delegate = self;
//        //        _floatingButton.title    = @"VIP2";
//        //        _floatingButton.percent  = 0.1;
//        _floatingButton.alpha    = 0.0f;
//    }
//    return _floatingButton;
//}
- (WaveBallView *) floatingButton
{
    if (!_floatingButton) {
        _floatingButton = [[WaveBallView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-kBOTTOM_BAR_HEIGHT-100, 80, 80)];
        _floatingButton.delegate = self;
        _floatingButton.alpha    = 0.0f;
    }
    return _floatingButton;
}

//- (ZYSuspensionView *) floatingButton
//{
//    if (!_floatingButton) {
//        _floatingButton = [[ZYSuspensionView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-kBOTTOM_BAR_HEIGHT-100, 80, 80)
//                                                            color:COLOR_TEXT_DARK
//                                                         delegate:self];
//        [_floatingButton setNormalTitle:@"开始转发"];
//        _floatingButton.alpha = 0.0f;
//        //        _floatingButton.hidden = YES;
//    }
//    return _floatingButton;
//}

#pragma mark - Left Menu

// 显示左边菜单栏
- (void) showLeftMenu
{
    if (!_tapButton) {
        _tapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _tapButton.frame = self.view.bounds;
        _tapButton.backgroundColor = DARKGRAY_COLOR;
        [_tapButton addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.tapButton.alpha = 0.0f;
    [self.view insertSubview:self.tapButton belowSubview:self.leftMenuView];
    
    [self didHideForward];
    
    self.navigationItem.titleView = self.leftTitleLabel;
    self.navigationItem.rightBarButtonItem = nil;
    [UIView animateWithDuration:kAnimationDurationShort animations:^{
        self.leftMenuView.left = 0.0f;
        self.tapButton.alpha = 0.2f;
        self.leftTitleLabel.alpha = 1.0f;
//        self.listButton.alpha = 0.5f;
        [self.listButton setTitleColor:COLOR_SELECTED forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        self.isLeftMenuOpened = YES;
    }];
    
    GCD_DELAY(^{
        [self.leftMenuController updateData];
    }, .1f);
}

- (void) hideLeftMenu:(BOOL)flag
{
    self.navigationItem.rightBarButtonItem = [self rightButtonItem];
    [UIView animateWithDuration:kAnimationDurationShort animations:^{
        self.leftMenuView.left = -kLeftMenuWidth-20;
        self.tapButton.alpha = 0.0f;
        self.leftTitleLabel.alpha = 0.0f;
//        self.listButton.alpha = 1.0f;
        [self.listButton setTitleColor:COLOR_TITLE forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        if (flag) {
            self.navigationItem.titleView = nil;
        }
        [self.tapButton removeFromSuperview];
        [self.leftMenuController hideMenu];
        self.isLeftMenuOpened = NO;
        [self didShowForward];
    }];
    
//    if (self.currentTitle) {
//        [self switchTitleText:self.currentTitle toRight:NO];
//    }
}

- (IBAction) tapAction:(id)sender
{
    [self hideLeftMenu:YES];
}

- (UIView *) leftMenuView
{
    if (!_leftMenuView) {
        _leftMenuView = [[UIView alloc] init];
        _leftMenuView.backgroundColor = WHITE_COLOR;
        _leftMenuView.frame = CGRectMake(-kLeftMenuWidth-20, 0, kLeftMenuWidth, self.view.height-HEADER_HEIGHT);
        
        _leftMenuView.layer.masksToBounds = NO;
        _leftMenuView.layer.shadowColor = BLACK_COLOR.CGColor;
        _leftMenuView.layer.shadowOffset = CGSizeMake(1.0f, 0.0f);
        _leftMenuView.layer.shadowOpacity = 0.5f;
        _leftMenuView.layer.shadowRadius = 3.0f;
    }
    return _leftMenuView;
}

- (UILabel *) leftTitleLabel
{
    if (!_leftTitleLabel) {
        _leftTitleLabel  = [[UILabel alloc] init];
        _leftTitleLabel.backgroundColor = CLEAR_COLOR;
        _leftTitleLabel.textColor = COLOR_SELECTED;
        _leftTitleLabel.font = SYSTEMFONT(18);
        _leftTitleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _leftTitleLabel.textAlignment = NSTextAlignmentCenter;
        _leftTitleLabel.text = @"活动进行中";
        [_leftTitleLabel sizeToFit];
        _leftTitleLabel.centerX = SCREEN_WIDTH/2.0f;
        _leftTitleLabel.centerY = 22.0f;
        _leftTitleLabel.alpha = 0.0f;
    }
    return _leftTitleLabel;
}

@end

