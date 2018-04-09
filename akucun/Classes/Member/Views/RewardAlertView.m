//
//  RewardAlertView.m
//  akucun
//
//  Created by Jarry Z on 2018/4/3.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RewardAlertView.h"
#import "UIView+TYAlertView.h"

@interface RewardAlertView ()

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel  *amountLabel;

@property (nonatomic, strong) UIButton *actionBtn;

@end

@implementation RewardAlertView

- (void) showWithBGTapDismiss:(BOOL)isEnable
{
//    self.isBottomViewAction = isEnable;
    [self showInWindowWithBackgoundTapDismissEnable:isEnable];
}

- (instancetype) initWithType:(NSInteger)type
                        value:(NSInteger)amountValue
{
    CGFloat imgW = 375;
    CGFloat imgH = imgW*835/750;
    CGRect frame = CGRectMake(0, 0.5*(SCREEN_HEIGHT-imgH), imgW, imgH);
    self = [self initWithFrame:frame];
    if (self) {
        self.alertType = type;
        self.amount = amountValue;
        [self setupUIWithFrame:frame];
    }
    return self;
}

- (void) setupUIWithFrame:(CGRect)frame
{
    [self addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.amountLabel];
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(175);
        make.width.lessThanOrEqualTo(@(150));
    }];
    
    [self addSubview:self.actionBtn];
    [self.actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-15);
        make.width.equalTo(@(175));
        make.height.equalTo(@(42));
    }];
}

- (void) setAlertType:(RewardAlertType)alertType
{
    _alertType = alertType;
    
    self.bgImageView.image = IMAGENAMED(FORMAT(@"bg_alert_reward_%ld", (long)alertType));
}

- (void) setAmount:(NSInteger)amount
{
    _amount = amount;
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:FORMAT(@"%ld元", (long)amount/100)];
    [attStr addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(18) range:NSMakeRange(attStr.length-1, 1)];
    self.amountLabel.attributedText = attStr;
}

- (IBAction) actionBtn:(id)sender
{
    [self hideView];
    
    if (self.actionBlock) {
        self.actionBlock();
    }
}

- (UIImageView *) bgImageView
{
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImageView;
}

- (UILabel *) amountLabel
{
    if (_amountLabel == nil) {
        _amountLabel = [[UILabel alloc] init];
        _amountLabel.textColor = RGBCOLOR(0xF6, 0x8F, 0x0B);
        _amountLabel.font      = BOLDSYSTEMFONT(40);
        _amountLabel.textAlignment = NSTextAlignmentCenter;
        _amountLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _amountLabel;
}

- (UIButton *) actionBtn
{
    if (!_actionBtn) {
        _actionBtn = [[UIButton alloc] init];
        
        [_actionBtn setNormalTitle:@"去查收"];
        _actionBtn.titleLabel.font = BOLDSYSTEMFONT(16);
        [_actionBtn setNormalColor:RGBCOLOR(0x8A, 0x60, 0x26) highlighted:WHITE_COLOR selected:nil];
        
        [_actionBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 5, 0)];
        [_actionBtn setBackgroundImage:IMAGENAMED(@"bg_alert_reward_btn") forState:UIControlStateNormal];
        
        [_actionBtn addTarget:self action:@selector(actionBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionBtn;
}

@end
