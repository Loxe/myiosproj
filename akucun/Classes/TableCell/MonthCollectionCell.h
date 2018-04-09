//
//  MonthCollectionCell.h
//  akucun
//
//  Created by deepin do on 2018/1/17.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonthCollectionCell : UICollectionViewCell

@property(nonatomic, strong) UILabel  *yearLabel;     // 年份
@property(nonatomic, strong) UILabel  *monthLabel;    // 月份
@property(nonatomic, strong) UIView   *redBarView;    // 红色底部条
@property(nonatomic, assign) BOOL     isChoosed;


@end
