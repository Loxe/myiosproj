//
//  ECChatMessageCell.h
//  akucun
//
//  Created by Jarry on 2017/9/10.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECChatMsgFrame.h"

@interface ECChatMessageCell : UITableViewCell

// 消息模型
@property (nonatomic, strong) ECChatMsgFrame *modelFrame;
// 头像
@property (nonatomic, strong) UIImageView *headImageView;
// 内容气泡视图
@property (nonatomic, strong) UIImageView *bubbleView;
// 菊花视图所在的view
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
// 重新发送
@property (nonatomic, strong) UIButton *retryButton;


@end
