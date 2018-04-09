//
//  MoreCollectionCell.m
//  akucun
//
//  Created by deepin do on 2018/1/8.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#define kCornerRadius   20.0
#define kImgWH          26.0
#define kCenterMargin   5.0
#define kTitleH         15.0

#import "MoreCollectionCell.h"

@implementation MoreCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    [self.contentView addSubview:self.BGView];
    [self.BGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.width.height.equalTo(@(2*kCornerRadius));
        make.top.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.BGView);
        make.width.height.equalTo(@(kImgWH));
    }];
    
    [self.contentView addSubview:self.noticeLabel];
    [self.noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.BGView);
        make.height.equalTo(@(kImgWH));
        make.width.equalTo(@(self.width));
    }];
    
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.BGView.mas_bottom).offset(kCenterMargin);
        make.centerX.equalTo(self.contentView);
        make.height.equalTo(@(kTitleH));
    }];
    
    [self.noticeLabel setHidden:YES];
}

- (void)updateUIWith:(UIImage *)img imgBGColor:(UIColor *)bgColor title:(NSString *)title {
    
    if (img) {
        self.imgView.image = img;
    }
    
    if (bgColor) {
        self.BGView.backgroundColor = bgColor;
    }
    
    if (title) {
        self.nameLabel.text = title;
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        // 设置高亮状态的颜色
        self.BGView.alpha = 0.8;
        if (self.noticeLabel.isHidden) {
            self.nameLabel.textColor = COLOR_MAIN;
        }
    } else {
        // 设置正常状态的颜色
        [UIView animateWithDuration:0.1 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.BGView.alpha = 1.0;
            if (self.noticeLabel.isHidden) {
                self.nameLabel.textColor = COLOR_TEXT_NORMAL;
            }
        } completion:nil];
    }
}

#pragma mark lazy
- (UIView *)BGView {
    if (_BGView == nil) {
        _BGView = [[UIView alloc]init];
        _BGView.backgroundColor     = [UIColor whiteColor];
        _BGView.layer.cornerRadius  = kCornerRadius;
        _BGView.layer.masksToBounds = YES;
    }
    return _BGView;
}

- (UIImageView *)imgView {
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc]init];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        _imgView.clipsToBounds = YES;
    }
    return _imgView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = COLOR_TEXT_NORMAL;
        _nameLabel.font      = [FontUtils smallFont];
    }
    return _nameLabel;
}

- (UILabel *)noticeLabel {
    if (_noticeLabel == nil) {
        _noticeLabel = [[UILabel alloc]init];
        _noticeLabel.text          = @"敬请期待";
        _noticeLabel.textColor     = COLOR_TEXT_DARK;
        _noticeLabel.font          = SYSTEMFONT(8);
        _noticeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _noticeLabel;
}


@end
