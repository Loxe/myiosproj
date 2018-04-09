//
//  BindPhoneController.h
//  akucun
//
//  Created by Jarry on 2017/7/14.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "BaseViewController.h"
#import "SubUser.h"

@interface BindPhoneController : BaseViewController

@property (nonatomic, copy) SubUser  *subUser;

@property (nonatomic, copy) voidBlock finishedBlock;

@end
