//
//  ECChatViewController.h
//  akucun
//
//  Created by Jarry on 2017/9/9.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECChatBox.h"
#import "ECChatTextCell.h"

@class ECChatViewController;
@protocol ECChatControllerDelegate <NSObject>

- (void) chatViewController:(ECChatViewController *)chatViewController
            sendTextMessage:(NSString *)messageStr;

- (void) chatViewController:(ECChatViewController *)chatViewController
            didChangeHeight:(CGFloat)height;

@end

@interface ECChatViewController : UIViewController

@property (nonatomic, weak) id<ECChatControllerDelegate>delegate;

@property (nonatomic, strong) ECChatBox *chatBox;

@end
