//
//  DiscoverCellLayout.m
//  akucun
//
//  Created by Jarry Zhu on 2017/11/15.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "DiscoverCellLayout.h"
#import "NSDate+akucun.h"

@interface DiscoverCellLayout ()

@property (nonatomic, strong) LWTextStorage* contentTextStorage;

@end

@implementation DiscoverCellLayout

- (void) updateData
{
    
}

- (id) initWithModel:(DiscoverData *)model isOpened:(BOOL)opened
{
    self = [super init];
    if (self) {
        @autoreleasepool {
            self.isOpened = opened;
            [self initContentWithModel:model];
        }
    }
    return self;
}

- (void) initContentWithModel:(DiscoverData *)model
{
    self.dataModel = model;
    
    CGFloat top = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
    CGFloat logoSize = 36.0f;
    // 名称模型 nameTextStorage
    NSString *name = self.dataModel.username;
    LWTextStorage* nameTextStorage = [[LWTextStorage alloc] init];
    nameTextStorage.text = name;
    nameTextStorage.font = BOLDTNRFONTSIZE(14);
    nameTextStorage.frame = CGRectMake(logoSize + kOFFSET_SIZE*1.5,
                                       top - 2.0f,
                                       SCREEN_WIDTH-logoSize-kOFFSET_SIZE*3,
                                       CGFLOAT_MAX);
    [nameTextStorage lw_addLinkWithData:name
                                  range:NSMakeRange(0, name.length)
                              linkColor:COLOR_TEXT_LINK
                         highLightColor:COLOR_BG_TEXT];
    
    // 时间 timeTextStorage
    LWTextStorage* timeTextStorage = [[LWTextStorage alloc] init];
    timeTextStorage.text = FORMAT(@"%@  发布", [self relativeTimeString:model.createtime]);
    timeTextStorage.font = TNRFONTSIZE(11);
    timeTextStorage.textColor = LIGHTGRAY_COLOR;
    timeTextStorage.frame = CGRectMake(nameTextStorage.left,
                                       nameTextStorage.bottom + 2.0f,
                                       SCREEN_WIDTH - kOFFSET_SIZE * 2,
                                       CGFLOAT_MAX);
    
    CGFloat contentWidth = SCREEN_WIDTH - kOFFSET_SIZE * 2.4;
    CGFloat titleOffsetX = 0;
    if (self.dataModel.isTop) {
        titleOffsetX = 28;
    }
    LWTextStorage* titleTextStorage = [[LWTextStorage alloc] init];
    titleTextStorage.maxNumberOfLines = 5;//设置最大行数，超过则折叠
    titleTextStorage.text = self.dataModel.title;
    titleTextStorage.font = [FontUtils normalFont];
    titleTextStorage.textColor = COLOR_TEXT_DARK;
    titleTextStorage.frame = CGRectMake(kOFFSET_SIZE*1.2+titleOffsetX, timeTextStorage.bottom + 10.0f, contentWidth-titleOffsetX, CGFLOAT_MAX);
    self.titleTop = timeTextStorage.bottom + 12.0f;
    
    // 正文内容模型 contentTextStorage
    LWTextStorage* contentTextStorage = [[LWTextStorage alloc] init];
    contentTextStorage.maxNumberOfLines = 5;
    if (self.isOpened) {
        contentTextStorage.maxNumberOfLines = 50;
    }
    contentTextStorage.linespacing = 2.0f;
    contentTextStorage.text = [self.dataModel.content filterSpaceAndNewline];
    contentTextStorage.font = [FontUtils normalFont];
    contentTextStorage.textColor = COLOR_TEXT_NORMAL;
    contentTextStorage.frame = CGRectMake(kOFFSET_SIZE*1.2,
                                          titleTextStorage.bottom + 5.0f,
                                          contentWidth,
                                          CGFLOAT_MAX);
    CGFloat contentBottom = contentTextStorage.bottom;
    if (contentTextStorage.text.length == 0) {
        contentBottom = titleTextStorage.bottom;
    }
    // 折叠的条件
    if (contentTextStorage.isTruncation || self.isOpened) {
        LWTextStorage* openStorage = [[LWTextStorage alloc] init];
        openStorage.font = TNRFONTSIZE(14);
        openStorage.textColor = RGB(40, 40, 40, 1);
        openStorage.frame = CGRectMake(contentTextStorage.left,
                                       contentTextStorage.bottom + 5.0f,
                                       200.0f,
                                       30.0f);
        openStorage.text = self.isOpened ? @"收起全文" : @"展开全文";
        [openStorage lw_addLinkWithData:self.isOpened ? @"close":@"open"
                                  range:NSMakeRange(0, 4)
                              linkColor:RGB(113, 129, 161, 1)
                         highLightColor:RGB(0, 0, 0, 0.15f)];
        [self addStorage:openStorage];
        contentBottom = openStorage.bottom;
    }
    // 图片
    CGFloat imageWidth = (SCREEN_WIDTH - kOFFSET_SIZE*3 - 10)/3.0f;
    NSInteger imageCount = model.imagesArray.count;
    NSMutableArray* imagePositionArray = [[NSMutableArray alloc] initWithCapacity:imageCount];
    NSInteger row = 0;
    NSInteger column = 0;
    CGFloat imageTop = contentBottom + 10.0f;
    CGFloat imageBottom = 0;
    if (imageCount == 1) {
        // 计算图片显示尺寸
        CGFloat width = model.imageWidth, height = model.imageHeight;
        if (width == 0) {
            width = imageWidth * 2 + 5;
            height = width;
        }
        else if (width >= height) {
            double ratio = width*1.0f/height;
            if (ratio >= 1 && ratio <= 2.5) {
                width = imageWidth * 2 + 5;
                height = width * model.imageHeight/model.imageWidth;
            }
            else if (ratio <= 3) {
                width = imageWidth * 2 + 5;
                height = width/2.5f;
            }
            else {
                width = imageWidth * 3 + 10;
                height = width/3.0f;
            }
        }
        else {
            double ratio = height*1.0f/width;
            if (ratio >= 1 && ratio <= 2.5) {
                height = imageWidth * 2;
                width = height * model.imageWidth/model.imageHeight;
            }
            else if (ratio <= 3) {
                height = imageWidth * 2;
                width = height/2.5f;
            }
            else {
                height = imageWidth * 2;
                width = height/3.0f;
            }
        }
        
        CGRect imageRect = CGRectMake(contentTextStorage.left, imageTop,
                                      width, height);
        NSString* imagePositionString = NSStringFromCGRect(imageRect);
        [imagePositionArray addObject:imagePositionString];

        imageBottom = imageTop + height + 10.0f;
    }
    else {
        for (NSInteger i = 0; i < imageCount; i ++) {
            CGRect imageRect = CGRectMake(contentTextStorage.left + (column * (imageWidth + 5.0f)), imageTop + (row * (imageWidth + 5.0f)),
                                          imageWidth, imageWidth);
            NSString* imagePositionString = NSStringFromCGRect(imageRect);
            [imagePositionArray addObject:imagePositionString];
            
            imageBottom = imageRect.origin.y + imageWidth + 10.0f;
            column = column + 1;
            if (imageCount == 4 && column > 1) {
                column = 0;
                row ++;
            }
            else if (column > 2) {
                column = 0;
                row ++;
            }
        }
    }
    
    // 保存图片位置的数组
    self.imagePostions = imagePositionArray;
    self.imageBottom = imageBottom;

    [self addStorage:nameTextStorage];
    [self addStorage:timeTextStorage];
    [self addStorage:titleTextStorage];
    [self addStorage:contentTextStorage];

    contentBottom = imageBottom + 15;
    NSArray *comments = model.comments;
    NSInteger commentCount = comments.count;
    if (commentCount > 0) {
        LWImageStorage* commentBgStorage = [[LWImageStorage alloc] init];
        NSMutableArray* commentTextStorages = [NSMutableArray array];
        CGFloat commentY = contentBottom + 28;
        for (NSInteger i = 0; i < commentCount; i ++) {
            DiscoverComment *comment = comments[i];
            NSString *name = comment.nickname;
            if (comment.replyid && comment.replyid.length > 0) {
                name = FORMAT(@"%@ 回复 %@", comment.nickname, comment.replyUsername);
            }
            
            LWTextStorage* commentStorage = [[LWTextStorage alloc] init];
            commentStorage.frame = CGRectMake(contentTextStorage.left + 8.0f, commentY, contentWidth - 16.0f, 20);
            commentStorage.text = FORMAT(@"%@ :  %@", name, comment.content);
            commentStorage.textColor = COLOR_TEXT_NORMAL;
            commentStorage.font = [FontUtils smallFont];
            commentStorage.linespacing = 3.0f;
            
            [commentStorage lw_addLinkForWholeTextStorageWithData:comment
                                                   highLightColor:COLOR_BG_TEXT];
            [commentStorage lw_addLinkWithData:nil
                                         range:NSMakeRange(0, name.length)
                                     linkColor:COLOR_TEXT_LINK
                                highLightColor:COLOR_BG_TEXT];
            [commentTextStorages addObject:commentStorage];
            commentY = commentStorage.bottom + 8.0f;
        }
    
        commentBgStorage.frame = CGRectMake(contentTextStorage.left,
                                            contentBottom + 10.0f,
                                            contentWidth,
                                            commentY - contentBottom - 5.0f);
        commentBgStorage.contents = IMAGENAMED(@"bg_comment");
        [commentBgStorage stretchableImageWithLeftCapWidth:40 topCapHeight:15];
        [self addStorage:commentBgStorage];
        
        [self addStorages:commentTextStorages];
        
        CGFloat margin = isPad ? 30 : kOFFSET_SIZE * 1.2;
        self.cellHeight = [self suggestHeightWithBottomMargin:margin];
    }
    else {
        self.cellHeight = imageBottom + (isPad ? 50 : (kOFFSET_SIZE+20));
    }
}

- (NSString *) relativeTimeString:(NSTimeInterval)time
{
    NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:time];
    
    const int SECOND = 1;
    const int MINUTE = 60 * SECOND;
    const int HOUR = 60 * MINUTE;
    //    const int DAY = 24 * HOUR;
    //    const int MONTH = 30 * DAY;
    
    NSDate *now = [NSDate date];
    NSTimeInterval delta = [dateTime timeIntervalSinceDate:now] * -1.0;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger units = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond);
    NSDateComponents *components = [calendar components:units fromDate:dateTime toDate:now options:0];
    
    NSString *relativeString;
    
    if (delta < 0) {
        relativeString = @"";
        
    } else if (delta < 1 * MINUTE) {
        relativeString = (components.second == 1) ? @"1秒钟前" : [NSString stringWithFormat:@"%ld秒钟前",(long)components.second];
        
    } else if (delta < 2 * MINUTE) {
        relativeString = @"1分钟前";
        
    } else if (delta < 55 * MINUTE) {
        relativeString = [NSString stringWithFormat:@"%ld分钟前",(long)components.minute];
        
    } else if (delta < 75 * MINUTE) {
        relativeString = @"1小时前";
        
    } else if (delta < 6 * HOUR) {
        relativeString = [NSString stringWithFormat:@"%ld小时前",(long)components.hour];
        
    } else if ([dateTime isToday]) {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"aa HH:mm"];
        [formatter setAMSymbol:@"上午"];
        [formatter setPMSymbol:@"下午"];
        relativeString = [formatter stringFromDate:dateTime];
        
    } else if ([dateTime isYesterday]) {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"昨天 HH:mm"];
        relativeString = [formatter stringFromDate:dateTime];
    }
    else {
        relativeString = [dateTime formattedDateWithFormatString:@"MM月dd日 HH:mm"];
    }
    return relativeString;
}

@end
