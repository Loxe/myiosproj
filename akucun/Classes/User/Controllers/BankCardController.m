//
//  BankCardController.m
//  akucun
//
//  Created by deepin do on 2017/12/21.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "BankCardController.h"
#import "AuthRemindView.h"
#import "AuthVerfyController.h"
#import "ValidateManger.h"
#import "RequestSMSBank.h"
#import "BankNumberFomatter.h"


#define KRemindH  40   // 顶部警示文字的高
#define KInputBGH 250  // 输入框背景区域高
#define KUploadY  165  // 底部上传文字的Y值
#define KNoticeY  325  // 底部提示文字的Y值
#define KNoticeH  20   // 底部提示文字的高
#define KTFieldH  49   // TextField的高
#define KTLabelW  75   // Label标题的宽
#define KTLabelLW 90   // Label长标题的宽
#define KTLabelH  30   // Label标题的高
#define KBtnY     350  // 按钮的Y
#define KBtnH     40   // 按钮的高

#define KBGColor  RGBCOLOR(240, 240, 240) // view背景色


@interface BankCardController ()<UITextFieldDelegate>
{
    NSString *previousTextFieldContent;
    UITextRange *previousSelection;
}

@property(nonatomic, strong) AuthRemindView *remindView;
@property(nonatomic, strong) UILabel        *nameLabel;
@property(nonatomic, strong) UILabel        *nameInfoLabel;
@property(nonatomic, strong) UILabel        *bankNameLabel;
@property(nonatomic, strong) UILabel        *bankNameInfoLabel;
@property(nonatomic, strong) UILabel        *bankTypeLabel;
@property(nonatomic, strong) UILabel        *bankTypeInfoLabel;
@property(nonatomic, strong) UILabel        *bankLabel;
@property(nonatomic, strong) UILabel        *phoneLabel;
@property(nonatomic, strong) UITextField    *bankTextField;
@property(nonatomic, strong) UITextField    *phoneTextField;
@property(nonatomic, strong) UIButton       *nextBtn;
@property(nonatomic, strong) UILabel        *noticeLabel;

@property(nonatomic, strong) NSString *bankContent;
@property(nonatomic, strong) NSString *phoneContent;

@property(nonatomic, strong) BankNumberFomatter *bankNumFomatter;

@end

@implementation BankCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    // 显示持卡人
    self.nameInfoLabel.text = self.realname;
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
    
    UIView *sepLine1 = [[UIView alloc]init];
    sepLine1.backgroundColor = COLOR_SEPERATOR_LIGHT;
    
    UIView *sepLine2 = [[UIView alloc]init];
    sepLine2.backgroundColor = COLOR_SEPERATOR_LIGHT;
    
    UIView *sepLine3 = [[UIView alloc]init];
    sepLine3.backgroundColor = COLOR_SEPERATOR_LIGHT;
    
    UIView *sepLine4 = [[UIView alloc]init];
    sepLine4.backgroundColor = COLOR_SEPERATOR_LIGHT;
    
    UIView *bottomLine = [[UIView alloc]init];
    bottomLine.backgroundColor = COLOR_SEPERATOR_LIGHT;
    
    [self.view addSubview:self.remindView];
    [self.view addSubview:inputBGView];
    [self.view addSubview:self.noticeLabel];
    [self.view addSubview:self.nextBtn];
    
    [inputBGView addSubview:topLine];
    [inputBGView addSubview:self.nameLabel];
    [inputBGView addSubview:self.nameInfoLabel];
    [inputBGView addSubview:sepLine1];
    [inputBGView addSubview:self.bankLabel];
    [inputBGView addSubview:self.bankTextField];
    [inputBGView addSubview:sepLine2];
    [inputBGView addSubview:self.bankNameLabel];
    [inputBGView addSubview:self.bankNameInfoLabel];
    [inputBGView addSubview:sepLine3];
    [inputBGView addSubview:self.bankTypeLabel];
    [inputBGView addSubview:self.bankTypeInfoLabel];
    [inputBGView addSubview:sepLine4];
    [inputBGView addSubview:self.phoneLabel];
    [inputBGView addSubview:self.phoneTextField];
    [inputBGView addSubview:bottomLine];
    
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(inputBGView);
        make.height.equalTo(@0.5);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(inputBGView).offset(kOFFSET_SIZE);
        make.top.equalTo(inputBGView).offset(10);
        make.width.equalTo(@KTLabelW);
        make.height.equalTo(@KTLabelH);
    }];
    
    [self.nameInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right);
        make.right.equalTo(inputBGView).offset(-kOFFSET_SIZE);
        make.centerY.equalTo(self.nameLabel);
        make.height.equalTo(@KTLabelH);
    }];
    
    [sepLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputBGView).offset(49.5);
        make.left.equalTo(inputBGView).offset(kOFFSET_SIZE);
        make.right.equalTo(inputBGView);
        make.height.equalTo(@0.5);
    }];
    
    [self.bankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(inputBGView).offset(kOFFSET_SIZE);
        make.top.equalTo(sepLine1.mas_bottom).offset(10);
        make.width.equalTo(@KTLabelW);
        make.height.equalTo(@KTLabelH);
    }];
    
    [self.bankTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bankLabel.mas_right);
        make.right.equalTo(inputBGView).offset(-kOFFSET_SIZE);
        make.centerY.equalTo(self.bankLabel);
        make.height.equalTo(@KTFieldH);
    }];
    
    [sepLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bankLabel.mas_bottom).offset(9.5);
        make.left.equalTo(inputBGView).offset(kOFFSET_SIZE);
        make.right.equalTo(inputBGView);
        make.height.equalTo(@0.5);
    }];
    
    [self.bankNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(inputBGView).offset(kOFFSET_SIZE);
        make.top.equalTo(sepLine2.mas_bottom).offset(10);
        make.width.equalTo(@KTLabelW);
        make.height.equalTo(@KTLabelH);
    }];
    
    [self.bankNameInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bankNameLabel.mas_right);
        make.right.equalTo(inputBGView).offset(-kOFFSET_SIZE);
        make.centerY.equalTo(self.bankNameLabel);
        make.height.equalTo(@KTLabelH);
    }];
    
    [sepLine3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bankNameLabel.mas_bottom).offset(9.5);
        make.left.equalTo(inputBGView).offset(kOFFSET_SIZE);
        make.right.equalTo(inputBGView);
        make.height.equalTo(@0.5);
    }];
    
    [self.bankTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(inputBGView).offset(kOFFSET_SIZE);
        make.top.equalTo(sepLine3.mas_bottom).offset(10);
        make.width.equalTo(@KTLabelLW);
        make.height.equalTo(@KTLabelH);
    }];
    
    [self.bankTypeInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bankTypeLabel.mas_right);
        make.right.equalTo(inputBGView).offset(-kOFFSET_SIZE);
        make.centerY.equalTo(self.bankTypeLabel);
        make.height.equalTo(@KTLabelH);
    }];
    
    [sepLine4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bankTypeLabel.mas_bottom).offset(9.5);
        make.left.equalTo(inputBGView).offset(kOFFSET_SIZE);
        make.right.equalTo(inputBGView);
        make.height.equalTo(@0.5);
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(inputBGView).offset(kOFFSET_SIZE);
        make.top.equalTo(sepLine4.mas_bottom).offset(10);
        make.width.equalTo(@KTLabelLW);
        make.height.equalTo(@KTLabelH);
    }];
    
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneLabel.mas_right);
        make.right.equalTo(inputBGView).offset(-kOFFSET_SIZE);
        make.centerY.equalTo(self.phoneLabel);
        make.height.equalTo(@KTFieldH);
    }];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(inputBGView);
        make.height.equalTo(@0.5);
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(KBtnY);
        make.left.equalTo(self.view).offset(kOFFSET_SIZE);
        make.right.equalTo(self.view).offset(-kOFFSET_SIZE);
        make.height.equalTo(@KBtnH);
    }];
    
    //[self.bankTextField addTarget:self action:@selector(bankTFChange:) forControlEvents:UIControlEventEditingChanged];
    [self.phoneTextField addTarget:self action:@selector(phoneTFChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.phoneTextField.delegate = self;
    self.bankTextField.delegate = self;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(viewDidPan)];
    [self.view addGestureRecognizer:pan];
}

- (void)viewDidPan {
    [self.bankTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
}

- (void)bankTFChange:(NSString *)text {
    
    // 将监听到的文字去空格
    NSString *checkContent = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.bankContent = checkContent;

    if (checkContent.length > 19) {
        [self.bankTextField resignFirstResponder];
        return;
    }
    
    // 查询卡号对应银行卡名称
    if(checkContent.length < 16 || checkContent.length > 19) {
        self.bankNameInfoLabel.text = @"未知";
        self.bankTypeInfoLabel.text = @"未知";
        return;
    }
    
    NSString *bankInfoStr = [self returnBankName:checkContent];
    BOOL isUnvalid = [bankInfoStr isEqualToString:@"unvalid"];
    BOOL isUnknown = [bankInfoStr isEqualToString:@"unknown"];
    
    if (isUnknown || isUnvalid) {
        self.bankNameInfoLabel.text = @"未知";
        self.bankTypeInfoLabel.text = @"未知";
        return;
    }
    
    if (!isUnvalid && !isUnknown) {
        NSArray *infoArray = [bankInfoStr componentsSeparatedByString:@"·"];
        self.bankNameInfoLabel.text = infoArray[0];
        self.bankTypeInfoLabel.text = infoArray[1];
        return;
    }
}

- (void)phoneTFChange:(UITextField *)tf {
    
    //限制手机账号长度（有两个空格）
    if (tf.text.length > 13) {
        tf.text = [tf.text substringToIndex:13];
        [self.phoneTextField resignFirstResponder];
    }
    
    // 将监听到的文字去空格
    NSString *checkContent = [tf.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.phoneContent = checkContent;
    
    NSUInteger targetCursorPosition = [tf offsetFromPosition:tf.beginningOfDocument toPosition:tf.selectedTextRange.start];
    
    NSString *currentStr = [tf.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *preStr = [previousTextFieldContent stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //正在执行删除操作时为0，否则为1
    char editFlag = 0;
    if (currentStr.length <= preStr.length) {
        editFlag = 0;
    }
    else {
        editFlag = 1;
    }
    
    NSMutableString *tempStr = [NSMutableString new];
    
    int spaceCount = 0;
    if (currentStr.length < 3 && currentStr.length > -1) {
        spaceCount = 0;
    } else if (currentStr.length < 7 && currentStr.length > 2) {
        spaceCount = 1;
    } else if (currentStr.length < 12 && currentStr.length > 6) {
        spaceCount = 2;
    }
    
    for (int i = 0; i < spaceCount; i++) {
        if (i == 0) {
            [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(0, 3)], @" "];
        }else if (i == 1) {
            [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(3, 4)], @" "];
        } else if (i == 2) {
            [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(7, 4)], @" "];
        }
    }
    
    if (currentStr.length == 11) {
        [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(7, 4)], @" "];
    }
    if (currentStr.length < 4) {
        [tempStr appendString:[currentStr substringWithRange:NSMakeRange(currentStr.length - currentStr.length % 3, currentStr.length % 3)]];
    } else if (currentStr.length > 3 && currentStr.length <12) {
        NSString *str = [currentStr substringFromIndex:3];
        [tempStr appendString:[str substringWithRange:NSMakeRange(str.length - str.length % 4, str.length % 4)]];
        if (currentStr.length == 11) {
            [tempStr deleteCharactersInRange:NSMakeRange(13, 1)];
        }
    }
    tf.text = tempStr;
    
    // 当前光标的偏移位置
    NSUInteger curTargetCursorPosition = targetCursorPosition;
    
    if (editFlag == 0) {
        //删除
        if (targetCursorPosition == 9 || targetCursorPosition == 4) {
            curTargetCursorPosition = targetCursorPosition - 1;
        }
    } else {
        //添加
        if (currentStr.length == 8 || currentStr.length == 4) {
            curTargetCursorPosition = targetCursorPosition + 1;
        }
    }
    UITextPosition *targetPosition = [tf positionFromPosition:[tf beginningOfDocument] offset:curTargetCursorPosition];
    [tf setSelectedTextRange:[tf textRangeFromPosition:targetPosition toPosition :targetPosition]];
}

/** 根据银行卡号返回银行信息 */
- (NSString *)returnBankName:(NSString*)idCard {
    
    if(idCard == nil || idCard.length < 16 || idCard.length > 19){
        return @"unvalid";
    }
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"bank" ofType:@"plist"];
    NSDictionary* resultDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *bankBin = resultDic.allKeys;
    
    //6位Bin号
    NSString* cardbin_6 = [idCard substringWithRange:NSMakeRange(0, 6)];
    //8位Bin号
    NSString* cardbin_8 = [idCard substringWithRange:NSMakeRange(0, 8)];
    
    if ([bankBin containsObject:cardbin_6]) {
        return [resultDic objectForKey:cardbin_6];
    } else if ([bankBin containsObject:cardbin_8]){
        return [resultDic objectForKey:cardbin_8];
    } else {
        return @"unknown";
    }
    return @"";
}

- (void)nextBtnDidClick {
    /*
    AuthVerfyController *vc = [AuthVerfyController new];
    vc.realname = self.realname;
    vc.idcard   = self.idcard;
    vc.frontImg = self.frontImg;
    vc.backImg  = self.backImg;
    vc.bankcard = self.bankContent;
    vc.mobile   = self.phoneContent;
    [self.navigationController pushViewController:vc animated:YES];
    return;*/
    
    /** 空判断 */
    if (self.bankContent.length <= 0) {
        POPUPINFO(@"银行卡号不能为空");
        return;
    }
    
    if (self.phoneContent.length <= 0) {
        POPUPINFO(@"预留手机号不能为空");
        return;
    }
    
    /** 正则较验判断银行卡&手机号 */
    BOOL isCorrect = [ValidateManger validateBankCard:self.bankContent];
    if (!isCorrect) {
        POPUPINFO(@"银行卡号码格式不对");
        return;
    }
    
    // 手机号正则较验
    BOOL isPhoneCorrect = [ValidateManger validateMobile:self.phoneContent];
    if (!isPhoneCorrect) {
        POPUPINFO(@"手机号码格式不对");
        return;
    }
    
    // 调发短信的接口
    RequestSMSBank *request = [RequestSMSBank new];
    request.mobile   = self.phoneContent;
    request.type     = 5;//固定
    
    [SCHttpServiceFace serviceWithPostRequest:request onSuccess:^(id content) {

        // 短信发送成功
        AuthVerfyController *vc = [AuthVerfyController new];
        vc.realname = self.realname;
        vc.idcard   = self.idcard;
        vc.frontImg = self.frontImg;
        vc.backImg  = self.backImg;
        vc.bankcard = self.bankContent;
        vc.mobile   = self.phoneContent;
        [self.navigationController pushViewController:vc animated:YES];
    } onFailed:^(id content) {
        return;
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.bankTextField) {
        NSLog(@"--->删除 %@",textField.text);
        if (textField.text.length < 23) {//加4个空格满23位，就不拼了
            NSString *str = [textField.text stringByAppendingString:string];
            [self bankTFChange:str];
        }
        [self.bankNumFomatter numberField:textField shouldChangeCharactersInRange:range replacementString:string];
        return NO;
    } else {
        previousTextFieldContent = textField.text;
        previousSelection = textField.selectedTextRange;
    }
    return YES;
}

#pragma mark - Lazy
- (AuthRemindView *)remindView {
    if (_remindView == nil) {
        _remindView = [[AuthRemindView alloc]init];
        _remindView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
        [_remindView setRemindViewWithTitle:@"请使用本人身份证认证的银行卡" image:nil];
    }
    return _remindView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.text      = @"持 卡 人:";
        _nameLabel.textColor = COLOR_TEXT_NORMAL;
        _nameLabel.font      = [FontUtils normalFont];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (UILabel *)nameInfoLabel {
    if (_nameInfoLabel == nil) {
        _nameInfoLabel = [[UILabel alloc]init];
        _nameInfoLabel.textColor = COLOR_TEXT_NORMAL;
        _nameInfoLabel.font      = [FontUtils normalFont];
        _nameInfoLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameInfoLabel;
}

- (UILabel *)bankLabel {
    if (_bankLabel == nil) {
        _bankLabel = [[UILabel alloc]init];
        _bankLabel.text      = @"银行卡号:";
        _bankLabel.textColor = COLOR_TEXT_NORMAL;
        _bankLabel.font      = [FontUtils normalFont];
        _bankLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _bankLabel;
}

- (UILabel *)bankNameLabel {
    if (_bankNameLabel == nil) {
        _bankNameLabel = [[UILabel alloc]init];
        _bankNameLabel.text      = @"银行名称:";
        _bankNameLabel.textColor = COLOR_TEXT_NORMAL;
        _bankNameLabel.font      = [FontUtils normalFont];
        _bankNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _bankNameLabel;
}

- (UILabel *)bankNameInfoLabel {
    if (_bankNameInfoLabel == nil) {
        _bankNameInfoLabel = [[UILabel alloc]init];
        _bankNameInfoLabel.text      = @"未知";
        _bankNameInfoLabel.textColor = COLOR_TEXT_NORMAL;
        _bankNameInfoLabel.font      = [FontUtils normalFont];
        _bankNameInfoLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _bankNameInfoLabel;
}

- (UILabel *)bankTypeLabel {
    if (_bankTypeLabel == nil) {
        _bankTypeLabel = [[UILabel alloc]init];
        _bankTypeLabel.text      = @"银行卡类型:";
        _bankTypeLabel.textColor = COLOR_TEXT_NORMAL;
        _bankTypeLabel.font      = [FontUtils normalFont];
        _bankTypeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _bankTypeLabel;
}

- (UILabel *)bankTypeInfoLabel {
    if (_bankTypeInfoLabel == nil) {
        _bankTypeInfoLabel = [[UILabel alloc]init];
        _bankTypeInfoLabel.text      = @"未知";
        _bankTypeInfoLabel.textColor = COLOR_TEXT_NORMAL;
        _bankTypeInfoLabel.font      = [FontUtils normalFont];
        _bankTypeInfoLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _bankTypeInfoLabel;
}

- (UILabel *)phoneLabel {
    if (_phoneLabel == nil) {
        _phoneLabel = [[UILabel alloc]init];
        _phoneLabel.text      = @"预留手机号:";
        _phoneLabel.textColor = COLOR_TEXT_NORMAL;
        _phoneLabel.font      = [FontUtils normalFont];
        _phoneLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _phoneLabel;
}

- (UITextField *)bankTextField {
    if (_bankTextField == nil) {
        _bankTextField = [[UITextField alloc]init];
        _bankTextField.backgroundColor = [UIColor whiteColor];
        _bankTextField.placeholder     = @"请输入您的银行卡号";
        _bankTextField.font            = [FontUtils normalFont];
        _bankTextField.keyboardType    = UIKeyboardTypeNumberPad;
    }
    return _bankTextField;
}

- (UITextField *)phoneTextField {
    if (_phoneTextField == nil) {
        _phoneTextField = [[UITextField alloc]init];
        _phoneTextField.backgroundColor = [UIColor whiteColor];
        _phoneTextField.placeholder     = @"请输入您的预留手机号";
        _phoneTextField.font            = [FontUtils normalFont];
        _phoneTextField.keyboardType    = UIKeyboardTypeNumberPad;
    }
    return _phoneTextField;
}

- (UIButton *)nextBtn {
    if (_nextBtn == nil) {
        _nextBtn = [[UIButton alloc]init];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        _nextBtn.backgroundColor = COLOR_MAIN;
        _nextBtn.titleLabel.font = [FontUtils buttonFont];
        _nextBtn.layer.cornerRadius  = 3.0f;
        _nextBtn.layer.masksToBounds = YES;
        [_nextBtn addTarget:self action:@selector(nextBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

- (UILabel *)noticeLabel {
    if (_noticeLabel == nil) {
        _noticeLabel = [[UILabel alloc]init];
        _noticeLabel.frame = CGRectMake(kOFFSET_SIZE, 325, SCREEN_WIDTH, 20);
        _noticeLabel.text      = @"以上信息仅用于身份验证";
        _noticeLabel.textColor = LIGHTGRAY_COLOR;
        _noticeLabel.font      = [FontUtils smallFont];
        _noticeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _noticeLabel;
}

/** 银行卡号显示格式 */
- (BankNumberFomatter *)bankNumFomatter {
    if (_bankNumFomatter == nil) {
        _bankNumFomatter = [[BankNumberFomatter alloc]init];
    }
    return _bankNumFomatter;
}


@end
