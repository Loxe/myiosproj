//
//  LogisticsDetailCell.h
//  akucun
//
//  Created by deepin do on 2017/12/7.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogisticsInfo.h"
#import <YYText/YYLabel.h>

@interface LogisticsDetailCell : UITableViewCell

@property(nonatomic, strong) LogisticsInfo *logisticsInfo;

@property(nonatomic, copy) idBlock phoneBlock;

// 上线
@property(nonatomic, strong) UIView *topLine;

// 黑点
@property(nonatomic, strong) UIView *blackPoint;

// 红点
@property(nonatomic, strong) UIView *redPoint;

// 下线
@property(nonatomic, strong) UIView *bottomLine;

// 描述信息
@property(nonatomic, strong) YYLabel *infoLabel;

// 时间
@property(nonatomic, strong) UILabel *timeLabel;

// 底线
@property(nonatomic, strong) UIView *sepLine;

@end
