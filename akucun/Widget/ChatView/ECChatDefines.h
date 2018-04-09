//
//  ECChatDefines.h
//  akucun
//
//  Created by Jarry on 2017/9/9.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#ifndef ECChatDefines_h
#define ECChatDefines_h

typedef NS_ENUM(NSInteger, ECChatBoxStatus) {
    ECChatBoxStatusNothing,     // 默认状态
    ECChatBoxStatusShowKeyboard // 正常键盘
//    ECChatBoxStatusShowVoice,   // 录音状态
//    ECChatBoxStatusShowFace,    // 输入表情状态
//    ECChatBoxStatusShowMore,    // 显示“更多”页面状态
//    ECChatBoxStatusShowVideo    // 录制视频
};

#define CHAT_MESSAGE_TEXT       @"CHAT_MESSAGE_TEXT"

#define CHAT_BAR_HEIGHT         49  
#define CHAT_TEXTVIEW_HEIGHT    37

#endif /* ECChatDefines_h */
