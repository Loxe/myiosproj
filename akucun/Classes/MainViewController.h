//
//  MainViewController.h
//  akucun
//
//  Created by Jarry on 2017/3/21.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ECTabBarController.h"

@interface MainViewController : ECTabBarController <ECTabBarControllerDelegate>

@property (nonatomic, assign) BOOL isFirstLogin;

@property (nonatomic, copy) NSString *liveId;

- (void) updateLeftButton:(UIButton *)button;

- (void) updateForwardPinpai:(NSString *)pinpaiId;

@end
