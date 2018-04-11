//
//  OrderCellLayout.m
//  akucun
//
//  Created by Jarry on 2017/4/2.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "OrderCellLayout.h"

#define LOGO_IDENTIFIER     @"logo"

@interface OrderCellLayout ()

@property (nonatomic, strong) LWTextStorage* statusTextStorage;

@end

@implementation OrderCellLayout

- (void) updateData
{
    if (self.statusTextStorage) {
        [self removeStorage:self.statusTextStorage];
    }
    
    //
    LWTextStorage* statusTextStorage = [[LWTextStorage alloc] init];
    statusTextStorage.font = [FontUtils smallFont];
    if (self.orderModel) {
        statusTextStorage.text = [self.orderModel statusText];
        statusTextStorage.textColor = [self.orderModel statusColor];
    }
    else if (self.adOrder) {
        if (self.adOrder.statu == 4) {
            statusTextStorage.text = [self.adOrder subStatusText];
            statusTextStorage.textColor = [self.adOrder subTextColor];
        }
        else if (self.adOrder.statu == 0) {
            statusTextStorage.text = @"待发货";
            statusTextStorage.textColor = COLOR_MAIN;
        }
        else {
            statusTextStorage.text = @"拣货中";
            statusTextStorage.textColor = COLOR_MAIN;
        }
    }

    CGFloat topOffset = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
    statusTextStorage.frame = CGRectMake(kOFFSET_SIZE, self.linePosition+topOffset*0.8,
                                         SCREEN_WIDTH * 0.5,
                                         CGFLOAT_MAX);
    self.statusTextStorage = statusTextStorage;
    [self addStorage:self.statusTextStorage];
    
    self.cellHeight = [self suggestHeightWithBottomMargin:topOffset * 0.8];
}

- (id) copyWithZone:(NSZone *)zone
{
    OrderCellLayout* one = [[OrderCellLayout alloc] init];
    one.cellHeight = self.cellHeight;
    one.orderModel = self.orderModel;
    one.nameHeight = self.nameHeight;
    return one;
}

- (id) initWithModel:(OrderModel*)orderModel showDate:(BOOL)flag
{
    self = [super init];
    if (self) {
        @autoreleasepool {
            self.showDate = flag;
            [self initContentWithModel:orderModel];
        }
    }
    return self;
}

- (id) initWithAdOrder:(AdOrder*)orderModel showDate:(BOOL)flag
{
    self = [super init];
    if (self) {
        @autoreleasepool {
            self.showDate = flag;
            [self initContentWithAdOrder:orderModel];
        }
    }
    return self;
}

- (void) initContentWithModel:(OrderModel *)order
{
    self.orderModel = order;
    
    CGFloat offset = kOFFSET_SIZE*0.3f;
    //
    LWTextStorage* dateTextStorage = [[LWTextStorage alloc] init];
    dateTextStorage.text = [order dateString];
    dateTextStorage.font = [FontUtils smallFont];
    dateTextStorage.textColor = COLOR_TEXT_DARK;
    dateTextStorage.frame = CGRectMake(kOFFSET_SIZE*1.2f,
                                       offset+2.0f,
                                       SCREEN_WIDTH * 0.5,
                                       CGFLOAT_MAX);
    
    CGFloat topOffset = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
    CGFloat top = topOffset;
    if (self.showDate) {
        self.dateHeight = dateTextStorage.bottom + offset;
        top = self.dateHeight + topOffset;
    }

    // 名称模型 nameTextStorage
    LWTextStorage* nameTextStorage = [[LWTextStorage alloc] init];
    nameTextStorage.text = order.pinpai;
    nameTextStorage.font = BOLDTNRFONTSIZE(15);
    nameTextStorage.textColor = COLOR_TITLE;
    nameTextStorage.frame = CGRectMake(18 + kOFFSET_SIZE*1.6,
                                       top,
                                       SCREEN_WIDTH - 18 - kOFFSET_SIZE * 3,
                                       CGFLOAT_MAX);
    
    //
    LWTextStorage* contentTextStorage = [[LWTextStorage alloc] init];
    contentTextStorage.text = FORMAT(@"共%ld件  结算金额：%@", (long)order.shangpinjianshu, [order totalAmount]);
    contentTextStorage.font = [FontUtils smallFont];
    contentTextStorage.textColor = COLOR_TEXT_DARK;
    contentTextStorage.textAlignment = NSTextAlignmentRight;
    contentTextStorage.frame = CGRectMake(kOFFSET_SIZE,
                                       top + 18 + topOffset,
                                       SCREEN_WIDTH - kOFFSET_SIZE * 2,
                                       CGFLOAT_MAX);
    
    //
    LWTextStorage* orderTextStorage = [[LWTextStorage alloc] init];
    orderTextStorage.text = FORMAT(@"订单号：%@", [order displayOrderId]);
    orderTextStorage.font = [FontUtils smallFont];
    orderTextStorage.textColor = COLOR_TEXT_NORMAL;
    orderTextStorage.frame = CGRectMake(kOFFSET_SIZE,
                                       contentTextStorage.top,
                                       SCREEN_WIDTH * 0.5,
                                       CGFLOAT_MAX);
    
    if (self.showDate) {
        [self addStorage:dateTextStorage];
    }
    [self addStorage:nameTextStorage];
    [self addStorage:contentTextStorage];
    [self addStorage:orderTextStorage];
    
    self.nameHeight = nameTextStorage.height + topOffset*2;
    self.linePosition = contentTextStorage.bottom + topOffset * 0.8;
    
    [self updateData];
//    self.cellHeight = [self suggestHeightWithBottomMargin:topOffset * 0.8];
}

- (void) initContentWithAdOrder:(AdOrder *)order
{
    self.adOrder = order;
    
    CGFloat offset = kOFFSET_SIZE*0.3f;
    //
    LWTextStorage* dateTextStorage = [[LWTextStorage alloc] init];
    dateTextStorage.text = [order dateString];
    dateTextStorage.font = [FontUtils smallFont];
    dateTextStorage.textColor = COLOR_TEXT_DARK;
    dateTextStorage.frame = CGRectMake(kOFFSET_SIZE*1.2f,
                                       offset+2.0f,
                                       SCREEN_WIDTH * 0.5,
                                       CGFLOAT_MAX);
    
    CGFloat topOffset = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
    CGFloat top = topOffset;
    if (self.showDate) {
        self.dateHeight = dateTextStorage.bottom + offset;
        top = self.dateHeight + topOffset;
    }
    
    // 名称模型 nameTextStorage
    LWTextStorage* nameTextStorage = [[LWTextStorage alloc] init];
    nameTextStorage.text = order.pinpai;
    nameTextStorage.font = BOLDTNRFONTSIZE(15);
    nameTextStorage.textColor = COLOR_TITLE;
    nameTextStorage.frame = CGRectMake(18 + kOFFSET_SIZE*1.6,
                                       top,
                                       SCREEN_WIDTH - 18 - kOFFSET_SIZE * 3,
                                       CGFLOAT_MAX);
    
    //
    LWTextStorage* contentTextStorage = [[LWTextStorage alloc] init];
    if (order.statu == 4) {
        if (order.substatu > 1 && order.pnum > 0) {
            contentTextStorage.text = FORMAT(@"共 %ld 件  实发: %ld件", (long)order.num, (long)order.pnum);
        }
        else {
            contentTextStorage.text = FORMAT(@"共 %ld 件", (long)order.num);
        }
    } else {
        contentTextStorage.text = FORMAT(@"待发 %ld 件", (long)[order daifahuoNum]);
    }
    contentTextStorage.font = [FontUtils smallFont];
    contentTextStorage.textColor = COLOR_TEXT_DARK;
    contentTextStorage.textAlignment = NSTextAlignmentRight;
    contentTextStorage.frame = CGRectMake(kOFFSET_SIZE,
                                          top + 18 + topOffset,
                                          SCREEN_WIDTH - kOFFSET_SIZE * 2,
                                          CGFLOAT_MAX);
    
    //
    LWTextStorage* orderTextStorage = [[LWTextStorage alloc] init];
    orderTextStorage.text = FORMAT(@"发货单：%@", [order odorderstr]);
    orderTextStorage.font = [FontUtils smallFont];
    orderTextStorage.textColor = COLOR_TEXT_NORMAL;
    orderTextStorage.frame = CGRectMake(kOFFSET_SIZE,
                                        contentTextStorage.top,
                                        SCREEN_WIDTH * 0.5,
                                        CGFLOAT_MAX);
    
    //
    
    if (self.showDate) {
        [self addStorage:dateTextStorage];
    }
    [self addStorage:nameTextStorage];
//    [self addStorage:statusTextStorage];
    [self addStorage:contentTextStorage];
    [self addStorage:orderTextStorage];
    
    self.nameHeight = nameTextStorage.height + topOffset*2;
    self.linePosition = contentTextStorage.bottom + topOffset * 0.8;
    
    [self updateData];
//    self.cellHeight = [self suggestHeightWithBottomMargin:topOffset * 0.8];
}

@end
