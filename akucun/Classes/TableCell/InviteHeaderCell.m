//
//  InviteHeaderCell.m
//  akucun
//
//  Created by deepin do on 2018/1/16.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "InviteHeaderCell.h"

@implementation InviteHeaderCell

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
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.BGImgView];
    [self.BGImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.contentView);
//        make.width.height.equalTo(@50);
        make.left.equalTo(self.contentView).offset(kOFFSET_SIZE*1.5);
        make.bottom.equalTo(self.contentView).offset(-kOFFSET_SIZE);
        make.width.height.equalTo(@30);
    }];
//    [self.contentView addSubview:self.awardBtn];
//    [self.awardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView).offset(0.5*kOFFSET_SIZE);
//        make.left.equalTo(self.contentView).offset(kOFFSET_SIZE);
//        make.width.equalTo(@85);
//        make.height.equalTo(@30);
//    }];
    
    [self.contentView addSubview:self.detailBtn];
    [self.detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-0.5*kOFFSET_SIZE);
        make.right.equalTo(self.contentView).offset(-kOFFSET_SIZE);
        make.width.equalTo(@80);
        make.height.equalTo(@30);
    }];
}

//- (void)awardBtnDidClick:(UIButton *)btn {
//    if (self.awardBlock) {
//        self.awardBlock(btn);
//    }
//}

- (void)playBtnDidClick:(UIButton *)btn {
    if (self.playBlock) {
        self.playBlock(btn);
    }
}

- (void)detailBtnDidClick:(UIButton *)btn {
    if (self.detailBlock) {
        self.detailBlock(btn);
    }
}

#pragma mark - LAZY
- (UIImageView *)BGImgView {
    if (_BGImgView == nil) {
        _BGImgView = [[UIImageView alloc]init];
        _BGImgView.image = [UIImage imageNamed:@"inviteHeaderBanner"];
    }
    return _BGImgView;
}

- (UIButton *)playBtn {
    if (_playBtn == nil) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _playBtn.backgroundColor = [BLACK_COLOR colorWithAlphaComponent:0.1f];
        [_playBtn setNormalImage:@"icon_play" hilighted:nil selectedImage:nil];
        [_playBtn addTarget:self action:@selector(playBtnDidClick:)
              forControlEvents:UIControlEventTouchUpInside];
        _playBtn.hidden = YES;
    }

    return _playBtn;
}
//- (UIButton *)awardBtn {
//    if (_awardBtn == nil) {
//        _awardBtn = [[UIButton alloc]init];
//        _awardBtn.titleLabel.font = [FontUtils normalFont];
//        [_awardBtn setTitleColor:COLOR_TEXT_DARK forState:UIControlStateNormal];
//
//        NSMutableAttributedString *normalStr = [[NSMutableAttributedString alloc]initWithString:@"邀请享奖励"];
//        [normalStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [normalStr length])];
//
//        NSMutableAttributedString *highlightStr = [[NSMutableAttributedString alloc]initWithString:@"邀请享奖励"];
//        [highlightStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [highlightStr length])];
//
//        [_awardBtn setAttributedTitle:normalStr forState:UIControlStateNormal];
//        [_awardBtn setAttributedTitle:highlightStr forState:UIControlStateHighlighted];
////        [_awardBtn addTarget:self action:@selector(awardBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _awardBtn;
//}

- (TextButton *)detailBtn {
    if (_detailBtn == nil) {
        _detailBtn = [[TextButton alloc]init];
        _detailBtn.titleLabel.font = [FontUtils smallFont];
        [_detailBtn setTitleAlignment:NSTextAlignmentRight];
        //[_detailBtn setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
        
        NSMutableAttributedString *normalStr = [[NSMutableAttributedString alloc]initWithString:@"详细规则"];
        [normalStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [normalStr length])];
        [normalStr addAttribute:NSForegroundColorAttributeName value:WHITE_COLOR range:NSMakeRange(0, [normalStr length])];
        
        NSMutableAttributedString *highlightStr = [[NSMutableAttributedString alloc]initWithString:@"详细规则"];
        [highlightStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [highlightStr length])];
        [highlightStr addAttribute:NSForegroundColorAttributeName value:COLOR_TEXT_NORMAL range:NSMakeRange(0, [highlightStr length])];
        
        [_detailBtn setAttributedTitle:normalStr forState:UIControlStateNormal];
        [_detailBtn setAttributedTitle:highlightStr forState:UIControlStateHighlighted];
        [_detailBtn addTarget:self action:@selector(detailBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        _detailBtn.hidden = YES;
    }
    return _detailBtn;
}

@end
