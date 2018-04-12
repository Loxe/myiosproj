//
//  DeliverLiveTableCell.h
//  akucun
//
//  Created by Jarry Z on 2018/4/12.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "TableCellBase.h"
#import "LiveInfo.h"

@interface DeliverLiveTableCell : TableCellBase

@property (nonatomic, strong) UIImageView *logoImage;
@property (nonatomic, strong) UILabel *adorderLabel, *totalLabel, *scanedLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) LiveInfo *liveInfo;
@property (nonatomic, assign) NSInteger type;

@end
