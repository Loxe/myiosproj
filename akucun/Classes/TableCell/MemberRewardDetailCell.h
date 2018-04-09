//
//  MemberRewardDetailCell.h
//  akucun
//
//  Created by deepin do on 2018/1/17.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamMember.h"

@interface MemberRewardDetailCell : UITableViewCell

@property(nonatomic, strong) UIImageView *avatorImgView;

@property(nonatomic, strong) UILabel *nameLabel;

@property(nonatomic, strong) UILabel *personCountLabel;

@property(nonatomic, strong) UILabel *forwardLabel;

@property(nonatomic, strong) UILabel *forwardCountLabel;

@property(nonatomic, strong) UIView  *separateLine;

@property(nonatomic, strong) TeamMember *model;

@end
