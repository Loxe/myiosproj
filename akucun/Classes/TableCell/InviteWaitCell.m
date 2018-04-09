//
//  InviteWaitCell.m
//  akucun
//
//  Created by deepin do on 2018/1/16.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#define kAvatorWH     30

#import "InviteWaitCell.h"

@implementation InviteWaitCell

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

- (void)showUserGuide
{
    [UserGuideManager createUserGuide:kUserGuideNewApproval title:@"点击“批准”帮他开通一年期会员" focusedView:self.approveBtn offset:15];
}

- (void)setupUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.avatorImgView];
    [self.avatorImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kOFFSET_SIZE);
        make.centerY.equalTo(self.contentView);
        make.width.height.equalTo(@kAvatorWH);
    }];
    
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatorImgView.mas_right).offset(0.5*kOFFSET_SIZE);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.approveBtn];
    [self.approveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-kOFFSET_SIZE);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@50);
        make.height.equalTo(@26);
    }];
}

- (void)approveBtnDidClick:(UIButton *)btn {
    if (self.approveBlock) {
        self.approveBlock(btn);
    }
}

#pragma mark - LAZY
- (UIImageView *)avatorImgView {
    if (_avatorImgView == nil) {
        _avatorImgView = [[UIImageView alloc]init];
        _avatorImgView.image = [UIImage imageNamed:@"userAvator"];
        
//        _avatorImgView.clipsToBounds = YES;
        _avatorImgView.layer.cornerRadius = kAvatorWH*0.5f;
        
//        _avatorImgView.badgeBgColor = COLOR_SELECTED;
        _avatorImgView.badgeCenterOffset = CGPointMake(30, 0);
    }
    return _avatorImgView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.text      = @"待批准代购 XX";
        _nameLabel.textColor = COLOR_TEXT_NORMAL;
        _nameLabel.font      = [FontUtils normalFont];
        
//        _nameLabel.badgeBgColor = COLOR_SELECTED;
//        _nameLabel.badgeCenterOffset = CGPointMake(10, 0);
    }
    return _nameLabel;
}

- (UIButton *)approveBtn {
    if (_approveBtn == nil) {
        _approveBtn = [[UIButton alloc]init];
        _approveBtn.backgroundColor = COLOR_MAIN;
        _approveBtn.clipsToBounds = YES;
        _approveBtn.layer.cornerRadius = 4.0;
        _approveBtn.titleLabel.font = [FontUtils normalFont];
        [_approveBtn setTitle:@"批准" forState:UIControlStateNormal];
        [_approveBtn setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
        [_approveBtn addTarget:self action:@selector(approveBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _approveBtn;
}



@end
