//
//  ChatMsg.h
//  akucun
//
//  Created by Jarry on 2017/9/7.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "JTModel.h"

@interface ChatMsg : JTModel

@property (nonatomic, copy) NSString *msgid;
@property (nonatomic, copy) NSString *userid;

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *createtime;

// 客服名称，在direction为1时有效
@property (nonatomic, copy) NSString *nicheng;

@property (nonatomic, assign) NSInteger statu;
@property (nonatomic, assign) NSInteger direction;
@property (nonatomic, assign) NSTimeInterval xuhao;

- (BOOL) isSender;

@end
