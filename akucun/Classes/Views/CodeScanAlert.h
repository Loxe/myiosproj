//
//  CodeScanAlert.h
//  akucun
//
//  Created by deepin do on 2018/1/26.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMAlertView.h"

@interface CodeScanAlert : MMPopupView

- (instancetype) initWithInputTitle:(NSString*)title
                             detail:(NSString*)detail
                        placeholder:(NSString*)inputPlaceholder
                            handler:(MMPopupInputHandler)inputHandler
                        scanHandler:(MMPopupItemHandler)scanHandler;

@end
