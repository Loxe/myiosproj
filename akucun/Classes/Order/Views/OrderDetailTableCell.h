//
//  OrderDetailTableCell.h
//  akucun
//
//  Created by Jarry on 2017/4/18.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "AKTableViewCell.h"
#import "CartCellLayout.h"

// 订单商品状态
typedef NS_ENUM(NSInteger, eOrderProductAction)
{
    ProductActionNone = 0 ,     //
    ProductActionChange = 1 ,   // 更换尺码
    ProductActionTuihuo ,       // 申请退货 退款
    ProductActionTuikuan ,      // 申请退款 不发货
    ProductActionHuanhuo ,      // 申请换货
    ProductActionApply ,        // 申请售后
    ProductActionAfterSale      // 售后进度
//    ProductActionTuihuan ,      // 申请退换货
//    ProductActionBuyAgain       // 再次购买
//    ProductActionLoufa ,        // 漏发申诉
};

@interface OrderDetailTableCell : AKTableViewCell

@property (nonatomic,strong) NSIndexPath* indexPath;

@property (nonatomic, assign) BOOL showStatus;

@property (nonatomic,copy) void(^clickedActionCallback)(OrderDetailTableCell* cell, NSInteger action, CartProduct *model);

@property (nonatomic,copy) void(^clickedRemarkCallback)(OrderDetailTableCell* cell, CartProduct *model);

//@property (nonatomic, assign) NSInteger orderStatus;

@property (nonatomic, assign) NSInteger status;

@end
