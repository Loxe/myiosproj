//
//  LeftMenuTableCell.m
//  akucun
//
//  Created by Jarry Zhu on 2017/12/21.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "LeftMenuTableCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation LeftMenuTableCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    self.seperatorLine.backgroundColor = COLOR_SEPERATOR_LIGHT;

    [self.contentView addSubview:self.logoImage];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.newLabel];
    [self.contentView addSubview:self.vipIconView];

    [self.logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(kOFFSET_SIZE);
        make.width.height.mas_equalTo(@(26));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.logoImage.mas_right).offset(kOFFSET_SIZE*0.8f);
        make.width.lessThanOrEqualTo(@(kLeftMenuWidth-26-1.8*kOFFSET_SIZE-40));
    }];
    
    /*
    [self.vipIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.nameLabel.mas_right).offset(5);
        make.width.mas_equalTo(@(38));
        make.height.mas_equalTo(@(16));
    }];
    [self.newLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.vipIconView.mas_right).offset(5);
        make.width.mas_equalTo(@(25));
        make.height.mas_equalTo(@(14));
    }];*/
    
    return self;
}

- (void) setLiveInfo:(LiveInfo *)liveInfo
{
    _liveInfo = liveInfo;
    
    NSInteger levelFlag = [liveInfo levelFlag];
    BOOL isNew = [liveInfo isTodayLive];
    
    self.newLabel.hidden = !isNew;
    self.vipIconView.hidden = (levelFlag <= 0);
    
    CGFloat maxWidth = kLeftMenuWidth-26-1.8*kOFFSET_SIZE;
    if (isNew && levelFlag > 0) {
        maxWidth = kLeftMenuWidth-26-1.8*kOFFSET_SIZE - 75;
    }
    else if (levelFlag > 0) {
        maxWidth = kLeftMenuWidth-26-1.8*kOFFSET_SIZE - 40;
    }
    else if (isNew) {
        maxWidth = kLeftMenuWidth-26-1.8*kOFFSET_SIZE - 40;
    }
    
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.logoImage.mas_right).offset(kOFFSET_SIZE*0.8f);
        make.width.lessThanOrEqualTo(@(maxWidth));
    }];
    
    MASViewAttribute *leftAttribute = self.nameLabel.mas_right;
    if (!self.vipIconView.hidden) {
        [self.vipIconView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.nameLabel.mas_right).offset(5);
            make.width.mas_equalTo(@(38));
            make.height.mas_equalTo(@(16));
        }];
        leftAttribute = self.vipIconView.mas_right;
    }

    if (isNew) {
        [self.newLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(leftAttribute).offset(5);
            make.width.mas_equalTo(@(25));
            make.height.mas_equalTo(@(14));
        }];
    }
    
    self.nameLabel.text = liveInfo.pinpaiming;
    
    if (levelFlag > 0) {
        NSString *imgName = FORMAT(@"icon_vip%ld",(long)levelFlag);
        self.vipIconView.image = IMAGENAMED(imgName);
    }

    [self.logoImage sd_setImageWithURL:[NSURL URLWithString:liveInfo.pinpaiurl] placeholderImage:nil];
}

- (void) layoutSubviews
{
    [super layoutSubviews];

//    self.logoImage.centerY = (self.height)/2.0f;
}

- (UIImageView *) logoImage
{
    if (!_logoImage) {
        _logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(kOFFSET_SIZE, 0, 26, 26)];
        _logoImage.backgroundColor = WHITE_COLOR;
        _logoImage.contentMode = UIViewContentModeScaleAspectFit;
        _logoImage.clipsToBounds = YES;
        _logoImage.userInteractionEnabled = YES;
        
        _logoImage.layer.cornerRadius = 3.0f;
        _logoImage.layer.borderColor = COLOR_SEPERATOR_LIGHT.CGColor;
        _logoImage.layer.borderWidth = kPIXEL_WIDTH;
    }
    return _logoImage;
}

- (UILabel *) nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.backgroundColor = CLEAR_COLOR;
        _nameLabel.textColor = COLOR_TEXT_DARK;
        _nameLabel.font = [FontUtils normalFont];
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _nameLabel;
}

- (UILabel *) newLabel
{
    if (!_newLabel) {
        _newLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 14)];
        _newLabel.backgroundColor     = COLOR_MAIN;
        _newLabel.layer.cornerRadius  = 2.0;
        _newLabel.layer.masksToBounds = YES;
        _newLabel.textColor = WHITE_COLOR;
        _newLabel.font = BOLDSYSTEMFONT(9);
        _newLabel.textAlignment = NSTextAlignmentCenter;
        _newLabel.text = @"New";
        _newLabel.hidden = YES;
    }
    return _newLabel;
}

- (UIImageView *) vipIconView
{
    if (!_vipIconView) {
        _vipIconView = [[UIImageView alloc] init];
        _vipIconView.frame = CGRectMake(0, 0, 38, 16);
        _vipIconView.contentMode = UIViewContentModeScaleAspectFit;
        _vipIconView.image = IMAGENAMED(@"icon_vip1");
        _vipIconView.hidden = YES;
    }
    return _vipIconView;
}

@end
