//
//  CartTableCell.h
//  akucun
//
//  Created by Jarry on 2017/4/2.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "AKTableViewCell.h"
#import "CartCellLayout.h"

@interface CartTableCell : AKTableViewCell

@property (nonatomic,strong) NSIndexPath* indexPath;

@property (nonatomic,assign) BOOL invalid;

@property (nonatomic,copy) void(^clickedRemarkCallback)(CartTableCell* cell, CartProduct *model);

@property (nonatomic,copy) void(^clickedDeleteCallback)(CartTableCell* cell, CartProduct *model);

@end
