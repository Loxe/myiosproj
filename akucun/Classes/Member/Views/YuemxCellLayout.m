//
//  YuemxCellLayout.m
//  akucun
//
//  Created by Jarry on 2017/6/18.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "YuemxCellLayout.h"
#import "NSString+akucun.h"

@implementation YuemxCellLayout

- (id) initWithModel:(AccountRecord*)record
{
    self = [super init];
    if (self) {
        @autoreleasepool {
            [self initContentWithModel:record];
        }
    }
    return self;
}

- (void) initContentWithModel:(AccountRecord *)record
{
    self.record = record;
    
    CGFloat offset = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
    //
    LWTextStorage* amountTextStorage = [[LWTextStorage alloc] init];
    if (record.type == AccountRecordIN) {
        amountTextStorage.textColor = COLOR_APP_ORANGE;
        amountTextStorage.text = FORMAT(@"+ %@", [NSString priceString:record.jine]);
    }
    else {
        amountTextStorage.textColor = COLOR_APP_GREEN;
        amountTextStorage.text = FORMAT(@"- %@", [NSString priceString:record.jine]);
    }
    amountTextStorage.font = [FontUtils bigFont];
    amountTextStorage.textAlignment = NSTextAlignmentRight;
    amountTextStorage.frame = CGRectMake(kOFFSET_SIZE,
                                       offset,
                                       SCREEN_WIDTH - kOFFSET_SIZE*2,
                                       CGFLOAT_MAX);

    //
    LWTextStorage* nameStorage = [[LWTextStorage alloc] init];
    nameStorage.text = record.title; // [record yuanyinText];
    nameStorage.font = [FontUtils buttonFont];
    nameStorage.textColor = COLOR_TEXT_DARK;
    nameStorage.frame = CGRectMake(kOFFSET_SIZE, offset,
                                      SCREEN_WIDTH*2/3,
                                      CGFLOAT_MAX);
    
    //
    LWTextStorage* contentStorage = [[LWTextStorage alloc] init];
    contentStorage.text = record.miaoshu;
    contentStorage.font = [FontUtils normalFont];
    contentStorage.textColor = COLOR_TEXT_DARK;
    contentStorage.frame = CGRectMake(kOFFSET_SIZE,
                                       nameStorage.bottom + offset*0.5,
                                       SCREEN_WIDTH - kOFFSET_SIZE*2 - 80,
                                       CGFLOAT_MAX);
    
    //
    LWTextStorage* timeTextStorage = [[LWTextStorage alloc] init];
    timeTextStorage.text = record.time;
    timeTextStorage.font = [FontUtils smallFont];
    timeTextStorage.textColor = COLOR_TEXT_NORMAL;
    timeTextStorage.frame = CGRectMake(kOFFSET_SIZE,
                                       contentStorage.bottom + offset*0.5,
                                       SCREEN_WIDTH - kOFFSET_SIZE*2,
                                       CGFLOAT_MAX);

    [self addStorage:amountTextStorage];
    [self addStorage:nameStorage];
    [self addStorage:contentStorage];
    [self addStorage:timeTextStorage];

    self.cellHeight = [self suggestHeightWithBottomMargin:offset];
}

@end
