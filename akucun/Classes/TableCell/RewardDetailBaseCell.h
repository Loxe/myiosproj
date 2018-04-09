//
//  RewardDetailBaseCell.h
//  akucun
//
//  Created by deepin do on 2018/1/17.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RewardDetailBaseCell : UITableViewCell

@property(nonatomic, strong) UILabel  *descLabel;

@property(nonatomic, strong) UILabel  *descMarkLabel;

@property(nonatomic, strong) UILabel  *countLabel;

@property(nonatomic, strong) UIView   *separateLine;

@property(nonatomic, strong) NSNumber *countNum;

@end
