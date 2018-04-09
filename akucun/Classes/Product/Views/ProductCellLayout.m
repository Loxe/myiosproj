//
//  ProductCellLayout.m
//  akucun
//
//  Created by Jarry on 2017/3/30.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ProductCellLayout.h"
#import "NSMutableAttributedString+Gallop.h"
#import "UserManager.h"

@interface ProductCellLayout ()

//@property (nonatomic, strong) LWTextStorage* timeTextStorage;

@property (nonatomic, strong) NSMutableArray* skuStorageArray;

@property (nonatomic, strong) LWImageStorage* commentBgStorage;
@property (nonatomic, strong) NSMutableArray* commentTextStorages;

@end

@implementation ProductCellLayout

- (void) updateData
{
    if (self.skuStorageArray) {
        [self removeStorages:self.skuStorageArray];
    }
    
    NSArray *skus = self.productModel.skus;
    NSInteger skuCount = skus.count;
    NSMutableArray* skuStorageArray = [NSMutableArray array];
    CGFloat spacing = 8.0f;
    NSInteger row = 0;
    CGFloat x = self.contentLeft + spacing;
    CGRect skuBgRect = self.skuBgPosition;
    CGFloat skuWidth = 0.0f;
    for (NSInteger i = 0; i < skuCount; i ++) {
        if (x + skuWidth > skuBgRect.origin.x + skuBgRect.size.width) { //column > 2
            row = row + 1;
            x = self.contentLeft + spacing;
        }
        CGFloat y = skuBgRect.origin.y + spacing + (row * (24 + spacing));
        CGRect skuRect = CGRectMake(x, y, skuBgRect.size.width, 24);

        ProductSKU *sku = skus[i];
        sku.isChecked = NO;
        NSString *skuText = FORMAT(@"　 %@ 　", sku.chima);
        
        LWTextStorage* skuStorage = [[LWTextStorage alloc] init];
        skuStorage.textBackgroundColor = COLOR_BG_TEXT_DISABLED;
        skuStorage.frame = skuRect;
        skuStorage.text = skuText;
        skuStorage.font = TNRFONTSIZE(14);
        skuStorage.textColor = COLOR_TEXT_DISABLED;
        skuStorage.linespacing = 10.0f;
        
        if (sku.shuliang > 0) {
            skuStorage.textBackgroundColor = COLOR_BG_TEXT;
            [skuStorage lw_addLinkWithData:sku
                                     range:NSMakeRange(0, skuText.length)
                                 linkColor:COLOR_TEXT_LINK
                            highLightColor:COLOR_BG_TEXT];
        }
        
        [skuStorageArray addObject:skuStorage];
        x = (skuStorage.right + spacing) + 18;
        skuWidth = skuStorage.width + spacing + 18;
    }
    
    if (skuCount > 0) {
        skuBgRect.size.height = (row + 2) * (24 + spacing);
        self.skuBgPosition = skuBgRect;
        self.skuBgBottom = skuBgRect.origin.y + skuBgRect.size.height;
        
        [self addStorages:skuStorageArray];
        self.skuStorageArray = skuStorageArray;
    }
    
    CGFloat margin = isPad ? 30 : kOFFSET_SIZE*1.2;
    //
    if (self.commentBgStorage) {
        [self removeStorage:self.commentBgStorage];
    }
    if (self.commentTextStorages) {
        [self removeStorages:self.commentTextStorages];
    }
    //
    NSArray *comments = self.productModel.comments;
    NSInteger commentCount = comments.count;
    if (commentCount > 0) {
        LWImageStorage* commentBgStorage = [[LWImageStorage alloc] init];
        NSMutableArray* commentTextStorages = [NSMutableArray array];
        CGFloat commentY = self.skuBgBottom + 20.0f;
        for (NSInteger i = 0; i < commentCount; i ++) {
            Comment *comment = comments[i];
            LWTextStorage* commentStorage = [[LWTextStorage alloc] init];
            commentStorage.frame = CGRectMake(self.contentLeft + 8.0f, commentY, skuBgRect.size.width-16.0f, 20);
            commentStorage.text = FORMAT(@"%@ : %@", comment.name, comment.content);
            commentStorage.textColor = COLOR_TEXT_NORMAL;
            commentStorage.font = [FontUtils smallFont];
            commentStorage.linespacing = 3.0f;
            
            [commentStorage lw_addLinkForWholeTextStorageWithData:comment
                                                   highLightColor:COLOR_BG_TEXT];
            
            [commentStorage lw_addLinkWithData:nil
                                         range:NSMakeRange(0, comment.name.length)
                                     linkColor:COLOR_TEXT_LINK
                                highLightColor:COLOR_BG_TEXT];
            
            [commentTextStorages addObject:commentStorage];
            
            commentY = commentStorage.bottom + 8.0f;
        }
        
        commentBgStorage.frame = CGRectMake(self.contentLeft,
                                            self.skuBgBottom + 5.0f,
                                            skuBgRect.size.width,
                                            commentY - self.skuBgBottom - 5.0f);
        commentBgStorage.contents = IMAGENAMED(@"bg_comment");
        [commentBgStorage stretchableImageWithLeftCapWidth:40 topCapHeight:15];
        
        [self addStorage:commentBgStorage];
        [self addStorages:commentTextStorages];
        self.commentBgStorage = commentBgStorage;
        self.commentTextStorages = commentTextStorages;
        
        self.cellHeight = [self suggestHeightWithBottomMargin:margin];
    }
    else {
        self.cellHeight = self.skuBgBottom + margin;
    }

    //    self.timeTextStorage.text = [self relativeDateString:self.productModel.updateTime];
}

- (id) initWithModel:(ProductModel *)product
{
    self = [super init];
    if (self) {
        @autoreleasepool {
            [self initContentWithModel:product];
        }
    }
    return self;
}

- (void) initContentWithModel:(ProductModel *)product
{
    self.productModel = product;
    
    CGFloat top = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
    //
    CGFloat logoSize = 40.0f;
    CGFloat contentWidth = SCREEN_WIDTH - logoSize - kOFFSET_SIZE*2.8;

    // 名称模型 nameTextStorage
    LWTextStorage* nameTextStorage = [[LWTextStorage alloc] init];
    nameTextStorage.text = product.pinpai;
    nameTextStorage.font = BOLDTNRFONTSIZE(15);
    nameTextStorage.frame = CGRectMake(logoSize + kOFFSET_SIZE*1.8,
                                       top - 2.0f,
                                       contentWidth,
                                       CGFLOAT_MAX);
    [nameTextStorage lw_addLinkWithData:product
                                  range:NSMakeRange(0, product.pinpai.length)
                              linkColor:COLOR_TEXT_LINK
                         highLightColor:COLOR_BG_TEXT];
    
    self.nameCenterY = nameTextStorage.top + nameTextStorage.height*0.5f;

    // 正文内容模型 contentTextStorage
    LWTextStorage* contentTextStorage = [[LWTextStorage alloc] init];
    contentTextStorage.maxNumberOfLines = 15;//设置最大行数，超过则折叠
    contentTextStorage.linespacing = 2.0f;
    contentTextStorage.lineBreakMode = NSLineBreakByCharWrapping;
    contentTextStorage.font = [FontUtils normalFont];
    contentTextStorage.textColor = COLOR_TEXT_DARK;
    contentTextStorage.frame = CGRectMake(nameTextStorage.left,
                                          nameTextStorage.bottom + 10.0f,
                                          contentWidth,
                                          CGFLOAT_MAX);
    contentTextStorage.text = product.desc;
    /*
    if (product.bohuojia > 0 && [UserManager isVIP]) {
        NSInteger daigoufei = product.bohuojia - product.jiesuanjia;
        NSString *dgfText = FORMAT(@"¥%ld", (long)daigoufei/100);
        contentTextStorage.text = FORMAT(@"%@ 【代购费: %@】", product.desc, dgfText) ;
        [contentTextStorage lw_addLinkWithData:nil
                                         range:NSMakeRange(product.desc.length+1, dgfText.length+7)
                                     linkColor:COLOR_SELECTED
                                highLightColor:CLEAR_COLOR];
    }
    else {
        contentTextStorage.text = product.desc;
    }*/
    
    BOOL showSKU = (product.skus && product.skus.count > 0);
    CGFloat contentBottom = contentTextStorage.bottom;
    
    if (showSKU && product.isvirtual) {
        LWTextStorage* virtualTextStorage = [[LWTextStorage alloc] init];
        virtualTextStorage.text = @"【虚拟商品不退不换】";
        virtualTextStorage.font = [FontUtils normalFont];
        virtualTextStorage.textColor = COLOR_SELECTED;
        virtualTextStorage.frame = CGRectMake(nameTextStorage.left-6.0f, contentBottom + 5.0f, contentWidth, CGFLOAT_MAX);
        [self addStorage:virtualTextStorage];
        contentBottom = virtualTextStorage.bottom;
    }
    
    self.contentBottom = contentBottom + 10.0f;
    if (product.salestype == SalesTypeDouble) {
        self.contentBottom = contentBottom + 20.0f;
    }
    
    if (showSKU && product.bohuojia > 0 && [UserManager isVIP]) { // 非VIP不显示
        LWTextStorage* priceTextStorage = [[LWTextStorage alloc] init];
        priceTextStorage.font = [FontUtils normalFont];
        priceTextStorage.textColor = COLOR_SELECTED;
        priceTextStorage.textAlignment = NSTextAlignmentRight;
        priceTextStorage.frame = CGRectMake(nameTextStorage.left, self.contentBottom, contentWidth, CGFLOAT_MAX);

        NSInteger daigoufei = product.bohuojia - product.jiesuanjia;
        NSString *priceStr = FORMAT(@"代购费：¥ %ld", (long)daigoufei/100);
        if (product.salestype == SalesTypeDouble) {
            priceStr = FORMAT(@"代购费：¥ %ldx2", (long)daigoufei/200);
        }
        NSMutableAttributedString *priceAttrText = [[NSMutableAttributedString alloc] initWithString:priceStr];
        [priceAttrText addAttributes:@{ NSForegroundColorAttributeName :COLOR_SELECTED, NSFontAttributeName : [FontUtils smallFont] } range:NSMakeRange(0, priceStr.length)];
        [priceAttrText addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(22) range:NSMakeRange(6, priceStr.length-6)];
        if (product.salestype == SalesTypeDouble) {
            [priceAttrText addAttribute:NSFontAttributeName value:[UIFont italicSystemFontOfSize:22] range:NSMakeRange(priceStr.length-2, 2)];
        }
        [priceAttrText setTextAlignment:NSTextAlignmentRight range:NSMakeRange(0, priceStr.length)];
        priceTextStorage.attributedText = priceAttrText;
        
        [self addStorage:priceTextStorage];
        contentBottom = priceTextStorage.bottom;
    }

    // 发布的图片模型 imgsStorage
    CGFloat imgCount = isPad ? 3.5f : 3.0f;
    CGFloat imageWidth = (SCREEN_WIDTH - nameTextStorage.left - kOFFSET_SIZE*2 - 10.0f)/imgCount;
    CGFloat imageHeight = imageWidth * 2 + 5.0f;
    
    //生成时间的模型 timeTextStorage
    LWTextStorage* timeTextStorage = [[LWTextStorage alloc] init];
    timeTextStorage.text = [self dateString:product.updateTime];
    timeTextStorage.font = [FontUtils smallFont];
    timeTextStorage.textColor = COLOR_TEXT_NORMAL;
    timeTextStorage.frame = CGRectMake(nameTextStorage.left,
                                       contentBottom + imageHeight + 30.0f,
                                       SCREEN_WIDTH - kOFFSET_SIZE * 2,
                                       CGFLOAT_MAX);

    CGFloat menuPosition = timeTextStorage.top - 5.0f;
    
    LWTextStorage* infoTextStorage = [[LWTextStorage alloc] init];
    infoTextStorage.text = @"先选尺码 再按购买下单";
    infoTextStorage.font = [FontUtils smallFont];
    infoTextStorage.textColor = LIGHTGRAY_COLOR;
    infoTextStorage.frame = CGRectMake(nameTextStorage.left,
                                       timeTextStorage.bottom + 12.0f,
                                       SCREEN_WIDTH - kOFFSET_SIZE * 2,
                                       CGFLOAT_MAX);
    
    LWTextStorage* forwardStorage = [[LWTextStorage alloc] init];
    forwardStorage.font = [FontUtils smallFont];
    forwardStorage.textColor = COLOR_SELECTED;
    forwardStorage.textAlignment = NSTextAlignmentRight;
    forwardStorage.frame = CGRectMake(kOFFSET_SIZE,
                                       infoTextStorage.top,
                                       SCREEN_WIDTH - kOFFSET_SIZE*2,
                                       CGFLOAT_MAX);
    forwardStorage.text = (product.forward>0)?@"已转发":@"";

    //
    CGRect skuBgRect = CGRectMake(nameTextStorage.left,
                                  infoTextStorage.bottom + 5.0f,
                                  contentWidth,
                                  60);
    CGFloat skuBgBottom = skuBgRect.origin.y + skuBgRect.size.height;    
    self.skuBgPosition = skuBgRect;
    self.skuBgBottom = skuBgBottom;
    
    if (!showSKU) {
        self.skuBgBottom = timeTextStorage.bottom + 12.0f;
    }
    
    [self addStorage:nameTextStorage];
    [self addStorage:contentTextStorage];
    [self addStorage:timeTextStorage];
    [self addStorage:forwardStorage];

    if (showSKU) {
        [self addStorage:infoTextStorage];
    }
    
//    [self addStorages:imageStorageArray];
//    [self addStorages:skuStorageArray];
//    [self addStorage:skuTextStorage];
//    [self addStorage:commentBgStorage];
//    [self addStorages:commentTextStorages];
//    [self addStorages:cancelTextStorages];
    
//    self.timeTextStorage = timeTextStorage;
//    self.skuStorageArray = skuStorageArray;
    
    self.contentLeft = nameTextStorage.left;
    self.menuPosition = menuPosition;//右下角菜单按钮的位置
//    self.imagePostions = imagePositionArray;//保存图片位置的数组
    self.imagesRect = CGRectMake(nameTextStorage.left, contentBottom + 10.0f, imageWidth*2 + 5.0f, imageWidth*2 + 5.0f);
    self.imageWidth = imageWidth;
    
    [self updateData];
    
//    self.cellHeight = [self suggestHeightWithBottomMargin:kOFFSET_SIZE*1.2];
}


- (NSString *) relativeDateString:(NSTimeInterval)time
{
    NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:time];
    
    const int SECOND = 1;
    const int MINUTE = 60 * SECOND;
//    const int HOUR = 60 * MINUTE;
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
        
    } else if ([dateTime isToday]) {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"aa HH:mm"];
        [formatter setAMSymbol:@"上午"];
        [formatter setPMSymbol:@"下午"];
        relativeString = [formatter stringFromDate:dateTime];
    }
    else {
        relativeString = [dateTime formattedDateWithFormatString:@"MM/dd HH:mm"];
    }
    
    return relativeString;
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
