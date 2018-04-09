//
//  LeftMenuController.h
//  akucun
//
//  Created by Jarry Zhu on 2017/12/21.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "BaseViewController.h"
#import "LeftMenuTableCell.h"

@interface LeftMenuController : UIViewController

@property (nonatomic, copy) intIdBlock selectBlock;

@property (nonatomic, assign) BOOL shouldUpdate;

- (void) updateData;

- (void) hideMenu;

@end
