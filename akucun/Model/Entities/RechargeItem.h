//
//  RechargeItem.h
//  akucun
//
//  Created by Jarry on 2017/9/17.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "JTModel.h"

@interface RechargeItem : JTModel

@property (nonatomic, assign) NSInteger jine;
@property (nonatomic, assign) NSInteger payjine;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *paytype;
@property (nonatomic, copy) NSString *deltaid;

@end
