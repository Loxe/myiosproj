//
//  AKShareConfirm.h
//  akucun
//
//  Created by Jarry on 2017/5/16.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "MMAlertView.h"

typedef void (^shareBlock)(BOOL check1, BOOL check2);

@interface AKShareConfirm : MMPopupView

@property (nonatomic, copy) shareBlock confirmBlock;

+ (void) showWithConfirmed:(shareBlock)confirmBlock model:(id)model showOption:(BOOL)showOption;

- (instancetype) initWithTitle:(NSString*)title
                        detail:(NSString*)detail
                         model:(id)model
                    showOption:(BOOL)showOption
                         items:(NSArray*)items;

@end
