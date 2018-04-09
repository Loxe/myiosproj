//
//  PhotoCollectionCell.m
//  akucun
//
//  Created by deepin do on 2017/11/20.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "PhotoCollectionCell.h"

@implementation PhotoCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    [self.contentView addSubview:self.displayImageView];
    [self.displayImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.deletButton];
    [self.deletButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.playImageView];
    [self.playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@30);
        make.center.equalTo(self.contentView);
    }];
    [self.playImageView setHidden:YES];
}

- (void)deleteButtonDidClick:(UIButton *)btn {
    
    if (self.playImageView.isHidden) {
        self.deleteBlock(self.photoModel);
    } else {
        self.deleteBlock(self.videoModel);
    }
}

#pragma mark lazy
- (PhotoSelectModel *)photoModel {
    if (_photoModel == nil) {
        _photoModel = [[PhotoSelectModel alloc]init];
    }
    return _photoModel;
}

- (VideoSelectModel *)videoModel {
    if (_videoModel == nil) {
        _videoModel = [[VideoSelectModel alloc]init];
    }
    return _videoModel;
}

- (UIButton *)deletButton {
    if (_deletButton == nil) {
        _deletButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deletButton setImage:[UIImage imageNamed:@"deleteBtn"] forState:UIControlStateNormal];
        [_deletButton addTarget:self action:@selector(deleteButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deletButton;
}

- (UIImageView *)playImageView {
    if (_playImageView == nil) {
        _playImageView = [[UIImageView alloc]init];
        _playImageView.image = [UIImage imageNamed:@"icon_play"];
    }
    return _playImageView;
}

- (UIImageView *)displayImageView {
    if (_displayImageView == nil) {
        _displayImageView = [[UIImageView alloc]init];
        _displayImageView.contentMode = UIViewContentModeScaleAspectFill;
        _displayImageView.clipsToBounds = YES;
    }
    return _displayImageView;
}

@end

