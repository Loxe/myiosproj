//
//  InviteCodeCell.m
//  akucun
//
//  Created by deepin do on 2018/2/26.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "InviteCodeCell.h"
#import "UIImageView+WebCache.h"

@implementation InviteCodeCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.backgroundColor = CLEAR_COLOR;
    self.contentView.backgroundColor = CLEAR_COLOR;
    
    [self.contentView addSubview:self.BGView];
    [self.BGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(kOFFSET_SIZE);
        make.right.equalTo(self.contentView).offset(-kOFFSET_SIZE);
        make.bottom.equalTo(self.contentView).offset(-0.5*kOFFSET_SIZE);
    }];
    
    [self.contentView addSubview:self.avatorImgView];
    [self.avatorImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.BGView).offset(kOFFSET_SIZE);
        make.centerY.equalTo(self.BGView);
        make.width.height.equalTo(@kAvatorWH);
    }];
    
    [self.contentView addSubview:self.actionLabel];
    [self.actionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatorImgView.mas_right).offset(0.5*kOFFSET_SIZE);
        make.centerY.equalTo(self.BGView).offset(-15);
    }];
    
    [self.contentView addSubview:self.codeLabel];
    [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatorImgView.mas_right).offset(0.5*kOFFSET_SIZE);
//        make.centerY.equalTo(self.BGView);
        make.bottom.equalTo(self.BGView).offset(-kOFFSET_SIZE);
    }];
    
    [self.contentView addSubview:self.shareBtn];
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.BGView).offset(-kOFFSET_SIZE);
        make.centerY.equalTo(self.BGView);
        make.width.equalTo(@70);
        make.height.equalTo(@30);
    }];
}

- (void) setRefCode:(RefCode *)refCode
{
    _refCode = refCode;
    
    // 头像
    UserInfo *userInfo = [UserManager instance].userInfo;
    NSString *avatorStr = userInfo.avatar;
    if (avatorStr && avatorStr.length > 0) {
        [self.avatorImgView sd_setImageWithURL:[NSURL URLWithString:avatorStr]];
    } else {
        self.avatorImgView.image = [UIImage imageNamed:@"userAvator"];
    }
    
    self.codeLabel.text = FORMAT(@"邀请码: %@", refCode.referralcode);
    
    if (refCode.status == 1) {
        self.codeLabel.textColor = COLOR_TEXT_NORMAL;
        self.actionLabel.textColor = COLOR_APP_GREEN;
        self.shareBtn.backgroundColor = COLOR_APP_GREEN;
        [self.shareBtn setNormalColor:WHITE_COLOR];
        [self.shareBtn setTitle:@"已邀请" forState:UIControlStateNormal];
        [self.shareBtn setEnabled:YES];
        self.actionLabel.text = @"已邀请";
    }
    else if (refCode.status == 2) {
        self.codeLabel.textColor = COLOR_TEXT_LIGHT;
        self.actionLabel.textColor = COLOR_TEXT_LIGHT;
        [self.shareBtn setNormalColor:COLOR_TEXT_NORMAL];
        self.shareBtn.backgroundColor = RGBCOLOR(204, 204, 204);
        [self.shareBtn setTitle:@"已使用" forState:UIControlStateNormal];
        [self.shareBtn setEnabled:NO];
        self.actionLabel.text = @"已使用";
    }
    else {
        self.codeLabel.textColor = COLOR_MAIN;
        self.shareBtn.backgroundColor = COLOR_MAIN;
        [self.shareBtn setNormalColor:WHITE_COLOR];
        [self.shareBtn setTitle:@"去邀请" forState:UIControlStateNormal];
        [self.shareBtn setEnabled:YES];
        self.actionLabel.text = @"";
    }
    
    if (refCode.status > 0) {
        [self.codeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatorImgView.mas_right).offset(0.5*kOFFSET_SIZE);
            make.centerY.equalTo(self.BGView).offset(5);
        }];
    }
    else {
        [self.codeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatorImgView.mas_right).offset(0.5*kOFFSET_SIZE);
            make.centerY.equalTo(self.BGView);
        }];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)shareBtnDidClick:(UIButton *)btn {
    if (self.shareBlock) {
        self.shareBlock(btn);
    }
}

#pragma mark - LAZY
- (UIImageView *)avatorImgView {
    if (_avatorImgView == nil) {
        _avatorImgView = [[UIImageView alloc]init];
        _avatorImgView.image = [UIImage imageNamed:@"userAvator"];
        _avatorImgView.clipsToBounds = YES;
        _avatorImgView.layer.cornerRadius = kAvatorWH*0.5f;
    }
    return _avatorImgView;
}

-  (UILabel *)actionLabel {
    if (_actionLabel == nil) {
        _actionLabel = [[UILabel alloc]init];
        _actionLabel.text      = @"";
        _actionLabel.textColor = [UIColor whiteColor];
        _actionLabel.font      = SYSTEMFONT(10);
    }
    return _actionLabel;
}

- (UILabel *)codeLabel {
    if (_codeLabel == nil) {
        _codeLabel = [[UILabel alloc]init];
        _codeLabel.text      = @"";
        _codeLabel.textColor = [UIColor whiteColor];
        _codeLabel.font      = BOLDSYSTEMFONT(15);
    }
    return _codeLabel;
}

- (UIButton *)shareBtn {
    if (_shareBtn == nil) {
        _shareBtn = [[UIButton alloc]init];
        _shareBtn.titleLabel.font = BOLDSYSTEMFONT(12);
        [_shareBtn setTitle:@"点击分享" forState:UIControlStateNormal];
        [_shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(shareBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        _shareBtn.backgroundColor = RGBCOLOR(247, 205, 70);
        _shareBtn.layer.cornerRadius = 15;
        _shareBtn.layer.masksToBounds = YES;
    }
    return _shareBtn;
}

- (UIView *)BGView {
    if (_BGView == nil) {
        _BGView = [[UIView alloc]init];
        _BGView.backgroundColor = WHITE_COLOR;
        _BGView.layer.cornerRadius  = 5.f;
        _BGView.layer.masksToBounds = YES;
        _BGView.layer.borderColor = COLOR_SEPERATOR_LIGHT.CGColor;
        _BGView.layer.borderWidth = 1.0f;
        _BGView.layer.shadowRadius  = 5.0f;
        _BGView.layer.shadowOpacity = 0.5f;
        _BGView.layer.shadowColor   = [[UIColor blackColor] CGColor];
        _BGView.layer.shadowPath    = [[UIBezierPath bezierPathWithRect:_BGView.bounds] CGPath];
    }
    return _BGView;
}

@end
