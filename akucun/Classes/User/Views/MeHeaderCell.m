//
//  MeHeaderCell.m
//  akucun
//
//  Created by deepin do on 2018/1/8.
//  Copyright © 2018年 Sucang. All rights reserved.
//



#import "MeHeaderCell.h"
#import "UserManager.h"
#import "UIImageView+WebCache.h"

@interface MeHeaderCell()

@property(nonatomic, strong) UIView *spaceView;
@property(nonatomic, strong) UIView *lineView;

@end

@implementation MeHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)updateData
{
    UserInfo *userInfo = [UserManager instance].userInfo;
    // vip
    NSInteger viplevel    = userInfo.viplevel;

    // 头像
    NSString *avatorStr = userInfo.avatar;
    if (avatorStr && avatorStr.length > 0) {
        [self.avatorImgView sd_setImageWithURL:[NSURL URLWithString:avatorStr]];
    } else {
        self.avatorImgView.image = [UIImage imageNamed:@"userAvator"];
    }

    [self.nameLabel setNormalTitle:userInfo.name];
    self.vipLevelLabel.text = [NSString stringWithFormat:@"VIP%ld",(long)viplevel];
    self.codeLabel.text = userInfo.yonghubianhao;
    
    [self setAuthened:userInfo.identityflag];
    
    self.vipLevelLabel.backgroundColor = viplevel > 0 ? COLOR_SELECTED :  COLOR_TEXT_LIGHT;
    if (userInfo.isrelevance) {
        self.typeLabel.backgroundColor = RGBCOLOR(0x00, 0xa0, 0xe9);
        self.typeLabel.text = @"关联";
    }
    else if (userInfo.istabaccount) {
        self.typeLabel.backgroundColor = RGBCOLOR(0xff, 0x57, 0x5d);
        self.typeLabel.text = @"主";
    }
    else {
        self.typeLabel.backgroundColor = RGBCOLOR(0x5a, 0x99, 0x00);
        self.typeLabel.text = @"子";
    }
    
    VIPMemberTarget *target = [UserManager targetByLevel:viplevel];
    if (viplevel == 0 && userInfo.isDowngrade) {
        // 降级为VIP0
        self.progressView.trackTintColor = COLOR_TEXT_NORMAL;
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:@"您上月销售额未达标已降级"];
        self.progressLabel.attributedText = attStr;
    }
    else if (target && userInfo.monthsale < target.minsale) {
        // 保级
        self.progressView.trackTintColor = COLOR_BG_TRACK;
        NSString *amountStr = [NSString amountCommaString:(target.minsale-userInfo.monthsale)];
        NSString *descText = FORMAT(@"距离保级成功还差%@", amountStr);
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:descText];
        [attStr addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(9) range:NSMakeRange(0, descText.length)];
        [attStr addAttribute:NSForegroundColorAttributeName value:COLOR_TEXT_NORMAL range:NSMakeRange(0, descText.length)];
        [attStr addAttribute:NSForegroundColorAttributeName value:COLOR_BG_TRACK range:NSMakeRange(descText.length-amountStr.length, amountStr.length)];
        self.progressLabel.attributedText = attStr;
    }
    else {
        // 升级
        self.progressView.trackTintColor = COLOR_MAIN;
        NSInteger nextLevel = [UserManager nextLevel:viplevel sales:userInfo.monthsale];
        self.progressLabel.attributedText = nil;
        if (nextLevel > 0) {
            VIPMemberTarget *nextTarget = [UserManager targetByLevel:nextLevel];
            NSInteger nextAmount = (nextTarget.minsale-userInfo.monthsale);
            NSString *amountStr = [NSString amountCommaString:(nextAmount)];
            
            NSString *descText = FORMAT(@"再销售%@下月升级VIP%ld", amountStr, (long)nextLevel);
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:descText];
            [attStr addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(9) range:NSMakeRange(0, descText.length)];
            [attStr addAttribute:NSForegroundColorAttributeName value:COLOR_TEXT_NORMAL range:NSMakeRange(0, descText.length)];
            [attStr addAttribute:NSForegroundColorAttributeName value:COLOR_MAIN range:NSMakeRange(3, amountStr.length)];
            [attStr addAttribute:NSForegroundColorAttributeName value:COLOR_MAIN range:NSMakeRange(descText.length-4, 4)];
            self.progressLabel.attributedText = attStr;
        }
        else {
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:@"您已是VIP顶级用户"];
            self.progressLabel.attributedText = attStr;
        }
    }
    /** 进度条 */
    CGFloat percent = [UserManager getSalesPercent:viplevel sales:userInfo.monthsale];
//    if ([UserManager isPrimaryAccount]) {
        NSString *amountStr = [NSString amountCommaString:userInfo.monthsale];
        [self setTrackPercent:percent andSaleCountStr:amountStr];
//    }
//    else {
//        NSString *text = FORMAT(@"%.0f%%", percent*100.0f);
//        [self setTrackPercent:percent andSaleCountStr:text];
//    }
    
    if (userInfo.isBalancePay) {
        self.spaceView.hidden = NO;
        self.accountLabel.hidden = NO;
        self.rechargeButton.hidden = !userInfo.istabaccount;
        // 账户余额
        NSString *yueStr = [NSString priceString:userInfo.account.keyongyue];
        NSString *accountStr = FORMAT(@"账户余额： %@", yueStr);
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:accountStr];
        [attStr addAttribute:NSForegroundColorAttributeName value:COLOR_MAIN range:NSMakeRange(accountStr.length-yueStr.length, yueStr.length)];
        [attStr addAttribute:NSFontAttributeName value:SYSTEMFONT(27) range:NSMakeRange(accountStr.length-yueStr.length+2, yueStr.length-2)];
        self.accountLabel.attributedText = attStr;
    }
    else {
        self.spaceView.hidden = YES;
        self.accountLabel.hidden = YES;
        self.rechargeButton.hidden = YES;
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self prepareData];
        [self setupUI];
    }
    return self;
}

- (void)prepareData {
}

- (void)setupUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat offset = isPad ? 20 : kOFFSET_SIZE;
    [self.contentView addSubview:self.avatorImgView];
    [self.avatorImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kOFFSET_SIZE);
        make.top.equalTo(self.contentView).offset(offset);
        make.width.height.equalTo(@(kAvatorWH));
    }];
    
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(offset);
        make.left.equalTo(self.avatorImgView.mas_right).offset(kOFFSET_SIZE);
        make.width.lessThanOrEqualTo(@(SCREEN_WIDTH-kAvatorWH-2*kOFFSET_SIZE-28-25-2*kOFFSET_SIZE));//不能超过这个距离
        make.height.equalTo(@(25));
    }];
    
    [self.contentView addSubview:self.vipLevelLabel];
    [self.vipLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.left.equalTo(self.nameLabel.mas_right).offset(kOFFSET_SIZE*0.5);
        make.width.equalTo(@28);
        make.height.equalTo(@15);
    }];
    
    [self.contentView addSubview:self.typeLabel];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.left.equalTo(self.vipLevelLabel.mas_right).offset(5);
        make.width.equalTo(@25);
        make.height.equalTo(@15);
    }];

    [self.contentView addSubview:self.codeTitleLabel];
    [self.codeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.avatorImgView);
        make.left.equalTo(self.avatorImgView.mas_right).offset(kOFFSET_SIZE);
    }];
    
    [self.contentView addSubview:self.codeLabel];
    [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.codeTitleLabel);
        make.left.equalTo(self.codeTitleLabel.mas_right).offset(5);
    }];
    
    [self.contentView addSubview:self.progressLabel];
    [self.contentView addSubview:self.progressView];
    [self.contentView addSubview:self.saleCountLabel];
    [self.contentView addSubview:self.levelRuleBtn];
    
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.progressView);
        make.right.equalTo(self.contentView).offset(-kOFFSET_SIZE);
        //        make.left.equalTo(self.progressView.mas_right).offset(5);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeTitleLabel.mas_bottom).offset(offset);
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.progressLabel.mas_left).offset(-10);
        //        make.width.equalTo(@kProgressw);
        make.height.equalTo(@kProgressH);
    }];
    
    [self.saleCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.progressView);
        make.height.equalTo(@kProgressH);
        make.width.equalTo(@kProgressw);
    }];
    
    [self.levelRuleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.codeTitleLabel);
        make.right.equalTo(self.contentView).offset(-kOFFSET_SIZE);
        make.width.equalTo(@80);
        make.height.equalTo(@20);
    }];
    
    [self.contentView addSubview:self.authImgView];
    [self.authImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatorImgView).offset(5);
        make.right.equalTo(self.avatorImgView).offset(-5);
        make.centerY.equalTo(self.progressView);
    }];

    CGFloat spaceH = isPad ? 0.5*kOFFSET_SIZE : 15;
    [self.contentView addSubview:self.spaceView];
    [self.contentView addSubview:self.lineView];
    [self.spaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.progressView.mas_bottom).offset(offset);
        make.height.equalTo(@(spaceH));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.equalTo(@(spaceH));
    }];
    
    [self.contentView addSubview:self.rechargeButton];
    [self.contentView addSubview:self.accountLabel];
    [self.rechargeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-kOFFSET_SIZE);
        make.top.equalTo(self.spaceView.mas_bottom).offset(isPad?offset:offset*0.6);
        make.width.equalTo(@(50));
        make.height.equalTo(@(25));
    }];
    [self.accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kOFFSET_SIZE);
        make.right.equalTo(self.rechargeButton.mas_left);
        make.centerY.equalTo(self.rechargeButton);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(accountClicked)];
    [self.accountLabel setUserInteractionEnabled:YES];
    [self.accountLabel addGestureRecognizer:tap];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
//    if (highlighted) {
//        self.contentView.backgroundColor = RGBCOLOR(0xF4, 0xF4, 0xF4);
//    } else {
//        self.contentView.backgroundColor = WHITE_COLOR;
//    }
}

- (void)levelRuleBtnDidClick:(UIButton *)btn {
    if (self.levelRuleBlock) {
        self.levelRuleBlock(btn);
    }
}

- (IBAction)nameClickedAction:(id)sender {
    if (self.avatarBlock) {
        self.avatarBlock();
    }
}

- (IBAction)rechargeAction:(id)sender {
    if (self.rechargeBlock) {
        self.rechargeBlock();
    }
}

- (void)accountClicked {
    if (self.accountBlock) {
        self.accountBlock();
    }
}

- (void)setAuthened:(BOOL)isAuthed
{
    self.authImgView.image = isAuthed ? IMAGENAMED(@"image_authened") : IMAGENAMED(@"image_unauthened");
}

- (void)setTrackPercent:(CGFloat)trackPercent andSaleCountStr:(NSString *)saleCountStr {
    
    _trackPercent = trackPercent;
    self.progressView.percent = trackPercent;
    CGFloat trackW = self.progressView.width*trackPercent;
    
    _saleCountStr = saleCountStr;
    
    self.saleCountLabel.textColor = WHITE_COLOR;
    self.saleCountLabel.text = saleCountStr;
    CGSize attrSize = [saleCountStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 10)
                                                 options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                              attributes:@{NSFontAttributeName : SYSTEMFONT(8)}
                                                 context:nil].size;
    CGFloat strW = attrSize.width;
    CGFloat leftMargin = (trackW-strW)*0.5;
    if (strW < trackW - 10) {
        [self.saleCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.progressView);
            make.left.equalTo(self.progressView).offset(leftMargin);
            //make.width.equalTo(@(self.trackLength));
            make.width.equalTo(@(trackW));
        }];
        
    } else {
        self.saleCountLabel.textColor = self.progressView.trackTintColor;
        [self.saleCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.progressView);
//            make.left.equalTo(self.progressView).offset(trackW+3);
        }];
    }
}

- (void)setTrackLength:(CGFloat)trackLength andSaleCountStr:(NSString *)saleCountStr {
    
    _trackLength = trackLength;
    self.progressView.progressValue = trackLength;
    
    _saleCountStr = saleCountStr;
    
    self.saleCountLabel.text = saleCountStr;
    CGSize attrSize = [saleCountStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 10)
                                                 options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                              attributes:@{NSFontAttributeName : SYSTEMFONT(8)}
                                                 context:nil].size;
    CGFloat strW = attrSize.width;
    CGFloat leftMargin = (self.trackLength-strW)*0.5;
    if (strW < self.trackLength - 10) {
        [self.saleCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.progressView);
            make.left.equalTo(self.progressView).offset(leftMargin);
            make.width.equalTo(@(self.trackLength));
        }];
        
    } else {
        [self.saleCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.progressView);
//            make.left.equalTo(self.progressView).offset(self.trackLength+3);
        }];
    }
}

- (void)setSaleCountStr:(NSString *)saleCountStr {
    _saleCountStr = saleCountStr;
    
    self.saleCountLabel.text = saleCountStr;
    CGSize attrSize = [saleCountStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 10)
                                                 options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                              attributes:@{NSFontAttributeName : SYSTEMFONT(8)}
                                                 context:nil].size;
    CGFloat strW = attrSize.width;
    CGFloat leftMargin = (self.trackLength-strW)*0.5;
    if (strW <= self.trackLength) {
        [self.saleCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.progressView);
            make.left.equalTo(self.progressView).offset(leftMargin);
            make.width.equalTo(@(self.trackLength));
        }];
        
    } else {
        [self.saleCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.progressView);
            make.left.equalTo(self.progressView).offset(self.trackLength+3);
            //            make.width.equalTo(@(strW));
        }];
    }
}

- (void)setTrackLength:(CGFloat)trackLength {
    _trackLength = trackLength;
    self.progressView.progressValue = trackLength;
}

#pragma mark - LAZY
- (SCImageView *)avatorImgView {
    if (_avatorImgView == nil) {
        _avatorImgView = [[SCImageView alloc]init];
        _avatorImgView.image = [UIImage imageNamed:@"userAvator"];
        
        _avatorImgView.userInteractionEnabled = YES;
        _avatorImgView.clipsToBounds = YES;
        _avatorImgView.layer.cornerRadius = kAvatorWH*0.5f;
        
        @weakify(self)
        _avatorImgView.clickedBlock = ^{
            @strongify(self)
            if (self.avatarBlock) {
                self.avatarBlock();
            }
        };
    }
    return _avatorImgView;
}

- (UIImageView *)authImgView {
    if (_authImgView == nil) {
        _authImgView = [[UIImageView alloc]init];
        _authImgView.contentMode = UIViewContentModeScaleAspectFit;
        _authImgView.image = IMAGENAMED(@"image_unauthened");
    }
    return _authImgView;
}

- (TextButton *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[TextButton alloc]init];
        _nameLabel.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_nameLabel setTitle:@"爱库存会员昵称" forState:UIControlStateNormal];
        [_nameLabel setTitleFont:SYSTEMFONT(17)];
        [_nameLabel setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
        [_nameLabel setTitleColor:COLOR_SELECTED forState:UIControlStateHighlighted];
        [_nameLabel addTarget:self
                          action:@selector(nameClickedAction:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _nameLabel;
}

- (UILabel *)vipLevelLabel {
    if (_vipLevelLabel == nil) {
        _vipLevelLabel = [[UILabel alloc]init];
        _vipLevelLabel.text = @"VIP0";
        _vipLevelLabel.backgroundColor     = COLOR_TEXT_LIGHT;
        _vipLevelLabel.layer.cornerRadius  = 4.0;
        _vipLevelLabel.layer.masksToBounds = YES;
        _vipLevelLabel.textColor = WHITE_COLOR;
        _vipLevelLabel.font      = BOLDSYSTEMFONT(10);
        _vipLevelLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _vipLevelLabel;
}

- (UILabel *)typeLabel {
    if (_typeLabel == nil) {
        _typeLabel = [[UILabel alloc]init];
        _typeLabel.text = @"主";
        _typeLabel.backgroundColor     = CLEAR_COLOR;
        _typeLabel.layer.cornerRadius  = 4.0;
        _typeLabel.layer.masksToBounds = YES;
        _typeLabel.textColor = WHITE_COLOR;
        _typeLabel.font      = BOLDSYSTEMFONT(10);
        _typeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _typeLabel;
}

- (UILabel *)codeTitleLabel {
    if (_codeTitleLabel == nil) {
        _codeTitleLabel = [[UILabel alloc]init];
        _codeTitleLabel.text      = @"代购编号:";
        _codeTitleLabel.textColor = COLOR_TEXT_NORMAL;
        _codeTitleLabel.font      = [FontUtils smallFont];
    }
    return _codeTitleLabel;
}

- (UILabel *)codeLabel {
    if (_codeLabel == nil) {
        _codeLabel = [[UILabel alloc]init];
        _codeLabel.text      = @"--";
        _codeLabel.textColor = COLOR_TEXT_NORMAL;
        _codeLabel.font      = [FontUtils smallFont];
    }
    return _codeLabel;
}

- (DDProgressView *)progressView {
    if (_progressView == nil) {
        _progressView = [[DDProgressView alloc]init];
        _progressView.progressHeight = kProgressH;
    }
    return _progressView;
}

- (UILabel *)saleCountLabel {
    if (_saleCountLabel == nil) {
        _saleCountLabel = [[UILabel alloc]init];
        _saleCountLabel.textColor = [UIColor whiteColor];
        _saleCountLabel.font = BOLDSYSTEMFONT(8);
    }
    return _saleCountLabel;
}

- (UILabel *)progressLabel {
    if (_progressLabel == nil) {
        _progressLabel = [[UILabel alloc]init];
        _progressLabel.textColor = COLOR_TEXT_NORMAL;
        _progressLabel.font = BOLDSYSTEMFONT(9);
    }
    return _progressLabel;
}

- (UILabel *)accountLabel {
    if (_accountLabel == nil) {
        _accountLabel = [[UILabel alloc]init];
        _accountLabel.textColor = COLOR_TEXT_NORMAL;
        _accountLabel.font = BOLDSYSTEMFONT(13);
        _accountLabel.text = @"账户余额：";
    }
    return _accountLabel;
}

- (UIButton *)rechargeButton {
    if (_rechargeButton) {
        return _rechargeButton;
    }
    _rechargeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rechargeButton.frame = CGRectMake(0, 0, 60, 22);
    _rechargeButton.backgroundColor = COLOR_MAIN;
    _rechargeButton.layer.masksToBounds = NO;
    _rechargeButton.layer.cornerRadius = 3.0f;
    _rechargeButton.layer.borderWidth = 0.5f;
    _rechargeButton.layer.borderColor = COLOR_SELECTED.CGColor;
    
    _rechargeButton.titleLabel.font = BOLDSYSTEMFONT(13);
    [_rechargeButton setNormalTitle:@"充 值"];
    [_rechargeButton setNormalColor:WHITE_COLOR highlighted:COLOR_TEXT_LIGHT selected:nil];
    
    [_rechargeButton addTarget:self action:@selector(rechargeAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
    return _rechargeButton;
}

- (TextButton *)levelRuleBtn {
    if (_levelRuleBtn == nil) {
        _levelRuleBtn = [[TextButton alloc]init];
        [_levelRuleBtn setTitleAlignment:NSTextAlignmentRight];
        [_levelRuleBtn setTitle:@"等级规则>" forState:UIControlStateNormal];
        _levelRuleBtn.titleLabel.font = BOLDSYSTEMFONT(12);
        [_levelRuleBtn setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
        [_levelRuleBtn setTitleColor:COLOR_SELECTED forState:UIControlStateHighlighted];
        [_levelRuleBtn addTarget:self
                          action:@selector(levelRuleBtnDidClick:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _levelRuleBtn;
}

- (UIView *)spaceView {
    if (_spaceView == nil) {
        _spaceView = [[UIView alloc]init];
        _spaceView.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    }
    return _spaceView;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    }
    return _lineView;
}

@end





