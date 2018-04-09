//
//  BindPhoneController.m
//  akucun
//
//  Created by Jarry on 2017/7/14.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "BindPhoneController.h"
#import "IQKeyboardManager.h"
#import "FormTextField.h"
#import "RequestAuthCode.h"
#import "RequestBindPhone.h"
#import "UserManager.h"

@interface BindPhoneController () <UITextFieldDelegate>

//@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UITextField *mobileTextField;
@property (nonatomic, strong) UITextField *codeTextField;
@property (nonatomic, strong) UIButton *codeButton;
@property (nonatomic, strong) UIButton *submitButton;


@end

@implementation BindPhoneController

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.mobileTextField becomeFirstResponder];
}

- (void) setupContent
{
    [super setupContent];
    
    [IQKeyboardManager sharedManager].enable = YES;
    
    self.title = @"绑定手机号";
    
//    [self.view addSubview:self.scrollView];
    
    [self.view addSubview:self.mobileTextField];
    [self.view addSubview:self.codeTextField];
    [self.view addSubview:self.codeButton];
    [self.view addSubview:self.submitButton];
    
    CGFloat fieldHeight = isPad ? 50 : kFIELD_HEIGHT;
    //设置 手机号码登录 控件 显示的布局
    [self.mobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(kOFFSET_SIZE);
        make.right.equalTo(self.view.mas_right).offset(-kOFFSET_SIZE);
        make.top.equalTo(self.view.mas_top).offset(kOFFSET_SIZE);
        make.height.mas_equalTo(@(fieldHeight));
    }];
    
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(self.mobileTextField);
        make.right.equalTo(self.codeButton.mas_left).offset(-kOFFSET_SIZE);
        make.top.equalTo(self.mobileTextField.mas_bottom).with.offset(kOFFSET_SIZE);
    }];
    
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mobileTextField.mas_bottom).with.offset(kOFFSET_SIZE);
        make.right.equalTo(self.view).with.offset(-kOFFSET_SIZE);
        make.height.equalTo(@(fieldHeight));
        make.width.equalTo(@(120));
    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.mobileTextField);
        make.top.equalTo(self.codeTextField.mas_bottom).with.offset(kOFFSET_SIZE*3);
        make.height.equalTo(@(fieldHeight));
    }];
}

- (void) setIsPresented:(BOOL)isPresented
{
    [super setIsPresented:isPresented];
    
    if (isPresented) {
        self.navigationItem.leftBarButtonItem = nil;
        
//        [self.rightButton setNormalTitle:@"跳过"];
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    }
}

#pragma mark - Actions

- (IBAction) rightButtonAction:(id)sender
{
    if (self.isPresented) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (self.finishedBlock) {
        self.finishedBlock();
    }
}

- (IBAction) submitAction:(id)sender
{
    if (self.mobileTextField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入手机号码"];
        return;
    }
    
    if (self.codeTextField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入验证码"];
        return;
    }
    
    if(![self.mobileTextField.text checkValidateMobile])
    {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号码"];
        return;
    }
    
    [self.view endEditing:YES];
    [self requestBindPhone];
}

- (IBAction) smsCodeAction:(id)sender
{
    if (self.mobileTextField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入手机号码"];
        return;
    }
    if(![self.mobileTextField.text checkValidateMobile]) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号码"];
        return;
    }
    
    //获取验证码
    [self requestAuthCode];
}

-(void) startTimer
{
    __block int timeout = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    @weakify(self)
    dispatch_source_set_event_handler(_timer, ^{
        @strongify(self)
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置（倒计时结束后调用）
                [self.codeButton setTitle:@"重新发送" forState:UIControlStateNormal];
                //设置不可点击
                self.codeButton.enabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;    //这里注释掉了，这个是用来测试多于60秒时计算分钟的。
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //                NSLog(@"____%@",strTime);
                [self.codeButton setTitle:[NSString stringWithFormat:@"重新发送(%@s)",strTime] forState:UIControlStateNormal];
                //设置可点击
                self.codeButton.enabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark -

- (void) requestAuthCode
{
    [SVProgressHUD showWithStatus:nil];
    RequestAuthCode *request = [RequestAuthCode new];
    request.phonenum = self.mobileTextField.text;
    request.type = AUTHCODE_TYPE_BIND;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [SVProgressHUD showSuccessWithStatus:@"验证码已发送"];
         [self.codeTextField becomeFirstResponder];
         [self startTimer];
     }
                                 onFailed:^(id content)
     {
     }];
}

- (void) requestBindPhone
{
    [SVProgressHUD showWithStatus:nil];
    RequestBindPhone *request = [RequestBindPhone new];
    request.phonenum = self.mobileTextField.text;
    request.authcode = self.codeTextField.text;
    request.subuserid = self.subUser.subUserId;
    request.token = self.subUser.tmptoken;
    
    [SCHttpServiceFace serviceWithPostRequest:request
                                    onSuccess:^(id content)
     {
//         [SVProgressHUD showSuccessWithStatus:@"手机号已成功绑定"];
         HttpResponseBase *response = content;
         NSDictionary *userInfo = response.responseData;
         NSString *userId = [userInfo getStringForKey:@"userid"];
         NSString *subUserId = [userInfo getStringForKey:@"subuserid"];
         NSString *token = [userInfo getStringForKey:@"token"];
         [UserManager saveToken:token userId:userId sub:subUserId];
         
         GCD_DELAY(^{
             [self rightButtonAction:nil];
         }, .3f);
     }
                                 onFailed:^(id content)
     {
     }];
}

#pragma mark - UITextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIScrollViewDelegate

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - Views
/*
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = WHITE_COLOR;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.view.height+1);
        
#ifdef XCODE9VERSION
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
#endif
    }
    return _scrollView;
}
*/
- (UITextField *) codeTextField
{
    if (!_codeTextField) {
        _codeTextField = [[UITextField alloc] init];
        _codeTextField.backgroundColor = WHITE_COLOR;
        _codeTextField.borderStyle = UITextBorderStyleRoundedRect;
        _codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _codeTextField.font = [FontUtils normalFont];
        _codeTextField.textColor = COLOR_TEXT_DARK;
        _codeTextField.placeholder = @"请输入验证码";
        _codeTextField.returnKeyType = UIReturnKeyDone;
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
        _codeTextField.delegate = self;
    }
    return _codeTextField;
}

- (UITextField *) mobileTextField
{
    if (!_mobileTextField) {
        _mobileTextField = [[UITextField alloc] init];
        _mobileTextField.backgroundColor = WHITE_COLOR;
        _mobileTextField.borderStyle = UITextBorderStyleRoundedRect;
        _mobileTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _mobileTextField.font = [FontUtils normalFont];
        _mobileTextField.textColor = COLOR_TEXT_DARK;
        _mobileTextField.placeholder = @"请输入手机号码";
        _mobileTextField.returnKeyType = UIReturnKeyDone;
        _mobileTextField.keyboardType = UIKeyboardTypePhonePad;
        _mobileTextField.delegate = self;
    }
    return _mobileTextField;
}

- (UIButton *) codeButton
{
    if (!_codeButton) {
        _codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _codeButton.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
        _codeButton.clipsToBounds = YES;
        _codeButton.layer.cornerRadius = 5;
        
        _codeButton.titleLabel.font = [FontUtils normalFont];
        
        [_codeButton setNormalColor:COLOR_TEXT_DARK highlighted:LIGHTGRAY_COLOR selected:nil];
        [_codeButton setNormalTitleColor:nil disableColor:COLOR_TEXT_LIGHT];
        [_codeButton setNormalTitle:@"获取验证码"];
        
        [_codeButton addTarget:self action:@selector(smsCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _codeButton;
}

- (UIButton *) submitButton
{
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitButton.backgroundColor = COLOR_SELECTED;
        _submitButton.clipsToBounds = YES;
        _submitButton.layer.cornerRadius = 5;
        
        _submitButton.titleLabel.font = [FontUtils buttonFont];
        
        [_submitButton setNormalColor:WHITE_COLOR highlighted:LIGHTGRAY_COLOR selected:nil];
        [_submitButton setNormalTitle:@" 确 定 "];
                
        [_submitButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

@end
