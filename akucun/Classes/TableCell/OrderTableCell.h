//
//  OrderTableCell.h
//  akucun
//
//  Created by Jarry on 2017/4/2.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKTableViewCell.h"
#import "OrderCellLayout.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface OrderTableCell : AKTableViewCell

@property (nonatomic,strong) NSIndexPath* indexPath;

@property (nonatomic,copy) void(^clickedPayCallback)(OrderTableCell* cell, OrderModel *model);

@property (nonatomic,copy) void(^clickedPreviewCallback)(OrderTableCell* cell, id model, NSString *pathUrl);

@property (nonatomic,copy) void(^clickedScanCallback)(OrderTableCell* cell, AdOrder *model);

@end
