//
//  CorpCellLayout.m
//  akucun
//
//  Created by Jarry Z on 2018/3/15.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "CorpCellLayout.h"

@implementation CorpCellLayout

- (id) initWithModel:(CorpInfo *)model isOpened:(BOOL)isOpened
{
    self = [super init];
    if (self) {
        @autoreleasepool {
            [self initContentWithModel:model isOpened:isOpened];
        }
    }
    return self;
}

- (void) updateData
{
}

- (void) initContentWithModel:(CorpInfo *)model isOpened:(BOOL)isOpened
{
    self.model = model;
    self.isOpened = isOpened;
    
    CGFloat top = isPad ? 20 : kOFFSET_SIZE;
    //
    CGFloat logoSize = 40.0f;
    CGFloat contentWidth = SCREEN_WIDTH - logoSize - kOFFSET_SIZE * 3;
    // 名称模型 nameTextStorage
    LWTextStorage* nameTextStorage = [[LWTextStorage alloc] init];
    nameTextStorage.text = model.shortName;
    nameTextStorage.font = BOLDTNRFONTSIZE(15);
    nameTextStorage.frame = CGRectMake(logoSize + kOFFSET_SIZE*2,
                                       top - 2.0f,
                                       contentWidth,
                                       CGFLOAT_MAX);
    [nameTextStorage lw_addLinkWithData:model
                                  range:NSMakeRange(0, model.shortName.length)
                              linkColor:COLOR_TEXT_LINK
                         highLightColor:COLOR_BG_TEXT];
    
    // 正文内容模型 contentTextStorage
    LWTextStorage* contentTextStorage = [[LWTextStorage alloc] init];
    if (!isOpened) {
        contentTextStorage.maxNumberOfLines = 5;
    }
    contentTextStorage.linespacing = 3.0f;
    contentTextStorage.text = model.descriptioninfo;
    contentTextStorage.font = [FontUtils normalFont];
    contentTextStorage.textColor = COLOR_TEXT_DARK;
    contentTextStorage.frame = CGRectMake(nameTextStorage.left,
                                          nameTextStorage.bottom + 10.0f,
                                          contentWidth,
                                          CGFLOAT_MAX);
    CGFloat contentBottom = contentTextStorage.bottom;
    // 折叠的条件
    if (contentTextStorage.isTruncation || isOpened) {
        LWTextStorage* openStorage = [[LWTextStorage alloc] init];
        openStorage.font = TNRFONTSIZE(14);
        openStorage.textColor = RGB(40, 40, 40, 1);
        openStorage.frame = CGRectMake(nameTextStorage.left,
                                       contentTextStorage.bottom + 5.0f,
                                       200.0f,
                                       30.0f);
        openStorage.text = isOpened ? @"收起全文" : @"展开全文";
        [openStorage lw_addLinkWithData:isOpened ? @"close" : @"open"
                                  range:NSMakeRange(0, 4)
                              linkColor:RGB(113, 129, 161, 1)
                         highLightColor:RGB(0, 0, 0, 0.15f)];
        [self addStorage:openStorage];
        contentBottom = openStorage.bottom;
    }
    
    // 发布的图片模型 imgsStorage
    CGFloat showCount = isPad ? 3.5f : 3.0f;
    NSInteger imageCount = model.imagesUrl.count;
    CGFloat imageWidth = (SCREEN_WIDTH - nameTextStorage.left - kOFFSET_SIZE*2 - 10.0f)/showCount;
    NSInteger row = 2, column = 2;
    if (imageCount > 6) {
        row = 3;
        column = 3;
    }
    else if (imageCount > 4) {
        row = 2;
        column = 3;
    }
    CGFloat imageHeight = imageWidth * row + 5.0f*(row-1);

    CGFloat menuPosition = contentBottom + imageHeight + 25.0f;
    
    [self addStorage:nameTextStorage];
    [self addStorage:contentTextStorage];
    
//    self.contentLeft = contentTextStorage.left;
//    self.contentWidth = contentWidth;
    
    self.menuPosition = menuPosition;//右下角菜单按钮的位置
    self.imageWidth = imageWidth;
    self.imagesRect = CGRectMake(nameTextStorage.left, contentBottom + 10.0f, imageWidth*3 + 10.0f, imageHeight);
    
    CGFloat margin = isPad ? 30 : kOFFSET_SIZE*1.2;
    self.cellHeight = menuPosition + 24 + margin;
}

@end
