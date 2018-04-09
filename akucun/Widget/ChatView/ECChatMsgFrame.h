//
//  ECChatMsgFrame.h
//  akucun
//
//  Created by Jarry on 2017/9/10.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatMsg.h"

@interface ECChatMsgFrame : NSObject

- (instancetype) initWithModel:(ChatMsg *)model;

// 消息模型
@property (nonatomic, strong) ChatMsg *model;


// 聊天信息的背景图
@property (nonatomic, assign, readonly) CGRect bubbleViewF;

// 聊天信息label
@property (nonatomic, assign, readonly) CGRect chatLabelF;

// 发送的菊花视图
@property (nonatomic, assign, readonly) CGRect activityF;

// 重新发送按钮
@property (nonatomic, assign, readonly) CGRect retryButtonF;

// 头像
@property (nonatomic, assign, readonly) CGRect headImageViewF;

// 计算总的高度
@property (nonatomic, assign) CGFloat cellHeight;

// 图片
@property (nonatomic, assign, readonly) CGRect picViewF;

// 语音图标
@property (nonatomic, assign) CGRect voiceIconF;

// 语音时长数字
@property (nonatomic, assign) CGRect durationLabelF;

// 语音未读红点
@property (nonatomic, assign) CGRect redViewF;

@end
