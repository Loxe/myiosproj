//
//  FriendSectionHeader.m
//  akucun
//
//  Created by deepin do on 2018/2/27.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "FriendSectionHeader.h"

@implementation FriendSectionHeader

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
    
    CGFloat offset = kOFFSET_SIZE;

    /** 参照view */
    UIView *topV    = [[UIView alloc]init];
    UIView *bottomV = [[UIView alloc]init];
    [self addSubview:topV];
    [self addSubview:bottomV];
    
    [topV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@(kTopH));
    }];
    
    [bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.equalTo(@(kBottomH));
    }];
    
    /** 子控件 */
    
//    [self addSubview:self.invitedTotalCount];
//    [self.invitedTotalCount mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(offset);
//        make.width.equalTo(@(kInviteW));
//        make.centerY.equalTo(topV);
//    }];
//
//    [self addSubview:self.vip0Count];
//    [self.vip0Count mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.invitedTotalCount.mas_right).offset(kRowMargin);
//        make.width.equalTo(@(kVip0W));
//        make.centerY.equalTo(topV);
//    }];
//
//    [self addSubview:self.lostCount];
//    [self.lostCount mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self).offset(-offset);
//        make.width.equalTo(@(kLostW));
//        make.centerY.equalTo(topV);
//    }];

    [self addSubview:self.invitedTotalLabel];
    [self.invitedTotalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(offset);
        make.width.equalTo(@(kInviteW));
        make.top.equalTo(topV).offset(10);
    }];
    
    [self addSubview:self.invitedTotalCount];
    [self.invitedTotalCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.invitedTotalLabel.mas_bottom).offset(5);
        make.centerX.equalTo(self.invitedTotalLabel).offset(-25);
//        make.left.equalTo(self.invitedTotalLabel);
    }];
    
    [self addSubview:self.vip0Label];
    [self.vip0Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.invitedTotalLabel.mas_right).offset(kRowMargin);
        make.width.equalTo(@(kVip0W));
        make.top.equalTo(topV).offset(10);
    }];
    
    [self addSubview:self.vip0Count];
    [self.vip0Count mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.vip0Label.mas_bottom).offset(5);
        make.centerX.equalTo(self.vip0Label);
    }];

    [self addSubview:self.lostLabel];
    [self.lostLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-offset);
        make.width.equalTo(@(kLostW));
        make.top.equalTo(topV).offset(10);
    }];

    [self addSubview:self.lostCount];
    [self.lostCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lostLabel.mas_bottom).offset(5);
        make.centerX.equalTo(self.lostLabel);
    }];
    
    [self addSubview:self.separateLine];
    [self.separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(kTopH);
        make.height.equalTo(@kPIXEL_WIDTH);
    }];
    
    [self addSubview:self.friendLabel];
    [self.friendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomV).offset(offset);
        make.centerY.equalTo(bottomV);
        make.width.equalTo(@(kInviteW));
    }];
    
    [self addSubview:self.levelLabel];
    [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.friendLabel.mas_right);
        make.centerY.equalTo(bottomV);
        make.width.equalTo(@(kVip0W+kRowMargin));
    }];
    
    [self addSubview:self.livenessLabel];
    [self.livenessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-offset);
        make.centerY.equalTo(bottomV);
        make.width.equalTo(@(kLostW));
    }];
    
    [self addSubview:self.bottomLine];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@kPIXEL_WIDTH);
    }];
}

- (void)setInvitedCount:(NSInteger)invitedCount activeCount:(NSInteger)activeCount andLostCount:(NSInteger)lostCount {
    
    NSString *invitedCountStr = FORMAT(@"%ld", (long)invitedCount);
    NSString *vip0CountStr = FORMAT(@"%ld", (long)activeCount);
    NSString *lostCountStr = FORMAT(@"%ld", (long)(invitedCount-activeCount));
    
    self.invitedTotalCount.text = invitedCountStr;
    self.vip0Count.text = vip0CountStr;
    self.lostCount.text = lostCountStr;
}

- (IBAction) levelAction:(id)sender
{
    self.vipFlag ++;
    if (self.vipFlag > 2) {
        self.vipFlag = 1;
    }
    
//    [_levelLabel setNormalTitle:(self.vipFlag == 1) ? @"当前VIP等级 ▼" : @"当前VIP等级 ▲"];
    [self.levelLabel setNormalImage:(self.vipFlag == 1) ? @"icon_arrow_down" : @"icon_arrow_up" selectedImage:nil];
    
    if (self.actionBlock) {
        self.actionBlock((int)self.vipFlag);
    }
}

/** 富文本方式 */
//- (void)setInvitedCount:(NSInteger)invitedCount VIP0Count:(NSInteger)vip0Count andLostCount:(NSInteger)lostCount {
//
//    // 累积邀请人数
//    NSString *invitedPrefixStr = @"累积邀请人数:";
//    NSString *invitedCountStr = FORMAT(@"%ld",invitedCount);
//    NSMutableAttributedString *invitedAttStr = [[NSMutableAttributedString alloc]initWithString:FORMAT(@"%@%@",invitedPrefixStr,invitedCountStr)];
//    [invitedAttStr addAttribute:NSForegroundColorAttributeName
//                   value:COLOR_TEXT_NORMAL
//                   range:NSMakeRange(0, invitedAttStr.length)];
//    [invitedAttStr addAttribute:NSFontAttributeName
//                   value:SYSTEMFONT(13)
//                   range:NSMakeRange(0, invitedAttStr.length)];
//    [invitedAttStr addAttribute:NSForegroundColorAttributeName
//                   value:COLOR_MAIN
//                   range:NSMakeRange(invitedPrefixStr.length, invitedCountStr.length)];
//    [invitedAttStr addAttribute:NSFontAttributeName
//                   value:SYSTEMFONT(13)
//                   range:NSMakeRange(invitedPrefixStr.length, invitedCountStr.length)];
//    self.invitedTotalCount.attributedText = invitedAttStr;
//
//    // 累积邀请人数
//    NSString *vip0PrefixStr = @"VIP0人数:";
//    NSString *vip0CountStr = FORMAT(@"%ld",vip0Count);
//    NSMutableAttributedString *vip0AttStr = [[NSMutableAttributedString alloc]initWithString:FORMAT(@"%@%@",vip0PrefixStr,vip0CountStr)];
//    [vip0AttStr addAttribute:NSForegroundColorAttributeName
//                          value:COLOR_TEXT_NORMAL
//                          range:NSMakeRange(0, vip0AttStr.length)];
//    [vip0AttStr addAttribute:NSFontAttributeName
//                          value:SYSTEMFONT(13)
//                          range:NSMakeRange(0, vip0AttStr.length)];
//    [vip0AttStr addAttribute:NSForegroundColorAttributeName
//                          value:COLOR_MAIN
//                          range:NSMakeRange(vip0PrefixStr.length, vip0CountStr.length)];
//    [vip0AttStr addAttribute:NSFontAttributeName
//                          value:SYSTEMFONT(13)
//                          range:NSMakeRange(vip0PrefixStr.length, vip0CountStr.length)];
//    self.vip0Count.attributedText = vip0AttStr;
//
//    // 累积邀请人数
//    NSString *lostPrefixStr = @"流失人数:";
//    NSString *lostCountStr = FORMAT(@"%ld",lostCount);
//    NSMutableAttributedString *lostAttStr = [[NSMutableAttributedString alloc]initWithString:FORMAT(@"%@%@",lostPrefixStr,lostCountStr)];
//    [lostAttStr addAttribute:NSForegroundColorAttributeName
//                          value:COLOR_TEXT_NORMAL
//                          range:NSMakeRange(0, lostAttStr.length)];
//    [lostAttStr addAttribute:NSFontAttributeName
//                          value:SYSTEMFONT(13)
//                          range:NSMakeRange(0, lostAttStr.length)];
//    [lostAttStr addAttribute:NSForegroundColorAttributeName
//                          value:COLOR_MAIN
//                          range:NSMakeRange(lostPrefixStr.length, lostCountStr.length)];
//    [lostAttStr addAttribute:NSFontAttributeName
//                          value:SYSTEMFONT(13)
//                          range:NSMakeRange(lostPrefixStr.length, lostCountStr.length)];
//    self.lostCount.attributedText = lostAttStr;
//}

#pragma mark - lazy
- (UILabel *)invitedTotalLabel {
    if (_invitedTotalLabel == nil) {
        _invitedTotalLabel = [[UILabel alloc]init];
        _invitedTotalLabel.textColor = COLOR_TEXT_NORMAL;
        _invitedTotalLabel.font      = BOLDSYSTEMFONT(13);
        _invitedTotalLabel.text = @"累计邀请人数";
//        _invitedTotalLabel.numberOfLines = 0;
    }
    return _invitedTotalLabel;
}

- (UILabel *)invitedTotalCount {
    if (_invitedTotalCount == nil) {
        _invitedTotalCount = [[UILabel alloc]init];
        _invitedTotalCount.textColor = COLOR_MAIN;
        _invitedTotalCount.font      = BOLDSYSTEMFONT(15);
        _invitedTotalCount.textAlignment = NSTextAlignmentLeft;
        _invitedTotalCount.text = @"--";
    }
    return _invitedTotalCount;
}

- (UILabel *)vip0Label {
    if (_vip0Label == nil) {
        _vip0Label = [[UILabel alloc]init];
        _vip0Label.textColor = COLOR_TEXT_NORMAL;
        _vip0Label.font      = BOLDSYSTEMFONT(13);
        _vip0Label.text      = @"活跃人数";
//        _vip0Label.numberOfLines = 0;
        _vip0Label.textAlignment = NSTextAlignmentCenter;
    }
    return _vip0Label;
}

- (UILabel *)vip0Count {
    if (_vip0Count == nil) {
        _vip0Count = [[UILabel alloc]init];
        _vip0Count.textColor = COLOR_MAIN;
        _vip0Count.font      = BOLDSYSTEMFONT(15);
        _vip0Count.textAlignment = NSTextAlignmentCenter;
        _vip0Count.text = @"--";
    }
    return _vip0Count;
}

- (UILabel *)lostLabel {
    if (_lostLabel == nil) {
        _lostLabel = [[UILabel alloc]init];
        _lostLabel.textColor = COLOR_TEXT_NORMAL;
        _lostLabel.font      = BOLDSYSTEMFONT(13);
        _lostLabel.text      = @"不活跃人数";
//        _lostLabel.numberOfLines = 0;
        _lostLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _lostLabel;
}

- (UILabel *)lostCount {
    if (_lostCount == nil) {
        _lostCount = [[UILabel alloc]init];
        _lostCount.textColor = COLOR_MAIN;
        _lostCount.font      = BOLDSYSTEMFONT(15);
        _lostCount.textAlignment = NSTextAlignmentCenter;
        _lostCount.text = @"--";
    }
    return _lostCount;
}

- (UIView *)separateLine {
    if (_separateLine == nil) {
        _separateLine = [[UIView alloc]init];
        _separateLine.backgroundColor = COLOR_SEPERATOR_LIGHT;
    }
    return _separateLine;
}

- (UILabel *)friendLabel {
    if (_friendLabel == nil) {
        _friendLabel = [[UILabel alloc]init];
        _friendLabel.textColor = COLOR_TEXT_NORMAL;
        _friendLabel.font      = BOLDSYSTEMFONT(13);
        _friendLabel.text      = @"我的好友";
        _friendLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _friendLabel;
}

- (UIButton *)levelLabel {
    if (_levelLabel == nil) {
        _levelLabel = [[UIButton alloc]init];
        
        _levelLabel.titleLabel.font = BOLDSYSTEMFONT(13);
        [_levelLabel setNormalColor:COLOR_TEXT_NORMAL highlighted:COLOR_SELECTED selected:nil];
        
        NSString *text = @"当前VIP等级";
        [_levelLabel setNormalTitle:text];
        
        CGSize size = [text sizeWithMaxWidth:300 andFont:BOLDSYSTEMFONT(13)];
        CGFloat offset = (kVip0W + size.width) * 0.5+6;
        
        [_levelLabel setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        [_levelLabel setImageEdgeInsets:UIEdgeInsetsMake(0, offset, 0, 0)];
        [_levelLabel setNormalImage:@"icon_arrow_t" selectedImage:nil];
        
        [_levelLabel addTarget:self action:@selector(levelAction:) forControlEvents:UIControlEventTouchUpInside];

//        _levelLabel.textColor = COLOR_TEXT_NORMAL;
//        _levelLabel.font      = BOLDSYSTEMFONT(13);
//        _levelLabel.text      = @"当前VIP等级";
//        _levelLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _levelLabel;
}

- (UILabel *)livenessLabel {
    if (_livenessLabel == nil) {
        _livenessLabel = [[UILabel alloc]init];
        _livenessLabel.textColor = COLOR_TEXT_NORMAL;
        _livenessLabel.font      = BOLDSYSTEMFONT(13);
        _livenessLabel.text      = @"活跃度";
        _livenessLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _livenessLabel;
}

- (UIView *)bottomLine {
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc]init];
        _bottomLine.backgroundColor = COLOR_SEPERATOR_LIGHT;
    }
    return _bottomLine;
}

@end
