//
//  LiveTableCell.m
//  akucun
//
//  Created by Jarry on 2017/7/1.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "LiveTableCell.h"
#import "LWAsyncDisplayView.h"
#import "LWImageBrowser.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "CountDownView.h"
#import "SCImageView.h"

@interface LiveTableCell ()

@property (nonatomic, strong) SCImageView *logoImage;
@property (nonatomic, strong) UIImageView *vipIconView;
@property (nonatomic, strong) UIImageView *qiangImageView;
@property (nonatomic, strong) UILabel *newLabel;

@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, strong) NSMutableArray* imagePostions;
@property (nonatomic, strong) NSMutableArray *imageUrls;

@property (nonatomic, copy) NSString *logoUrl;

@property (nonatomic, strong) UIButton *forwardButton;
@property (nonatomic, strong) UIButton *pinpaiButton;

@property (nonatomic, strong) CountDownView *statusView;

@property (nonatomic, strong) UILabel *endTextLabel, *endTimeLabel;

@end

@implementation LiveTableCell

- (void) dealloc
{
    [self.statusView cancelTimer];
}

- (void) updateData
{
    YugaoCellLayout *cellLayout = (YugaoCellLayout *)self.cellLayout;
    NSArray *images = [cellLayout.model imagesUrl];
//    NSInteger index = 0;
//    for (NSString *item in images) {
    for (int i = 0; i < 9; i ++) {
        SCImageView *imageView = self.imageViews[i];
        if (i >= images.count) {
            imageView.alpha = 0.0f;
            continue;
        }
//        imageView.alpha = 1.0f;
        NSString *item = images[i];
        NSString *imageUrl = [item stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (imageUrl.length == 0) {
            break;
        }
        if (![imageUrl isEqualToString:self.imageUrls[i]]) {
            [imageView setImage:nil];
        }
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil options:SDWebImageDelayPlaceholder];
        [self.imageUrls replaceObjectAtIndex:i withObject:imageUrl];
    }
    
    NSString *logoUrl = cellLayout.model.pinpaiurl;
    if (logoUrl && logoUrl.length > 0) {
        if (![self.logoUrl isEqualToString:logoUrl]) {
            [self.logoImage setImage:nil];
        }
        [self.logoImage sd_setImageWithURL:[NSURL URLWithString:logoUrl] placeholderImage:nil options:SDWebImageDelayPlaceholder];
        self.logoUrl = logoUrl;
    }
    
    //
    self.vipIconView.image = nil;
    NSInteger levelFlag = [cellLayout.model levelFlag];
    if (levelFlag > 0) {
        NSString *imgName = FORMAT(@"icon_vip%ld",(long)levelFlag);
        self.vipIconView.image = IMAGENAMED(imgName);
    }

    //
    LiveInfo *liveInfo = cellLayout.model;
    NSTimeInterval now = [NSDate timeIntervalValue];
    @weakify(self)
    if (liveInfo.begintimestamp > now) {
        self.statusView.title = @"即将开始";
        self.statusView.liveTime = liveInfo.begintimestamp;
        self.statusView.timeoutBlock = ^{
            @strongify(self)
            self.statusView.title = @"距活动结束";
            self.statusView.liveTime = liveInfo.endtimestamp;
            [self customLayoutViews];
        };
    }
    else if (liveInfo.endtimestamp > now) {
        self.statusView.title = @"距活动结束";
        self.statusView.liveTime = liveInfo.endtimestamp;
        self.statusView.timeoutBlock = ^{
            @strongify(self)
            self.statusView.title = @"活动已结束";
//            self.statusView.liveTime = liveInfo.endtimestamp;
            [self customLayoutViews];
        };
    }
    else {
        self.statusView.title = @"活动已结束";
        self.statusView.liveTime = liveInfo.endtimestamp;
    }
    
    NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:liveInfo.endtimestamp];
    NSString *dateString = [dateTime formattedDateWithFormatString:@"MM/dd HH:mm"];
    self.endTimeLabel.text = dateString;
    [self.endTimeLabel sizeToFit];
    
}

- (void) initContent
{
    [self.contentView addSubview:self.logoImage];
    [self.contentView addSubview:self.newLabel];
    [self.contentView addSubview:self.vipIconView];
    [self.contentView addSubview:self.qiangImageView];

    self.imageViews = [NSMutableArray array];
    self.imageUrls = [NSMutableArray array];
    self.imagePostions = [NSMutableArray array];
    for (int i = 0; i < 9; i ++) {
        SCImageView *imageView = [self imageViewAt:i];
        [self.contentView addSubview:imageView];
        [self.imageViews addObject:imageView];
        [self.imageUrls addObject:@""];
    }
    
    [self.contentView addSubview:self.statusView];
    [self.contentView addSubview:self.forwardButton];
    [self.contentView addSubview:self.pinpaiButton];
    [self.contentView addSubview:self.endTextLabel];
    [self.contentView addSubview:self.endTimeLabel];
}

- (void) customLayoutViews
{
    [self.imagePostions removeAllObjects];
    YugaoCellLayout *cellLayout = (YugaoCellLayout *)self.cellLayout;
    NSInteger imgCount = cellLayout.model.imagesUrl.count;
    CGFloat imageWidth = cellLayout.imageWidth;
    CGFloat left = cellLayout.imagesRect.origin.x;
    CGFloat top = cellLayout.imagesRect.origin.y;
    CGFloat height = cellLayout.imagesRect.size.height;
    NSInteger row = 0;
    NSInteger column = 0;
    for (int i = 0; i < 9; i ++) {
        SCImageView *imageView = self.imageViews[i];
        if (i >= imgCount) {
            imageView.alpha = 0.0f;
            continue;
        }
        CGRect imageRect = CGRectMake(left + (column * (imageWidth + 5.0f)), top + (row * (imageWidth + 5.0f)), imageWidth, imageWidth);
        imageView.frame = imageRect;
        NSString* imagePositionString = NSStringFromCGRect(imageRect);
        [self.imagePostions addObject:imagePositionString];
        column ++;
        if (imgCount <= 4 && column > 1) {
            column = 0;
            row ++;
        }
        else if (column > 2) {
            column = 0;
            row ++;
        }
        imageView.alpha = 1.0f;
    }
    
    if (imgCount <= 4) {
        self.statusView.left = left + imageWidth*2 + 5.0 + kOFFSET_SIZE;
        self.statusView.bottom = top + imageWidth*2 + 5.0;
    }
    else {
        self.statusView.left = left;
        self.statusView.top = top + height + 8.0f;
    }
    self.statusView.width = SCREEN_WIDTH - self.statusView.left - kOFFSET_SIZE;
    self.statusView.hidden = NO;
    
    self.forwardButton.top = cellLayout.menuPosition;
    self.forwardButton.right = SCREEN_WIDTH - kOFFSET_SIZE;
    self.forwardButton.hidden = NO;
    
    if (self.showPinpai) {
        self.pinpaiButton.top = cellLayout.menuPosition;
        self.pinpaiButton.right = self.forwardButton.left - kOFFSET_SIZE*0.5;
        self.pinpaiButton.hidden = NO;
    }
    
    if (isPad) {
        self.statusView.left = self.forwardButton.left - kOFFSET_SIZE - 90;
    }
    
    if (imgCount <= 4) {
        self.endTimeLabel.left = self.statusView.left;
        self.endTimeLabel.bottom = self.statusView.top - kOFFSET_SIZE;
        self.endTextLabel.left = self.endTimeLabel.left;
        self.endTextLabel.bottom = self.endTimeLabel.top - 1.0f;
    }
    else {
        self.endTimeLabel.left = left + imageWidth*2 + 10.0;
        self.endTextLabel.left = self.endTimeLabel.left;
        self.endTextLabel.top = self.statusView.top;
        self.endTimeLabel.top = self.endTextLabel.bottom + 5.0f;
    }
    self.endTextLabel.hidden = NO;
    self.endTimeLabel.hidden = NO;

    self.vipIconView.left = cellLayout.nameRight;
    self.vipIconView.centerY = cellLayout.nameCenterY;

    CGFloat iconLeft = cellLayout.nameRight;
    NSInteger levelFlag = [cellLayout.model levelFlag];
    if (levelFlag > 0) {
        self.vipIconView.hidden = NO;
        iconLeft += 43;
    }
    
    BOOL isNew = [cellLayout.model isTodayLive];
    if (isNew) {
        self.newLabel.left = iconLeft;
        self.newLabel.centerY = cellLayout.nameCenterY;
    }
    self.newLabel.hidden = !isNew;
    
    self.qiangImageView.right = SCREEN_WIDTH;
    self.qiangImageView.hidden = NO;
}

- (IBAction) forwardAction:(id)sender
{
    YugaoCellLayout *cellLayout = (YugaoCellLayout *)self.cellLayout;
    if (self.clickedForwardCallback) {
        self.clickedForwardCallback(self, cellLayout.model);
    }
}

- (IBAction) pinpaiAction:(id)sender
{
    YugaoCellLayout *cellLayout = (YugaoCellLayout *)self.cellLayout;
    if (self.clickedPinpaiCallback) {
        self.clickedPinpaiCallback(self, cellLayout.model);
    }
}

//点击查看大图
- (void) showImageBrowserWithIndex:(NSInteger)imageIndex
{
    YugaoCellLayout *layout = (YugaoCellLayout *)self.cellLayout;
    NSArray *imagesUrl = [layout.model imagesUrl];
    
    NSMutableArray* tmps = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.imagePostions.count; i ++) {
        LWImageBrowserModel* model = [[LWImageBrowserModel alloc]
                                      initWithplaceholder:nil
                                      thumbnailURL:[NSURL URLWithString:imagesUrl[i]]
                                      HDURL:[NSURL URLWithString:imagesUrl[i]]
                                      containerView:self.contentView
                                      positionInContainer:CGRectFromString(self.imagePostions[i])
                                      index:i];
        [tmps addObject:model];
    }
    LWImageBrowser* browser = [[LWImageBrowser alloc] initWithImageBrowserModels:tmps currentIndex:imageIndex];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FORWARD_HIDE object:nil];
    browser.finishedBlock = ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FORWARD_SHOW object:nil];
    };
    [browser show];
    
    if (self.clickedImageCallback) {
        self.clickedImageCallback(self, imageIndex);
    }
}

#pragma mark - LWAsyncDisplayViewDelegate

// 额外的绘制
- (void) extraAsyncDisplayIncontext:(CGContextRef)context
                               size:(CGSize)size
                        isCancelled:(LWAsyncDisplayIsCanclledBlock)isCancelled
{
    if (!isCancelled()) {
        CGFloat offset = isPad ? kOFFSET_SIZE : 0.0f;
        CGContextMoveToPoint(context, offset, self.bounds.size.height);
        CGContextAddLineToPoint(context, self.bounds.size.width-offset, self.bounds.size.height);
        CGContextSetLineWidth(context, 0.5f);
        CGContextSetStrokeColorWithColor(context,RGB(220.0f, 220.0f, 220.0f, 1).CGColor);
        CGContextStrokePath(context);
    }
}

//点击LWImageStorage
- (void) lwAsyncDisplayView:(LWAsyncDisplayView *)asyncDisplayView
    didCilickedImageStorage:(LWImageStorage *)imageStorage
                      touch:(UITouch *)touch
{
    NSInteger tag = imageStorage.tag;
    //tag 0~8 是图片，9是头像
    switch (tag) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:{
            if (self.clickedImageCallback) {
                self.clickedImageCallback(self,tag);
            }
        }
            break;
            
        case 9: {
            YugaoCellLayout *cellLayout = (YugaoCellLayout *)self.cellLayout;
            if (self.clickedPinpaiCallback) {
                self.clickedPinpaiCallback(self, cellLayout.model);
            }
        }
            break;
    }
}

//点击LWTextStorage
- (void) lwAsyncDisplayView:(LWAsyncDisplayView *)asyncDisplayView
     didCilickedTextStorage:(LWTextStorage *)textStorage
                   linkdata:(id)data
{
    if ([data isKindOfClass:[LiveInfo class]]) {
        YugaoCellLayout *cellLayout = (YugaoCellLayout *)self.cellLayout;
        if (self.clickedPinpaiCallback) {
            self.clickedPinpaiCallback(self, cellLayout.model);
        }
    }
    else if ([data isKindOfClass:[NSString class]]) {
        // 折叠Cell
        if ([data isEqualToString:@"close"]) {
            if (self.clickedOpenCallback) {
                self.clickedOpenCallback(self, NO);
            }
        }
        // 展开Cell
        else if ([data isEqualToString:@"open"]) {
            if (self.clickedOpenCallback) {
                self.clickedOpenCallback(self, YES);
            }
        }
    }
}

#pragma mark - Getter

- (SCImageView *) logoImage
{
    if (!_logoImage) {
        CGFloat top = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
        _logoImage = [[SCImageView alloc] initWithFrame:CGRectMake(kOFFSET_SIZE, top, 40, 40)];
        _logoImage.backgroundColor = WHITE_COLOR;
        _logoImage.contentMode = UIViewContentModeScaleAspectFit;
        _logoImage.clipsToBounds = YES;
        _logoImage.userInteractionEnabled = YES;
        
        _logoImage.layer.cornerRadius = 6.0f;
        _logoImage.layer.borderColor = [COLOR_TITLE colorWithAlphaComponent:0.5f].CGColor;
        _logoImage.layer.borderWidth = 0.2f;
        
        @weakify(self)
        _logoImage.clickedBlock = ^{
            @strongify(self)
            YugaoCellLayout *cellLayout = (YugaoCellLayout *)self.cellLayout;
            if (self.clickedPinpaiCallback) {
                self.clickedPinpaiCallback(self, cellLayout.model);
            }
        };
    }
    return _logoImage;
}

- (UIImageView *) vipIconView
{
    if (!_vipIconView) {
        _vipIconView = [[UIImageView alloc] init];
        CGFloat top = isPad ? 20 : kOFFSET_SIZE;
        _vipIconView.frame = CGRectMake(0, top, 38, 16);
        _vipIconView.contentMode = UIViewContentModeScaleAspectFit;
        _vipIconView.hidden = YES;
    }
    return _vipIconView;
}

- (UIImageView *) qiangImageView
{
    if (!_qiangImageView) {
        _qiangImageView = [[UIImageView alloc] init];
        _qiangImageView.frame = CGRectMake(0, 0, 50, 50);
        _qiangImageView.image = IMAGENAMED(@"image_qiang");
        _qiangImageView.contentMode = UIViewContentModeScaleToFill;
        _qiangImageView.hidden = YES;
    }
    return _qiangImageView;
}

- (UILabel *) newLabel
{
    if (!_newLabel) {
        _newLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 14)];
        _newLabel.backgroundColor     = COLOR_MAIN;
        _newLabel.layer.cornerRadius  = 2.0;
        _newLabel.layer.masksToBounds = YES;
        _newLabel.textColor = WHITE_COLOR;
        _newLabel.font = BOLDSYSTEMFONT(9);
        _newLabel.textAlignment = NSTextAlignmentCenter;
        _newLabel.text = @"New";
        _newLabel.hidden = YES;
    }
    return _newLabel;
}

- (SCImageView *) imageViewAt:(NSInteger)index
{
    SCImageView *imageView = [[SCImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    imageView.backgroundColor = COLOR_BG_IMAGE;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = YES;
    imageView.tag = index;
    
    imageView.alpha = 0.0f;
    
    @weakify(self)
    imageView.clickedBlock = ^{
        @strongify(self)
        [self showImageBrowserWithIndex:index];
    };
    
    return imageView;
}

- (UIButton *) forwardButton
{
    if (_forwardButton) {
        return _forwardButton;
    }
    _forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _forwardButton.frame = CGRectMake(0, 0, 45, 24);
    _forwardButton.backgroundColor = COLOR_BG_BUTTON;
    _forwardButton.layer.masksToBounds = NO;
    _forwardButton.layer.cornerRadius = 3.0f;
    _forwardButton.titleLabel.font = [FontUtils smallFont];
    [_forwardButton setNormalTitle:@"转发"];
    [_forwardButton setNormalColor:WHITE_COLOR highlighted:COLOR_SELECTED selected:nil];
    
    [_forwardButton addTarget:self action:@selector(forwardAction:)
             forControlEvents:UIControlEventTouchUpInside];
    
    _forwardButton.hidden = YES;
    
    return _forwardButton;
}

- (UIButton *) pinpaiButton
{
    if (_pinpaiButton) {
        return _pinpaiButton;
    }
    _pinpaiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _pinpaiButton.frame = CGRectMake(0, 0, 60, 24);
    _pinpaiButton.backgroundColor = COLOR_BG_BUTTON;
    _pinpaiButton.layer.masksToBounds = NO;
    _pinpaiButton.layer.cornerRadius = 3.0f;
    _pinpaiButton.titleLabel.font = [FontUtils smallFont];
    [_pinpaiButton setNormalTitle:@"去抢购"];
    [_pinpaiButton setNormalColor:WHITE_COLOR highlighted:COLOR_SELECTED selected:nil];
    
    [_pinpaiButton addTarget:self action:@selector(pinpaiAction:)
            forControlEvents:UIControlEventTouchUpInside];
    
    _pinpaiButton.hidden = YES;
    
    return _pinpaiButton;
}

- (CountDownView *) statusView
{
    if (!_statusView) {
        _statusView = [[CountDownView alloc] initWithFrame:CGRectZero];
        _statusView.hidden = YES;
    }
    return _statusView;
}

- (UILabel *) endTextLabel
{
    if (!_endTextLabel) {
        _endTextLabel = [[UILabel alloc] init];
        _endTextLabel.font = SYSTEMFONT(12);
        _endTextLabel.textColor = COLOR_TEXT_NORMAL;
        _endTextLabel.text = @"结束时间";
        [_endTextLabel sizeToFit];
        _endTextLabel.hidden = YES;
    }
    return _endTextLabel;
}

- (UILabel *) endTimeLabel
{
    if (!_endTimeLabel) {
        _endTimeLabel = [[UILabel alloc] init];
        _endTimeLabel.font = [FontUtils normalFont];
        _endTimeLabel.textColor = COLOR_TEXT_DARK;
        _endTimeLabel.hidden = YES;
    }
    return _endTimeLabel;
}

@end
