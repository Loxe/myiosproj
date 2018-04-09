//
//  MeSectionHeaderView.m
//  akucun
//
//  Created by deepin do on 2018/1/8.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "MeSectionHeaderView.h"

@implementation MeSectionHeaderView

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
    
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(offset);
    }];
    
    [self addSubview:self.arrowImgView];
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-offset);
        make.width.height.equalTo(@12);
    }];
    
    [self addSubview:self.actionLabel];
    [self.actionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowImgView.mas_left).offset(-offset*0.5);
        make.centerY.equalTo(self);
    }];

    [self addSubview:self.actionBtn];
    [self.actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.left.equalTo(self);
    }];
    
    UIView *seperatorLine = [[UIView alloc] init];
    seperatorLine.backgroundColor = COLOR_SEPERATOR_LIGHT;
    [self addSubview:seperatorLine];
    [seperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@(kPIXEL_WIDTH));
    }];
}

- (void)setHeaderViewNameTitle:(NSString *)name actionTitle:(NSString *)action {
    self.nameString   = name;
    self.actionString = action;
    
    if (self.nameString.length > 0) {
        self.nameLabel.text = self.nameString;
    } else {
        self.nameLabel.text = @"";
    }
    
    if (self.actionString.length > 0) {
        self.actionLabel.text = self.actionString;
    } else {
        self.actionLabel.text = @"";
    }
}

- (void)actionBtnDidClick:(UIButton *)btn {
    if (self.clickBlock) {
        self.clickBlock(btn);
    }
}

#pragma mark - lazy
- (UIButton *)actionBtn {
    if (_actionBtn == nil) {
        _actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_actionBtn addTarget:self action:@selector(actionBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionBtn;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.text      = @"我的订单";
        _nameLabel.textColor = COLOR_TEXT_DARK;
        _nameLabel.font      = BOLDSYSTEMFONT(13);
    }
    return _nameLabel;
}

- (UILabel *)actionLabel {
    if (_actionLabel == nil) {
        _actionLabel = [[UILabel alloc]init];
        _actionLabel.text      = @"查看全部";
        _actionLabel.textColor = COLOR_TEXT_NORMAL;
        _actionLabel.font      = [FontUtils smallFont];
    }
    return _actionLabel;
}

- (UIImageView *)arrowImgView {
    if (_arrowImgView == nil) {
        _arrowImgView = [[UIImageView alloc]init];
        _arrowImgView.image = [UIImage imageNamed:@"rightArrow"];
    }
    return _arrowImgView;
}

@end
