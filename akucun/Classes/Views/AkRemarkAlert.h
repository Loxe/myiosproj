//
//  AkRemarkAlert.h
//  akucun
//
//  Created by Jarry on 2017/8/23.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "MMAlertView.h"

@interface AkRemarkAlert : MMPopupView

- (instancetype) initWithInputTitle:(NSString*)title
                             detail:(NSString*)detail
                            content:(NSString*)content
                        placeholder:(NSString*)inputPlaceholder
                            handler:(MMPopupInputHandler)inputHandler;

@end
