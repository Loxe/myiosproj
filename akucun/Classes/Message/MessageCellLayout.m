//
//  MessageCellLayout.m
//  akucun
//
//  Created by Jarry on 2017/6/29.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "MessageCellLayout.h"
#import "NSDate+akucun.h"

@interface MessageCellLayout ()

@property (nonatomic, strong) LWTextStorage* iconStorage;

@end

@implementation MessageCellLayout

- (id) initWithModel:(Message *)model
{
    self = [super init];
    if (self) {
        @autoreleasepool {
            [self initContentWithModel:model];
        }
    }
    return self;
}

- (void) updateData
{
//    if (self.iconStorage) {
//        [self removeStorage:self.iconStorage];
//    }
//    LWTextStorage* iconStorage = [[LWTextStorage alloc] init];
//    iconStorage.text = FA_ICONFONT_MSG2;
//    iconStorage.font = FA_ICONFONTSIZE(26);
//    iconStorage.textColor = self.model.readflag == 0 ? COLOR_SELECTED : COLOR_TEXT_NORMAL;
//    iconStorage.frame = CGRectMake(kOFFSET_SIZE, kOFFSET_SIZE, CGFLOAT_MAX, CGFLOAT_MAX);
//    self.iconStorage = iconStorage;
//    [self addStorage:iconStorage];
}

- (void) initContentWithModel:(Message *)model
{
    self.model = model;
    
    CGFloat top = isPad ? 20 : kOFFSET_SIZE;
    LWTextStorage* iconStorage = [[LWTextStorage alloc] init];
    iconStorage.text = FA_ICONFONT_MSG2;
    iconStorage.font = FA_ICONFONTSIZE(26);
    iconStorage.textColor = model.readflag == 0 ? COLOR_SELECTED : COLOR_TEXT_NORMAL;
    iconStorage.frame = CGRectMake(kOFFSET_SIZE, top, CGFLOAT_MAX, CGFLOAT_MAX);
//    self.iconStorage = iconStorage;
    
    //
    LWTextStorage* titleStorage = [[LWTextStorage alloc] init];
    titleStorage.text = model.title;
    titleStorage.font = BOLDTNRFONTSIZE(15);
    titleStorage.textColor = model.readflag == 0 ? COLOR_TEXT_LINK : COLOR_TEXT_NORMAL;
    titleStorage.frame = CGRectMake(iconStorage.right+kOFFSET_SIZE, top, SCREEN_WIDTH*0.6f, CGFLOAT_MAX);

    LWTextStorage* timeStorage = [[LWTextStorage alloc] init];
    timeStorage.text = [NSDate relativeDateString:model.timestamp];
    timeStorage.font = [FontUtils smallFont];
    timeStorage.textAlignment = NSTextAlignmentRight;
    timeStorage.textColor = COLOR_TEXT_NORMAL;
    timeStorage.frame = CGRectMake(titleStorage.right+kOFFSET_SIZE, titleStorage.top, SCREEN_WIDTH-titleStorage.right-kOFFSET_SIZE*2, CGFLOAT_MAX);
    
    LWTextStorage* contentStorage = [[LWTextStorage alloc] init];
    contentStorage.text = model.content;
    contentStorage.font = [FontUtils normalFont];
    contentStorage.textColor = COLOR_TEXT_NORMAL;
    contentStorage.frame = CGRectMake(titleStorage.left, titleStorage.bottom+5.0f, SCREEN_WIDTH-titleStorage.left-kOFFSET_SIZE, CGFLOAT_MAX);
    
//    [self addStorage:iconStorage];
    [self addStorage:titleStorage];
    [self addStorage:timeStorage];
    [self addStorage:contentStorage];

    self.cellHeight = [self suggestHeightWithBottomMargin:top];
    
    [self updateData];
}

@end
