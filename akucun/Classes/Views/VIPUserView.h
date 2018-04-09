//
//  VIPUserView.h
//  akucun
//
//  Created by Jarry on 2017/8/20.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"
#import "SCStarRateView.h"

@interface VIPUserView : UIView

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel, *statusLabel, *vipLabel;
@property (nonatomic, strong) SCStarRateView *vipStarView;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UserInfo *userInfo;

@end
