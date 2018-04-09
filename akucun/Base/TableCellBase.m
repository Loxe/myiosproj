//
//  TableCellBase.m
//  J1ST-System
//
//  Created by Jarry on 16/11/30.
//  Copyright © 2016年 Zenin-tech. All rights reserved.
//

#import "TableCellBase.h"

@interface TableCellBase ()


@end

@implementation TableCellBase

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.backgroundColor = WHITE_COLOR;
    self.contentView.backgroundColor = CLEAR_COLOR;
    self.textLabel.backgroundColor = CLEAR_COLOR;
    self.textLabel.textColor = COLOR_TEXT_DARK;
    self.textLabel.font = [FontUtils normalFont];
    
    self.detailTextLabel.backgroundColor = CLEAR_COLOR;
    self.detailTextLabel.textColor = COLOR_TEXT_NORMAL;
    self.detailTextLabel.font = [FontUtils normalFont];
    self.detailTextLabel.adjustsFontSizeToFitWidth = YES;

    _seperatorLine = [[UIView alloc] initWithFrame:CGRectMake(kOFFSET_SIZE, kTableCellHeight-1.0f, SCREEN_WIDTH-kOFFSET_SIZE, kPIXEL_WIDTH)];
    _seperatorLine.backgroundColor = COLOR_SEPERATOR_LIGHT;
    _seperatorLine.alpha = 0.0f;
    [self.contentView addSubview:_seperatorLine];
    
    self.showSeperator = YES;
    
    return self;
}

- (void) setIsSubcellStyle:(BOOL)isSubcellStyle
{
    _isSubcellStyle = isSubcellStyle;
    
    if (isSubcellStyle) {
        self.contentView.backgroundColor = COLOR_HEX(@"0xF0F0F0");
        self.textLabel.textColor = COLOR_TEXT_NORMAL;
    }
}

- (void) setShowSeperator:(BOOL)showSeperator
{
    _showSeperator = showSeperator;
    self.seperatorLine.alpha = showSeperator ? 1.0f : 0.0f;
}

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (self.selectionDisabled) {
        return;
    }
    self.backgroundColor = highlighted ? RGBCOLOR(0xF4, 0xF4, 0xF4) : WHITE_COLOR;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    if (self.isSubcellStyle) {
        self.contentView.left = kOFFSET_SIZE;
    }
    
    self.textLabel.left = kOFFSET_SIZE;
    self.detailTextLabel.right = SCREEN_WIDTH-kOFFSET_SIZE*2;
    self.accessoryView.right = SCREEN_WIDTH-kOFFSET_SIZE;
    if (self.accessoryType == UITableViewCellAccessoryNone) {
        self.detailTextLabel.right = SCREEN_WIDTH-kOFFSET_SIZE;
    }
    
    self.seperatorLine.bottom = self.height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
