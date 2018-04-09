//
//  YugaoTableCell.m
//  akucun
//
//  Created by Jarry on 2017/4/26.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "YugaoTableCell.h"
#import "LWAsyncDisplayView.h"
#import "LWImageBrowser.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "CountDownView.h"
#import "SCImageView.h"

@interface YugaoTableCell ()

@property (nonatomic, strong) SCImageView *logoImage;
@property (nonatomic, strong) UIImageView *vipIconView;

@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, strong) NSMutableArray* imagePostions;
@property (nonatomic, strong) NSMutableArray *imageUrls;

@property (nonatomic, copy) NSString *logoUrl;

@property (nonatomic, strong) UIButton *forwardButton;
//@property (nonatomic, strong) UIButton *pinpaiButton;

@property (nonatomic, strong) CountDownView *statusView;

@end

@implementation YugaoTableCell

- (void) updateData
{
    YugaoCellLayout *cellLayout = (YugaoCellLayout *)self.cellLayout;
    NSArray *images = [cellLayout.trailer imagesUrl];
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
    
    NSString *logoUrl = cellLayout.trailer.pinpaiurl;
    if (logoUrl && logoUrl.length > 0) {
        if (![self.logoUrl isEqualToString:logoUrl]) {
            [self.logoImage setImage:nil];
        }
        [self.logoImage sd_setImageWithURL:[NSURL URLWithString:logoUrl] placeholderImage:nil options:SDWebImageDelayPlaceholder];
        self.logoUrl = logoUrl;
    }
    
    //
    Trailer *trailer = cellLayout.trailer;
    self.statusView.title = @"即将开始";
    self.statusView.liveTime = trailer.begintimestamp;
    
    //
    self.vipIconView.image = nil;
    NSInteger levelFlag = [trailer levelFlag];
    if (levelFlag > 0) {
        NSString *imgName = FORMAT(@"icon_vip%ld",(long)levelFlag);
        self.vipIconView.image = IMAGENAMED(imgName);
    }
}

- (void) initContent
{
    [self.contentView addSubview:self.logoImage];
    [self.contentView addSubview:self.vipIconView];

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
//    [self.contentView addSubview:self.pinpaiButton];
}

- (void) customLayoutViews
{
    [self.imagePostions removeAllObjects];
    YugaoCellLayout *cellLayout = (YugaoCellLayout *)self.cellLayout;
    NSInteger imgCount = cellLayout.trailer.imagesUrl.count;
    CGFloat imageWidth = cellLayout.imageWidth;
    CGFloat left = cellLayout.imagesRect.origin.x;
    CGFloat top = cellLayout.imagesRect.origin.y;
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
        self.statusView.top = top + cellLayout.imagesRect.size.height + 8.0f;
    }
    self.statusView.width = SCREEN_WIDTH - self.statusView.left - kOFFSET_SIZE;
    self.statusView.hidden = NO;

    self.forwardButton.top = cellLayout.menuPosition;
    self.forwardButton.right = SCREEN_WIDTH - kOFFSET_SIZE;
    self.forwardButton.hidden = NO;
 
    if (isPad) {
        self.statusView.left = self.forwardButton.left - kOFFSET_SIZE - 90;
    }
    
    self.vipIconView.left = cellLayout.nameRight;
    self.vipIconView.centerY = cellLayout.nameCenterY;
    NSInteger levelFlag = [cellLayout.trailer levelFlag];
    if (levelFlag > 0) {
        self.vipIconView.hidden = NO;
    }
}

- (IBAction) forwardAction:(id)sender
{
    YugaoCellLayout *cellLayout = (YugaoCellLayout *)self.cellLayout;
    if (self.clickedForwardCallback) {
        self.clickedForwardCallback(self, cellLayout.trailer);
    }
}

//点击查看大图
- (void) showImageBrowserWithIndex:(NSInteger)imageIndex
{
    YugaoCellLayout *layout = (YugaoCellLayout *)self.cellLayout;
    NSArray *imagesUrl = [layout.trailer imagesUrl];
    
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
        }
            break;
    }
}

//点击LWTextStorage
- (void) lwAsyncDisplayView:(LWAsyncDisplayView *)asyncDisplayView
     didCilickedTextStorage:(LWTextStorage *)textStorage
                   linkdata:(id)data
{
    if ([data isKindOfClass:[Trailer class]]) {
        //
        if (self.clickedPinpaiCallback) {
            self.clickedPinpaiCallback(self);
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
            if (self.clickedPinpaiCallback) {
                self.clickedPinpaiCallback(self);
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

- (CountDownView *) statusView
{
    if (!_statusView) {
        _statusView = [[CountDownView alloc] initWithFrame:CGRectZero];
        _statusView.titleColor = COLOR_TEXT_DARK;
        _statusView.hidden = YES;
    }
    return _statusView;
}

@end
