//
//  TradeDetailBillCell.h
//  akucun
//
//  Created by deepin do on 2018/1/9.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TradeModel.h"

@interface TradeDetailBillCell : UITableViewCell

@property(nonatomic, strong) UILabel *numTitleLabel;

@property(nonatomic, strong) UILabel *numDetailLabel;

@property(nonatomic, strong) UILabel *dateTitleLabel;

@property(nonatomic, strong) UILabel *dateDetailLabel;

@property(nonatomic, strong) UILabel *billTitleLabel;

@property(nonatomic, strong) UILabel *billDetailLabel;

@property(nonatomic, strong) TradeModel *model;

@end
