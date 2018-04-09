//
//  ECChatBox.h
//  akucun
//
//  Created by Jarry on 2017/9/9.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ECChatDefines.h"

@class ECChatBox;

@protocol ECChatBoxDelegate <NSObject>

/**
 *  发送消息
 *
 *  @param chatBox     chatBox
 *  @param textMessage 消息
 */
- (void) chatBox:(ECChatBox *)chatBox sendTextMessage:(NSString *)textMessage;

/**
 *  输入框高度改变
 *
 *  @param chatBox chatBox
 *  @param height  height
 */
- (void) chatBox:(ECChatBox *)chatBox changeHeight:(CGFloat)height;

@end

/**
 聊天对话框
 */
@interface ECChatBox : UIView

@property (nonatomic, weak) id<ECChatBoxDelegate>delegate;

@property (nonatomic, assign) ECChatBoxStatus status;

@end
