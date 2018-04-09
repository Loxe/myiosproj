//
//  Member.h
//  akucun
//
//  Created by Jarry Z on 2018/4/5.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "JTModel.h"

@interface Member : JTModel

@property (nonatomic, copy) NSString *daigouId;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, assign) NSInteger forwardCount;
@property (nonatomic, assign) NSInteger monthsTotal;
@property (nonatomic, assign) NSInteger memberLevel;

@property (nonatomic, assign) BOOL usershadow;  // 关联账号申请 审核状态

@end
