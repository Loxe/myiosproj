//
//  UserManagerController.h
//  akucun
//
//  Created by Jarry Z on 2018/3/24.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "BaseViewController.h"
#import "TableCellBase.h"
#import "IconButton.h"

@interface UserManagerController : BaseViewController

@end

@interface SubUserCell : TableCellBase

@property (nonatomic, strong) UIImageView *avatarImage;
@property (nonatomic, strong) UIButton *unbindButton;

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) IconButton *defaultButton;    // 主账号

@property (nonatomic, strong) SubUser *subUser;

@property (nonatomic, copy) voidBlock defaultBlock;
@property (nonatomic, copy) voidBlock actionBlock;

@end
