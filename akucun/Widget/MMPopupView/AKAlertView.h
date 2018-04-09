//
//  AkAlertView.h
//  akucun
//
//  Created by Jarry Z on 2018/4/5.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "MMAlertView.h"

@interface AKAlertView : MMPopupView

@property (nonatomic, copy) voidBlock confirmBlock;

- (instancetype) initWithConfirmTitle:(NSString*)title
                            titleFont:(UIFont *)font
                           titleColor:(UIColor*)color
                               detail:(NSString*)detail
                                items:(NSArray*)items;

- (void) showWithConfirmed:(voidBlock)confirmBlock;

@end
