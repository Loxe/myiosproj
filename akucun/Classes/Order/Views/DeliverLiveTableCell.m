//
//  DeliverLiveTableCell.m
//  akucun
//
//  Created by Jarry Z on 2018/4/12.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "DeliverLiveTableCell.h"
#import "TextButton.h"

@interface DeliverLiveTableCell ()

@property (nonatomic, strong) UIView *liveView;
@property (nonatomic, strong) TextButton* accessoryButton;
@property (nonatomic, strong) UIButton *previewButton;
@property (nonatomic, strong) UIButton *scanButton;
//@property (nonatomic, copy) NSString *logoUrl;

@end

@implementation DeliverLiveTableCell

- (void) setupContent
{
    self.textLabel.font = BOLDSYSTEMFONT(15);
    self.textLabel.textColor = COLOR_TEXT_DARK;
    
    [self.contentView addSubview:self.logoImage];
    [self.contentView addSubview:self.accessoryButton];
    [self.contentView addSubview:self.adorderLabel];
    [self.contentView addSubview:self.totalLabel];
    [self.contentView addSubview:self.scanedLabel];
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.previewButton];
    [self.contentView addSubview:self.scanButton];

    self.seperatorLine.backgroundColor = COLOR_SEPERATOR_LINE;
    self.liveView = [[UIView alloc] initWithFrame:CGRectMake(kOFFSET_SIZE, 0, SCREEN_WIDTH-kOFFSET_SIZE, kPIXEL_WIDTH)];
    self.liveView.backgroundColor = COLOR_SEPERATOR_LIGHT;
    [self.contentView addSubview:self.liveView];
}

- (void) setLiveInfo:(LiveInfo *)liveInfo
{
    _liveInfo = liveInfo;
    
    NSString *logoUrl = liveInfo.pinpaiurl;
    [self.logoImage sd_setImageWithURL:[NSURL URLWithString:logoUrl] placeholderImage:nil options:SDWebImageDelayPlaceholder];
    
    self.textLabel.text = liveInfo.pinpaiming;
    
    self.scanedLabel.hidden = (self.type == 1);
    
    self.adorderLabel.text = FORMAT(@"发货单数：%ld", (long)liveInfo.adcount);
    self.totalLabel.text = FORMAT(@"商品总计：%ld 件", (long)liveInfo.prosum);
    NSInteger noscanCount = liveInfo.prosum-liveInfo.scancount;
    self.scanedLabel.text = FORMAT(@"未分拣：%ld 件", (long)(noscanCount));
    self.scanedLabel.textColor = (noscanCount>0) ? COLOR_MAIN : COLOR_TEXT_NORMAL;
    
    self.dateLabel.text = @"结束日期：2018年4月8日";
    
    [self.adorderLabel sizeToFit];
    [self.totalLabel sizeToFit];
    [self.scanedLabel sizeToFit];
    [self.dateLabel sizeToFit];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.seperatorLine.left = 0;
    self.seperatorLine.width = SCREEN_WIDTH;
    
    self.textLabel.centerY = self.logoImage.centerY;
    self.textLabel.left = self.logoImage.right + kOFFSET_SIZE*0.5f;
    
    self.accessoryButton.centerY = self.logoImage.centerY;
    self.accessoryButton.right = SCREEN_WIDTH;
    
    self.adorderLabel.left = self.logoImage.left;
    self.adorderLabel.top = self.logoImage.bottom + 10;
    self.totalLabel.left = self.adorderLabel.right + kOFFSET_SIZE;
    self.totalLabel.top = self.adorderLabel.top;
    self.scanedLabel.right = SCREEN_WIDTH - kOFFSET_SIZE;
    self.scanedLabel.top = self.adorderLabel.top;
    
    self.liveView.top = self.adorderLabel.bottom + 10;

    CGFloat offset = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
    self.previewButton.right = self.scanedLabel.right;
    self.previewButton.bottom = self.height - offset;
    self.scanButton.right = self.previewButton.left - 10;
    self.scanButton.bottom = self.previewButton.bottom;

    self.dateLabel.left = self.logoImage.left;
    self.dateLabel.centerY = self.previewButton.centerY;
}

- (IBAction) previewAction:(id)sender
{
    
}

- (IBAction) scanAction:(id)sender
{
    
}

#pragma mark - Views

- (UIImageView *) logoImage
{
    if (!_logoImage) {
        CGFloat top = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
        _logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(kOFFSET_SIZE, top, 20, 20)];
        _logoImage.backgroundColor = COLOR_BG_LIGHTGRAY;
        _logoImage.contentMode = UIViewContentModeScaleAspectFit;
        _logoImage.clipsToBounds = YES;
        
        _logoImage.layer.cornerRadius = 3.0f;
        _logoImage.layer.borderColor = COLOR_SEPERATOR_LIGHT.CGColor;
        _logoImage.layer.borderWidth = 0.2f;
    }
    return _logoImage;
}

- (UILabel *) adorderLabel
{
    if (!_adorderLabel) {
        _adorderLabel = [[UILabel alloc] init];
        _adorderLabel.font = [FontUtils smallFont];
        _adorderLabel.textColor = COLOR_TEXT_NORMAL;
    }
    return _adorderLabel;
}

- (UILabel *) totalLabel
{
    if (!_totalLabel) {
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.font = [FontUtils smallFont];
        _totalLabel.textColor = COLOR_TEXT_NORMAL;
    }
    return _totalLabel;
}

- (UILabel *) scanedLabel
{
    if (!_scanedLabel) {
        _scanedLabel = [[UILabel alloc] init];
        _scanedLabel.font = [FontUtils smallFont];
        _scanedLabel.textColor = COLOR_TEXT_NORMAL;
    }
    return _scanedLabel;
}

- (UILabel *) dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = SYSTEMFONT(12);
        _dateLabel.textColor = LIGHTGRAY_COLOR;
    }
    return _dateLabel;
}

- (UIButton *) previewButton
{
    if (_previewButton) {
        return _previewButton;
    }
    _previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _previewButton.frame = CGRectMake(0, 0, 60, 24);
    _previewButton.backgroundColor = COLOR_BG_BUTTON;
    _previewButton.layer.masksToBounds = NO;
    _previewButton.layer.cornerRadius = 3.0f;
    _previewButton.titleLabel.font = [FontUtils smallFont];
    [_previewButton setNormalTitle:@"对账单"];
    [_previewButton setNormalColor:WHITE_COLOR highlighted:GRAY_COLOR selected:nil];
    
    [_previewButton addTarget:self action:@selector(previewAction:)
             forControlEvents:UIControlEventTouchUpInside];
        
    return _previewButton;
}

- (UIButton *) scanButton
{
    if (_scanButton) {
        return _scanButton;
    }
    _scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _scanButton.frame = CGRectMake(0, 0, 60, 24);
    _scanButton.backgroundColor = WHITE_COLOR;
    _scanButton.layer.masksToBounds = NO;
    _scanButton.layer.cornerRadius = 3.0f;
    _scanButton.layer.borderWidth = 0.5f;
    _scanButton.layer.borderColor = COLOR_SELECTED.CGColor;
    
    _scanButton.titleLabel.font = [FontUtils smallFont];
    [_scanButton setNormalTitle:@"扫码分拣"];
    [_scanButton setNormalColor:COLOR_SELECTED highlighted:COLOR_TEXT_NORMAL selected:nil];
    
    [_scanButton addTarget:self action:@selector(scanAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
    return _scanButton;
}

- (TextButton *) accessoryButton
{
    if (!_accessoryButton) {
        _accessoryButton = [TextButton buttonWithType:UIButtonTypeCustom];
        _accessoryButton.frame = CGRectMake(0, 0, 60, 20);
        _accessoryButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kOFFSET_SIZE);
        
        [_accessoryButton setTitleFont:FA_ICONFONTSIZE(20)];
        [_accessoryButton setTitleAlignment:NSTextAlignmentRight];
        
        [_accessoryButton setTitle:FA_ICONFONT_RIGHT forState:UIControlStateNormal];
        [_accessoryButton setTitleColor:COLOR_TEXT_LIGHT forState:UIControlStateNormal];
        
        _accessoryButton.enabled = NO;
    }
    return _accessoryButton;
}

@end
