//
//  IDCardController.h
//  akucun
//
//  Created by deepin do on 2017/12/21.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface IDCardController : BaseViewController

@property(nonatomic, strong) UIImage  *IDCardFrontImg;
@property(nonatomic, strong) UIImage  *IDCardBackImg;
@property(nonatomic, strong) NSString *IDName;
@property(nonatomic, strong) NSString *IDNumber;

@end
