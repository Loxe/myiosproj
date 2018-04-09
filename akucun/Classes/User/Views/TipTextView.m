//
//  TipTextView.m
//  akucun
//
//  Created by Jarry Z on 2018/4/4.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "TipTextView.h"

@implementation TipTextView

- (instancetype) init
{
    self = [super init];
    if (self) {
        self.backgroundColor = CLEAR_COLOR;
        
        [self addSubview:self.tipLabel];
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self).offset(3);
            make.width.equalTo(@(10));
        }];
        
        [self addSubview:self.textLabel];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self);
            make.left.equalTo(self.tipLabel.mas_right).offset(10);
        }];
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.textLabel.mas_bottom);
        }];

    }
    return self;
}

- (void) setText:(NSString *)text
{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:text];
    // 段落换行居中及默认属性
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing = 5; // 行间距
    [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    
    self.textLabel.attributedText = attStr;
}

- (void) setAttributeText:(NSAttributedString *)attrText
{
    self.textLabel.attributedText = attrText;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    
//    self.height = self.textLabel.bottom;
}

- (UILabel *) tipLabel
{
    if (_tipLabel == nil) {
        _tipLabel = [[UILabel alloc]init];
        _tipLabel.textColor = RED_COLOR;
        _tipLabel.font = FA_ICONFONTSIZE(10);
        _tipLabel.text = FA_ICONFONT_TIP;
    }
    return _tipLabel;
}

- (UILabel *) textLabel
{
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc]init];
        _textLabel.textColor = COLOR_TEXT_NORMAL;
        _textLabel.font = [FontUtils normalFont];
        _textLabel.numberOfLines = 0;
    }
    return _textLabel;
}

@end
