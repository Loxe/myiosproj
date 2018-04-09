//
//  TradeDetailCountCell.m
//  akucun
//
//  Created by deepin do on 2018/1/9.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "TradeDetailCountCell.h"

@implementation TradeDetailCountCell

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

- (void)setModel:(TradeModel *)model {
    self.descLabel.text       = model.displayTradeType;
    self.countLabel.text      = model.displayAmount;
    self.countLabel.textColor = model.displayAmountColor;
    self.resultLabel.text     = model.displayStatusText;
}

- (void)setupUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(kOFFSET_SIZE);
    }];
    
    [self.contentView addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.descLabel.mas_bottom).offset(kOFFSET_SIZE);
    }];
    
    [self.contentView addSubview:self.resultLabel];
    [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.countLabel.mas_bottom).offset(kOFFSET_SIZE);
    }];
}

#pragma mark - LAZY
- (UILabel *)descLabel {
    if (_descLabel == nil) {
        _descLabel = [[UILabel alloc]init];
        _descLabel.text = @"订单支付";
        _descLabel.textColor = COLOR_TEXT_NORMAL;
        _descLabel.font      = [FontUtils normalFont];
        _descLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _descLabel;
}

- (UILabel *)countLabel {
    if (_countLabel == nil) {
        _countLabel = [[UILabel alloc]init];
        _countLabel.text      = @"+999.00";
        _countLabel.textColor = COLOR_MAIN;
        _countLabel.font      = BOLDSYSTEMFONT(35);
    }
    return _countLabel;
}

- (UILabel *)resultLabel {
    if (_resultLabel == nil) {
        _resultLabel = [[UILabel alloc]init];
        _resultLabel.text      = @"交易成功";
        _resultLabel.textColor = COLOR_TEXT_LIGHT;
        _resultLabel.font      = [FontUtils smallFont];
    }
    return _resultLabel;
}


@end
