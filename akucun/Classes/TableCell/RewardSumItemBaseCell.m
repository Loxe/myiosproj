//
//  RewardSumItemBaseCell.m
//  akucun
//
//  Created by deepin do on 2018/1/17.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#define kTitleH         15.0
#define kPriceH         30.0
#define kItemMargin     30.0
#define kItemW          (SCREEN_WIDTH-2*kOFFSET_SIZE-kItemMargin)/2

#import "RewardSumItemBaseCell.h"

@implementation RewardSumItemBaseCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.centerX.equalTo(self.contentView);
        make.height.equalTo(@(kTitleH));
    }];
    
    [self.contentView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.nameLabel.mas_top).offset(-0.5*kOFFSET_SIZE);
        make.centerX.equalTo(self.contentView);
        make.width.equalTo(@(kItemW));
        make.height.equalTo(@(kPriceH));
    }];
}

- (void)initWithTitle:(NSString *)price titleColor:(UIColor *)color {
    
    self.priceLabel.text = price;
    
    if (color) {
        self.priceLabel.textColor = color;
        self.nameLabel.textColor  = color;
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
}
//    if (highlighted) {
//        self.priceLabel.alpha = 0.8;
//        self.nameLabel.textColor  = COLOR_MAIN;
//    } else {
//        [UIView animateWithDuration:0.1 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
//            self.priceLabel.alpha = 1.0;
//            self.nameLabel.textColor  = COLOR_TEXT_DARK;
//        } completion:nil];
//    }
//}

#pragma mark lazy
- (UILabel *)priceLabel {
    if (_priceLabel == nil) {
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.font          = SYSTEMFONT(30);
        _priceLabel.adjustsFontSizeToFitWidth = YES;
        _priceLabel.textColor     = COLOR_TEXT_NORMAL;
    }
    return _priceLabel;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = COLOR_TEXT_NORMAL;
        _nameLabel.font      = [FontUtils smallFont];
    }
    return _nameLabel;
}

@end
