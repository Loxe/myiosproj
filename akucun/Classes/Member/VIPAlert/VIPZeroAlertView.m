//
//  VIPZeroAlertView.m
//  akucun
//
//  Created by deepin do on 2018/3/5.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "VIPZeroAlertView.h"
#import "UIView+TYAlertView.h"

@interface VIPZeroAlertView ()

@property (nonatomic, strong) UIView      *bottomView;
@property (nonatomic, strong) UIView      *displayView;

@property (nonatomic, strong) UIImageView *faceImgView;

@property (nonatomic, strong) UILabel  *vipTitleLabel;
@property (nonatomic, strong) UILabel  *descripeLabel;

@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *actionBtn;

@property (nonatomic, assign) BOOL isBottomViewAction;

@end

@implementation VIPZeroAlertView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    [self addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.displayView];
    [self.displayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.left.bottom.right.equalTo(self);
        make.top.equalTo(self).offset(50);
    }];
    
    [self addSubview:self.faceImgView];
    [self.faceImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.displayView.mas_top);
        make.width.height.equalTo(@80);
    }];
    
    [self addSubview:self.vipTitleLabel];
    [self.vipTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.equalTo(@(self.size.width-2*kOFFSET_SIZE));
        make.top.equalTo(self.faceImgView.mas_bottom).offset(15);
    }];
    
    [self addSubview:self.descripeLabel];
    [self.descripeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.equalTo(@(self.size.width-2*kOFFSET_SIZE));
        make.top.equalTo(self.vipTitleLabel.mas_bottom).offset(10);
    }];
    
    CGFloat btnW = self.size.width-8*kOFFSET_SIZE;
    CGFloat btnH = btnW/5;
    [self addSubview:self.actionBtn];
    [self.actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.descripeLabel.mas_bottom).offset(20);
        make.width.equalTo(@(btnW));
        make.height.equalTo(@(btnH));
    }];
    
    [self addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.width.height.equalTo(@30);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewDidTap)];
    [self.bottomView setUserInteractionEnabled:YES];
    [self.bottomView addGestureRecognizer:tap];
}

- (void)setAlertType:(VIPZeroAlertType)alertType {
    _alertType = alertType;
    
    switch (alertType) {
        case VIPZeroAlertTypeNormal:
            self.faceImgView.image = [UIImage imageNamed:@"regret"];
            break;
        case VIPZeroAlertTypeAction:
            self.faceImgView.image = [UIImage imageNamed:@"regret"];
            break;
        default:
            self.faceImgView.image = [UIImage imageNamed:@"regret"];
            break;
    }
}

- (void)setVipTitleText:(NSString *)vipTitleText {
    _vipTitleText = vipTitleText;
    
    self.vipTitleLabel.text = vipTitleText;
}

- (void)setDescriptionText:(NSString *)descriptionText {
    _descriptionText = descriptionText;
    
    self.descripeLabel.text = descriptionText;
}

- (void)setDescriptionAttributedText:(NSAttributedString *)descriptionAttributedText {
    _descriptionAttributedText = descriptionAttributedText;
    
    self.descripeLabel.attributedText = descriptionAttributedText;
}

- (void)setIsShowCloseBtn:(BOOL)isShowCloseBtn {
    _isShowCloseBtn = isShowCloseBtn;
    
    [self.closeBtn setHidden:!isShowCloseBtn];
}

- (void)setIsShowActionBtn:(BOOL)isShowActionBtn {
    _isShowActionBtn = isShowActionBtn;
    
    [self.actionBtn setHidden:!isShowActionBtn];
}

- (void)setActionBtnTitle:(NSString *)actionBtnTitle {
    _actionBtnTitle = actionBtnTitle;
    
    [self.actionBtn setNormalTitle:actionBtnTitle];
}

- (void)showWithBGTapDismiss:(BOOL)isEnable {
    self.isBottomViewAction = isEnable;
    
    [self showInWindowWithBackgoundTapDismissEnable:isEnable];
}

- (void)close:(UIButton*)btn {
    [self hideInWindow];
}

- (void)actionBtn:(UIButton*)btn {
    if (self.actionHandle) {
        [self hideInWindow];
        self.actionHandle(btn);
    }
}

- (void)viewDidTap {
    if (self.isBottomViewAction) {
        [self hideInWindow];
    }
}

#pragma mark - LAZY
- (UIView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor clearColor];
    }
    return _bottomView;
}

- (UIView *)displayView {
    if (_displayView == nil) {
        _displayView = [[UIView alloc]init];
        _displayView.backgroundColor = [UIColor whiteColor];
        _displayView.layer.cornerRadius = 5.f;
        _displayView.layer.masksToBounds = YES;
    }
    return _displayView;
}

- (UIImageView *)faceImgView {
    if (_faceImgView == nil) {
        _faceImgView = [[UIImageView alloc]init];
    }
    return _faceImgView;
}

- (UILabel *)vipTitleLabel {
    if (_vipTitleLabel == nil) {
        _vipTitleLabel = [[UILabel alloc]init];
        _vipTitleLabel.textColor = COLOR_TEXT_NORMAL;
        _vipTitleLabel.font      = BOLDSYSTEMFONT(22);
        _vipTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _vipTitleLabel;
}

- (UILabel *)descripeLabel {
    if (_descripeLabel == nil) {
        _descripeLabel = [[UILabel alloc]init];
        _descripeLabel.textColor = COLOR_TEXT_NORMAL;
        _descripeLabel.font      = SYSTEMFONT(16);
        _descripeLabel.numberOfLines = 0;
        _descripeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _descripeLabel;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc]init];
        [_closeBtn setImage:[UIImage imageNamed:@"alertClose"] forState:UIControlStateNormal];
        _closeBtn.layer.cornerRadius = 3;
        _closeBtn.layer.masksToBounds = YES;
        
        [_closeBtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIButton *)actionBtn {
    if (!_actionBtn) {
        _actionBtn = [[UIButton alloc]init];
        [_actionBtn setNormalTitle:@"确定"];
        _actionBtn.titleLabel.font = BOLDSYSTEMFONT(16);
        //        [_actionBtn setTitle:@"确定" forState:UIControlStateNormal];
        //        [_actionBtn setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
        //        _actionBtn.backgroundColor = [UIColor blueColor];
        [_actionBtn setNormalColor:WHITE_COLOR highlighted:COLOR_TEXT_LIGHT selected:nil];
        [_actionBtn setBackgroundColor:COLOR_MAIN];
        _actionBtn.layer.cornerRadius  = 3;
        _actionBtn.layer.masksToBounds = YES;
        
        [_actionBtn addTarget:self action:@selector(actionBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionBtn;
}

@end
