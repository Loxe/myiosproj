//
//  InputCodeController.m
//  akucun
//
//  Created by deepin do on 2018/3/1.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "InputCodeController.h"
#import "AKScanViewController.h"
#import "MainViewController.h"
#import "CameraUtils.h"
#import "VIPLevelAlertView.h"
#import "UIView+TYAlertView.h"
#import "TYAlertController.h"
#import "RequestUseCode.h"
#import "RequestUserInfo.h"

@interface InputCodeController ()

@property (nonatomic, strong) UIImageView *bgImgView;

@property (nonatomic, strong) UILabel    *navLabel;
@property (nonatomic, strong) UIButton   *backBtn;

@property (nonatomic, strong) UILabel     *descLabel;
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) UIView      *bottomLine;

@property (nonatomic, strong) UIButton  *confirmBtn;

@property (nonatomic, strong) NSString  *codeContent;

@end

@implementation InputCodeController

- (void) setupContent
{
    [super setupContent];
    
    [self prepareNav];
    [self prepareSubView];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)prepareNav {
    
    self.view.backgroundColor   = WHITE_COLOR;
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)prepareSubView {
    
    CGFloat offset = kOFFSET_SIZE;
    CGFloat statusH = kSafeAreaTopHeight - 44;
    
    [self.view addSubview:self.bgImgView];
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    
    // 考虑导航栏的高
    [self.view addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0.5*offset);
        make.top.equalTo(self.view).offset(statusH);
        make.width.height.equalTo(@44);
    }];
    
    [self.view addSubview:self.navLabel];
    [self.navLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(statusH);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@44);
    }];

    [self.view addSubview:self.inputTextField];
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100+4*offset);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(SCREEN_WIDTH-4*offset));
        make.height.equalTo(@(2*offset));
    }];
    
    [self.view addSubview:self.bottomLine];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputTextField.mas_bottom).offset(2);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(SCREEN_WIDTH-4*offset));
        make.height.equalTo(@1);
    }];
    
    [self.view addSubview:self.confirmBtn];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputTextField.mas_bottom).offset(3*offset);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(SCREEN_WIDTH-4*offset));
        make.height.equalTo(@(44));
    }];
    
    
    [self.inputTextField addTarget:self action:@selector(inputTFChange:) forControlEvents:UIControlEventEditingChanged];
    
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(viewDidPan)];
//    [self.view addGestureRecognizer:pan];
    
    UIButton *scanBtn = [[UIButton alloc]init];
    scanBtn.frame = CGRectMake(0, 0, 2*offset, 2*offset);
    [scanBtn setImage:[UIImage imageNamed:@"codeRecognition"] forState:UIControlStateNormal];
    [scanBtn addTarget:self action:@selector(scanAction) forControlEvents:UIControlEventTouchUpInside];
    self.inputTextField.rightViewMode = UITextFieldViewModeAlways;
    self.inputTextField.rightView = scanBtn;
}

- (void)inputTFChange:(UITextField *)tf
{
    self.codeContent = tf.text;
}

- (void)viewDidPan
{
    [self.inputTextField resignFirstResponder];
}

- (void)back:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) scanAction
{
    if ([CameraUtils isCameraNotDetermined]) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    // 用户授权
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
    AKScanViewController *vc = [[AKScanViewController alloc] init];
    vc.title    = @"邀请码扫描";
    vc.scanningType = AKScanningTypeQRCode;
    
    @weakify(self)
    vc.scanResultBlock = ^(NSString *codeString) {
        @strongify(self)
        INFOLOG(@"扫描结果: %@", codeString);
        self.inputTextField.text = @"";
        NSRange range = [codeString rangeOfString:@"code="];
        if (range.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请扫描有效的二维码"];
            return;
        }
        
        NSString *code = [codeString substringFromIndex:(range.location+range.length)];
        self.inputTextField.text = code;
        [self requestActiveCode:code];
    };
    
    [self presentViewController:vc animated:YES completion:nil];
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

- (void)confirm:(UIButton *)btn
{
    [self.inputTextField resignFirstResponder];
    
    if (self.inputTextField.text.length < 6) {
        [SVProgressHUD showInfoWithStatus:@"请输入有效的邀请码"];
        return;
    }
    
    [self requestActiveCode:self.inputTextField.text];
}

- (void) requestActiveCode:(NSString *)code
{
    [SVProgressHUD showWithStatus:nil];
    RequestUseCode *request = [RequestUseCode new];
    request.referralcode = [code uppercaseString];
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [self requestUserInfo];
         
     } onFailed:^(id content) {
         
     }];
}

- (void) requestUserInfo
{
    RequestUserInfo *request = [RequestUserInfo new];
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         UserInfo *userInfo = [UserManager instance].userInfo;
         if (userInfo.viplevel <= 0) {
             [SVProgressHUD showErrorWithStatus:@"邀请码开通失败 ！请重试 ！"];
             return;
         }
         
         [SVProgressHUD dismiss];
         VIPLevelAlertType type = VIPLevelAlertTypeUpgrade;
         NSInteger level = 1;
         NSString  *descText = @"恭喜您成为爱库存VIP1用户！\n相关会员权益请在等级规则中查看\n";
         VIPLevelAlertView *alertView = [[VIPLevelAlertView alloc]initWithType:type title:FORMAT(@"VIP%ld",(long)level) subTitle:descText actionBtnTitle:@"确 定"];
         typeof(self) __weak weakSelf = self;
         alertView.actionHandle = ^(UIButton *btn) {
             [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_VIP0_UPGRADED object:nil];
             [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
         };
         alertView.isShowCloseBtn = NO;
         [alertView showWithBGTapDismiss:NO];
     }
                                 onFailed:^(id content)
     {
     }
                                  onError:^(id content)
     {
     }];
}

#pragma mark - LAZY
- (UIImageView *)bgImgView {
    if (_bgImgView == nil) {
        _bgImgView = [[UIImageView alloc]init];
        _bgImgView.image = [UIImage imageNamed:@"inputCodeBG"];
    }
    return _bgImgView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc]init];
        [_backBtn setImage:[UIImage imageNamed:@"inputBack"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UILabel *)navLabel {
    if (_navLabel == nil) {
        _navLabel = [[UILabel alloc]init];
        _navLabel.text = @"填写邀请码";
        _navLabel.font = BOLDSYSTEMFONT(18);
        _navLabel.textColor = WHITE_COLOR;
    }
    return _navLabel;
}

- (UITextField *)inputTextField {
    if (_inputTextField == nil) {
        _inputTextField = [[UITextField alloc]init];
        _inputTextField.textColor = WHITE_COLOR;
        _inputTextField.tintColor = WHITE_COLOR;
        _inputTextField.backgroundColor = [UIColor clearColor];
        
        // 设置占位符属性
        NSString *holderText = @"请输入邀请码";
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
        [placeholder addAttribute:NSForegroundColorAttributeName
                            value:COLOR_TEXT_LIGHT
                            range:NSMakeRange(0, holderText.length)];
        [placeholder addAttribute:NSFontAttributeName
                            value:SYSTEMFONT(16)
                            range:NSMakeRange(0, holderText.length)];
        _inputTextField.attributedPlaceholder = placeholder;
    }
    return _inputTextField;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc]init];
        _bottomLine.backgroundColor = WHITE_COLOR;
    }
    return _bottomLine;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        
        _confirmBtn = [[UIButton alloc]init];
        [_confirmBtn setNormalTitle:@"确定"];
        _confirmBtn.titleLabel.font = BOLDSYSTEMFONT(16);
        [_confirmBtn setNormalColor:COLOR_MAIN highlighted:COLOR_TEXT_LIGHT selected:nil];
        [_confirmBtn setBackgroundColor:WHITE_COLOR];
        _confirmBtn.layer.cornerRadius = 3;
        _confirmBtn.layer.masksToBounds = YES;
        
        [_confirmBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

@end
