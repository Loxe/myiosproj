//
//  RewardDetailBaseCell.m
//  akucun
//
//  Created by deepin do on 2018/1/17.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RewardDetailBaseCell.h"
#import "UIView+DDExtension.h"

@implementation RewardDetailBaseCell

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
    
    [self.contentView addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kOFFSET_SIZE);
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(@20);
    }];
    
    [self.contentView addSubview:self.descMarkLabel];
    [self.descMarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kOFFSET_SIZE);
        make.top.equalTo(self.descLabel.mas_bottom);
        make.height.equalTo(@15);
    }];
    
    [self.contentView addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-kOFFSET_SIZE);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.separateLine];
    [self.separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kOFFSET_SIZE);
        make.right.bottom.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
}

- (void)setCountNum:(NSNumber *)countNum {
    
    NSString *priceStr = [self.contentView getPriceStringNoComma:countNum];
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [attrText addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(14) range:NSMakeRange(0, 2)];
    self.countLabel.attributedText = attrText;
}

#pragma mark - LAZY
- (UILabel *)descLabel {
    if (_descLabel == nil) {
        _descLabel = [[UILabel alloc]init];
        _descLabel.text      = @"";
        _descLabel.textColor = COLOR_TEXT_NORMAL;
        _descLabel.font      = [FontUtils normalFont];
    }
    return _descLabel;
}

- (UILabel *)descMarkLabel {
    if (_descMarkLabel == nil) {
        _descMarkLabel = [[UILabel alloc]init];
        _descMarkLabel.text      = @"";
        _descMarkLabel.textColor = COLOR_MAIN;
        _descMarkLabel.font      = SYSTEMFONT(12);
    }
    return _descMarkLabel;
}

- (UILabel *)countLabel {
    if (_countLabel == nil) {
        _countLabel = [[UILabel alloc]init];
        _countLabel.text      = @"";
        _countLabel.textColor = COLOR_MAIN;
        _countLabel.font      = SYSTEMFONT(30);
    }
    return _countLabel;
}

- (UIView *)separateLine {
    if (_separateLine == nil) {
        _separateLine = [[UIView alloc]init];
        _separateLine.backgroundColor = COLOR_TEXT_LIGHT;
    }
    return _separateLine;
}

@end
