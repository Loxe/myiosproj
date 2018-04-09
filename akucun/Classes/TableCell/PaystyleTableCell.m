//
//  PaystyleTableCell.m
//  akucun
//
//  Created by Jarry on 2017/5/3.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "PaystyleTableCell.h"

@interface PaystyleTableCell ()

@property (nonatomic, strong) UIImageView *checkImage;

@end

@implementation PaystyleTableCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    self.textLabel.font = [FontUtils buttonFont];
    self.detailTextLabel.textColor = COLOR_TEXT_LIGHT;
    self.detailTextLabel.font = SYSTEMFONT(12);

    self.imageView.size = CGSizeMake(30, 30);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.contentView addSubview:self.checkImage];

    return self;
}

- (void) setChecked:(BOOL)checked
{
    self.checkImage.image = checked ? IMAGENAMED(@"icon_check") : IMAGENAMED(@"icon_uncheck");
}

- (void) setSelectionDisabled:(BOOL)selectionDisabled
{
    [super setSelectionDisabled:selectionDisabled];
    
    self.checkImage.alpha = selectionDisabled ? .2f : 1.0f;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.seperatorLine.top = self.height - 1.0f;

    self.imageView.left = kOFFSET_SIZE;

//    CGFloat offset = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE*0.6;
    CGFloat centerY = self.height*0.5f;
    self.textLabel.centerY = centerY-10;
    self.textLabel.left = self.imageView.right + kOFFSET_SIZE*0.8;
    
    self.detailTextLabel.centerY = centerY+10;
    self.detailTextLabel.left = self.textLabel.left;
    
    self.checkImage.right = self.width - kOFFSET_SIZE;
    self.checkImage.centerY = centerY;
}

- (UIImageView *) checkImage
{
    if (!_checkImage) {
        _checkImage = [[UIImageView alloc] init];
        _checkImage.frame = CGRectMake(0, 0, 16, 16);
        _checkImage.contentMode = UIViewContentModeScaleAspectFit;
        _checkImage.image = IMAGENAMED(@"icon_uncheck");
//        _checkImage.alpha = 0.0f;
    }
    return _checkImage;
}

@end
