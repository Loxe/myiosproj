//
//  LeftMenuTableCell.h
//  akucun
//
//  Created by Jarry Zhu on 2017/12/21.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "TableCellBase.h"
#import "LiveInfo.h"

#define kLeftMenuWidth  (isPad ? (SCREEN_WIDTH*0.5f) : (SCREEN_WIDTH*0.8f))

@interface LeftMenuTableCell : TableCellBase

@property (nonatomic, strong) UIImageView *logoImage;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *newLabel;
@property (nonatomic, strong) UIImageView *vipIconView;

@property (nonatomic, strong) LiveInfo *liveInfo;

@end
