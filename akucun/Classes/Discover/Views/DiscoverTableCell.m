//
//  DiscoverTableCell.m
//  akucun
//
//  Created by Jarry Zhu on 2017/11/15.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "DiscoverTableCell.h"
#import "LWAsyncDisplayView.h"
#import "LWImageBrowser.h"
#import "TextButton.h"
#import "SCImageView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DiscoverTableCell ()

@property (nonatomic, strong) SCImageView *logoImage;
@property (nonatomic, copy) NSString *logoUrl;

@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, strong) NSMutableArray *imageUrls;

@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *saveButton;

@property (nonatomic, strong) UIButton *playButton;

@property (nonatomic, strong) UILabel *topLabel;

@end

@implementation DiscoverTableCell

- (void) updateData
{
    DiscoverCellLayout *cellLayout = (DiscoverCellLayout *)self.cellLayout;
    NSArray *images = [cellLayout.dataModel imagesArray];
//    NSInteger index = 0;
//    for (NSString *item in images) {
    for (int index = 0; index < 9; index ++) {
        SCImageView *imageView = self.imageViews[index];
        if (index >= images.count) {
            imageView.alpha = 0.0f;
            continue;
        }
        imageView.alpha = 1.0f;
        NSString *item = images[index];
//        NSString *imageUrl = [item stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *imageUrl = FORMAT(@"%@?x-oss-process=image/resize,w_600,limit_0", [item stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]);
        if (![imageUrl isEqualToString:self.imageUrls[index]]) {
            [imageView setImage:nil];
        }
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil options:SDWebImageDelayPlaceholder];
        [self.imageUrls replaceObjectAtIndex:index withObject:imageUrl];
//        index ++;
    }
    
    NSString *logoUrl = cellLayout.dataModel.avatar;
    if (logoUrl && logoUrl.length > 0) {
        if (![self.logoUrl isEqualToString:logoUrl]) {
            [self.logoImage setImage:nil];
        }
        [self.logoImage sd_setImageWithURL:[NSURL URLWithString:logoUrl] placeholderImage:nil options:SDWebImageDelayPlaceholder];
        self.logoUrl = logoUrl;
    }
    else {
        self.logoImage.image = IMAGENAMED(@"icon_avatar_default");
    }
    
}

- (void) initContent
{
    [self.contentView addSubview:self.logoImage];

    self.imageViews = [NSMutableArray array];
    self.imageUrls = [NSMutableArray array];
    for (int i = 0; i < 9; i ++) {
        SCImageView *imageView = [self imageViewAt:i];
        [self.contentView addSubview:imageView];
        [self.imageViews addObject:imageView];
        [self.imageUrls addObject:@""];
    }
    
    [self.contentView addSubview:self.commentButton];
    [self.contentView addSubview:self.shareButton];
    [self.contentView addSubview:self.saveButton];
    [self.contentView addSubview:self.playButton];
    [self.contentView addSubview:self.topLabel];
}

- (void) customLayoutViews
{
    DiscoverCellLayout *cellLayout = (DiscoverCellLayout *)self.cellLayout;
    NSArray *imagePostions = cellLayout.imagePostions;
    NSInteger imgCount = cellLayout.dataModel.imagesArray.count;
    for (int i = 0; i < 9; i ++) {
        SCImageView *imageView = self.imageViews[i];
        if (i >= imgCount) {
//            imageView.alpha = 0.0f;
            continue;
        }
        CGRect imageRect = CGRectFromString(imagePostions[i]);
        imageView.frame = imageRect;
//        imageView.alpha = 1.0f;
    }
    
    self.shareButton.top = cellLayout.imageBottom;
    self.shareButton.right = SCREEN_WIDTH - kOFFSET_SIZE*1.2;
    self.shareButton.hidden = NO;

    self.commentButton.top = cellLayout.imageBottom;
    self.commentButton.right = self.shareButton.left - kOFFSET_SIZE*0.5;
    self.commentButton.hidden = NO;

    self.playButton.hidden = YES;
    self.saveButton.hidden = YES;
    if (cellLayout.dataModel.type == DISCOVER_TYPE_VIDEO) {
        self.playButton.frame = CGRectFromString(imagePostions[0]);
        self.playButton.hidden = NO;
        
        self.saveButton.centerY = self.shareButton.centerY;
        self.saveButton.right = self.commentButton.left - kOFFSET_SIZE*0.5;
        self.saveButton.hidden = NO;
    }
    
    self.topLabel.left = kOFFSET_SIZE*1.2;
    self.topLabel.top = cellLayout.titleTop;
    self.topLabel.hidden = !cellLayout.dataModel.isTop;
}

//点击查看大图
- (void) showImageBrowserWithIndex:(NSInteger)imageIndex
{
    DiscoverCellLayout *layout = (DiscoverCellLayout *)self.cellLayout;
    NSArray *imagesUrl = [layout.dataModel imagesArray];
    
    NSMutableArray* tmps = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < layout.imagePostions.count; i ++) {
        NSString *url = [imagesUrl[i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *thumbnailURL = FORMAT(@"%@?x-oss-process=image/resize,w_600,limit_0", url);
        NSString *HDURL = FORMAT(@"%@?x-oss-process=image/resize,w_1000,limit_0", url);
        LWImageBrowserModel* model = [[LWImageBrowserModel alloc]
                                      initWithplaceholder:nil
                                      thumbnailURL:[NSURL URLWithString:thumbnailURL]
                                      HDURL:[NSURL URLWithString:HDURL]
                                      containerView:self.contentView
                                      positionInContainer:CGRectFromString(layout.imagePostions[i])
                                      index:i];
        [tmps addObject:model];
    }
    LWImageBrowser* browser = [[LWImageBrowser alloc] initWithImageBrowserModels:tmps currentIndex:imageIndex];
    [browser show];
    
    if (self.clickedImageCallback) {
        self.clickedImageCallback(self, imageIndex);
    }
}

- (IBAction) commentAction:(id)sender
{
    DiscoverCellLayout *layout = (DiscoverCellLayout *)self.cellLayout;
    if (self.clickedCommentCallback) {
        self.clickedCommentCallback(self, layout.dataModel);
    }
}

- (IBAction) shareAction:(id)sender
{
    DiscoverCellLayout *layout = (DiscoverCellLayout *)self.cellLayout;
    if (self.clickedForwardCallback) {
        self.clickedForwardCallback(self, layout.dataModel);
    }
}

- (IBAction) saveAction:(id)sender
{
    DiscoverCellLayout *layout = (DiscoverCellLayout *)self.cellLayout;
    if (self.clickedSaveCallback) {
        self.clickedSaveCallback(self, layout.dataModel);
    }
}

- (IBAction) playAction:(id)sender
{
    DiscoverCellLayout *layout = (DiscoverCellLayout *)self.cellLayout;
    if (self.clickedVideoCallback) {
        self.clickedVideoCallback(self, layout.dataModel, self.imageViews[0]);
    }
}

#pragma mark - LWAsyncDisplayViewDelegate

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
            [self showImageBrowserWithIndex:tag];
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
    DiscoverCellLayout *layout = (DiscoverCellLayout *)self.cellLayout;
    if ([data isKindOfClass:[NSString class]]) {
        // 折叠Cell
        if ([data isEqualToString:@"close"]) {
            if (self.clickedOpenCallback) {
                self.clickedOpenCallback(self, layout.dataModel, NO);
            }
        }
        // 展开Cell
        else if ([data isEqualToString:@"open"]) {
            if (self.clickedOpenCallback) {
                self.clickedOpenCallback(self, layout.dataModel, YES);
            }
        }
    }
}

#pragma mark -

- (SCImageView *) logoImage
{
    if (!_logoImage) {
        CGFloat top = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
        _logoImage = [[SCImageView alloc] initWithFrame:CGRectMake(kOFFSET_SIZE, top, 36, 36)];
        _logoImage.backgroundColor = WHITE_COLOR;
        _logoImage.contentMode = UIViewContentModeScaleAspectFit;
        _logoImage.clipsToBounds = YES;
        _logoImage.userInteractionEnabled = YES;
        
        _logoImage.layer.cornerRadius = 18.0f;
        _logoImage.layer.borderColor = COLOR_SEPERATOR_LINE.CGColor;
        _logoImage.layer.borderWidth = 0.3f;
    }
    return _logoImage;
}

- (SCImageView *) imageViewAt:(NSInteger)index
{
    SCImageView *imageView = [[SCImageView alloc] initWithFrame:CGRectZero];
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

- (UIButton *) commentButton
{
    if (_commentButton) {
        return _commentButton;
    }

    _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _commentButton.frame = CGRectMake(0, 0, 44, 22);
    _commentButton.backgroundColor = COLOR_BG_BUTTON;
    _commentButton.layer.masksToBounds = NO;
    _commentButton.layer.cornerRadius = 3.0f;
    _commentButton.titleLabel.font = [FontUtils smallFont];
    [_commentButton setNormalTitle:@"评论"];
    [_commentButton setNormalColor:WHITE_COLOR highlighted:COLOR_TEXT_LIGHT selected:nil];
    
    [_commentButton addTarget:self action:@selector(commentAction:)
             forControlEvents:UIControlEventTouchUpInside];
    
    _commentButton.hidden = YES;
    
    return _commentButton;
}

- (UIButton *) shareButton
{
    if (_shareButton) {
        return _shareButton;
    }
    _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareButton.frame = CGRectMake(0, 0, 44, 22);
    
    _shareButton.backgroundColor = COLOR_BG_BUTTON;
    _shareButton.layer.masksToBounds = NO;
    _shareButton.layer.cornerRadius = 3.0f;
    _shareButton.titleLabel.font = [FontUtils smallFont];
    [_shareButton setNormalTitle:@"转发"];
    [_shareButton setNormalColor:WHITE_COLOR highlighted:COLOR_TEXT_LIGHT selected:nil];

    [_shareButton addTarget:self action:@selector(shareAction:)
             forControlEvents:UIControlEventTouchUpInside];
    
    _shareButton.hidden = YES;
    
    return _shareButton;
}

- (UIButton *) saveButton
{
    if (_saveButton) {
        return _saveButton;
    }
    _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveButton.frame = CGRectMake(0, 0, 80, 22);
    
    _saveButton.backgroundColor = COLOR_BG_BUTTON;
    _saveButton.layer.masksToBounds = NO;
    _saveButton.layer.cornerRadius = 3.0f;
    _saveButton.titleLabel.font = [FontUtils smallFont];
    [_saveButton setNormalTitle:@"保存到相册"];
    [_saveButton setNormalColor:WHITE_COLOR highlighted:COLOR_TEXT_LIGHT selected:nil];
    
    [_saveButton addTarget:self action:@selector(saveAction:)
           forControlEvents:UIControlEventTouchUpInside];
    
    _saveButton.hidden = YES;
    
    return _saveButton;
}

- (UIButton *) playButton
{
    if (_playButton) {
        return _playButton;
    }
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _playButton.backgroundColor = [BLACK_COLOR colorWithAlphaComponent:0.1f];
    
    [_playButton setNormalImage:@"icon_play" hilighted:nil selectedImage:nil];
    
    [_playButton addTarget:self action:@selector(playAction:)
           forControlEvents:UIControlEventTouchUpInside];
    
    _playButton.hidden = YES;
    
    return _playButton;
}

- (UILabel *) topLabel
{
    if (!_topLabel) {
        _topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 14)];
        _topLabel.backgroundColor     = COLOR_MAIN;
        _topLabel.layer.cornerRadius  = 2.0;
        _topLabel.layer.masksToBounds = YES;
        _topLabel.textColor = WHITE_COLOR;
        _topLabel.font = BOLDSYSTEMFONT(9);
        _topLabel.textAlignment = NSTextAlignmentCenter;
        _topLabel.text = @"置顶";
        _topLabel.hidden = YES;
    }
    return _topLabel;
}

@end
