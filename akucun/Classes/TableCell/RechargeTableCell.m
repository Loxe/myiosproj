//
//  RechargeTableCell.m
//  akucun
//
//  Created by Jarry on 2017/9/17.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RechargeTableCell.h"

@interface RechargeTableCell ()

@property (nonatomic, strong) UILabel *titleLabel, *despLabel, *priceLabel;
@property (nonatomic, strong) UILabel *checkedLabel;

@end

@implementation RechargeTableCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = RGBCOLOR(0xF9, 0xF9, 0xF9);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.layer.borderColor = COLOR_SEPERATOR_LIGHT.CGColor;
        self.layer.borderWidth = 2.0f;
        
        [self initContent];
    }
    return self;
}

- (void) initContent
{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.despLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.checkedLabel];
}

- (void) setRechargeItem:(RechargeItem *)rechargeItem
{
    _rechargeItem = rechargeItem;
    
    self.titleLabel.text = rechargeItem.title;
    [self.titleLabel sizeToFit];
    
    self.despLabel.text = rechargeItem.content;
    [self.despLabel sizeToFit];
    
    self.priceLabel.text = FORMAT(@"¥ %ld", (long)rechargeItem.payjine);
    [self.priceLabel sizeToFit];
    
    [self setNeedsLayout];
}

- (void) setCellSelected:(BOOL)cellSelected
{
    _cellSelected = cellSelected;
    
    if (cellSelected) {
        self.checkedLabel.hidden = NO;
        self.layer.borderColor = COLOR_SELECTED.CGColor;
        self.layer.borderWidth = 2.0f;
    }
    else {
        self.checkedLabel.hidden = YES;
        self.layer.borderColor = COLOR_SEPERATOR_LINE.CGColor;
        self.layer.borderWidth = 1.0f;
    }
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.left = kOFFSET_SIZE;
    self.despLabel.left = kOFFSET_SIZE;
    
    CGFloat top = kOFFSET_SIZE;
    if (self.despLabel.text.length > 0) {
        self.titleLabel.top = top;
        self.despLabel.top = self.titleLabel.bottom + 10.0f;
    }
    else {
        self.titleLabel.centerY = self.height*0.5f;
    }
    
    self.checkedLabel.right = self.width;
        
    self.priceLabel.right = self.width - kOFFSET_SIZE;
    self.priceLabel.centerY = self.height * 0.5;
}

- (void) drawRect:(CGRect)rect
{
    if (self.cellSelected) {
        CGFloat width = kOFFSET_SIZE * 1.8;
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextMoveToPoint(context, self.bounds.size.width, 0);
        CGContextAddLineToPoint(context, self.bounds.size.width, width);
        CGContextAddLineToPoint(context, self.bounds.size.width - width, 0);
        CGContextSetFillColorWithColor(context, COLOR_SELECTED.CGColor);
        CGContextFillPath(context);
    }
}

- (UILabel *) titleLabel
{
    if (!_titleLabel) {
        _titleLabel  = [[UILabel alloc] init];
        _titleLabel.backgroundColor = CLEAR_COLOR;
        _titleLabel.textColor = COLOR_TEXT_DARK;
        _titleLabel.font = BOLDSYSTEMFONT(16);
    }
    return _titleLabel;
}

- (UILabel *) despLabel
{
    if (!_despLabel) {
        _despLabel  = [[UILabel alloc] init];
        _despLabel.backgroundColor = CLEAR_COLOR;
        _despLabel.textColor = COLOR_SELECTED;
        _despLabel.font = [FontUtils smallFont];
    }
    return _despLabel;
}

- (UILabel *) priceLabel
{
    if (!_priceLabel) {
        _priceLabel  = [[UILabel alloc] init];
        _priceLabel.backgroundColor = CLEAR_COLOR;
        _priceLabel.textColor = COLOR_SELECTED;
        _priceLabel.font = BOLDSYSTEMFONT(18);
    }
    return _priceLabel;
}

- (UILabel *) checkedLabel
{
    if (!_checkedLabel) {
        CGFloat width = kOFFSET_SIZE;
        _checkedLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        _checkedLabel.backgroundColor = CLEAR_COLOR;
        _checkedLabel.textColor = WHITE_COLOR;
        _checkedLabel.font = ICON_FONT(14);
        _checkedLabel.text = @"\ue5ca"; //kIconChecked;
    }
    return _checkedLabel;
}

@end
