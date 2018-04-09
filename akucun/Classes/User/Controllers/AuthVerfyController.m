//
//  AuthVerfyController.m
//  akucun
//
//  Created by deepin do on 2017/12/21.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "AuthVerfyController.h"
#import "AuthRemindView.h"
#import "ValidateManger.h"
#import "RequestAuthUser.h"
#import "RequestSMSBank.h"
#import "UserManager.h"

#define TIMECOUNT 60
#define KBGColor  RGBCOLOR(240, 240, 240) // view背景色

#define KRemindH  40   // 顶部警示文字的高
#define KInputBGH 50  // 输入框背景区域高
#define KTFieldH  49   // TextField的高
#define KTLabelW  60   // Label标题的宽
#define KTLabelH  30   // Label标题的高
#define KCodeBtnW 100  // 验证码按钮宽
#define KBtnY     240  // 按钮的Y
#define KBtnH     40   // 按钮的高

@interface AuthVerfyController ()

@property(nonatomic, strong) AuthRemindView *remindView;
@property(nonatomic, strong) UILabel        *verCodeLabel;
@property(nonatomic, strong) UITextField    *verCodeTextField;
@property(nonatomic, strong) UIButton       *submitBtn;
@property(nonatomic, strong) UIButton       *codeBtn;
@property(nonatomic, strong) NSString       *verCodeContent;

@property(nonatomic, assign) NSInteger totalCount; //倒计时总时长
@property(nonatomic, strong) NSTimer   *timer;

@end

@implementation AuthVerfyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.totalCount = TIMECOUNT;
    [self prepareNav];
    [self prepareSubView];
}

// MARK: 这个要在这个方法里面重写，只能！！！
- (void)setupContent {
    
    self.view.backgroundColor = KBGColor;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.view.superview) {
        [SVProgressHUD setContainerView:self.view];
        [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, -64-44)];
    }
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    // 设置标题
    NSRange range = NSMakeRange(2, 4);
    NSString *securPhone = [self.mobile stringByReplacingCharactersInRange:range withString:@"****"];
    NSString *securTitle = [NSString stringWithFormat:@"已向您的预留手机号%@发送验证码",securPhone];
    [_remindView setRemindViewWithTitle:securTitle image:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    //页面消失的时候暂停定时器，防止出现循环引用，导致内存泄漏
    [self.timer invalidate];
}

- (void)prepareNav {
    self.navigationItem.title = @"实名认证";
}

- (void)prepareSubView {
    
    UIView *inputBGView = [[UIView alloc]init];
    inputBGView.frame = CGRectMake(0, KRemindH, SCREEN_WIDTH, KInputBGH);
    inputBGView.backgroundColor = RGBCOLOR(255, 255, 255);
    
    UIView *topLine = [[UIView alloc]init];
    topLine.backgroundColor = COLOR_SEPERATOR_LIGHT;
    
    UIView *sepLine = [[UIView alloc]init];
    sepLine.backgroundColor = COLOR_SEPERATOR_LIGHT;
    
    UIView *bottomLine = [[UIView alloc]init];
    bottomLine.backgroundColor = COLOR_SEPERATOR_LIGHT;
    
    [self.view addSubview:self.remindView];
    [self.view addSubview:inputBGView];
    [self.view addSubview:self.submitBtn];
    
    [inputBGView addSubview:topLine];
    [inputBGView addSubview:self.verCodeLabel];
    [inputBGView addSubview:self.verCodeTextField];
    [inputBGView addSubview:self.codeBtn];
    [inputBGView addSubview:bottomLine];
    
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(inputBGView);
        make.height.equalTo(@0.5);
    }];
    
    [self.verCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(inputBGView);
        make.left.equalTo(inputBGView).offset(kOFFSET_SIZE);
        make.width.equalTo(@KTLabelW);
        make.height.equalTo(@KTLabelH);
    }];
    
    [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(inputBGView).offset(-kOFFSET_SIZE);
        make.centerY.equalTo(inputBGView);
        make.width.equalTo(@KCodeBtnW);
    }];
    
    [self.verCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.verCodeLabel.mas_right);
        make.right.equalTo(self.codeBtn.mas_left).offset(-kOFFSET_SIZE*0.5);
        make.centerY.equalTo(self.verCodeLabel);
        make.height.equalTo(@KTFieldH);
    }];

    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(inputBGView);
        make.height.equalTo(@0.5);
    }];
    
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(KBtnY);
        make.left.equalTo(self.view).offset(kOFFSET_SIZE);
        make.right.equalTo(self.view).offset(-kOFFSET_SIZE);
        make.height.equalTo(@KBtnH);
    }];
    
    [self.verCodeTextField addTarget:self action:@selector(verCodeTFChange:) forControlEvents:UIControlEventEditingChanged];
    
    // 将定时器设置为默认自动开启的
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(autoTimer) userInfo:nil repeats:YES];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(viewDidPan)];
    [self.view addGestureRecognizer:pan];
}

- (void)viewDidPan {
    [self.verCodeTextField resignFirstResponder];
}

- (void)verCodeTFChange:(UITextField *)tf {
    self.verCodeContent = tf.text;
}

// 点击重新获取的定时器
- (void)codeBtnDidClick {
    
    // 调发短信的接口
    RequestSMSBank *request = [RequestSMSBank new];
    request.mobile   = self.mobile;
    request.type     = 5;//固定
    
    // 请求第二个接口，成功再开始倒计时，不成功报错
    [SCHttpServiceFace serviceWithPostRequest:request onSuccess:^(id content) {
        // 短信发送成功
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(handelTimer) userInfo:nil repeats:YES];
        
    } onFailed:^(id content) {
        return;
    }];
}

- (void)autoTimer {
    if (self.totalCount == 0) {
        self.codeBtn.userInteractionEnabled = YES;
        self.codeBtn.backgroundColor = COLOR_MAIN;
        [self.codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.codeBtn setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];
        self.totalCount = TIMECOUNT;
        [self.timer invalidate];
    } else {
        self.codeBtn.userInteractionEnabled = NO;
        self.codeBtn.backgroundColor = [UIColor whiteColor];
        [self.codeBtn setTitleColor:RGBCOLOR(128, 128, 128) forState:UIControlStateNormal];
        [self.codeBtn setTitle:[NSString stringWithFormat:@"%ld 秒",(long)self.totalCount] forState:UIControlStateNormal];
    }
    self.totalCount --;
}

- (void)handelTimer {
    if (self.totalCount == 0) {
        self.codeBtn.userInteractionEnabled = YES;
        self.codeBtn.backgroundColor = COLOR_MAIN;
        [self.codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.codeBtn setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];
        self.totalCount = TIMECOUNT;
        [self.timer invalidate];
    } else {
        self.codeBtn.userInteractionEnabled = NO;
        self.codeBtn.backgroundColor = [UIColor whiteColor];
        [self.codeBtn setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
        [self.codeBtn setTitle:[NSString stringWithFormat:@"%ld 秒",(long)self.totalCount] forState:UIControlStateNormal];
    }
    self.totalCount --;
}

- (void)submitBtnDidClick {

    /** 空判断 */
    if (self.verCodeContent.length <= 0) {
        POPUPINFO(@"验证码不能为空");
        return;
    }
    
    /** 正则较验判断验证码位数 */
//    BOOL isCorrect = [ValidateManger validateSMSCode:self.verCodeContent];
//    if (!isCorrect) {
//        POPUPINFO(@"验证码格式不对");
//        return;
//    }
    
    // 调判断是否存在的接口
    RequestAuthUser *request = [RequestAuthUser new];
    request.code         = self.verCodeContent;
    request.mobile       = self.mobile;
    request.idcard       = self.idcard;
    request.realname     = self.realname;
    request.bankcard     = self.bankcard;
    
    // 图片格式要转成base64
    NSData *frontData    = UIImageJPEGRepresentation(self.frontImg, 0.5f);
    NSData *backData     = UIImageJPEGRepresentation(self.backImg, 0.5f);
    request.base64Img    = [frontData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    request.base64ImgBac = [backData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    [SVProgressHUD showWithStatus:nil];
    [SCHttpServiceFace serviceWithPostRequest:request onSuccess:^(id content) {
        [SVProgressHUD showSuccessWithStatus:@"提交成功"];
        [UserManager instance].userInfo.identityflag = YES;
        GCD_DELAY(^{
            [self dismissViewControllerAnimated:YES completion:nil];
        }, 2.0f);
//        POPUPINFO(@"提交成功");
    } onFailed:^(id content) {

    }];
}

#pragma mark - Lazy
- (AuthRemindView *)remindView {
    if (_remindView == nil) {
        _remindView = [[AuthRemindView alloc]init];
        _remindView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    }
    return _remindView;
}

- (UILabel *)verCodeLabel {
    if (_verCodeLabel == nil) {
        _verCodeLabel = [[UILabel alloc]init];
        _verCodeLabel.text      = @"验证码:";
        _verCodeLabel.textColor = COLOR_TEXT_NORMAL;
        _verCodeLabel.font      = [FontUtils normalFont];
        _verCodeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _verCodeLabel;
}

- (UITextField *)verCodeTextField {
    if (_verCodeTextField == nil) {
        _verCodeTextField = [[UITextField alloc]init];
        _verCodeTextField.backgroundColor = [UIColor whiteColor];
        _verCodeTextField.keyboardType    = UIKeyboardTypeNumberPad;
    }
    return _verCodeTextField;
}

- (UIButton *)submitBtn {
    if (_submitBtn == nil) {
        _submitBtn = [[UIButton alloc]init];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        _submitBtn.backgroundColor = COLOR_MAIN;
        _submitBtn.titleLabel.font = [FontUtils buttonFont];
        _submitBtn.layer.cornerRadius  = 3.0f;
        _submitBtn.layer.masksToBounds = YES;
        [_submitBtn addTarget:self action:@selector(submitBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

- (UIButton *)codeBtn {
    if (_codeBtn == nil) {
        _codeBtn = [[UIButton alloc]init];
        [_codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_codeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_codeBtn setTitle:@"60 秒" forState:UIControlStateNormal];
        _codeBtn.backgroundColor = [UIColor whiteColor];
        _codeBtn.titleLabel.font = [FontUtils buttonFont];
        _codeBtn.layer.cornerRadius  = 3.0f;
        _codeBtn.layer.masksToBounds = YES;
        [_codeBtn addTarget:self action:@selector(codeBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _codeBtn;
}



@end
