//
//  VIPUserView.m
//  akucun
//
//  Created by Jarry on 2017/8/20.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "VIPUserView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation VIPUserView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    
    [self addSubview:self.headImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.vipLabel];
    [self addSubview:self.statusLabel];
    [self addSubview:self.vipStarView];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.0f, SCREEN_WIDTH, kPIXEL_WIDTH)];
    _lineView.backgroundColor = COLOR_SEPERATOR_LINE;
    [self addSubview:_lineView];
    
    return self;
}

- (void) setUserInfo:(UserInfo *)userInfo
{
    _userInfo = userInfo;
    
    self.nameLabel.text = userInfo.name;
    [self.nameLabel sizeToFit];
    
    if ([UserManager isVIP]) {
        self.vipLabel.text = FORMAT(@"VIP%ld", (long)userInfo.viplevel);
        self.vipLabel.backgroundColor = COLOR_SELECTED;
        
        self.vipStarView.currentScore = userInfo.viplevel;
        self.statusLabel.text = FORMAT(@"会员有效期至%@", userInfo.vipendtime);
    }
    else {
        self.vipLabel.text = FORMAT(@"VIP0");
        self.vipLabel.backgroundColor = COLOR_TEXT_LIGHT;
        
        self.vipStarView.currentScore = 0;
        self.statusLabel.text = @"您还不是会员";
    }
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar]
                          placeholderImage:IMAGENAMED(@"userAvator")
                                   options:SDWebImageDelayPlaceholder];
    
    [self setNeedsLayout];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat offset = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
    self.headImageView.top = offset;
    self.nameLabel.top = self.headImageView.top;
    self.nameLabel.left = self.headImageView.right + kOFFSET_SIZE*0.6f;
    
    if (self.nameLabel.right > SCREEN_WIDTH - kOFFSET_SIZE - 32) {
        self.nameLabel.width = SCREEN_WIDTH - self.nameLabel.left - kOFFSET_SIZE - 32;
    }
    
    self.vipLabel.left = self.nameLabel.right + 5.0f;
    self.vipLabel.centerY = self.nameLabel.centerY;
    
    self.vipStarView.left = self.nameLabel.left;
    self.vipStarView.bottom = self.headImageView.bottom;
    
    self.statusLabel.bottom = self.vipStarView.bottom;
    self.statusLabel.left = self.vipStarView.right + 5.0f;
    self.statusLabel.width = self.width - self.statusLabel.left - kOFFSET_SIZE;
    
    self.height = self.headImageView.bottom + offset;
    self.lineView.top = self.height - kPIXEL_WIDTH;
}

- (UIImageView *) headImageView
{
    if (!_headImageView) {
        UIImage *image = IMAGENAMED(@"userAvator");
        _headImageView = [[UIImageView alloc] initWithImage:image];
        _headImageView.frame = CGRectMake(kOFFSET_SIZE, kOFFSET_SIZE, 50, 50);
        _headImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        _headImageView.clipsToBounds = YES;
        _headImageView.layer.cornerRadius = 25.0f;
    }
    return _headImageView;
}

- (UILabel *) nameLabel
{
    if (!_nameLabel) {
        _nameLabel  = [[UILabel alloc] init];
        _nameLabel.backgroundColor = CLEAR_COLOR;
        _nameLabel.textColor = COLOR_TEXT_DARK;
        _nameLabel.font = BOLDSYSTEMFONT(17);
    }
    return _nameLabel;
}

- (UILabel *) statusLabel
{
    if (!_statusLabel) {
        _statusLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.5f, 20)];
        _statusLabel.backgroundColor = CLEAR_COLOR;
        _statusLabel.textColor = COLOR_TEXT_NORMAL;
        _statusLabel.font = [FontUtils smallFont];
        _statusLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _statusLabel;
}

- (UILabel *) vipLabel
{
    if (!_vipLabel) {
        _vipLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 28, 14)];
        _vipLabel.backgroundColor = COLOR_TEXT_LIGHT;
        _vipLabel.textColor = WHITE_COLOR;
        _vipLabel.font = BOLDSYSTEMFONT(10);
        _vipLabel.textAlignment = NSTextAlignmentCenter;
        _vipLabel.clipsToBounds = YES;
        _vipLabel.layer.cornerRadius = 5.0f;
    }
    return _vipLabel;
}

- (SCStarRateView *) vipStarView
{
    if (!_vipStarView) {
        _vipStarView = [[SCStarRateView alloc] initWithFrame:CGRectMake(0, 0, 68, 20)];
    }
    return _vipStarView;
}

@end
