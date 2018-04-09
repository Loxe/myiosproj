//
//  Message.h
//  akucun
//
//  Created by Jarry on 2017/6/29.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "JTModel.h"

@interface Message : JTModel

@property (nonatomic, copy) NSString *msgid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *msgtypename;
@property (nonatomic, copy) NSString *messagetime;

@property (nonatomic, assign) NSTimeInterval timestamp;

// 是否已读标志， 0未读 1已读
@property (nonatomic, assign) NSInteger readflag;

@end
