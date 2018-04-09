//
//  AuthRemindView.m
//  akucun
//
//  Created by deepin do on 2017/12/21.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "AuthRemindView.h"

@interface AuthRemindView()

@property(nonatomic, strong) UIImageView *remindImgView;

@property(nonatomic, strong) UILabel *remindLabel;

@end

@implementation AuthRemindView

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
    
    [self addSubview:self.remindImgView];
    [self.remindImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.width.height.equalTo(@20);
        make.left.equalTo(self).offset(offset);
    }];
    
    [self addSubview:self.remindLabel];
    [self.remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.remindImgView.mas_right).offset(offset*0.5);
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-offset);
    }];
}

- (void)setRemindViewWithTitle:(NSString *)title image:(NSString *)img {
    _remindString = title;
    _imgString    = img;
    
    if (_imgString) {
        self.remindImgView.image = [UIImage imageNamed:_imgString];
    } else {
        self.remindImgView.image = [UIImage imageNamed:@"remind"];
    }
    
    self.remindLabel.text = _remindString.length > 0 ? _remindString : @"";
}

- (UIImageView *)remindImgView {
    if (_remindImgView == nil) {
        _remindImgView = [[UIImageView alloc]init];
        //_remindImgView.image = [UIImage imageNamed:@"Reminder"];
    }
    return _remindImgView;
}

- (UILabel *)remindLabel {
    if (_remindLabel == nil) {
        _remindLabel = [[UILabel alloc]init];
        //_remindLabel.text      = @"请填写您的真实信息，通过后将不能修改";
        _remindLabel.font      = [FontUtils smallFont];
        _remindLabel.textColor = LIGHTGRAY_COLOR; //RGBCOLOR(194, 194, 194);
    }
    return _remindLabel;
}

@end
