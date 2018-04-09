//
//  TradeDetailBillCell.m
//  akucun
//
//  Created by deepin do on 2018/1/9.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "TradeDetailBillCell.h"

@implementation TradeDetailBillCell

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
    self.numDetailLabel.text   = model.displayTradeId;
    self.dateDetailLabel.text  = model.displayDateString;
    self.billDetailLabel.text  = model.displayTradeInfo;
}

- (void)setupUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.numTitleLabel];
    [self.numTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(kOFFSET_SIZE);
        make.width.lessThanOrEqualTo(@(100));
    }];
    
    [self.contentView addSubview:self.numDetailLabel];
    [self.numDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView).offset(kOFFSET_SIZE);
        make.centerY.equalTo(self.numTitleLabel);
        make.right.equalTo(self.contentView).offset(-kOFFSET_SIZE);
        make.width.lessThanOrEqualTo(@(0.5*SCREEN_WIDTH+20));
    }];
    
    [self.contentView addSubview:self.dateTitleLabel];
    [self.dateTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kOFFSET_SIZE);
        make.top.equalTo(self.numTitleLabel.mas_bottom).offset(kOFFSET_SIZE);
        make.width.lessThanOrEqualTo(@(100));
    }];
    
    [self.contentView addSubview:self.dateDetailLabel];
    [self.dateDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.dateTitleLabel);
        make.right.equalTo(self.contentView).offset(-kOFFSET_SIZE);
        make.width.lessThanOrEqualTo(@(0.5*SCREEN_WIDTH+20));
    }];
    
    [self.contentView addSubview:self.billTitleLabel];
    [self.billTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kOFFSET_SIZE);
        make.top.equalTo(self.dateTitleLabel.mas_bottom).offset(kOFFSET_SIZE);
        make.width.lessThanOrEqualTo(@(100));
    }];
    
    [self.contentView addSubview:self.billDetailLabel];
    [self.billDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.billTitleLabel);
        make.right.equalTo(self.contentView).offset(-kOFFSET_SIZE);
        make.width.lessThanOrEqualTo(@(0.7*SCREEN_WIDTH));
    }];
}

#pragma mark - LAZY
- (UILabel *)numTitleLabel {
    if (_numTitleLabel == nil) {
        _numTitleLabel = [[UILabel alloc]init];
        _numTitleLabel.text = @"流水号";
        _numTitleLabel.textColor = COLOR_TEXT_NORMAL;
        _numTitleLabel.font      = [FontUtils smallFont];
        _numTitleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _numTitleLabel;
}

- (UILabel *)numDetailLabel {
    if (_numDetailLabel == nil) {
        _numDetailLabel = [[UILabel alloc]init];
        _numDetailLabel.text      = @"DSC18023473205023840238423423";
        _numDetailLabel.textColor = COLOR_TEXT_DARK;
        _numDetailLabel.font      = [FontUtils smallFont];
        _numDetailLabel.adjustsFontSizeToFitWidth = YES;
        _numDetailLabel.textAlignment = NSTextAlignmentRight;
    }
    return _numDetailLabel;
}

- (UILabel *)dateTitleLabel {
    if (_dateTitleLabel == nil) {
        _dateTitleLabel = [[UILabel alloc]init];
        _dateTitleLabel.text      = @"交易时间";
        _dateTitleLabel.textColor = COLOR_TEXT_NORMAL;
        _dateTitleLabel.font      = [FontUtils smallFont];
        _dateTitleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _dateTitleLabel;
}

- (UILabel *)dateDetailLabel {
    if (_dateDetailLabel == nil) {
        _dateDetailLabel = [[UILabel alloc]init];
        _dateDetailLabel.text      = @"2018-01-08 08:00:00";
        _dateDetailLabel.textColor = COLOR_TEXT_DARK;
        _dateDetailLabel.font      = [FontUtils smallFont];
        _dateDetailLabel.textAlignment = NSTextAlignmentRight;
    }
    return _dateDetailLabel;
}

- (UILabel *)billTitleLabel {
    if (_billTitleLabel == nil) {
        _billTitleLabel = [[UILabel alloc]init];
        _billTitleLabel.text      = @"交易详情";
        _billTitleLabel.textColor = COLOR_TEXT_NORMAL;
        _billTitleLabel.font      = [FontUtils smallFont];
        _billTitleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _billTitleLabel;
}

- (UILabel *)billDetailLabel {
    if (_billDetailLabel == nil) {
        _billDetailLabel = [[UILabel alloc]init];
        _billDetailLabel.text      = @"订单号：x18010207/支付方式：微信支付/支付号：DSC3401834015830418/订单详情：testthis";
        _billDetailLabel.numberOfLines = 0;
        _billDetailLabel.textColor = COLOR_TEXT_DARK;
        _billDetailLabel.font      = [FontUtils smallFont];
        _billDetailLabel.textAlignment = NSTextAlignmentRight;
    }
    return _billDetailLabel;
}


@end
