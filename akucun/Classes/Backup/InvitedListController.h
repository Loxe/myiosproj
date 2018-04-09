//
//  InvitedListController.h
//  akucun
//
//  Created by Jarry Zhu on 2017/10/25.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "BaseViewController.h"
#import "InvitedUser.h"

@interface InvitedTableCell : UITableViewCell

@property (nonatomic, strong) UIView *seperatorLine;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *activeButton;

@property (nonatomic, strong) InvitedUser *userItem;
@property (nonatomic, copy) idBlock actionBlock;

@end

@interface InvitedListController : BaseViewController

@end
