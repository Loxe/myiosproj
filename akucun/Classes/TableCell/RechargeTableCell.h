//
//  RechargeTableCell.h
//  akucun
//
//  Created by Jarry on 2017/9/17.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RechargeItem.h"

@interface RechargeTableCell : UITableViewCell

@property (nonatomic, strong) RechargeItem *rechargeItem;

@property (nonatomic, assign) BOOL cellSelected;

@end
