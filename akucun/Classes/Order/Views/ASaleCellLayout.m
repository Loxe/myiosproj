//
//  ASaleCellLayout.m
//  akucun
//
//  Created by Jarry on 2017/9/12.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ASaleCellLayout.h"

@implementation ASaleCellLayout

- (id) initWithModel:(ASaleService *)model
{
    self = [super init];
    if (self) {
        @autoreleasepool {
            [self initContentWithModel:model];
        }
    }
    return self;
}

- (void) initContentWithModel:(ASaleService *)model
{
    self.model = model;

    CGFloat offset = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
    
    //
    LWTextStorage* typeTextStorage = [[LWTextStorage alloc] init];
    typeTextStorage.text = [model serviceTypeText];
    typeTextStorage.font = [FontUtils normalFont];
    typeTextStorage.textColor = COLOR_TEXT_DARK;
    typeTextStorage.textAlignment = NSTextAlignmentRight;
    typeTextStorage.frame = CGRectMake(SCREEN_WIDTH * 0.5f,
                                       offset,
                                       SCREEN_WIDTH * 0.5f-kOFFSET_SIZE,
                                       CGFLOAT_MAX);
    
    // 服务单号
    LWTextStorage* nameTextStorage = [[LWTextStorage alloc] init];
    nameTextStorage.text = FORMAT(@"服务单号：%@", model.servicehao);
    nameTextStorage.font = [FontUtils normalFont];
    nameTextStorage.textColor = COLOR_TEXT_DARK;
    nameTextStorage.frame = CGRectMake(kOFFSET_SIZE,
                                       offset,
                                       SCREEN_WIDTH - kOFFSET_SIZE * 2,
                                       CGFLOAT_MAX);
    
    //
    CGFloat imageWidth = 80.0f;
    self.imageTop = nameTextStorage.bottom+offset*1.6f;
    
    // 正文内容模型 contentTextStorage
    LWTextStorage* contentTextStorage = [[LWTextStorage alloc] init];
    contentTextStorage.text = [model productDesc];
    contentTextStorage.font = [FontUtils smallFont];
    contentTextStorage.textColor = COLOR_TEXT_DARK;
    CGFloat left = kOFFSET_SIZE*2 + imageWidth;
    CGFloat contentWidth = SCREEN_WIDTH - left - kOFFSET_SIZE;
    contentTextStorage.frame = CGRectMake(left, nameTextStorage.bottom+offset*1.6f, contentWidth, CGFLOAT_MAX);
    
    LWTextStorage* amountTextStorage = [[LWTextStorage alloc] init];
    amountTextStorage.text = [model jiesuanPrice];
    amountTextStorage.font = [FontUtils smallFont];
    amountTextStorage.textColor = COLOR_TEXT_DARK;
    amountTextStorage.textAlignment = NSTextAlignmentRight;
    amountTextStorage.frame = CGRectMake(contentTextStorage.left,
                                         contentTextStorage.bottom+10,
                                         contentWidth,
                                         CGFLOAT_MAX);
    
    LWTextStorage* skuTextStorage = [[LWTextStorage alloc] init];
    if (model.sku) {
        skuTextStorage.text = FORMAT(@"%@ x1%@", model.sku.chima, model.danwei);
    }
    skuTextStorage.font = [FontUtils smallFont];
    skuTextStorage.textColor = COLOR_TEXT_NORMAL;
    skuTextStorage.frame = CGRectMake(contentTextStorage.left,
                                      amountTextStorage.top,
                                      contentWidth-5-amountTextStorage.width,
                                      CGFLOAT_MAX);
    
    CGFloat positionY = MAX(self.imageTop+imageWidth, skuTextStorage.bottom);

    LWTextStorage* statusStorage = [[LWTextStorage alloc] init];
    statusStorage.text = FORMAT(@"售后进度：%@", [model statusText]);
    statusStorage.font = [FontUtils smallFont];
    statusStorage.textColor = [model statusColor];
    statusStorage.frame = CGRectMake(kOFFSET_SIZE,
                                       positionY + offset*1.6f,
                                       SCREEN_WIDTH - kOFFSET_SIZE * 2,
                                       CGFLOAT_MAX);
    
    [self addStorage:typeTextStorage];
    [self addStorage:nameTextStorage];
    [self addStorage:contentTextStorage];
    [self addStorage:amountTextStorage];
    [self addStorage:skuTextStorage];
    [self addStorage:statusStorage];

    self.linePosition1 = nameTextStorage.bottom + offset * 0.8f;
    self.linePosition2 = positionY + offset * 0.8f;

    CGFloat margin = isPad ? 25 : kOFFSET_SIZE;
    self.cellHeight = [self suggestHeightWithBottomMargin:margin];
}

@end
