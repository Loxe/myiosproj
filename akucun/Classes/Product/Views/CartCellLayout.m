//
//  CartCellLayout.m
//  akucun
//
//  Created by Jarry on 2017/4/2.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "CartCellLayout.h"

#define IMAGE_IDENTIFIER    @"image"

@implementation CartCellLayout

- (id) initWithModel:(CartProduct*)cartProduct checkable:(BOOL)checkable remark:(BOOL)showRemark
{
    self = [super init];
    if (self) {
        @autoreleasepool {
            self.isCheckable = checkable;
            self.showRemark = showRemark;
            [self initContentWithModel:cartProduct];
        }
    }
    return self;
}

- (void) initContentWithModel:(CartProduct *)cartProduct
{
    self.cartProduct = cartProduct;
    
    BOOL quehuo = NO; //[cartProduct quehuo];
    if (self.cartProduct.scanstatu > 0) {
        quehuo = YES;
    }
    
    CGFloat offset = isPad ? 25 : kOFFSET_SIZE;
    CGFloat imageWidth = 80;
    CGFloat left = self.isCheckable ? (kOFFSET_SIZE*1.5+18) :  kOFFSET_SIZE;
    CGFloat imageRight = left + imageWidth;
    self.imagePosition = CGRectMake(left, offset, imageWidth, imageWidth);
    
    CGFloat contentWidth = SCREEN_WIDTH - imageRight - kOFFSET_SIZE * 2;
    // 正文内容模型 contentTextStorage
    LWTextStorage* contentTextStorage = [[LWTextStorage alloc] init];
    contentTextStorage.text = [cartProduct productDesc];
    contentTextStorage.font = [FontUtils normalFont];
    contentTextStorage.textColor = quehuo ? COLOR_APP_GREEN : COLOR_TEXT_DARK;
    contentTextStorage.frame = CGRectMake(imageRight + kOFFSET_SIZE,
                                          offset-3.0f,
                                          contentWidth,
                                          CGFLOAT_MAX);
    
    CGFloat skuTop = contentTextStorage.bottom+10;
    if (cartProduct.showBarcode) {
        LWTextStorage* barcodeStorage = [[LWTextStorage alloc] init];
        barcodeStorage.frame = CGRectMake(contentTextStorage.left, contentTextStorage.bottom + 8, contentWidth, CGFLOAT_MAX);
        barcodeStorage.textColor = quehuo ? COLOR_APP_GREEN : RED_COLOR;
        barcodeStorage.font = [FontUtils smallFont];
        if (cartProduct.sku) {
            barcodeStorage.text = FORMAT(@"条码  %@",cartProduct.sku.barcode);
        }
        else {
            barcodeStorage.text = FORMAT(@"条码  %@",cartProduct.barcode);
        }
        [self addStorage:barcodeStorage];
        skuTop = barcodeStorage.bottom + 5;
    }

    LWTextStorage* amountTextStorage = [[LWTextStorage alloc] init];
    amountTextStorage.text = [cartProduct jiesuanPrice];
    amountTextStorage.font = [FontUtils smallFont];
    amountTextStorage.textColor = quehuo ? COLOR_APP_GREEN : COLOR_TEXT_DARK;
    amountTextStorage.textAlignment = NSTextAlignmentRight;
    amountTextStorage.frame = CGRectMake(contentTextStorage.left,
                                         skuTop,
                                         contentWidth,
                                         CGFLOAT_MAX);
    
    LWTextStorage* skuTextStorage = [[LWTextStorage alloc] init];
    if (cartProduct.sku) {
        skuTextStorage.text = FORMAT(@"%@ x1%@", cartProduct.sku.chima, cartProduct.danwei);
    }
    else {
        skuTextStorage.text = FORMAT(@"%@ x1%@", cartProduct.chima, cartProduct.danwei);
    }
    skuTextStorage.font = [FontUtils smallFont];
    skuTextStorage.textColor = quehuo ? COLOR_APP_GREEN : COLOR_TEXT_DARK;
    skuTextStorage.frame = CGRectMake(contentTextStorage.left,
                                      skuTop,
                                      contentWidth-5-amountTextStorage.width,
                                      CGFLOAT_MAX);
    
    CGFloat remarkY = MAX(imageWidth+offset*2.0f, skuTextStorage.bottom + 13);
    if (![NSString isEmpty:cartProduct.extrainfo]) {
        NSString *infoText = FORMAT(@"附加信息：%@", cartProduct.extrainfo);
        LWTextStorage* infoTextStorage = [[LWTextStorage alloc] init];
        infoTextStorage.font = [FontUtils smallFont];
        infoTextStorage.textColor = COLOR_TEXT_NORMAL;
        infoTextStorage.frame = CGRectMake(kOFFSET_SIZE, remarkY, SCREEN_WIDTH-kOFFSET_SIZE*2, CGFLOAT_MAX);
        infoTextStorage.text = infoText;
        [infoTextStorage lw_addLinkWithData:@"info"
                                      range:NSMakeRange(5, infoText.length-5)
                                  linkColor:COLOR_TEXT_LINK
                             highLightColor:COLOR_BG_TEXT];
        [self addStorage:infoTextStorage];
        remarkY = infoTextStorage.bottom + 10.0f;
    }

    if (self.showRemark) {
        LWTextStorage* remarkTextStorage = [[LWTextStorage alloc] init];
        if (cartProduct.remark.length > 0) {
            remarkTextStorage.text = FORMAT(@"备注：%@", cartProduct.remark);
        }
        else {
            remarkTextStorage.text = @"备注：";
        }
        remarkTextStorage.font = [FontUtils smallFont];
        remarkTextStorage.textColor = quehuo ? RED_COLOR : COLOR_TEXT_NORMAL;
        remarkTextStorage.frame = CGRectMake(kOFFSET_SIZE,
                                             remarkY,
                                             SCREEN_WIDTH*0.5f,
                                             CGFLOAT_MAX);
        [self addStorage:remarkTextStorage];
    }
    
    /*
    if (self.cartProduct.isPeihuo) {
        LWTextStorage* statusTextStorage = [[LWTextStorage alloc] init];
        statusTextStorage.frame = CGRectMake(kOFFSET_SIZE, remarkTextStorage.bottom+10, 100, 20);
        statusTextStorage.textColor = RED_COLOR;
        statusTextStorage.font = [FontUtils smallFont];
        statusTextStorage.text = @"已拣货";
        [self addStorage:statusTextStorage];
    }*/
    
//    [self addStorage:imageStorage];
    [self addStorage:contentTextStorage];
    [self addStorage:skuTextStorage];
    [self addStorage:amountTextStorage];
//    [self addStorage:statusTextStorage];

    self.buttonPosition = remarkY;// MAX(imageWidth+offset*2.0f, skuTextStorage.bottom + 13);
    CGFloat margin = isPad ? 25 : kOFFSET_SIZE;
    if (!self.showRemark) {
        margin  += 20 + kOFFSET_SIZE;
    }
    self.cellHeight = [self suggestHeightWithBottomMargin:margin];
}

@end
