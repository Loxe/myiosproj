//
//  BuyerRewardDetailCell.m
//  akucun
//
//  Created by deepin do on 2018/1/17.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#define kAvatorWH     30

#import "BuyerRewardDetailCell.h"
#import "UIImageView+WebCache.h"
#import "UIView+DDExtension.h"

@implementation BuyerRewardDetailCell

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
        make.width.height.equalTo(@30);
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
    }];
    
    [self.contentView addSubview:self.teamCountLabel];
    [self.teamCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-kOFFSET_SIZE);
        make.top.equalTo(self.personCountLabel.mas_bottom).offset(0.5*kOFFSET_SIZE);
    }];
    
    [self.contentView addSubview:self.separateLine];
    [self.separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kOFFSET_SIZE);
        make.right.bottom.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
}

- (void)setModel:(InviteDetail *)model {
    
    [self.avatorImgView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    self.nameLabel.text = model.nick;
    
    NSNumber *personNum = [NSNumber numberWithInteger:model.daigoufzh*model.daigoufjl];
    NSNumber *teamNum   = [NSNumber numberWithInteger:model.jianjiedaigouf*model.jianjiedagoufjl];
    
    NSString *personStr     = [self.contentView getPriceStringNoComma:personNum];
    NSString *personFullStr = [NSString stringWithFormat:@"个人贡献: %@",personStr];
//    NSMutableAttributedString *personAttrText = [[NSMutableAttributedString alloc] initWithString:personStr];
    NSMutableAttributedString *personAttrText = [[NSMutableAttributedString alloc] initWithString:personFullStr];
    [personAttrText addAttribute:NSFontAttributeName value:[FontUtils smallFont] range:NSMakeRange(0, 6)];
    [personAttrText addAttribute:NSForegroundColorAttributeName value:COLOR_TEXT_LIGHT range:NSMakeRange(0, 6)];
    [personAttrText addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(14) range:NSMakeRange(7, 2)];
    self.personCountLabel.attributedText = personAttrText;
    
    NSString *teamStr     = [self.contentView getPriceStringNoComma:teamNum];
    NSString *teamFullStr = [NSString stringWithFormat:@"团队贡献: %@",teamStr];
//    NSMutableAttributedString *teamAttrText = [[NSMutableAttributedString alloc] initWithString:teamStr];
    NSMutableAttributedString *teamAttrText = [[NSMutableAttributedString alloc] initWithString:teamFullStr];
    [teamAttrText addAttribute:NSFontAttributeName value:[FontUtils smallFont] range:NSMakeRange(0, 6)];
    [teamAttrText addAttribute:NSForegroundColorAttributeName value:COLOR_TEXT_LIGHT range:NSMakeRange(0, 6)];
    [teamAttrText addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(14) range:NSMakeRange(7, 2)];
    self.teamCountLabel.attributedText = teamAttrText;
    
    
    
    CGSize personAttrSize = [self.personCountLabel.attributedText boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30)
                                                                       options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                                       context:nil].size;
    CGSize teamAttrSize  = [self.teamCountLabel.attributedText boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30)
                                                                               options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                                               context:nil].size;
    if (personAttrSize.width >= teamAttrSize.width) {
        [self.personCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-kOFFSET_SIZE);
            make.top.equalTo(self.contentView).offset(kOFFSET_SIZE);
        }];
        
        [self.teamCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-kOFFSET_SIZE);
            make.top.equalTo(self.personCountLabel.mas_bottom).offset(0.5*kOFFSET_SIZE);
            make.left.equalTo(self.personCountLabel.mas_left);
        }];

    } else {
        [self.personCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-kOFFSET_SIZE);
            make.top.equalTo(self.contentView).offset(kOFFSET_SIZE);
            make.left.equalTo(self.teamCountLabel.mas_left);
        }];
        
        [self.teamCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-kOFFSET_SIZE);
            make.top.equalTo(self.personCountLabel.mas_bottom).offset(0.5*kOFFSET_SIZE);
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
        _personCountLabel.font      = [FontUtils normalFont];
        _personCountLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _personCountLabel;
}

- (UILabel *)teamCountLabel {
    if (_teamCountLabel == nil) {
        _teamCountLabel = [[UILabel alloc]init];
        _teamCountLabel.text      = @"";
        _teamCountLabel.textColor = COLOR_MAIN;
        _teamCountLabel.font      = [FontUtils normalFont];
        _teamCountLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _teamCountLabel;
}

- (UIView *)separateLine {
    if (_separateLine == nil) {
        _separateLine = [[UIView alloc]init];
        _separateLine.backgroundColor = COLOR_TEXT_LIGHT;
    }
    return _separateLine;
}


@end
