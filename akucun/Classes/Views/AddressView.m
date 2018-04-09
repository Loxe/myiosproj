//
//  AddressView.m
//  akucun
//
//  Created by Jarry on 2017/4/21.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "AddressView.h"

@implementation AddressView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.backgroundColor = CLEAR_COLOR;
    
    self.width = SCREEN_WIDTH;
    
    [self addSubview:self.nameLabel];
    [self addSubview:self.mobileLabel];
    [self addSubview:self.addressLabel];
    [self addSubview:self.titleLabel];
    [self addSubview:self.editButton];
    [self addSubview:self.defaultLabel];
//    [self addSubview:self.defaultButton];
//    [self addSubview:self.deleteButton];

    _lineView = [[UIView alloc] initWithFrame:CGRectMake(kOFFSET_SIZE, 0.0f, SCREEN_WIDTH-kOFFSET_SIZE, 0.5f)];
    _lineView.backgroundColor = COLOR_SEPERATOR_LIGHT;
    [self addSubview:_lineView];
    
    self.address = nil;
    
    return self;
}

- (void) setAddress:(Address *)address
{
    _address = address;
    if (address) {
        self.nameLabel.hidden = NO;
        self.mobileLabel.hidden = NO;
        
        self.nameLabel.text = address.name;
        [self.nameLabel sizeToFit];
        
        self.mobileLabel.text = [address displayMobile];
        [self.mobileLabel sizeToFit];
        
        self.addressLabel.font = [FontUtils smallFont];
        self.addressLabel.text = [address displayAddress];
        [self.addressLabel sizeToFit];
        
        [self.editButton setTitle:@"编辑" icon:FA_ICONFONT_EDIT];
        
        self.defaultLabel.hidden = (address.defaultflag == 0);
    }
    else {
        self.nameLabel.hidden = NO;
        self.mobileLabel.hidden = NO;
        self.addressLabel.font = [FontUtils normalFont];
        [self.addressLabel sizeToFit];
        [self.editButton setTitle:@"新建" icon:FA_ICONFONT_ADD];
        self.defaultLabel.hidden = YES;
    }
    
    [self setNeedsLayout];
}

- (void) setLogistics:(Logistics *)logistics
{
    _logistics = logistics;
    
    self.nameLabel.hidden = NO;
    self.mobileLabel.hidden = NO;
    
    self.nameLabel.text = logistics.shouhuoren;
    [self.nameLabel sizeToFit];
    
    self.mobileLabel.text = [logistics displayMobile];
    [self.mobileLabel sizeToFit];
    
    self.addressLabel.font = [FontUtils smallFont];
    self.addressLabel.text = logistics.shouhuodizhi;
    [self.addressLabel sizeToFit];
    
    self.defaultLabel.hidden = YES;
    
    [self setNeedsLayout];
}

- (IBAction) editAction:(id)sender
{
    if (self.actionBlock) {
        self.actionBlock();
    }
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    [self updateLayout];
}

- (void) updateLayout
{
    CGFloat offset = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
    self.nameLabel.top = offset;
    self.mobileLabel.top = self.nameLabel.top;
    self.mobileLabel.left = self.nameLabel.right + kOFFSET_SIZE;
    
    self.defaultLabel.left = self.mobileLabel.right + 10;
    self.defaultLabel.centerY = self.nameLabel.centerY;
    
    CGFloat top = kOFFSET_SIZE;
    if (self.address || self.logistics) {
        top = self.nameLabel.bottom + offset*0.5;
    }
    self.addressLabel.top = top;
    self.addressLabel.width = SCREEN_WIDTH - kOFFSET_SIZE*2;
    
    self.lineView.top = self.addressLabel.bottom + offset;
    self.titleLabel.top = self.lineView.bottom + offset*0.6f;
    self.editButton.centerY = self.titleLabel.centerY;
    self.editButton.right = self.width - kOFFSET_SIZE;

//    self.defaultButton.left = self.titleLabel.left;
//    self.defaultButton.centerY = self.titleLabel.centerY;
//
//    self.deleteButton.centerY = self.titleLabel.centerY;
//    self.deleteButton.right = self.width - kOFFSET_SIZE;
    
    self.height = self.titleLabel.bottom + offset*0.6f;
}

- (UILabel *) nameLabel
{
    if (!_nameLabel) {
        _nameLabel  = [[UILabel alloc] init];
        _nameLabel.backgroundColor = CLEAR_COLOR;
        _nameLabel.left = kOFFSET_SIZE;
        _nameLabel.textColor = COLOR_TEXT_DARK;
        _nameLabel.font = [FontUtils buttonFont];
        _nameLabel.text = @"Name";
    }
    return _nameLabel;
}

- (UILabel *) mobileLabel
{
    if (!_mobileLabel) {
        _mobileLabel  = [[UILabel alloc] init];
        _mobileLabel.backgroundColor = CLEAR_COLOR;
        _mobileLabel.textColor = COLOR_TEXT_DARK;
        _mobileLabel.font = [FontUtils normalFont];
    }
    return _mobileLabel;
}

- (UILabel *) addressLabel
{
    if (!_addressLabel) {
        _addressLabel  = [[UILabel alloc] init];
        _addressLabel.backgroundColor = CLEAR_COLOR;
        _addressLabel.left = kOFFSET_SIZE;
        _addressLabel.textColor = COLOR_TEXT_NORMAL;
        _addressLabel.font = [FontUtils smallFont];
        _addressLabel.text = @"请添加你的收货地址";
        //        _addressLabel.numberOfLines = 0;
        _addressLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_addressLabel sizeToFit];
    }
    return _addressLabel;
}

- (UILabel *) titleLabel
{
    if (!_titleLabel) {
        _titleLabel  = [[UILabel alloc] init];
        _titleLabel.backgroundColor = CLEAR_COLOR;
        _titleLabel.left = kOFFSET_SIZE;
        _titleLabel.textColor = COLOR_TEXT_NORMAL;
        _titleLabel.font = [FontUtils smallFont];
        _titleLabel.text = @"收货地址";
        
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (IconButton *) editButton
{
    if (!_editButton) {
        _editButton = [[IconButton alloc] initWithFrame:CGRectMake(0, 0, 48, 40)];
        [_editButton setTitleFont:[FontUtils smallFont]];
        [_editButton setTitle:@"新建" icon:FA_ICONFONT_ADD];
        
        [_editButton addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editButton;
}

- (UILabel *) defaultLabel
{
    if (!_defaultLabel) {
        _defaultLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 15)];
        _defaultLabel.backgroundColor = CLEAR_COLOR;
        
        _defaultLabel.clipsToBounds = YES;
        _defaultLabel.layer.cornerRadius = 3.0f;
        _defaultLabel.layer.borderColor = COLOR_SELECTED.CGColor;
        _defaultLabel.layer.borderWidth = 1.0f;
        
        _defaultLabel.textColor = COLOR_SELECTED;
        _defaultLabel.font = SYSTEMFONT(10);
        _defaultLabel.textAlignment = NSTextAlignmentCenter;
        _defaultLabel.text = @"默认";
    }
    return _defaultLabel;
}
/*
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
*/
@end
