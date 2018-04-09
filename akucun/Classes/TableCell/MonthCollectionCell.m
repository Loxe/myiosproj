//
//  MonthCollectionCell.m
//  akucun
//
//  Created by deepin do on 2018/1/17.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#define kMonthH         30.0
#define kYearH          20.0
#define kRedBarH        3.0
#define kItemW          SCREEN_WIDTH/5
#define kItemH          kMonthH+kYearH+kRedBarH

#import "MonthCollectionCell.h"

@implementation MonthCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    [self.contentView addSubview:self.monthLabel];
    [self.monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView).offset(2);
        make.top.equalTo(self.contentView);
        make.height.equalTo(@(kMonthH));
    }];
    
    [self.contentView addSubview:self.yearLabel];
    [self.yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.monthLabel.mas_bottom);
        make.centerX.equalTo(self.contentView);
        make.height.equalTo(@(kYearH));
    }];
    
    [self.contentView addSubview:self.redBarView];
    [self.redBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.height.equalTo(@(kRedBarH));
    }];
    
    [self.redBarView setHidden:YES];
}

- (void)setIsChoosed:(BOOL)isChoosed {
    if (isChoosed) {
        self.monthLabel.textColor = COLOR_MAIN;
        self.yearLabel.textColor  = COLOR_MAIN;
        [self.redBarView setHidden:NO];
    } else {
        [UIView animateWithDuration:0.1 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.monthLabel.textColor = COLOR_TEXT_NORMAL;
            self.yearLabel.textColor  = COLOR_TEXT_NORMAL;
            [self.redBarView setHidden:YES];
        } completion:nil];
    }
}

#pragma mark - lazy
- (UILabel *)monthLabel {
    if (_monthLabel == nil) {
        _monthLabel = [[UILabel alloc]init];
        _monthLabel.textAlignment = NSTextAlignmentCenter;
        _monthLabel.font          = BOLDSYSTEMFONT(18);
        _monthLabel.textColor     = COLOR_TEXT_NORMAL;//COLOR_MAIN
    }
    return _monthLabel;
}

- (UILabel *)yearLabel {
    if (_yearLabel == nil) {
        _yearLabel = [[UILabel alloc]init];
        _yearLabel.textAlignment = NSTextAlignmentCenter;
        _yearLabel.font          = BOLDSYSTEMFONT(12);
        _yearLabel.textColor     = COLOR_TEXT_NORMAL;//COLOR_MAIN
    }
    return _yearLabel;
}

- (UIView *)redBarView {
    if (_redBarView == nil) {
        _redBarView = [[UIView alloc]init];
        _redBarView.backgroundColor = COLOR_MAIN;
    }
    return _redBarView;
}


@end
