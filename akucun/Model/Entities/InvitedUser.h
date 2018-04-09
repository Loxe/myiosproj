//
//  InvitedUser.h
//  akucun
//
//  Created by Jarry Zhu on 2017/10/25.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "JTModel.h"

@interface InvitedUser : JTModel

@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *ruserid;
@property (nonatomic, copy) NSString *yonghubianhao;
@property (nonatomic, copy) NSString *nicheng;

@property (nonatomic, copy) NSString *referralcode;
@property (nonatomic, copy) NSString *createtime;

@property (nonatomic, assign) NSInteger statu;

@end
