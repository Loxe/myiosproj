//
//  UpDownButton.m
//  akucun
//
//  Created by deepin do on 2018/2/8.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "UpDownButton.h"

@implementation UpDownButton

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
    
    [self addSubview:self.topIcon];
    [self addSubview:self.bottomLabel];
    
    [self.topIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self);
        make.width.height.equalTo(@25);
    }];
    
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.topIcon.mas_bottom);
        make.height.equalTo(@20);
    }];

}

- (void)initWithTitle:(NSString *)title Image:(NSString *)img {
    if (img.length > 0 && img != nil) {
        self.topIcon.image = [UIImage imageNamed:img];
    }
    self.bottomLabel.text = title;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    self.topIcon.alpha = highlighted ? 0.6f : 1.0f;
    self.bottomLabel.textColor = highlighted ? COLOR_SELECTED : WHITE_COLOR;
}

- (UIImageView *)topIcon {
    if (_topIcon == nil) {
        _topIcon = [[UIImageView alloc]init];
    }
    return _topIcon;
}

- (UILabel *)bottomLabel {
    if (_bottomLabel == nil) {
        _bottomLabel = [[UILabel alloc]init];
        _bottomLabel.font = [UIFont boldSystemFontOfSize:13];
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
        _bottomLabel.adjustsFontSizeToFitWidth = YES;
        _bottomLabel.textColor = WHITE_COLOR;
    }
    return _bottomLabel;
}

@end
