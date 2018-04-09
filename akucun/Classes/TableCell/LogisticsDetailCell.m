//
//  LogisticsDetailCell.m
//  akucun
//
//  Created by deepin do on 2017/12/7.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "LogisticsDetailCell.h"
#import "NSAttributedString+YYText.h"

@implementation LogisticsDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
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

- (void)setupUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    CGFloat offset = kOFFSET_SIZE;
    [self.contentView addSubview:self.infoLabel];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(offset);
        make.left.equalTo(self.contentView).offset(offset*2+20);
        make.right.equalTo(self.contentView).offset(-offset);
    }];
    
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoLabel.mas_bottom).offset(offset*0.5);
        make.left.equalTo(self.infoLabel);
    }];
    
    [self.contentView addSubview:self.topLine];
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.centerX.equalTo(self.contentView.mas_left).offset(offset+10);
        make.height.equalTo(@(offset+10));
        make.width.equalTo(@1);
    }];
    
    [self.contentView addSubview:self.bottomLine];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topLine.mas_bottom);
        make.bottom.equalTo(self.contentView);
        make.centerX.equalTo(self.contentView.mas_left).offset(offset+10);
        make.width.equalTo(@1);
    }];
    
    [self.contentView addSubview:self.sepLine];
    [self.sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.contentView);
        make.left.equalTo(self.infoLabel);
        make.height.equalTo(@(kPIXEL_WIDTH));
    }];
    
    [self.contentView addSubview:self.blackPoint];
    [self.blackPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_top).offset(offset+10);
        make.centerX.equalTo(self.contentView.mas_left).offset(offset+10);
        make.width.height.equalTo(@8);
    }];
    
    [self.contentView addSubview:self.redPoint];
    [self.redPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_top).offset(offset+10);
        make.centerX.equalTo(self.contentView.mas_left).offset(offset+10);
        make.width.height.equalTo(@12);
    }];
    
    [self.redPoint setHidden:YES];
}

- (void)setLogisticsInfo:(LogisticsInfo *)logisticsInfo
{
    self.infoLabel.textColor = COLOR_TEXT_NORMAL;
    self.infoLabel.text = logisticsInfo.content;
    self.timeLabel.text = logisticsInfo.time;
    
    [self distinguishPhoneNumLabel:self.infoLabel labelStr:logisticsInfo.content];
}

-(void)distinguishPhoneNumLabel:(YYLabel *)label labelStr:(NSString *)labelStr
{
    //获取字符串中的电话号码
    NSString *regulaStr = @"\\d{3,4}[- ]?\\d{7,8}";
    NSRange stringRange = NSMakeRange(0, labelStr.length);
    //正则匹配
    NSError *error;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:labelStr];
    str.yy_font = [FontUtils normalFont];
    str.yy_color = COLOR_TEXT_NORMAL;
    NSRegularExpression *regexps = [NSRegularExpression regularExpressionWithPattern:regulaStr options:0 error:&error];
    if (!error && regexps != nil) {
        @weakify(self)
        [regexps enumerateMatchesInString:labelStr options:0 range:stringRange usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            
            NSRange phoneRange = result.range;
            NSString *phone = [str attributedSubstringFromRange:phoneRange].string;
            [str yy_setTextHighlightRange:phoneRange color:COLOR_APP_BLUE backgroundColor:CLEAR_COLOR tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                @strongify(self)
                if (self.phoneBlock) {
                    self.phoneBlock(phone);
                }
            }];
            
            label.attributedText = str;
        }];
    }
}

#pragma mark - Lazy
- (UIView *)topLine {
    
    if (_topLine == nil) {
        _topLine = [[UIView alloc]init];
        _topLine.backgroundColor = COLOR_SEPERATOR_LINE;
    }
    return _topLine;
}

- (UIView *)blackPoint {
    
    if (_blackPoint == nil) {
        _blackPoint = [[UIView alloc]init];
        _blackPoint.backgroundColor = COLOR_SEPERATOR_LINE;
        _blackPoint.layer.cornerRadius = 4;
        _blackPoint.layer.masksToBounds = YES;
    }
    return _blackPoint;
}

- (UIView *)redPoint {
    
    if (_redPoint == nil) {
        _redPoint = [[UIView alloc]init];
        _redPoint.backgroundColor = RED_COLOR;
        _redPoint.layer.cornerRadius = 6;
        _redPoint.layer.masksToBounds = YES;
    }
    return _redPoint;
}

- (UIView *)bottomLine {
    
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc]init];
        _bottomLine.backgroundColor = COLOR_SEPERATOR_LINE;
    }
    return _bottomLine;
}

- (YYLabel *)infoLabel {
    
    if (_infoLabel == nil) {
        _infoLabel = [[YYLabel alloc]init];
        _infoLabel.text = @"";
        _infoLabel.font = [FontUtils normalFont];
        _infoLabel.textAlignment = NSTextAlignmentLeft;
        _infoLabel.textColor = COLOR_TEXT_NORMAL;
        _infoLabel.numberOfLines = 0;
        _infoLabel.preferredMaxLayoutWidth = SCREEN_WIDTH-(kOFFSET_SIZE*3+20);
    }
    return _infoLabel;
}

- (UILabel *)timeLabel {
    
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.text = @"";
        _timeLabel.font = [FontUtils smallFont];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = COLOR_TEXT_LIGHT;
    }
    return _timeLabel;
}

- (UIView *)sepLine {
    
    if (_sepLine == nil) {
        _sepLine = [[UIView alloc]init];
        _sepLine.backgroundColor = COLOR_SEPERATOR_LIGHT;
    }
    return _sepLine;
}

@end
