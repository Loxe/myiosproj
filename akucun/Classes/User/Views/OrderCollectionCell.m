//
//  OrderCollectionCell.m
//  akucun
//
//  Created by deepin do on 2018/1/8.
//  Copyright © 2018年 Sucang. All rights reserved.
//

//#define kCornerRadius   20.0
#define kImgWH          26.0
#define kCenterMargin   6.0
#define kTitleH         20.0

#import "OrderCollectionCell.h"

@implementation OrderCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    [self.contentView addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.width.height.equalTo(@(kImgWH));
        make.top.equalTo(self.contentView).offset(3);
    }];
    
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_bottom).offset(kCenterMargin);
        make.centerX.equalTo(self.contentView);
        make.height.equalTo(@(kTitleH));
    }];
}

- (void)updateUIWith:(UIImage *)img title:(NSString *)title {
    
    if (img) {
        self.imgView.image = img;
    }

    if (title) {
        self.nameLabel.text = title;
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.nameLabel.textColor = COLOR_MAIN;
    } else {
        [UIView animateWithDuration:0.1 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.nameLabel.textColor = COLOR_TEXT_DARK;
        } completion:nil];
    }
}

#pragma mark lazy
- (UIImageView *)imgView {
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc]init];
        _imgView.contentMode   = UIViewContentModeScaleAspectFit;
        _imgView.clipsToBounds = YES;
    }
    return _imgView;
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
