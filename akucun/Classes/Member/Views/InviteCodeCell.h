//
//  InviteCodeCell.h
//  akucun
//
//  Created by deepin do on 2018/2/26.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefCode.h"

#define kAvatorWH 50
#define kBtnWH    50

typedef void(^ShareBlock)(id nsobject);

@interface InviteCodeCell : UITableViewCell

@property(nonatomic, strong) UIImageView *avatorImgView;

@property(nonatomic, strong) UILabel *actionLabel;

@property(nonatomic, strong) UILabel *codeLabel;

@property(nonatomic, strong) UIButton *shareBtn;

@property (nonatomic, strong) UIView *BGView;

@property(nonatomic, copy) ShareBlock shareBlock;

@property (nonatomic, strong) RefCode *refCode;

@end
