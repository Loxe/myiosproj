//
//  IDCardController.m
//  akucun
//
//  Created by deepin do on 2017/12/21.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "IDCardController.h"
#import "AuthRemindView.h"
#import "BankCardController.h"
#import "ValidateManger.h"
#import "IDAuthViewController.h"
#import "IDBackAuthController.h"
#import "RequestIDExist.h"

#define KRemindH  40   // 顶部警示文字的高
#define KInputBGH 100  // 输入框背景区域高
#define KNoticeH  20   // 底部提示文字的高
#define KTFieldH  49   // TextField的高
#define KTLabelW  75   // Label标题的宽
#define KTLabelH  30   // Label标题的高
#define KBtnH     40   // 按钮的高

#define KBGColor  RGBCOLOR(240, 240, 240) // view背景色

@interface IDCardController ()<UITextFieldDelegate>
{
    NSString *previousTextFieldContent;
    UITextRange *previousSelection;
}

@property(nonatomic, strong) AuthRemindView *remindView;
@property(nonatomic, strong) UILabel        *nameLabel;
@property(nonatomic, strong) UILabel        *IDLabel;
@property(nonatomic, strong) UITextField    *nameTextField;
@property(nonatomic, strong) UITextField    *IDTextField;
@property(nonatomic, strong) UIButton       *nextBtn;
@property(nonatomic, strong) UILabel        *uploadLabel;
@property(nonatomic, strong) UIImageView    *IDFrontImgView;
@property(nonatomic, strong) UIImageView    *IDBackImgView;
@property(nonatomic, strong) UILabel        *noticeLabel;

@property(nonatomic, strong) NSString *nameContent;
@property(nonatomic, strong) NSString *IDCardContent;

@end

@implementation IDCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareNav];
    [self prepareSubView];
}

// MARK: 这个要在这个方法里面重写，只能！！！
- (void)setupContent {
    
    self.view.backgroundColor = KBGColor;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
    self.isPresented = YES;

    if (self.view.superview) {
        [SVProgressHUD setContainerView:self.view];
        [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, -64-44)];
    }
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    if (self.IDCardFrontImg) {
        self.IDFrontImgView.image = self.IDCardFrontImg;
    }
    
    if (self.IDCardBackImg) {
        self.IDBackImgView.image = self.IDCardBackImg;
    }
    
    if (self.IDName.length > 0) {
        self.nameTextField.text = self.IDName;
        self.nameContent = self.IDName;
    }
    
    if (self.IDNumber.length > 0) {
        
        self.IDCardContent = self.IDNumber;

        /** 转格式显示 */
        NSMutableString *tempStr = [NSMutableString new];
        for (int i = 0; i < 4; i++) {
            if (i == 0) {
                [tempStr appendFormat:@"%@%@", [self.IDNumber substringWithRange:NSMakeRange(0, 6)], @" "];
            } else if (i == 1) {
                [tempStr appendFormat:@"%@%@", [self.IDNumber substringWithRange:NSMakeRange(6, 4)], @" "];
            } else if (i == 2) {
                [tempStr appendFormat:@"%@%@", [self.IDNumber substringWithRange:NSMakeRange(10, 4)], @" "];
            } else if (i == 3) {
                NSRange lastRange;
                if (self.IDNumber.length == 18) { //身份证号18位
                    lastRange = NSMakeRange(14, 4);
                    [tempStr appendFormat:@"%@", [self.IDNumber substringWithRange:lastRange]];
                }
                else if (self.IDNumber.length == 15) { //身份证号15位
                    lastRange = NSMakeRange(14, 1);
                    [tempStr appendFormat:@"%@", [self.IDNumber substringWithRange:lastRange]];
                }
            }
        }
        //NSLog(@"转格式 --%@",tempStr);
        self.IDTextField.text = tempStr;//完整加空格的
    }
}

- (void)prepareNav {
    self.navigationItem.title = @"实名认证";
}

- (void)prepareSubView {
    
    self.remindView.frame = CGRectMake(0, 0, SCREEN_WIDTH, KRemindH);
    [self.view addSubview:self.remindView];
    
    CGFloat imgW = 0.5*(SCREEN_WIDTH-3*kOFFSET_SIZE);
    CGFloat imgH = 9*imgW/16;
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.frame = CGRectMake(0, KRemindH, SCREEN_WIDTH, imgH+20);
    [self.view addSubview:bgView];
    
    [self.view addSubview:self.IDFrontImgView];
    [self.view addSubview:self.IDBackImgView];
    [self.IDFrontImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(KRemindH+10);
        make.left.equalTo(self.view).offset(kOFFSET_SIZE);
        make.width.equalTo(@(imgW));
        make.height.equalTo(@(imgH));
    }];
    
    [self.IDBackImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(KRemindH+10);
        make.right.equalTo(self.view).offset(-kOFFSET_SIZE);
        make.width.equalTo(@(imgW));
        make.height.equalTo(@(imgH));
    }];
    
    CGFloat uploadY = KRemindH+imgH+20+0.5*kOFFSET_SIZE;
    self.uploadLabel.frame = CGRectMake(kOFFSET_SIZE, uploadY, SCREEN_WIDTH, KNoticeH);
    [self.view addSubview:self.uploadLabel];

    UIView *inputBGView = [[UIView alloc]init];
    CGFloat inputBGY = uploadY + KNoticeH;
    inputBGView.frame = CGRectMake(0, inputBGY, SCREEN_WIDTH, KInputBGH);
    inputBGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:inputBGView];
    
    UIView *topLine = [[UIView alloc]init];
    topLine.backgroundColor = COLOR_SEPERATOR_LIGHT;
    
    UIView *sepLine = [[UIView alloc]init];
    sepLine.backgroundColor = COLOR_SEPERATOR_LIGHT;
    
    UIView *bottomLine = [[UIView alloc]init];
    bottomLine.backgroundColor = COLOR_SEPERATOR_LIGHT;

    [inputBGView addSubview:topLine];
    [inputBGView addSubview:self.nameLabel];
    [inputBGView addSubview:self.nameTextField];
    [inputBGView addSubview:sepLine];
    [inputBGView addSubview:self.IDLabel];
    [inputBGView addSubview:self.IDTextField];
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
    
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right);
        make.right.equalTo(inputBGView).offset(-kOFFSET_SIZE);
        make.centerY.equalTo(self.nameLabel);
        make.height.equalTo(@KTFieldH);
    }];
    
    [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(inputBGView);
        make.left.equalTo(inputBGView).offset(kOFFSET_SIZE);
        make.right.equalTo(inputBGView);
        make.height.equalTo(@0.5);
    }];
    
    [self.IDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(inputBGView).offset(kOFFSET_SIZE);
        make.top.equalTo(inputBGView).offset(60);
        make.width.equalTo(@KTLabelW);
        make.height.equalTo(@KTLabelH);
    }];
    
    [self.IDTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.IDLabel.mas_right);
        make.right.equalTo(inputBGView).offset(-kOFFSET_SIZE);
        make.centerY.equalTo(self.IDLabel);
        make.height.equalTo(@KTFieldH);
    }];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(inputBGView);
        make.height.equalTo(@0.5);
    }];

    CGFloat noticeY = inputBGY + KInputBGH + 40;
    self.noticeLabel.frame = CGRectMake(kOFFSET_SIZE, noticeY, SCREEN_WIDTH, KNoticeH);
    [self.view addSubview:self.noticeLabel];
    
    [self.view addSubview:self.nextBtn];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.noticeLabel.mas_bottom).offset(5);
        make.left.equalTo(self.view).offset(kOFFSET_SIZE);
        make.right.equalTo(self.view).offset(-kOFFSET_SIZE);
        make.height.equalTo(@KBtnH);
    }];
    
    [self.nameTextField addTarget:self action:@selector(nameTFChange:) forControlEvents:UIControlEventEditingChanged];
    [self.IDTextField addTarget:self action:@selector(IDTFChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.IDTextField.delegate = self;
    
    UITapGestureRecognizer *frontTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(frontImageViewDidTap:)];
    [self.IDFrontImgView setUserInteractionEnabled:YES];
    [self.IDFrontImgView addGestureRecognizer:frontTap];
    
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backImageViewDidTap:)];
    [self.IDBackImgView setUserInteractionEnabled:YES];
    [self.IDBackImgView addGestureRecognizer:backTap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(viewDidPan)];
    [self.view addGestureRecognizer:pan];
}

- (void)viewDidPan {
    [self.nameTextField resignFirstResponder];
    [self.IDTextField resignFirstResponder];
}

- (void)nameTFChange:(UITextField *)tf {
    self.nameContent = tf.text;
}

- (void)IDTFChange:(UITextField *)tf {
    
    //限制手机账号长度（有两个空格）
    if (tf.text.length > 21) {
        tf.text = [tf.text substringToIndex:21];
        [self.IDTextField resignFirstResponder];
    }
    
    // 将监听到的文字去空格
    NSString *checkContent = [tf.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.IDCardContent     = checkContent;
    
    /** 预处理 */
    NSUInteger targetCursorPosition = [tf offsetFromPosition:tf.beginningOfDocument toPosition:tf.selectedTextRange.start];
    NSString   *currentStr          = [tf.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString   *preStr              = [previousTextFieldContent stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    /** 标记操作flag 删除为0，添加为1*/
    NSInteger editFlag = 0;
    if (currentStr.length <= preStr.length) {
        editFlag = 0;
    } else {
        editFlag = 1;
    }
    
    /** 处理tf的显示内容 */
    NSMutableString *tempStr = [NSMutableString new];
    int spaceCount = 0;
    
    if (currentStr.length < 6 && currentStr.length > -1) {
        spaceCount = 0;
    } else if (currentStr.length < 10 && currentStr.length > 5) {
        spaceCount = 1;
    } else if (currentStr.length < 14 && currentStr.length > 9) {
        spaceCount = 2;
    } else if (currentStr.length < 19 && currentStr.length > 13) { //小于19是为了把18包含在内
        spaceCount = 3;
    }
    
    for (int i = 0; i < spaceCount; i++) {
        if (i == 0) {
            [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(0, 6)], @" "];
        } else if (i == 1) {
            [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(6, 4)], @" "];
        } else if (i == 2) {
            [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(10, 4)], @" "];
        } else if (i == 3) {//i 小于3的，不会走，也就是后4们拼不到，所以下面单独加一个拼接后4位及空格的
            //[tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(14, 4)], @" "];
        }
    }
    
    if (currentStr.length == 18) {
        [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(14, 4)], @" "];
    }
    
    if (currentStr.length < 7) {
        [tempStr appendString:[currentStr substringWithRange:NSMakeRange(currentStr.length - currentStr.length % 6, currentStr.length % 6)]];
    } else if (currentStr.length > 6 && currentStr.length < 12) {
        NSString *str = [currentStr substringFromIndex:6];
        [tempStr appendString:[str substringWithRange:NSMakeRange(str.length - str.length % 4, str.length % 4)]];
    } else if (currentStr.length > 11 && currentStr.length < 17) {
        NSString *str = [currentStr substringFromIndex:10];
        [tempStr appendString:[str substringWithRange:NSMakeRange(str.length - str.length % 4, str.length % 4)]];
    } else if (currentStr.length > 16 && currentStr.length < 19) {
        NSString *str = [currentStr substringFromIndex:14];
        [tempStr appendString:[str substringWithRange:NSMakeRange(str.length - str.length % 4, str.length % 4)]];
        if (currentStr.length == 18) {
            [tempStr deleteCharactersInRange:NSMakeRange(21, 1)];
        }
    }
    tf.text = tempStr;
    
    /** 当前光标的偏移位置 */
    NSUInteger curTargetCursorPosition = targetCursorPosition;

    if (editFlag == 0) {
        //删除
        if (targetCursorPosition == 22 || targetCursorPosition == 17 || targetCursorPosition == 12 || targetCursorPosition == 7) {
            curTargetCursorPosition = targetCursorPosition - 1;
        }
    } else {
        //添加
        if (targetCursorPosition == 16 || targetCursorPosition == 11 || targetCursorPosition == 7) {
            curTargetCursorPosition = targetCursorPosition + 1;
        }
    }
    UITextPosition *targetPosition = [tf positionFromPosition:[tf beginningOfDocument] offset:curTargetCursorPosition];
    [tf setSelectedTextRange:[tf textRangeFromPosition:targetPosition toPosition:targetPosition]];
}

- (void)frontImageViewDidTap:(UIImageView *)iv {
    NSLog(@"frontImageViewDidTap");
    
    IDAuthViewController *vc = [IDAuthViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)backImageViewDidTap:(UIImageView *)iv {
    NSLog(@"backImageViewDidTap");

    IDBackAuthController *vc = [IDBackAuthController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)nextBtnDidClick {
    
    [self.nameTextField resignFirstResponder];
    [self.IDTextField resignFirstResponder];
/*
    // 请求身份证通过
    BankCardController *vc = [BankCardController new];
    vc.realname = self.nameContent;
    vc.idcard   = self.IDCardContent;
    vc.frontImg = self.IDCardFrontImg;
    vc.backImg  = self.IDCardBackImg;
    [self.navigationController pushViewController:vc animated:YES];
    return;*/
    
    /** 空判断 */
    if (self.nameContent.length <= 0) {
        POPUPINFO(@"真实姓名不能为空");
        return;
    }
    
    if (self.IDCardContent.length <= 0) {
        POPUPINFO(@"身份证号不能为空");
        return;
    }
    
    if (self.IDCardFrontImg == nil) {
        POPUPINFO(@"请扫描身份证正面");
        return;
    }

    if (self.IDCardBackImg == nil) {
        POPUPINFO(@"请扫描身份证反面");
        return;
    }
    
    /** 正则较验判断身份证 */
    BOOL isCorrect = [ValidateManger validateIDCardNumber:self.IDCardContent];
    if (!isCorrect) {
        POPUPINFO(@"身份证号码格式不对");
        return;
    }
    
    // 调判断是否存在的接口
    RequestIDExist *request = [RequestIDExist new];
    request.idcard = self.IDCardContent;
    
    [SCHttpServiceFace serviceWithPostRequest:request onSuccess:^(id content) {
        
        // 请求身份证通过
        BankCardController *vc = [BankCardController new];
        vc.realname = self.nameContent;
        vc.idcard   = self.IDCardContent;
        vc.frontImg = self.IDCardFrontImg;
        vc.backImg  = self.IDCardBackImg;
        [self.navigationController pushViewController:vc animated:YES];
        
    } onFailed:^(id content) {
        
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.IDTextField) {
        previousTextFieldContent = textField.text;
        previousSelection = textField.selectedTextRange;
    }
    return YES;
}

#pragma mark - Lazy
- (AuthRemindView *)remindView {
    if (_remindView == nil) {
        _remindView = [[AuthRemindView alloc]init];
        NSString *text = isPad ? @"请使用您本人的身份证" : @"请使用您本人的身份证扫描";
        [_remindView setRemindViewWithTitle:text image:nil];
    }
    return _remindView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.text      = @"真实姓名:";
        _nameLabel.textColor = COLOR_TEXT_NORMAL;
        _nameLabel.font      = [FontUtils normalFont];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (UILabel *)IDLabel {
    if (_IDLabel == nil) {
        _IDLabel = [[UILabel alloc]init];
        _IDLabel.text      = @"身份证号:";
        _IDLabel.textColor = COLOR_TEXT_NORMAL;
        _IDLabel.font      = [FontUtils normalFont];
        _IDLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _IDLabel;
}

- (UITextField *)nameTextField {
    if (_nameTextField == nil) {
        _nameTextField = [[UITextField alloc]init];
        _nameTextField.backgroundColor = [UIColor whiteColor];
    }
    return _nameTextField;
}

- (UITextField *)IDTextField {
    if (_IDTextField == nil) {
        _IDTextField = [[UITextField alloc]init];
        _IDTextField.backgroundColor = [UIColor whiteColor];
    }
    return _IDTextField;
}

- (UILabel *)uploadLabel {
    if (_uploadLabel == nil) {
        _uploadLabel = [[UILabel alloc]init];
        _uploadLabel.text      = @"确认身份证信息:";//@"请上传身份证照片:"
        _uploadLabel.textColor = LIGHTGRAY_COLOR;
        _uploadLabel.font      = [FontUtils smallFont];
        _uploadLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _uploadLabel;
}

- (UIImageView *)IDFrontImgView {
    if (_IDFrontImgView == nil) {
        _IDFrontImgView = [[UIImageView alloc]init];
        _IDFrontImgView.layer.cornerRadius  = 4;
        _IDFrontImgView.layer.masksToBounds = YES;
        _IDFrontImgView.contentMode = UIViewContentModeScaleAspectFill;
        _IDFrontImgView.image       = [UIImage imageNamed:@"id_front"];
    }
    return _IDFrontImgView;
}

- (UIImageView *)IDBackImgView {
    if (_IDBackImgView == nil) {
        _IDBackImgView = [[UIImageView alloc]init];
        _IDBackImgView.layer.cornerRadius  = 4;
        _IDBackImgView.layer.masksToBounds = YES;
        _IDBackImgView.contentMode = UIViewContentModeScaleAspectFill;
        _IDBackImgView.image       = [UIImage imageNamed:@"id_reverse"];
    }
    return _IDBackImgView;
}

- (UILabel *)noticeLabel {
    if (_noticeLabel == nil) {
        _noticeLabel = [[UILabel alloc]init];
        _noticeLabel.text      = @"以上信息仅用于身份验证";
        _noticeLabel.textColor = LIGHTGRAY_COLOR;
        _noticeLabel.font      = [FontUtils smallFont];
        _noticeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _noticeLabel;
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





@end







