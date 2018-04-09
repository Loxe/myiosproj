//
//  TradeDetailCountCell.h
//  akucun
//
//  Created by deepin do on 2018/1/9.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TradeModel.h"

@interface TradeDetailCountCell : UITableViewCell

@property(nonatomic, strong) UILabel *descLabel;

@property(nonatomic, strong) UILabel *countLabel;

@property(nonatomic, strong) UILabel *resultLabel;

@property(nonatomic, strong) TradeModel *model;

@end
