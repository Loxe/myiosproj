//
//  RewardSectionHeaderView.m
//  akucun
//
//  Created by deepin do on 2018/1/17.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RewardSectionHeaderView.h"

@implementation RewardSectionHeaderView

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
    
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(offset);
    }];
    
    [self addSubview:self.actionBtn];
    [self.actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-offset);
        make.centerY.equalTo(self);
        make.width.equalTo(@120);
        make.height.equalTo(@30);
    }];
    
    [self addSubview:self.separateLine];
    [self.separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@kPIXEL_WIDTH);
    }];
}

- (void)initWithTitle:(NSString *)name count:(NSInteger)count actionTitle:(NSString *)action {
    self.nameString   = name;
    self.actionString = action;
    
    if (count >= 0) {
        NSString *countStr = kIntergerToString(count);
        NSMutableAttributedString *nameStr = [[NSMutableAttributedString alloc]initWithString:FORMAT(@"%@%@",name,countStr)];
        [nameStr addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(18) range:NSMakeRange(name.length, countStr.length)];
        self.nameLabel.attributedText = nameStr;
    }
    else {
        self.nameLabel.text = self.nameString;
    }
    
//    if (self.nameString.length > 0) {
//        self.nameLabel.text = self.nameString;
//    } else {
//        self.nameLabel.text = @"";
//    }
    
    if (self.actionString.length > 0) {
        NSMutableAttributedString *normalStr = [[NSMutableAttributedString alloc]initWithString:self.actionString];
        [normalStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [normalStr length])];
        [normalStr addAttribute:NSForegroundColorAttributeName value:COLOR_TEXT_NORMAL range:NSMakeRange(0, [normalStr length])];
        
        NSMutableAttributedString *highlightStr = [[NSMutableAttributedString alloc]initWithString:self.actionString];
        [highlightStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [highlightStr length])];
        [highlightStr addAttribute:NSForegroundColorAttributeName value:COLOR_MAIN range:NSMakeRange(0, [highlightStr length])];
        
        [self.actionBtn setAttributedTitle:normalStr forState:UIControlStateNormal];
        [self.actionBtn setAttributedTitle:highlightStr forState:UIControlStateHighlighted];
    } else {
        
    }
}

- (void)actionBtnDidClick:(UIButton *)btn {
    if (self.clickBlock) {
        self.clickBlock(btn);
    }
}

#pragma mark - lazy
- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.text      = @"";
        _nameLabel.textColor = COLOR_TEXT_NORMAL;
        _nameLabel.font      = BOLDSYSTEMFONT(13);
    }
    return _nameLabel;
}

- (TextButton *)actionBtn {
    if (_actionBtn == nil) {
        _actionBtn = [[TextButton alloc]init];
        _actionBtn.titleLabel.font = [FontUtils smallFont];
        [_actionBtn setTitleAlignment:NSTextAlignmentRight];
        [_actionBtn setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
        
        [_actionBtn addTarget:self action:@selector(actionBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionBtn;
}

- (UIView *)separateLine {
    if (_separateLine == nil) {
        _separateLine = [[UIView alloc]init];
        _separateLine.backgroundColor = COLOR_SEPERATOR_LIGHT;
    }
    return _separateLine;
}

@end
