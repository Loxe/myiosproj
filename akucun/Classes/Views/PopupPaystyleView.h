//
//  PopupPaystyleView.h
//  akucun
//
//  Created by Jarry on 2017/9/3.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "MMPopupView.h"

@interface PopupPaystyleView : MMPopupView

@property (nonatomic, copy) intBlock selectBlock;

- (instancetype) initWithTitle:(NSString *)title types:(NSArray *)payTypes value:(NSInteger)value;

@end
