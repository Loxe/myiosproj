//
//  ECTNavItemController.m
//  akucun
//
//  Created by Jarry on 2017/4/28.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ECTNavItemController.h"
#import "ECTabBarController.h"

@interface ECTNavItemController ()

@end

@implementation ECTNavItemController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) setTabTitle:(NSString *)title image:(NSString *)image
{
    [self ec_setTabTitle:title];
    [self ec_setTabImage:image];
}

@end
