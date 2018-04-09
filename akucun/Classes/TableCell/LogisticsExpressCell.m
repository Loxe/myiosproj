//
//  LogisticsExpressCell.m
//  akucun
//
//  Created by deepin do on 2017/12/7.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "LogisticsExpressCell.h"

@implementation LogisticsExpressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    CGFloat offset = kOFFSET_SIZE;
    [self.contentView addSubview:self.expressNumberTitle];
    [self.expressNumberTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(offset);
        make.left.equalTo(self.contentView).offset(offset);
        make.height.equalTo(@20);
    }];
    
    [self.contentView addSubview:self.expressNumberLabel];
    [self.expressNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.expressNumberTitle);
        make.left.equalTo(self.expressNumberTitle.mas_right);
        make.height.equalTo(@20);
    }];
    
    [self.contentView addSubview:self.expressCompanyTitle];
    [self.expressCompanyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.expressNumberTitle.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(offset);
        make.height.equalTo(@20);
    }];
    
    [self.contentView addSubview:self.expressCompanyLabel];
    [self.expressCompanyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.expressNumberTitle.mas_bottom).offset(10);
        make.left.equalTo(self.expressCompanyTitle.mas_right);
        make.height.equalTo(@20);
    }];
    
    [self.contentView addSubview:self.copyBtn];
    [self.copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.expressNumberTitle);
        make.right.equalTo(self.contentView).offset(-offset);
        make.height.equalTo(@24);
        make.width.equalTo(@70);
    }];
}

- (void)copyBtnDidClick:(UIButton *)btn {
    if (self.copyBlock) {
        self.copyBlock(self.wuliuhao);
    }
}

- (void) setWuliuhao:(NSString *)wuliuhao
{
    _wuliuhao = wuliuhao;
    self.expressNumberLabel.text = wuliuhao;
}

- (void) setWuliugongsi:(NSString *)wuliugongsi
{
    _wuliugongsi = wuliugongsi;
    self.expressCompanyLabel.text = wuliugongsi;
}

#pragma mark - Lazy
- (UIButton *)copyBtn {
    if (_copyBtn == nil) {
        _copyBtn = [[UIButton alloc]init];
        [_copyBtn setTitle:@"复制单号" forState:UIControlStateNormal];
        [_copyBtn setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
        [_copyBtn setTitleColor:COLOR_SELECTED forState:UIControlStateHighlighted];
        [_copyBtn addTarget:self action:@selector(copyBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        _copyBtn.titleLabel.font = [FontUtils smallFont];
        _copyBtn.layer.borderColor = COLOR_TEXT_NORMAL.CGColor;
        _copyBtn.layer.borderWidth = 0.5f;
        _copyBtn.layer.cornerRadius = 3.0f;
        _copyBtn.layer.masksToBounds = YES;
    }
    return _copyBtn;
}

- (UILabel *)expressNumberTitle {
    
    if (_expressNumberTitle == nil) {
        _expressNumberTitle = [[UILabel alloc]init];
        _expressNumberTitle.text = @"快递单号：";
        _expressNumberTitle.font = [FontUtils normalFont];
        _expressNumberTitle.textAlignment = NSTextAlignmentLeft;
        _expressNumberTitle.textColor = COLOR_TEXT_NORMAL;
    }
    return _expressNumberTitle;
}

- (UILabel *)expressNumberLabel {
    
    if (_expressNumberLabel == nil) {
        _expressNumberLabel = [[UILabel alloc]init];
        _expressNumberLabel.text = @"";
        _expressNumberLabel.font = [FontUtils normalFont];
        _expressNumberLabel.textAlignment = NSTextAlignmentLeft;
        _expressNumberLabel.textColor = COLOR_TEXT_DARK;
    }
    return _expressNumberLabel;
}

- (UILabel *)expressCompanyTitle {
    
    if (_expressCompanyTitle == nil) {
        _expressCompanyTitle = [[UILabel alloc]init];
        _expressCompanyTitle.text = @"快递公司：";
        _expressCompanyTitle.font = [FontUtils normalFont];
        _expressCompanyTitle.textAlignment = NSTextAlignmentLeft;
        _expressCompanyTitle.textColor = COLOR_TEXT_NORMAL;
    }
    return _expressCompanyTitle;
}

- (UILabel *)expressCompanyLabel {
    
    if (_expressCompanyLabel == nil) {
        _expressCompanyLabel = [[UILabel alloc]init];
        _expressCompanyLabel.text = @"";
        _expressCompanyLabel.font = [FontUtils normalFont];
        _expressCompanyLabel.textAlignment = NSTextAlignmentLeft;
        _expressCompanyLabel.textColor = COLOR_TEXT_DARK;
    }
    return _expressCompanyLabel;
}

@end
