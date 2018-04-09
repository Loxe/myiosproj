//
//  RelatedUserHeader.m
//  akucun
//
//  Created by Jarry Z on 2018/4/5.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RelatedUserHeader.h"

#define kPadding    10
#define kRow1Width  (SCREEN_WIDTH-2*kOFFSET_SIZE-2*kPadding)*0.4
#define kRow2Width  (SCREEN_WIDTH-2*kOFFSET_SIZE-2*kPadding)*0.3
#define kRow3Width  (SCREEN_WIDTH-2*kOFFSET_SIZE-2*kPadding)*0.3

@implementation RelatedUserHeader

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    CGFloat offset = kOFFSET_SIZE;
    
    [self addSubview:self.majorLabel];
    [self.majorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(offset);
        make.left.equalTo(self).offset(kOFFSET_SIZE+150);
    }];
    
    [self addSubview:self.relatedLabel];
    [self.relatedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.majorLabel);
        make.top.equalTo(self.majorLabel.mas_bottom).offset(offset*0.5);
    }];
    
    [self addSubview:self.totalLabel];
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.majorLabel);
        make.top.equalTo(self.relatedLabel.mas_bottom).offset(offset*0.5);
    }];
    
    [self addSubview:self.monthButton];
    [self.monthButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kOFFSET_SIZE);
        make.centerY.equalTo(self.relatedLabel);
        make.width.equalTo(@(120));
        make.height.equalTo(@(40));
    }];
    
    [self addSubview:self.bottomLine];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@kPIXEL_WIDTH);
    }];
    
    [self addSubview:self.friendLabel];
    [self.friendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(offset);
        make.bottom.equalTo(self.bottomLine.mas_top).offset(-5);
        make.width.equalTo(@(kRow1Width));
    }];
    
    [self addSubview:self.levelLabel];
    [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.friendLabel.mas_right).offset(kPadding);
        make.centerY.equalTo(self.friendLabel);
        make.width.equalTo(@(kRow2Width));
    }];
    
    [self addSubview:self.livenessLabel];
    [self.livenessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-offset);
        make.centerY.equalTo(self.friendLabel);
        make.width.equalTo(@(kRow3Width));
    }];
    
    [self addSubview:self.separateLine];
    [self.separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.friendLabel.mas_top).offset(-5);
        make.height.equalTo(@kPIXEL_WIDTH);
    }];
 
}

- (IBAction) selectAction:(id)sender
{
    if (self.actionBlock) {
        self.actionBlock();
    }
}

#pragma mark -

- (IconButton *) monthButton
{
    if (!_monthButton) {
        _monthButton = [[IconButton alloc] initWithFrame:CGRectMake(0, 0, 48, 40)];
        
        _monthButton.textColor = COLOR_MAIN;
        _monthButton.iconColor = COLOR_MAIN;
        [_monthButton setIconFont:FA_ICONFONTSIZE(15)];
        [_monthButton setTitleFont:BOLDSYSTEMFONT(13)];
        [_monthButton setTitle:@"--" icon:@"\uF13A"];
//        _monthButton.image = @"icon_down_arrow";
        
        [_monthButton addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _monthButton;
}

- (UILabel *)majorLabel
{
    if (_majorLabel == nil) {
        _majorLabel = [[UILabel alloc]init];
        _majorLabel.textColor = COLOR_TEXT_NORMAL;
        _majorLabel.font      = BOLDSYSTEMFONT(13);
        _majorLabel.text      = @"主账号的业绩： ¥ 0.00";
    }
    return _majorLabel;
}

- (UILabel *)relatedLabel
{
    if (_relatedLabel == nil) {
        _relatedLabel = [[UILabel alloc]init];
        _relatedLabel.textColor = COLOR_TEXT_NORMAL;
        _relatedLabel.font      = BOLDSYSTEMFONT(13);
        _relatedLabel.text      = @"关联账号业绩： ¥ 0.00";
    }
    return _relatedLabel;
}

- (UILabel *)totalLabel
{
    if (_totalLabel == nil) {
        _totalLabel = [[UILabel alloc]init];
        _totalLabel.textColor = COLOR_MAIN;
        _totalLabel.font      = BOLDSYSTEMFONT(13);
        _totalLabel.text      = @"总计销售业绩： ¥ 0.00";
    }
    return _totalLabel;
}

- (UIView *)separateLine
{
    if (_separateLine == nil) {
        _separateLine = [[UIView alloc]init];
        _separateLine.backgroundColor = COLOR_SEPERATOR_LIGHT;
    }
    return _separateLine;
}

- (UILabel *)friendLabel
{
    if (_friendLabel == nil) {
        _friendLabel = [[UILabel alloc]init];
        _friendLabel.textColor = COLOR_TEXT_NORMAL;
        _friendLabel.font      = BOLDSYSTEMFONT(13);
        _friendLabel.text      = @"我的关联账号";
        _friendLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _friendLabel;
}

- (UILabel *)levelLabel
{
    if (_levelLabel == nil) {
        _levelLabel = [[UILabel alloc]init];
        _levelLabel.textColor = COLOR_TEXT_NORMAL;
        _levelLabel.font      = BOLDSYSTEMFONT(13);
        _levelLabel.text      = @"当前VIP等级";
        _levelLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _levelLabel;
}

- (UILabel *)livenessLabel
{
    if (_livenessLabel == nil) {
        _livenessLabel = [[UILabel alloc]init];
        _livenessLabel.textColor = COLOR_TEXT_NORMAL;
        _livenessLabel.font      = BOLDSYSTEMFONT(13);
        _livenessLabel.text      = @"月度业绩";
        _livenessLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _livenessLabel;
}

- (UIView *)bottomLine
{
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc]init];
        _bottomLine.backgroundColor = COLOR_SEPERATOR_LIGHT;
    }
    return _bottomLine;
}

@end
