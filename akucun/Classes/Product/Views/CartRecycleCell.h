//
//  CartRecycleCell.h
//  akucun
//
//  Created by Jarry on 2017/9/2.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "AKTableViewCell.h"
#import "CartCellLayout.h"

@interface CartRecycleCell : AKTableViewCell

@property (nonatomic,strong) NSIndexPath* indexPath;

@property (nonatomic,copy) void(^clickedBuyCallback)(CartRecycleCell* cell, CartProduct *model);

@end
