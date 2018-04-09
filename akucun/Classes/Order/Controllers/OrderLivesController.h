//
//  OrderLivesController.h
//  akucun
//
//  Created by Jarry Z on 2018/1/22.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "BaseViewController.h"
#import "TableCellBase.h"
#import "LiveInfo.h"

#define  kOrderLivesTopHeight   44.0f

@class OrderLiveTableCell;

/**
 售后中的活动列表
 */
@interface OrderLivesController : UIViewController

@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, copy) idBlock selectBlock;

@end

@interface OrderLiveTableCell : TableCellBase

@property (nonatomic, strong) UIImageView *logoImage;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) LiveInfo *liveInfo;

@property (nonatomic, assign) BOOL checked;

@end
