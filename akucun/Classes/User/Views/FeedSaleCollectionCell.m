//
//  FeedSaleCollectionCell.m
//  akucun
//
//  Created by deepin do on 2018/1/8.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#define kCountWH        32.0
#define kCenterMargin   5.0
#define kTitleH         20.0

#import "FeedSaleCollectionCell.h"

@implementation FeedSaleCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    [self.contentView addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.height.equalTo(@(kCountWH));
        make.top.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.countLabel.mas_bottom).offset(kCenterMargin);
        make.centerX.equalTo(self.contentView);
        make.height.equalTo(@(kTitleH));
    }];
}

- (void)updateUIWithTitle:(NSString *)count titleColor:(UIColor *)color {
    
    self.countLabel.text = count;
    
    if (color) {
        self.countLabel.textColor = color;
        self.nameLabel.textColor  = color;
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        // 设置高亮状态的颜色
        self.countLabel.textColor = COLOR_MAIN;
        self.nameLabel.textColor  = COLOR_MAIN;
    } else {
        // 设置正常状态的颜色
        [UIView animateWithDuration:0.1 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.countLabel.textColor = COLOR_TEXT_DARK;
            self.nameLabel.textColor  = COLOR_TEXT_DARK;
        } completion:nil];
    }
}

#pragma mark lazy
- (UILabel *)countLabel {
    if (_countLabel == nil) {
        _countLabel = [[UILabel alloc]init];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.font      = SYSTEMFONT(35);
        _countLabel.textColor = COLOR_TEXT_DARK;
        _countLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _countLabel;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = COLOR_TEXT_DARK;
        _nameLabel.font      = [FontUtils smallFont];
    }
    return _nameLabel;
}

@end
