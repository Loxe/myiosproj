//
//  LogisticsTransferCell.h
//  akucun
//
//  Created by deepin do on 2017/12/7.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdOrder.h"
#import "OrderModel.h"

@interface LogisticsTransferCell : UITableViewCell

@property (nonatomic, strong) AdOrder *adOrder;
@property (nonatomic, strong) OrderModel *order;

// 品牌图标
@property(nonatomic, strong) UIImageView *brandImageView;

// 品牌名称
@property(nonatomic, strong) UILabel *brandLabel;

// 总件数
@property(nonatomic, strong) UILabel *totalCountLabel;

// 发货单号-标题
@property(nonatomic, strong) UILabel *orderNumberTitle;

// 发货单号
@property(nonatomic, strong) UILabel *orderNumberLabel;

// 发货时间-标题
@property(nonatomic, strong) UILabel *sendTimeTitle;

// 发货时间
@property(nonatomic, strong) UILabel *sendTimeLabel;

@end
