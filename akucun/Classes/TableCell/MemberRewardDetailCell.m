//
//  MemberRewardDetailCell.m
//  akucun
//
//  Created by deepin do on 2018/1/17.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#define kAvatorWH     30

#import "MemberRewardDetailCell.h"
#import "UIView+DDExtension.h"
#import "UIImageView+WebCache.h"

@implementation MemberRewardDetailCell

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
        make.left.top.equalTo(self.contentView).offset(kOFFSET_SIZE);
        make.width.height.equalTo(@kAvatorWH);
    }];
    
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatorImgView.mas_right).offset(0.5*kOFFSET_SIZE);
        make.centerY.equalTo(self.avatorImgView);
        make.height.equalTo(@20);
    }];
    
    [self.contentView addSubview:self.personCountLabel];
    [self.personCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-kOFFSET_SIZE);
        make.top.equalTo(self.contentView).offset(kOFFSET_SIZE);
//        make.height.equalTo(@30);
    }];
    
    [self.contentView addSubview:self.forwardLabel];
    [self.forwardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kOFFSET_SIZE);
//        make.height.equalTo(@20);
    }];
    
    [self.contentView addSubview:self.forwardCountLabel];
    [self.forwardCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.forwardLabel.mas_right);
        make.centerY.equalTo(self.forwardLabel);
//        make.height.equalTo(@20);
    }];
    
    [self.contentView addSubview:self.separateLine];
    [self.separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kOFFSET_SIZE);
        make.right.bottom.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
}

- (void)setModel:(TeamMember *)model {
    if (model.avatar && model.avatar.length > 0) {
        [self.avatorImgView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    } else {
        [self.avatorImgView setImage:IMAGENAMED(@"userAvator")];
    }
    
    self.nameLabel.text         = model.nick;
    self.forwardCountLabel.text = [NSString stringWithFormat:@"%ld",(long)model.forwardCount];
    
    NSNumber *monthNum  = [NSNumber numberWithInteger:model.monthsTotal];
    NSString *priceStr = [self.contentView getPriceString:monthNum];
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [attrText addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(14) range:NSMakeRange(0, 2)];
    self.personCountLabel.attributedText = attrText;
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
        _nameLabel.text      = @"";
        _nameLabel.textColor = COLOR_TEXT_NORMAL;
        _nameLabel.font      = [FontUtils normalFont];
    }
    return _nameLabel;
}

- (UILabel *)personCountLabel {
    if (_personCountLabel == nil) {
        _personCountLabel = [[UILabel alloc]init];
        _personCountLabel.text      = @"";
        _personCountLabel.textColor = COLOR_MAIN;
        _personCountLabel.font      = [FontUtils bigFont];
    }
    return _personCountLabel;
}

- (UILabel *)forwardLabel {
    if (_forwardLabel == nil) {
        _forwardLabel = [[UILabel alloc]init];
        _forwardLabel.text      = @"转发数: ";
        _forwardLabel.textColor = COLOR_TEXT_LIGHT;
        _forwardLabel.font      = [FontUtils smallFont];
        _forwardLabel.hidden = YES;
    }
    return _forwardLabel;
}

- (UILabel *)forwardCountLabel {
    if (_forwardCountLabel == nil) {
        _forwardCountLabel = [[UILabel alloc]init];
        _forwardCountLabel.text      = @"";
        _forwardCountLabel.textColor = COLOR_TEXT_LIGHT;
        _forwardCountLabel.font      = [FontUtils smallFont];
        _forwardCountLabel.hidden = YES;
    }
    return _forwardCountLabel;
}

- (UIView *)separateLine {
    if (_separateLine == nil) {
        _separateLine = [[UIView alloc]init];
        _separateLine.backgroundColor = COLOR_SEPERATOR_LIGHT;
    }
    return _separateLine;
}

@end
