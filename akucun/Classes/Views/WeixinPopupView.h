//
//  WeixinPopupView.h
//  akucun
//
//  Created by Jarry on 2017/4/24.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeixinPopupView : UIView

@property (nonatomic, copy) idBlock completeBolck;


+ (void) showWithCompeted:(idBlock)completeBolck;

@end
