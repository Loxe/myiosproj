//
//  PopupAccountsView.h
//  akucun
//
//  Created by Jarry Z on 2018/1/8.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "MMPopupView.h"
#import "SubUser.h"

@interface PopupAccountsView : MMPopupView

@property (nonatomic, copy) intIdBlock completeBolck;

- (instancetype) initWithTitle:(NSString *)title
                      accounts:(NSArray *)accounts;

@end
