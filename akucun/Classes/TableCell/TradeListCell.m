//
//  TradeListCell.m
//  akucun
//
//  Created by deepin do on 2018/1/9.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "TradeListCell.h"

@interface TradeListCell()

@property(nonatomic, strong) UIView *lineView;

@end

@implementation TradeListCell

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
    self.dateLabel.text       = model.displayDateString;
}

- (void)setupUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(kOFFSET_SIZE);
        make.width.lessThanOrEqualTo(@(0.5*SCREEN_WIDTH-kOFFSET_SIZE));//不能超过这个距离
    }];
    
    [self.contentView addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kOFFSET_SIZE);
        make.bottom.equalTo(self.contentView).offset(-kOFFSET_SIZE);
        make.width.lessThanOrEqualTo(@(0.5*SCREEN_WIDTH-kOFFSET_SIZE));
    }];
    
    [self.contentView addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-kOFFSET_SIZE);
        make.top.equalTo(self.contentView).offset(kOFFSET_SIZE);
        make.width.lessThanOrEqualTo(@(0.5*SCREEN_WIDTH-kOFFSET_SIZE));
    }];
    
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(kOFFSET_SIZE);
        make.height.equalTo(@0.5);
    }];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.contentView.backgroundColor = RGBCOLOR(0xF4, 0xF4, 0xF4);
    } else {
        self.contentView.backgroundColor = WHITE_COLOR;
    }
}

#pragma mark - LAZY
- (UILabel *)descLabel {
    if (_descLabel == nil) {
        _descLabel = [[UILabel alloc]init];
        _descLabel.text = @"订单支付";
        _descLabel.textColor = COLOR_TEXT_DARK;
        _descLabel.font      = [FontUtils normalFont];
        _descLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _descLabel;
}

- (UILabel *)dateLabel {
    if (_dateLabel == nil) {
        _dateLabel = [[UILabel alloc]init];
        _dateLabel.text      = @"2018-01-08 08:00:00";
        _dateLabel.textColor = COLOR_TEXT_NORMAL;
        _dateLabel.font      = [FontUtils smallFont];
    }
    return _dateLabel;
}

- (UILabel *)countLabel {
    if (_countLabel == nil) {
        _countLabel = [[UILabel alloc]init];
        _countLabel.text      = @"+99.00";
        _countLabel.textColor = [UIColor greenColor];
        _countLabel.font      = BOLDSYSTEMFONT(22);
    }
    return _countLabel;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = COLOR_SEPERATOR_LIGHT;
    }
    return _lineView;
}

@end
