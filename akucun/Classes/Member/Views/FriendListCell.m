//
//  FriendListCell.m
//  akucun
//
//  Created by deepin do on 2018/2/27.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "FriendListCell.h"
#import "UIImageView+WebCache.h"
#import "UserManager.h"

@implementation FriendListCell

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
    
    [self.contentView addSubview:self.avatorImgView];
    [self.avatorImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(kOFFSET_SIZE);
        make.left.equalTo(self.contentView).offset(kOFFSET_SIZE-5.0f);
        make.width.height.equalTo(@kAvatorWH);
    }];
    
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatorImgView.mas_right).offset(0.5*kOFFSET_SIZE);
        make.centerY.equalTo(self.avatorImgView);
        make.width.equalTo(@(kNameItemW-kAvatorWH));
    }];
    
    [self.contentView addSubview:self.levelLabel];
    [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.avatorImgView);
        make.width.equalTo(@(kLevelItemW));
        make.left.equalTo(self.contentView).offset(kOFFSET_SIZE+kNameItemW+kMargin);
    }];
    
    [self.contentView addSubview:self.livenessProgress];
    [self.livenessProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.avatorImgView);
        make.right.equalTo(self.contentView).offset(-kOFFSET_SIZE);
        make.width.equalTo(@(kProgresItemW));
        make.height.equalTo(@(kLiveProgressH));
    }];
    
    [self.contentView addSubview:self.livenessLabel];
    [self.livenessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.livenessProgress);
        make.width.equalTo(@(kProgresItemW));
        make.height.equalTo(@(kLiveProgressH));
    }];
    
    [self.contentView addSubview:self.separateLine];
    [self.separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kOFFSET_SIZE);
        make.right.bottom.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
    
    [self.contentView addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.livenessProgress);
        make.width.equalTo(@(60));
        make.height.equalTo(@(15));
    }];
}

- (void)setModel:(Member *)model {
    if (model.avatar && model.avatar.length > 0) {
        [self.avatorImgView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    } else {
        [self.avatorImgView setImage:IMAGENAMED(@"userAvator")];
    }
    
    self.nameLabel.text  = model.username;
    self.levelLabel.text = FORMAT(@"VIP%ld", (long)model.memberLevel);
    
    VIPMemberTarget *target = [UserManager targetByLevel:model.memberLevel];
    if (model.memberLevel == 0) {
        self.livenessProgress.trackTintColor = LIGHTGRAY_COLOR;
        self.levelLabel.textColor = LIGHTGRAY_COLOR;
    }
    else if (model.monthsTotal < target.minsale) {
        // 保级
        self.livenessProgress.trackTintColor = COLOR_BG_TRACK;
        self.levelLabel.textColor = COLOR_BG_TRACK;
    }
    else {
        // 升级
        self.livenessProgress.trackTintColor = COLOR_MAIN;
        self.levelLabel.textColor = COLOR_MAIN;
    }

    if (self.usershadow) {
        CGFloat percent = [UserManager getSalesPercent:model.memberLevel sales:model.monthsTotal];
        NSString *text = [NSString amountCommaString:model.monthsTotal];
        [self setTrackLength:kProgresItemW*percent andLivenessStr:text];
    }
    else {
        CGFloat percent = [UserManager getSalesPercent:model.memberLevel sales:model.monthsTotal];
        NSString *text = FORMAT(@"%.0f%%", percent*100.0f);
        [self setTrackLength:kProgresItemW*percent andLivenessStr:text];
    }
}

- (void)setUsershadow:(BOOL)usershadow
{
    _usershadow = usershadow;
    
    if (usershadow) {
        self.statusLabel.hidden = YES;
        self.livenessProgress.hidden = NO;
        self.livenessLabel.hidden = NO;
    }
    else {
        self.statusLabel.hidden = NO;
        self.livenessProgress.hidden = YES;
        self.livenessLabel.hidden = YES;
    }
}

- (void)setLivenessStr:(NSString *)livenessStr {
    _livenessStr = livenessStr;
    
    self.livenessLabel.text = livenessStr;
    CGSize attrSize = [livenessStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 10)
                                                 options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                              attributes:@{NSFontAttributeName : SYSTEMFONT(8)}
                                                 context:nil].size;
    CGFloat strW = attrSize.width;
    CGFloat leftMargin = (self.trackLength-strW)*0.5;
    if (strW <= self.trackLength) {
        [self.livenessLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.livenessProgress);
            make.left.equalTo(self.livenessProgress).offset(leftMargin);
            make.width.equalTo(@(self.trackLength));
        }];
        
    } else {
        [self.livenessLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.livenessProgress);
            make.left.equalTo(self.livenessProgress).offset(self.trackLength);
        }];
    }
}

- (void)setTrackLength:(CGFloat)trackLength {
    _trackLength = trackLength;
    self.livenessProgress.progressValue = trackLength;
}

- (void)setTrackLength:(CGFloat)trackLength andLivenessStr:(NSString *)livenessStr {
    
    _trackLength = trackLength;
    self.livenessProgress.progressValue = trackLength;
    
    self.livenessLabel.textColor = WHITE_COLOR;
    self.livenessLabel.text = livenessStr;
    CGSize attrSize = [livenessStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 10)
                                                options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                             attributes:@{NSFontAttributeName : SYSTEMFONT(8)}
                                                context:nil].size;
    CGFloat strW = attrSize.width;
    CGFloat leftMargin = (self.trackLength-strW)*0.5;
    if (strW < self.trackLength-20) {
        [self.livenessLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.livenessProgress);
            make.left.equalTo(self.livenessProgress).offset(leftMargin);
            make.width.equalTo(@(self.trackLength));
        }];
        
    } else {
        self.livenessLabel.textColor = self.levelLabel.textColor;
        [self.livenessLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.livenessProgress);
        }];
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

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = COLOR_TEXT_NORMAL;
        _nameLabel.font      = [FontUtils normalFont];
        _nameLabel.numberOfLines = 0;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (UILabel *)levelLabel {
    if (_levelLabel == nil) {
        _levelLabel = [[UILabel alloc]init];
        _levelLabel.textAlignment = NSTextAlignmentCenter;
        _levelLabel.textColor = COLOR_MAIN;
        _levelLabel.font      = [UIFont boldSystemFontOfSize:14];
    }
    return _levelLabel;
}

- (DDProgressView *)livenessProgress {
    if (_livenessProgress == nil) {
        _livenessProgress = [[DDProgressView alloc]init];
        _livenessProgress.progressHeight = kLiveProgressH;
    }
    return _livenessProgress;
}

- (UILabel *)livenessLabel {
    if (_livenessLabel == nil) {
        _livenessLabel = [[UILabel alloc]init];
        _livenessLabel.textColor = [UIColor whiteColor];
        _livenessLabel.font = BOLDSYSTEMFONT(8);
    }
    return _livenessLabel;
}

- (UIView *)separateLine {
    if (_separateLine == nil) {
        _separateLine = [[UIView alloc]init];
        _separateLine.backgroundColor = COLOR_SEPERATOR_LIGHT;
    }
    return _separateLine;
}

- (UILabel *) statusLabel
{
    if (_statusLabel == nil) {
        _statusLabel = [[UILabel alloc]init];
        _statusLabel.text = @"关联审核中";
        _statusLabel.backgroundColor     = COLOR_MAIN;
        _statusLabel.layer.cornerRadius  = 4.0;
        _statusLabel.layer.masksToBounds = YES;
        _statusLabel.textColor = WHITE_COLOR;
        _statusLabel.font      = BOLDSYSTEMFONT(10);
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.hidden = YES;
    }
    return _statusLabel;
}

@end
