//
//  AddressTableCell.m
//  akucun
//
//  Created by Jarry on 2017/7/15.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "AddressTableCell.h"
#import "IconButton.h"

@interface AddressTableCell ()

@property (nonatomic, strong) UIView *seperatorLine;

@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) IconButton *editButton;
@property (nonatomic, strong) IconButton *defaultButton;
@property (nonatomic, strong) IconButton *deleteButton;

@property (nonatomic, strong) UILabel *checkLabel;

@end

@implementation AddressTableCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.backgroundColor = WHITE_COLOR;
    self.contentView.backgroundColor = CLEAR_COLOR;

    self.textLabel.textColor = COLOR_TEXT_DARK;
    self.textLabel.font = [FontUtils buttonFont];

    self.detailTextLabel.textColor = COLOR_TEXT_DARK;
    self.detailTextLabel.font = [FontUtils normalFont];

    _seperatorLine = [[UIView alloc] initWithFrame:CGRectMake(kOFFSET_SIZE, 0.0f, SCREEN_WIDTH-kOFFSET_SIZE, 0.5f)];
    _seperatorLine.backgroundColor = COLOR_SEPERATOR_LINE;
    [self.contentView addSubview:_seperatorLine];
    
    [self.contentView addSubview:self.addressLabel];
    
    [self addSubview:self.checkLabel];
    [self addSubview:self.defaultButton];
    [self addSubview:self.editButton];
//    [self addSubview:self.deleteButton];
    
    return self;
}

- (void) setAddress:(Address *)address
{
    _address = address;
    
    self.textLabel.text = address.name;
    [self.textLabel sizeToFit];
    
    self.detailTextLabel.text = [address displayMobile];
    [self.detailTextLabel sizeToFit];
    
    self.addressLabel.font = [FontUtils smallFont];
    self.addressLabel.text = [address displayAddress];
    [self.addressLabel sizeToFit];
    
    if (address.defaultflag > 0) {
//        self.deleteButton.enabled = YES;
        [self.defaultButton setNormalTitle:@"设为默认"];
        [self.defaultButton setImage:@"icon_uncheck"];
    }
    else {
//        self.deleteButton.enabled = NO;
        [self.defaultButton setNormalTitle:@"默认地址"];
        [self.defaultButton setImage:@"icon_check"];
    }
}

- (void) setCellChecked:(BOOL)cellChecked
{
    _cellChecked = cellChecked;
    
    if (cellChecked) {
        self.checkLabel.hidden = NO;
        self.textLabel.textColor = COLOR_SELECTED;
        self.detailTextLabel.textColor = COLOR_SELECTED;
        self.addressLabel.textColor = COLOR_SELECTED;
    }
    else {
        self.checkLabel.hidden = YES;
        self.textLabel.textColor = COLOR_TEXT_DARK;
        self.detailTextLabel.textColor = COLOR_TEXT_DARK;
        self.addressLabel.textColor = COLOR_TEXT_NORMAL;
    }
}

- (IBAction) editAction:(id)sender
{
    if (self.actionBlock) {
        self.actionBlock(AddrActionEdit, self.address);
    }
}

- (IBAction) defaultAction:(id)sender
{
    if (self.address.defaultflag > 0) {
        return;
    }
    if (self.actionBlock) {
        self.actionBlock(AddrActionDefault, self.address);
    }
}

- (IBAction) deleteAction:(id)sender
{
    if (self.actionBlock) {
        self.actionBlock(AddrActionDelete, self.address);
    }
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
    
    CGFloat offset = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
    self.textLabel.left = kOFFSET_SIZE;
    self.textLabel.top = offset;
    self.detailTextLabel.top = self.textLabel.top;
    self.detailTextLabel.left = self.textLabel.right + kOFFSET_SIZE;

    self.checkLabel.centerY = self.textLabel.centerY;
    self.checkLabel.right = SCREEN_WIDTH - kOFFSET_SIZE;
    
    self.addressLabel.top = self.textLabel.bottom + kOFFSET_SIZE*0.5;
    self.addressLabel.width = SCREEN_WIDTH - kOFFSET_SIZE*2;
    
    self.seperatorLine.top = self.addressLabel.bottom + offset;

//    self.contentView.frame = CGRectMake(0, 0, self.width, self.seperatorLine.bottom);

    self.defaultButton.left = self.textLabel.left;
    self.defaultButton.top = self.seperatorLine.bottom + 3;
    
//    self.deleteButton.centerY = self.defaultButton.centerY;
//    self.deleteButton.right = self.width - kOFFSET_SIZE;
    
    self.editButton.centerY = self.defaultButton.centerY;
    self.editButton.right = self.width - kOFFSET_SIZE; //self.deleteButton.left - kOFFSET_SIZE;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UILabel *) addressLabel
{
    if (!_addressLabel) {
        _addressLabel  = [[UILabel alloc] init];
        _addressLabel.backgroundColor = CLEAR_COLOR;
        _addressLabel.left = kOFFSET_SIZE;
        _addressLabel.textColor = COLOR_TEXT_NORMAL;
        _addressLabel.font = [FontUtils smallFont];
        _addressLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _addressLabel;
}

- (IconButton *) editButton
{
    if (!_editButton) {
        _editButton = [[IconButton alloc] initWithFrame:CGRectMake(0, 0, 48, 40)];
        [_editButton setTitleFont:[FontUtils smallFont]];
        [_editButton setTitle:@"编辑" icon:FA_ICONFONT_EDIT];
        
        [_editButton addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editButton;
}

- (IconButton *) defaultButton
{
    if (!_defaultButton) {
        _defaultButton = [[IconButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
        [_defaultButton setTitleFont:[FontUtils smallFont]];
        [_defaultButton setNormalTitle:@"设为默认"];
        [_defaultButton setImage:@"icon_check"];
        [_defaultButton setImageSize:15.0f];
        
        [_defaultButton addTarget:self action:@selector(defaultAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _defaultButton;
}

- (IconButton *) deleteButton
{
    if (!_deleteButton) {
        _deleteButton = [[IconButton alloc] initWithFrame:CGRectMake(0, 0, 48, 40)];
        [_deleteButton setTitleFont:[FontUtils smallFont]];
        [_deleteButton setTitle:@"删除" icon:FA_ICONFONT_DELETE];
        
        [_deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

- (UILabel *) checkLabel
{
    if (!_checkLabel) {
        _checkLabel = [[UILabel alloc] init];
        _checkLabel.textColor = COLOR_SELECTED;
        _checkLabel.font = FA_ICONFONTSIZE(20);
        _checkLabel.text = FA_ICONFONT_SELECT;
        [_checkLabel sizeToFit];
        _checkLabel.hidden = YES;
    }
    return _checkLabel;
}

@end
