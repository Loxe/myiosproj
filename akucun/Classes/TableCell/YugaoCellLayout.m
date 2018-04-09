//
//  YugaoCellLayout.m
//  akucun
//
//  Created by Jarry on 2017/4/26.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "YugaoCellLayout.h"
#import "Comment.h"

@interface YugaoCellLayout ()

//@property (nonatomic, strong) LWImageStorage* commentBgStorage;
//@property (nonatomic, strong) NSMutableArray* commentTextStorages;

@end

@implementation YugaoCellLayout

- (id) initWithModel:(LiveInfo *)model isOpened:(BOOL)isOpened
{
    self = [super init];
    if (self) {
        @autoreleasepool {
            [self initContentWithModel:model isOpened:isOpened];
        }
    }
    return self;
}

- (id) initWithTrailer:(Trailer *)trailer isOpened:(BOOL)isOpened
{
    self = [super init];
    if (self) {
        @autoreleasepool {
            [self initContentWithTrailer:trailer isOpened:isOpened];
        }
    }
    return self;
}

- (void) updateData
{
    /*
    if (self.model) {
        //
        if (self.commentBgStorage) {
            [self removeStorage:self.commentBgStorage];
        }
        if (self.commentTextStorages) {
            [self removeStorages:self.commentTextStorages];
        }
        self.commentBgStorage = commentBgStorage;
        self.commentTextStorages = commentTextStorages;
        
    }*/
}

- (void) initContentWithModel:(LiveInfo *)model isOpened:(BOOL)isOpened
{
    self.model = model;
    self.isOpened = isOpened;
    
    CGFloat top = isPad ? 20 : kOFFSET_SIZE;
    //
    CGFloat logoSize = 40.0f;
    CGFloat contentWidth = SCREEN_WIDTH - logoSize - kOFFSET_SIZE * 3;
    CGFloat nameOffset = 0;
    if ([model isTodayLive] && [model levelFlag] > 0) {
        nameOffset = 70;
    }
    else if ([model isTodayLive] || [model levelFlag] > 0) {
        nameOffset = 40;
    }
    // 名称模型 nameTextStorage
    LWTextStorage* nameTextStorage = [[LWTextStorage alloc] init];
    nameTextStorage.text = model.pinpaiming;
    nameTextStorage.font = BOLDTNRFONTSIZE(15);
    nameTextStorage.lineBreakMode = NSLineBreakByTruncatingTail;
    nameTextStorage.frame = CGRectMake(logoSize + kOFFSET_SIZE*2,
                                       top - 2.0f,
                                       contentWidth-nameOffset,
                                       CGFLOAT_MAX);
    [nameTextStorage lw_addLinkWithData:model
                                  range:NSMakeRange(0, model.pinpaiming.length)
                              linkColor:COLOR_TEXT_LINK
                         highLightColor:COLOR_BG_TEXT];
    self.nameCenterY = nameTextStorage.top+nameTextStorage.height*0.5f;
    self.nameRight = nameTextStorage.right + 5;
    
    // 正文内容模型 contentTextStorage
    LWTextStorage* contentTextStorage = [[LWTextStorage alloc] init];
    if (!isOpened) {
        contentTextStorage.maxNumberOfLines = 5;
    }
    contentTextStorage.linespacing = 3.0f;
    contentTextStorage.text = model.yugaoneirong;
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
    
    // 生成时间的模型 timeTextStorage
    CGFloat timeTop = contentBottom + imageHeight + 30.0f;
    if (imageCount > 4) {
        timeTop += 40.0f;
    }
    LWTextStorage* timeTextStorage = [[LWTextStorage alloc] init];
    timeTextStorage.text = [self dateString:model.begintimestamp];
    timeTextStorage.font = [FontUtils smallFont];
    timeTextStorage.textColor = COLOR_TEXT_NORMAL;
    timeTextStorage.frame = CGRectMake(nameTextStorage.left,
                                       timeTop,
                                       SCREEN_WIDTH - kOFFSET_SIZE * 2,
                                       CGFLOAT_MAX);
    
    CGFloat menuPosition = timeTextStorage.top - 5.0f;
    
    [self addStorage:nameTextStorage];
    [self addStorage:contentTextStorage];
    [self addStorage:timeTextStorage];
    
    self.contentBottom = timeTextStorage.bottom;
    self.contentLeft = contentTextStorage.left;
    self.contentWidth = contentWidth;
    self.menuPosition = menuPosition;//右下角菜单按钮的位置
    self.imageWidth = imageWidth;
    self.imagesRect = CGRectMake(nameTextStorage.left, contentBottom + 10.0f, imageWidth*3 + 10.0f, imageHeight);
    
    CGFloat margin = isPad ? 30 : kOFFSET_SIZE*1.2;

    NSArray *comments = self.model.comments;
    NSInteger commentCount = comments.count;
    if (commentCount > 0) {
        LWImageStorage* commentBgStorage = [[LWImageStorage alloc] init];
        NSMutableArray* commentTextStorages = [NSMutableArray array];
        CGFloat commentY = self.contentBottom + 24;
        for (NSInteger i = 0; i < commentCount; i ++) {
            Comment *comment = comments[i];
            LWTextStorage* commentStorage = [[LWTextStorage alloc] init];
            commentStorage.frame = CGRectMake(self.contentLeft + 8.0f, commentY, self.contentWidth-16.0f, 20);
            commentStorage.text = comment.content;
            commentStorage.textColor = COLOR_TEXT_NORMAL;
            commentStorage.font = [FontUtils smallFont];
            commentStorage.linespacing = 3.0f;
            
            [commentStorage lw_addLinkForWholeTextStorageWithData:comment
                                                   highLightColor:COLOR_BG_TEXT];
            [commentTextStorages addObject:commentStorage];
            commentY = commentStorage.bottom + 8.0f;
        }

        commentBgStorage.frame = CGRectMake(self.contentLeft,
                                            self.contentBottom + 8.0f,
                                            self.contentWidth,
                                            commentY - self.contentBottom - 5.0f);
        commentBgStorage.contents = IMAGENAMED(@"bg_comment");
        [commentBgStorage stretchableImageWithLeftCapWidth:40 topCapHeight:15];
        [self addStorage:commentBgStorage];
        
        [self addStorages:commentTextStorages];
        
        self.cellHeight = [self suggestHeightWithBottomMargin:margin];
    }
    else {
        self.cellHeight = self.contentBottom + margin;
    }
}

- (void) initContentWithTrailer:(Trailer *)model isOpened:(BOOL)isOpened
{
    self.trailer = model;
    self.isOpened = isOpened;
    
    CGFloat top = isPad ? 20 : kOFFSET_SIZE;
    //
    CGFloat logoSize = 40.0f;
    CGFloat contentWidth = SCREEN_WIDTH - logoSize - kOFFSET_SIZE * 3;
    // 名称模型 nameTextStorage
    LWTextStorage* nameTextStorage = [[LWTextStorage alloc] init];
    nameTextStorage.text = model.pinpaiming;
    nameTextStorage.font = BOLDTNRFONTSIZE(15);
    nameTextStorage.frame = CGRectMake(logoSize + kOFFSET_SIZE*2,
                                       top - 2.0f,
                                       contentWidth-40,
                                       CGFLOAT_MAX);
    [nameTextStorage lw_addLinkWithData:model
                                  range:NSMakeRange(0, model.pinpaiming.length)
                              linkColor:COLOR_TEXT_LINK
                         highLightColor:COLOR_BG_TEXT];
    self.nameCenterY = nameTextStorage.top+nameTextStorage.height*0.5f;
    self.nameRight = nameTextStorage.right + 5;
    
    // 正文内容模型 contentTextStorage
    LWTextStorage* contentTextStorage = [[LWTextStorage alloc] init];
    if (!isOpened) {
        contentTextStorage.maxNumberOfLines = 5;
    }
    contentTextStorage.linespacing = 3.0f;
    contentTextStorage.text = model.yugaoneirong;
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

    // 生成时间的模型 timeTextStorage
    CGFloat timeTop = contentBottom + imageHeight + 30.0f;
    if (imageCount > 4) {
        timeTop += 40.0f;
    }
    LWTextStorage* timeTextStorage = [[LWTextStorage alloc] init];
    timeTextStorage.text = [self dateString:model.begintimestamp];
    timeTextStorage.font = [FontUtils smallFont];
    timeTextStorage.textColor = COLOR_TEXT_NORMAL;
    timeTextStorage.frame = CGRectMake(nameTextStorage.left,
                                       timeTop,
                                       SCREEN_WIDTH - kOFFSET_SIZE * 2,
                                       CGFLOAT_MAX);
    
    CGFloat menuPosition = timeTextStorage.top - 5.0f;
    
    [self addStorage:nameTextStorage];
    [self addStorage:contentTextStorage];
    [self addStorage:timeTextStorage];
    
    self.menuPosition = menuPosition;//右下角菜单按钮的位置
    self.imageWidth = imageWidth;
    self.imagesRect = CGRectMake(nameTextStorage.left, contentBottom + 10.0f, imageWidth*3 + 10.0f, imageHeight);
//    self.imagePostions = imagePositionArray;//保存图片位置的数组
    
    CGFloat margin = isPad ? 30 : kOFFSET_SIZE*1.2;
    self.cellHeight = [self suggestHeightWithBottomMargin:margin];
}

- (NSString *) dateString:(NSTimeInterval)time
{
    NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *dateString = nil;
    if ([dateTime isToday]) {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"aa HH:mm"];
        [formatter setAMSymbol:@"上午"];
        [formatter setPMSymbol:@"下午"];
        dateString = [formatter stringFromDate:dateTime];
    }
    else if ([self isYesterday:dateTime]) {
        dateString = [dateTime formattedDateWithFormatString:@"昨天 HH:mm"];
    }
    else {
        dateString = [dateTime formattedDateWithFormatString:@"MM/dd HH:mm"];
    }
    return dateString;
}

- (BOOL) isYesterday:(NSDate *)date
{
    NSCalendar *calendar = [ NSCalendar currentCalendar ];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear ;
    // 获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    // 获得 self 的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:date];
    return (selfCmps.year == nowCmps.year) && (selfCmps.month == nowCmps. month ) && (selfCmps.day == nowCmps.day-1);
}

@end
