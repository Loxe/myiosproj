//
//  LoginViewController.m
//  akucun
//
//  Created by Jarry Zhu on 2017/3/19.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "LoginViewController.h"
#import "BindPhoneController.h"
#import "MainViewController.h"
#import "TermsViewController.h"
#import "IQKeyboardManager.h"
#import "WXApiManager.h"
#import "RequestUserInfo.h"
#import "RequestAddrList.h"
#import "UserManager.h"
#import "ProductsManager.h"
#import <GTSDK/GeTuiSdk.h>
#import "RequestAuthCode.h"
#import "RequestPhoneLogin.h"
#import "RequestSubuserLogin.h"
#import "RequestThirdLogin.h"
#import "NSString+akucun.h"
#import "TextButton.h"
#import "PopupAccountsView.h"

@interface LoginViewController () <WXApiManagerDelegate,UITextFieldDelegate>

//@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *logoView;

@property (nonatomic, strong) UIButton *weixinButton;

@property (nonatomic, strong) TextButton *termsButton, *switchButton;

@property (nonatomic, strong) UIView *smsLoginView;

//手机号码 短信验证码登录 added by James
@property (nonatomic, strong) UITextField *smsMobileTextField;
@property (nonatomic, strong) UITextField *smsCodeTextField;

@property (nonatomic, strong) UIButton *smsCodeButton;

@property (nonatomic, strong) UIButton *smsLoginButton;

@property (nonatomic, assign) NSInteger loginType;

@end

@implementation LoginViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
        
    [SVProgressHUD setContainerView:self.view];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [WXApiManager sharedManager].delegate = self;
}

- (void) setupContent
{
    [super setupContent];
        
//    [self.view addSubview:self.scrollView];
    
    [self.view addSubview:self.logoView];
    [self.view addSubview:self.weixinButton];
    [self.view addSubview:self.smsLoginView];

    UILabel *tipLabel = [UILabel new];
    tipLabel.font = [FontUtils smallFont];
    tipLabel.textColor = LIGHTGRAY_COLOR;
    tipLabel.text = @"登录即表明您同意";
    [self.view addSubview:tipLabel];
    [self.view addSubview:self.termsButton];
    [self.view addSubview:self.switchButton];

    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])
    {
        self.loginType = 1;
        self.smsLoginView.hidden = YES;
        self.switchButton.hidden = NO;
    }
    else {
        self.loginType = 2;
        self.weixinButton.hidden = YES;
        self.switchButton.hidden = YES;
    }

    //
    CGFloat top = SCREEN_HEIGHT * 0.382;
    self.logoView.centerY = top/2;
    self.smsLoginView.top = self.view.centerY - kFIELD_HEIGHT - kSafeAreaBottomHeight;

    CGFloat offsetWidth = isPad ? kOFFSET_SIZE * 4 : kOFFSET_SIZE;
    CGFloat fieldHeight = isPad ? 50 : kFIELD_HEIGHT;
    [self.weixinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.smsLoginButton);
        make.left.equalTo(self.view.mas_left).with.offset(offsetWidth);
        make.right.equalTo(self.view.mas_right).with.offset(-offsetWidth);
        make.height.equalTo(@(fieldHeight));
    }];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(offsetWidth);
        make.bottom.equalTo(self.view).offset(-kOFFSET_SIZE*2-kSafeAreaBottomHeight);
    }];
    [self.termsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipLabel.mas_right).offset(3);
        make.centerY.equalTo(tipLabel);
        make.width.equalTo(@(100));
        make.height.equalTo(@(40));
    }];
    [self.switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-offsetWidth);
        make.centerY.equalTo(self.termsButton);
        make.width.equalTo(@(100));
        make.height.equalTo(@(40));
    }];
    
#ifdef APPSTORE
#if DEBUG
    self.smsMobileTextField.text = @"17135673125";
    self.smsCodeTextField.text = @"938418";
#endif
#endif
}

- (void) initViewData
{
#if DEBUG
//    self.smsMobileTextField.text = @"13817918368";
//    self.smsCodeTextField.text = @"132691";
#endif
}

- (void) setLoginType:(NSInteger)loginType
{
    _loginType = loginType;
    
    if (loginType == 1) {
//        self.smsLoginView.alpha = 0.0f;
//        self.weixinButton.alpha = 1.0f;
        [self.switchButton setNormalTitle:@"手机主账号登录"];
    }
    else {
//        self.smsLoginView.alpha = 1.0f;
//        self.weixinButton.alpha = 0.0f;
        [self.switchButton setNormalTitle:@"微信登录"];
    }
}

-(void)startTime
{
    __block int timeout = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置（倒计时结束后调用）
                [_smsCodeButton setTitle:@"重新发送" forState:UIControlStateNormal];
                //设置不可点击
                _smsCodeButton.enabled = YES;
            });
        }
        else{
            //            int minutes = timeout / 60;    //这里注释掉了，这个是用来测试多于60秒时计算分钟的。
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
//                NSLog(@"____%@",strTime);
                [_smsCodeButton setTitle:[NSString stringWithFormat:@"重新发送(%@s)",strTime] forState:UIControlStateNormal];
                //设置可点击
                _smsCodeButton.enabled = NO;
            });
            timeout--;
        }
    });
    
    dispatch_resume(_timer);
}

- (void) switchMainController
{
    self.smsCodeTextField.text = @"";

    MainViewController *mainController = [MainViewController new];
    mainController.isFirstLogin = YES;
    [self.navigationController pushViewController:mainController animated:YES];
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mainController];
//    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark -

- (void) requestWXLoginWith:(NSString *)openId unionId:(NSString *)unionId name:(NSString *)nickName avatar:(NSString *)avatar
{
    RequestThirdLogin *request = [RequestThirdLogin new];
    request.openid = openId;
    request.unionid = unionId;
    request.name = nickName;
    request.avatar = avatar;
    
    [UserManager instance].userId = nil;
    [UserManager instance].subuserId = nil;
    [UserManager instance].token = nil;
    
    [SCHttpServiceFace serviceWithPostRequest:request
                                    onSuccess:^(id content)
    {
        //
        HttpResponseBase *response = content;
        NSDictionary *userInfo = response.responseData;
        SubUser *user = [SubUser yy_modelWithDictionary:userInfo[@"subuserinfo"]];
        if (user.validflag) {
            // 已绑定手机号，调用子账号登录
            [self requestLoginWith:user];
        }
        else {
            // 未绑定手机号，进入手机号绑定页面
            [SVProgressHUD dismiss];
            BindPhoneController *controller = [BindPhoneController new];
            controller.subUser = user;
            controller.isPresented = YES;
            @weakify(self)
            controller.finishedBlock = ^{
                @strongify(self)
                [SVProgressHUD showWithStatus:nil];
                [self requestUserInfo];
            };
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
                                 onFailed:^(id content)
    {
    }];
}

- (void) requestPhoneLogin
{
    [UserManager instance].userId = nil;
    [UserManager instance].subuserId = nil;
    [UserManager instance].token = nil;
    
    [SVProgressHUD showWithStatus:@"登录中..."];
    // 手机号码加验证码 登录
    RequestPhoneLogin *request = [RequestPhoneLogin new];
    request.phonenum = _smsMobileTextField.text;
    request.authcode = _smsCodeTextField.text;
    
    [SCHttpServiceFace serviceWithPostRequest:request
                                    onSuccess:^(id content)
     {
         //
         ResponseSubuserList *response = content;
         // 默认以手机号账号登录
         SubUser *subUser = response.phoneAccount;
         [self requestLoginWith:subUser];
         /*
         if (subUsers.count == 1) {
             SubUser *subUser = subUsers[0];
             [self requestLoginWith:subUser];
         }
         else {
             [SVProgressHUD dismiss];
             PopupAccountsView *popupView = [[PopupAccountsView alloc] initWithTitle:@"请选择账号登录" accounts:subUsers];
             @weakify(self)
             popupView.completeBolck = ^(int type, id content) {
                 @strongify(self)
                 SubUser *subUser = content;
                 if (subUser.islogin) {
                     [self confirmWithTitle:@"账号已登录" detail:@"您的账号已在其他设备登录，选择“继续登录”其他设备上将被强制退出，是否继续 ？" btnText:@"继续登录" block:^{
                         [SVProgressHUD showWithStatus:nil];
                         [self requestLoginWith:subUser];
                     } canceled:nil];
                 }
                 else {
                     [SVProgressHUD showWithStatus:nil];
                     [self requestLoginWith:subUser];
                 }
             };
             [popupView show];
         }
          */
     }
                                 onFailed:^(id content)
     {
     }];
}

- (void) requestAuthCode
{
    [SVProgressHUD showWithStatus:nil];
    RequestAuthCode *request = [RequestAuthCode new];
    request.phonenum = _smsMobileTextField.text;
    request.type = AUTHCODE_TYPE_LOGIN;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [self.smsCodeTextField becomeFirstResponder];
         [SVProgressHUD showSuccessWithStatus:@"验证码已发送"];
         [self startTime];
     }
                                 onFailed:^(id content)
     {
     }];
}

- (void) requestLoginWith:(SubUser *)subUser
{
    RequestSubuserLogin *request = [RequestSubuserLogin new];
    request.userid = subUser.userid;
    request.subuserid = subUser.subUserId;
    request.token = subUser.tmptoken;
    
    [SCHttpServiceFace serviceWithPostRequest:request
                                    onSuccess:^(id content)
     {
         //
         HttpResponseBase *response = content;
         NSDictionary *userInfo = response.responseData;
         NSString *userId = [userInfo getStringForKey:@"userid"];
         NSString *subUserId = [userInfo getStringForKey:@"subuserid"];
         NSString *token = [userInfo getStringForKey:@"token"];
         [UserManager saveToken:token userId:userId sub:subUserId];
         
         [self requestUserInfo];
     }
                                     onFailed:^(id content)
     {
     }];
}

- (void) requestUserInfo
{
    RequestUserInfo *request = [RequestUserInfo new];
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         // 绑定个推别名
         [GeTuiSdk bindAlias:[UserManager userId] andSequenceNum:@"seq-1"];
         
         [self requestUserAddress];
     }
                                 onFailed:^(id content)
     {
     }];
}

- (void) requestUserAddress
{
    RequestAddrList *request = [RequestAddrList new];
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         // 清空商品数据
         [ProductsManager clearHistoryData];
         
         [SVProgressHUD dismiss];
         [self switchMainController];
         /*
         // 没有手机号 提示绑定手机号
         UserInfo *userInfo = [UserManager instance].userInfo;
         if (!userInfo.shoujihaovalid) {
             [SVProgressHUD dismiss];
             BindPhoneController *controller = [BindPhoneController new];
             controller.isPresented = YES;
             @weakify(self)
             controller.finishedBlock = ^{
                 @strongify(self)
                 [SVProgressHUD dismiss];
                 [self switchMainController];
             };
             UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
             [self presentViewController:nav animated:YES completion:nil];
         }
         else {
             [SVProgressHUD dismiss];
             [self switchMainController];
         }*/
     }
                                 onFailed:^(id content)
     {
     }];
}

// 登录成功进入后根据活动同步商品 20171228 Jarry
/*
- (void) syncProducts
{
    [SVProgressHUD showWithStatus:@"数据初始化..."];

    [ProductsManager syncProducts:^{
        //
        [SVProgressHUD dismiss];
        [self switchMainController];
    } failed:nil];
}
*/
#pragma mark - Actions

- (IBAction) weixinAction:(id)sender
{
    [SVProgressHUD showWithStatus:@"登录中..."];
    
#if DEBUG
/*
#warning TEST
 NSString *openId = @"oVx8yvw3MgLAbf8jk1E1xqEd6wLs";
 NSString *unionId = @"oRuFRtyFRlKByxqVHTm8RDIgEbK0";
 [self requestWXLoginWith:openId unionId:unionId name:@"朱建林" avatar:@"http://wx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTJlXMqDz35qFniaFOSibz9DTLGQhTP1sgPB2baXBibgE8Uiab3TnhNibDuibxHDynRb5l5BKmW94L5d9xsA/0"];
    return;

    NSString *openId = @"oVx8yvxg96S3q6gKRi2w5BNRXRUY";
    NSString *unionId = @"oRuFRt6cNjm3I0__08fGTwso6PHI";
//    NSString *openId = @"oVx8yv3sEnRxIcDGB_hOxFmbEzbE";
//    NSString *unionId = @"oRuFRtxM3jzwsPtYM9n00VPG1U0U";
//    NSString *openId = @"oVx8yvykXng_nEpRrk8g05Nu7WEY";
//    NSString *unionId = @"oRuFRt0daNJ77FBZ0wNOBuIPtIt8";
    [self requestWXLoginWith:openId unionId:unionId name:@"爱库存会员昵称" avatar:@""];
    return;
*/
#endif

    [WXApiManager sendAuthRequestWithState:@"123" openId:nil viewController:self];
}

- (IBAction) smsLoginAction:(id)sender
{
#if DEBUG
/*
     #warning TEST
     [SVProgressHUD showWithStatus:@"登录中..."];
     NSString *openId = @"oVx8yvw3MgLAbf8jk1E1xqEd6wLs";
     NSString *unionId = @"oRuFRtyFRlKByxqVHTm8RDIgEbK0";
     //    NSString *openId = @"oVx8yvykXng_nEpRrk8g05Nu7WEY";
     //    NSString *unionId = @"oRuFRt0daNJ77FBZ0wNOBuIPtIt8";
     [self requestWXLoginWith:openId unionId:unionId name:@"爱库存会员昵称" avatar:@""];
     return;
*/
#endif
    if (self.smsMobileTextField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入手机号码"];
        return;
    }
    
    if (self.smsCodeTextField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入验证码"];
        return;
    }
    
    if(![self.smsMobileTextField.text checkValidateMobile])
    {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号码"];
        return;
    }
    
    [self.view endEditing:YES];
    [self requestPhoneLogin];
}

- (IBAction) smsCodeAction:(id)sender
{
    if (self.smsMobileTextField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入手机号码"];
        return;
    }
    if(![self.smsMobileTextField.text checkValidateMobile]) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号码"];
        return;
    }
    
    //获取验证码
    [self requestAuthCode];
}

- (IBAction) switchAction:(id)sender
{
    if (self.loginType == 1) {
        self.loginType = 2;
        [UIView transitionFromView:self.weixinButton
                            toView:self.smsLoginView
                          duration:.5f
                           options:UIViewAnimationOptionTransitionFlipFromLeft | UIViewAnimationOptionShowHideTransitionViews
                        completion:^(BOOL finished)
        {
        }];
    }
    else {
        self.loginType = 1;
        [UIView transitionFromView:self.smsLoginView
                            toView:self.weixinButton
                          duration:.5f
                           options:UIViewAnimationOptionTransitionFlipFromLeft | UIViewAnimationOptionShowHideTransitionViews
                        completion:^(BOOL finished)
        {
        }];
    }
}

- (IBAction) termsAction:(id)sender
{
    TermsViewController *controller = [TermsViewController new];
    controller.isPresented = YES;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - WXApiManagerDelegate

- (void) managerDidAuthSuccess:(NSString *)openId unionId:(NSString *)unionId userInfo:(NSDictionary *)userInfo
{
//    [SVProgressHUD dismiss];
    
    INFOLOG(@"--> WX Open ID : %@\n --> WX Union ID : %@", openId, unionId);
    
    if (!openId || openId.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"微信获取授权信息失败 ！"];
        return;
    }
    
    NSString *nickName = [userInfo getStringForKey:@"nickname"];
    NSString *avatar = [userInfo getStringForKey:@"headimgurl"];

    [self requestWXLoginWith:openId unionId:unionId name:nickName avatar:avatar];
}

- (void) managerDidAuthCanceled:(SendAuthResp *)authResp msg:(NSString*)message
{
    if (message) {
        [SVProgressHUD showInfoWithStatus:message];
    }
    else {
        [SVProgressHUD showInfoWithStatus:@"授权失败 ！"];
    }
}

#pragma mark - Views
/*
- (UIScrollView *) scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = WHITE_COLOR;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.view.height);
    }
    return _scrollView;
}
*/
- (UIImageView *) logoView
{
    if (!_logoView) {
        UIImage *image = IMAGENAMED(@"logo");
        _logoView = [[UIImageView alloc] initWithImage:image];
        _logoView.frame = CGRectMake(0, 0, 180, 60);
        _logoView.centerX = self.view.centerX;
        _logoView.contentMode = UIViewContentModeScaleAspectFit;
        
//        _logoView.clipsToBounds = YES;
//        _logoView.layer.cornerRadius = 20;
        //        _logoView.layer.borderWidth = 4.0f;
        //        _logoView.layer.borderColor = COLOR_APP_RED.CGColor;
    }
    return _logoView;
}

- (UIButton *) weixinButton
{
    if (!_weixinButton) {
        _weixinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _weixinButton.backgroundColor = COLOR_MAIN;
        _weixinButton.clipsToBounds = YES;
        _weixinButton.layer.cornerRadius = 5;
        
        _weixinButton.titleLabel.font = SYSTEMFONT(16);
        
        [_weixinButton setNormalColor:WHITE_COLOR highlighted:LIGHTGRAY_COLOR selected:nil];
        [_weixinButton setNormalTitle:@" 微信账号登录 "];
        
        [_weixinButton setNormalImage:@"icon_wx" selectedImage:nil];
        
        [_weixinButton addTarget:self action:@selector(weixinAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _weixinButton;
}

- (UITextField *) smsCodeTextField
{
    if (!_smsCodeTextField) {
        _smsCodeTextField = [[UITextField alloc] init];
        _smsCodeTextField.backgroundColor = WHITE_COLOR;
        _smsCodeTextField.borderStyle = UITextBorderStyleRoundedRect;
        _smsCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;

        _smsCodeTextField.font = [FontUtils normalFont];
        _smsCodeTextField.textColor = COLOR_TEXT_DARK;
        _smsCodeTextField.tintColor = COLOR_MAIN;
        _smsCodeTextField.placeholder = @"请输入验证码";
        _smsCodeTextField.returnKeyType = UIReturnKeyDone;
        _smsCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
        _smsCodeTextField.delegate = self;
        
//        _smsCodeTextField.required = YES;
    }
    return _smsCodeTextField;
}

- (UITextField *) smsMobileTextField
{
    if (!_smsMobileTextField) {
        _smsMobileTextField = [[UITextField alloc] init];
        _smsMobileTextField.backgroundColor = WHITE_COLOR;
        _smsMobileTextField.borderStyle = UITextBorderStyleRoundedRect;
        _smsMobileTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _smsMobileTextField.font = [FontUtils normalFont];
        _smsMobileTextField.textColor = COLOR_TEXT_DARK;
        _smsMobileTextField.tintColor = COLOR_MAIN;
        _smsMobileTextField.placeholder = @"请输入手机号码";
        _smsMobileTextField.returnKeyType = UIReturnKeyDone;
        _smsMobileTextField.keyboardType = UIKeyboardTypePhonePad;
        _smsMobileTextField.delegate = self;
        
//        _smsMobileTextField.required = YES;
    }
    return _smsMobileTextField;
}


- (UIButton *) smsCodeButton
{
    if (!_smsCodeButton) {
        _smsCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _smsCodeButton.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
        _smsCodeButton.clipsToBounds = YES;
        _smsCodeButton.layer.cornerRadius = 5;
        
        _smsCodeButton.titleLabel.font = [FontUtils normalFont];
        
        [_smsCodeButton setNormalColor:COLOR_MAIN highlighted:LIGHTGRAY_COLOR selected:nil];
        [_smsCodeButton setNormalTitleColor:nil disableColor:COLOR_TEXT_LIGHT];
        [_smsCodeButton setNormalTitle:@"获取验证码"];
        
        [_smsCodeButton addTarget:self action:@selector(smsCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _smsCodeButton;
}

- (UIButton *) smsLoginButton
{
    if (!_smsLoginButton) {
        _smsLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _smsLoginButton.backgroundColor = COLOR_BG_BUTTON;
        _smsLoginButton.clipsToBounds = YES;
        _smsLoginButton.layer.cornerRadius = 5;
        
        _smsLoginButton.titleLabel.font = [FontUtils buttonFont];
        
        [_smsLoginButton setNormalColor:WHITE_COLOR highlighted:LIGHTGRAY_COLOR selected:nil];
        [_smsLoginButton setNormalTitle:@" 登 录 "];
        
        //[_smsLoginButton setNormalImage:@"icon_wx" selectedImage:nil];
        
        [_smsLoginButton addTarget:self action:@selector(smsLoginAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _smsLoginButton;
}

- (UIView *) smsLoginView
{
    if (!_smsLoginView) {
        _smsLoginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/2.0f)];
//        _smsLoginView.backgroundColor = RED_COLOR;
        
        [_smsLoginView addSubview:self.smsMobileTextField];
        [_smsLoginView addSubview:self.smsCodeTextField];
        [_smsLoginView addSubview:self.smsCodeButton];
        [_smsLoginView addSubview:self.smsLoginButton];
        
        //设置 手机号码登录 控件 显示的布局
        CGFloat offsetWidth = isPad ? kOFFSET_SIZE * 4 : kOFFSET_SIZE;
        CGFloat fieldHeight = isPad ? 50 : kFIELD_HEIGHT;
        self.smsMobileTextField.frame = CGRectMake(offsetWidth, 0, SCREEN_WIDTH-offsetWidth*2, fieldHeight);
        self.smsCodeButton.frame = CGRectMake(SCREEN_WIDTH-120-offsetWidth, fieldHeight+kOFFSET_SIZE, 120, fieldHeight);
        self.smsCodeTextField.frame = CGRectMake(offsetWidth, fieldHeight+kOFFSET_SIZE, self.smsCodeButton.left-offsetWidth*2, fieldHeight);
        self.smsLoginButton.frame = CGRectMake(offsetWidth, self.smsCodeTextField.bottom+kOFFSET_SIZE*3, SCREEN_WIDTH-offsetWidth*2, fieldHeight);
//        [self.smsMobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_smsLoginView.mas_left).offset(offsetWidth);
//            make.right.equalTo(_smsLoginView.mas_right).offset(-offsetWidth);
//            make.top.equalTo(_smsLoginView.mas_top);
//            make.height.mas_equalTo(@(fieldHeight));
//        }];
        
//        [self.smsCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.smsMobileTextField.mas_bottom).with.offset(kOFFSET_SIZE);
//            make.right.equalTo(_smsLoginView).with.offset(-offsetWidth);
//            make.height.equalTo(@(fieldHeight));
//            make.width.equalTo(@(120));
//        }];
        
//        [self.smsCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.height.equalTo(self.smsMobileTextField);
//            make.right.equalTo(self.smsCodeButton.mas_left).offset(-kOFFSET_SIZE);
//            make.top.equalTo(self.smsMobileTextField.mas_bottom).with.offset(kOFFSET_SIZE);
//        }];
        
//        [self.smsLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.equalTo(self.smsMobileTextField);
//            make.top.equalTo(self.smsCodeTextField.mas_bottom).with.offset(kOFFSET_SIZE*3);
//            make.height.equalTo(@(fieldHeight));
//        }];
    }
    return _smsLoginView;
}

- (TextButton *) termsButton
{
    if (!_termsButton) {
        _termsButton = [TextButton buttonWithType:UIButtonTypeCustom];
        
        [_termsButton setTitleFont:[FontUtils smallFont]];
        
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"使用条款"];
        NSRange titleRange = {0,[title length]};
        [title addAttribute:NSForegroundColorAttributeName value:COLOR_TEXT_NORMAL range:titleRange];
        [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
        [_termsButton setAttributedTitle:title forState:UIControlStateNormal];
        
        NSMutableAttributedString *titleHl = [[NSMutableAttributedString alloc] initWithAttributedString:title];
        [titleHl addAttribute:NSForegroundColorAttributeName value:COLOR_SELECTED range:titleRange];
        [_termsButton setAttributedTitle:titleHl forState:UIControlStateHighlighted];
        
        [_termsButton addTarget:self action:@selector(termsAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _termsButton;
}

- (TextButton *) switchButton
{
    if (!_switchButton) {
        _switchButton = [TextButton buttonWithType:UIButtonTypeCustom];
        
        _switchButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        [_switchButton setTitleAlignment:NSTextAlignmentRight];
        [_switchButton setTitleFont:BOLDSYSTEMFONT(13)];
        [_switchButton setNormalColor:COLOR_TEXT_NORMAL highlighted:COLOR_SELECTED selected:nil];
        [_switchButton setNormalTitle:@"微信登录"];
        
        [_switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchButton;
}

@end
