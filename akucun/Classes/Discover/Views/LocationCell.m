//
//  LocationCell.m
//  Discovery
//
//  Created by deepin do on 2017/11/24.
//  Copyright © 2017年 deepin do. All rights reserved.
//

#import "LocationCell.h"

@implementation LocationCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    UIView *sepLine = [[UIView alloc]init];
    sepLine.backgroundColor = RGBCOLOR(200, 200, 200);
    [self.contentView addSubview:sepLine];
    [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
    
    [self.contentView addSubview:self.locationBtn];
    [self.locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.width.equalTo(@120);
        make.top.bottom.equalTo(self.contentView);
        make.height.equalTo(@25);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.locationLabel];
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-18);
        make.left.equalTo(self.locationBtn.mas_right);
        make.top.bottom.equalTo(self.contentView);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)locationBtnDidClick:(UIButton *)btn {
    if (self.locationBlock) {
        self.locationBlock(btn);
    }
}

#pragma mark - LAZY
- (UIButton *)locationBtn {
    if (_locationBtn == nil) {
        _locationBtn = [[UIButton alloc]init];
        [_locationBtn setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
        [_locationBtn setTitle:@"所在位置" forState:UIControlStateNormal];
        _locationBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _locationBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        _locationBtn.titleLabel.font = [FontUtils normalFont];
        [_locationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_locationBtn addTarget:self action:@selector(locationBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _locationBtn;
}

- (UILabel *)locationLabel {
    if (_locationLabel == nil) {
        _locationLabel = [[UILabel alloc]init];
        _locationLabel.text          = @"点击定位图标获取位置";
        _locationLabel.font          = [UIFont systemFontOfSize:14];
        _locationLabel.textColor     = [UIColor blackColor];
        _locationLabel.textAlignment = NSTextAlignmentRight;
    }
    return _locationLabel;
}

@end
